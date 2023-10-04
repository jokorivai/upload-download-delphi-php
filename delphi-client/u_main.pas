unit u_main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, superobject, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdSSLOpenSSL, IdMultipartFormData, system.NetEncoding,
  Vcl.Menus, Vcl.StdCtrls, Vcl.ComCtrls, Winapi.ShellAPI;

type
  TSynSockOnMonitor = procedure(Sender: TObject; Writing: Boolean; const Buffer: Pointer; Len: Integer) of object;
  TForm1 = class(TForm)
    IdHTTP1: TIdHTTP;
    DataSource1: TDataSource;
    PopupMenu1: TPopupMenu;
    GetInfo1: TMenuItem;
    Download1: TMenuItem;
    Button1: TButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    ListView1: TListView;
    N1: TMenuItem;
    RefreshList1: TMenuItem;
    procedure GetInfo1Click(Sender: TObject);
    procedure Download1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure RefreshList1Click(Sender: TObject);
  private
    { Private declarations }
    procedure OnMonitor(Sender: TObject; Writing: Boolean; const Buffer: Pointer; Len: Integer);
    function  HttpCreateClient(isSSL: Boolean): TIdHTTP;
    function  HttpFetchText(const URI: String; const Response: TStrings): Boolean;
    function  HttpFetchBin(const URI: string; const Response: TStream; onMonitor: TSynSockOnMonitor = nil): Boolean;
  public
    { Public declarations }
    function  UploadFile(const AFile: String): ISuperObject;
    function  DownloadFile( const AFileId: String): ISuperObject;
    function  GetFileInfo(const AFileId: String):ISuperObject;
    function  GetFileList: ISuperObject;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  result : ISuperObject;
begin
  if OpenDialog1.Execute(handle) then
  begin
    result := UploadFile(OpenDialog1.FileName);
    if result.S['error'] = 'true' then
    begin
      MessageDlg('Error bro!', mtError, [mbOK], 0);
    end
    else
    begin
      MessageDlg('File uploaded!', mtInformation, [mbOK], 0);
      GetFileList;
    end;
  end;
end;

procedure TForm1.Download1Click(Sender: TObject);
var
  id,
  savedName,
  savedExt,
  uri: string;
  ms: TMemoryStream;
begin
  if ListView1.Items.Count = 0 then exit;
  id := ListView1.Selected.Caption;
  savedName := ListView1.Selected.SubItems[0];
  savedExt  := ListView1.Selected.SubItems[1];
  SaveDialog1.Filter := uppercase(SavedExt)+'File (*.'+savedExt+')|*.'+savedExt;
  SaveDialog1.DefaultExt := '.'+savedExt;
  SaveDialog1.FileName := savedName;
  uri := 'http://atm.net/upload-download/backend/?method=download&fileid='+id;
  // InputBox('','', uri);
  if SaveDialog1.Execute(handle) then
  begin
    ms := TMemoryStream.Create;
    try
      if HttpFetchBin(uri, ms) then
      begin
        ms.SaveToFile(SaveDialog1.FileName);
        ShellExecute(handle, 'open', PChar(SaveDialog1.FileName), nil, nil, SW_SHOWNORMAL);
      end;
    finally
      ms.Free;
    end;
  end;
end;

function TForm1.DownloadFile(const AFileId: String): ISuperObject;
begin

end;

function TForm1.GetFileInfo(const AFileId: String): ISuperObject;
begin

end;

function TForm1.GetFileList: ISuperObject;
var
  uri: string;
  StrResult: TStringList;
  iList: ISuperObject;
  i: integer;
  li: TListItem;
begin
  uri := 'http://atm.net/upload-download/backend/?method=list';
  StrResult := TStringList.Create;
  ListView1.Items.BeginUpdate;
  try
    ListView1.Items.Clear;
    if HttpFetchText(uri, StrResult) then
    begin
      iList := so(StrResult.Text);
      if iList.A['data'].Length>0 then
      begin
        for i := 0 to iList.A['data'].Length-1 do
        begin
          li := ListView1.Items.Add;
          li.Caption := iList.A['data'][i].S['file_id'];
          li.SubItems.Add( iList.A['data'][i].S['file_name'] );
          li.SubItems.Add( iList.A['data'][i].S['file_ext'] );
        end;
      end;
    end;
  finally
    ListView1.Items.EndUpdate;
    StrResult.Free;
  end;
end;

procedure TForm1.GetInfo1Click(Sender: TObject);
begin
  if ListView1.Items.Count = 0 then exit;
end;

function TForm1.HttpCreateClient(isSSL: Boolean): TIdHTTP;
begin
  Result := TIdHTTP.Create(Application);
  if isSSL then
  begin
    Result.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(Result);
    with TIdSSLIOHandlerSocketOpenSSL(Result.IOHandler) do
    begin
      SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2, sslvSSLv2, sslvSSLv3];
      SSLOptions.Mode := sslmUnassigned;
      SSLOptions.VerifyMode := [];
      SSLOptions.VerifyDepth := 0;
      PassThrough := true;
    end;
  end;
  // nhc.on
  Result.HandleRedirects := true;
end;

function TForm1.HttpFetchBin(const URI: string; const Response: TStream;
  onMonitor: TSynSockOnMonitor): Boolean;
var
  _uri,
  rcs,
  e64: string;
  f,
  err,
  i: integer;
  nhc: TIdHTTP;
  isSSL: boolean;
begin
  Result := false;
  isSSL := LowerCase(copy(uri,1,5))='https';
  nhc := HttpCreateClient(isSSL);
  try
    Response.Position := 0;
    try
      nhc.Get(uri, Response);
      Result := true;
      if Assigned(onMonitor) then
        onMonitor(nhc, false, nil, Response.Size);
    finally

    end;
  finally
    nhc.Free;
  end;
end;

function TForm1.HttpFetchText(const URI: String;
  const Response: TStrings): Boolean;
var
  _uri,
  rcs,
  e64: string;
  f,
  err,
  i: integer;
  nhc: TIdHTTP;
  stream: TStringStream;
  isSSL: boolean;
begin
  Result := false;
  isSSL := LowerCase(copy(uri,1,5))='https';
  nhc := HttpCreateClient(isSSL);
  try
    stream := TStringStream.Create();
    try
      nhc.Get(uri, stream);
      Result := true;
      Response.Text := stream.DataString;
    finally
      stream.Free;
    end;
  finally
    nhc.Free;
  end;
end;

procedure TForm1.OnMonitor(Sender: TObject; Writing: Boolean;
  const Buffer: Pointer; Len: Integer);
begin
  Application.ProcessMessages;
end;

procedure TForm1.RefreshList1Click(Sender: TObject);
begin
  GetFileList();
end;

function TForm1.UploadFile(const AFile: String): ISuperObject;
var
  mpds: TIdMultiPartFormDataStream;
  ms : TMemoryStream;
  uri,
  rcs,
  ext,
  e64: string;
  f,
  tmpRes,
  tmpResData,
  resData: ISuperObject;
  locErr,
  err,
  i, j: integer;
  htp: TIdHTTP;
  isSSL: Boolean;
begin
  uri := 'http://atm.net/upload-download/backend/';
  ms := TMemoryStream.Create;
  htp := HttpCreateClient(uri.toLower().StartsWith( 'https'));
  err := 0;
  try
    mpds := TIdMultiPartFormDataStream.Create;
    try
      ext := ExtractFileExt(AFile);
      if ext[1] = '.' then ext := copy(ext, 2, 10);
      mpds.AddFormField('file_name', ExtractFileName(AFile));
      mpds.AddFormField('file_ext' , ext);
      ms.Clear;
      ms.LoadFromFile(AFile);
      e64 := 'data:image/jpeg;base64,'+TNetEncoding.Base64.EncodeBytesToString(ms.Memory, ms.Size);
      mpds.AddFormField('file_data', e64);
      rcs := '';
      rcs := htp.Post(uri, mpds);
      if copy(rcs,1,2) <> '{"' then
      begin
        Result := so;
        Result.S['error'] := 'true';
        Result.S['message'] := 'Somtehing went wrong on server side.';
        Result.ForcePath('data', stArray);
      end
      else
      begin
        Result := so(rcs);
      end;
    finally
      mpds.Free;
    end;
  finally
    htp.Free;
    ms.free;
  end;
end;

end.
