<?php
header('Content-Type: application/json');

$file_name = post_var('file_name', '');
$file_ext = post_var('file_ext', '');

$bin64 = post_var('file_data', '');
$bin64array = explode(',', $bin64);
$bin64data = $bin64array[1];
$bin64meta = explode(';', $bin64array[0])[0];
unset($bin64array);

$file_dir = dirname(dirname(__FILE__)).'/files';
$file_dir = str_replace("\\", "/", $file_dir);
if (!is_dir($file_dir))
{
    mkdir($file_dir);
}    
$file_id = '64-'.uniqid(
  md5(
    $file_ext.
    sha1($bin64).
    $file_name.
    rand(1, 255555)
  ),
  true
);

$file_path = $file_dir . '/' . $file_id . '.' . $file_ext;

$fdata = base64_decode($bin64data);

$fid = fopen($file_path, 'wb');
fwrite($fid, $fdata);
fclose($fid);

$sql = "insert into file_list(file_name, file_ext, file_id) values('".
  mysqli_escape_string($con, $file_name) . "', '" .
  mysqli_escape_string($con, $file_ext) . "', '" .
  $file_id . "')"; 
// die($sql);
if (mysqli_query($con, $sql)){
  $insert_id = mysqli_insert_id($con);
  echo json(array(
    'error'     => 'false',
    'message'   => 'File uploaded.',
    'data'      => array(
      'file_id' => $file_id
    )
    ));
} else {
  unlink($file_path);
  echo json(array(
    'error'     => 'true',
    'message'   => 'File upload failed.',
    'data'      => array()
  ));
}
?>