<?php
$query = get_var('method', 'list');
switch($query){
  case 'list':
    $q = mysqli_query($con, "select id, file_name, file_ext, file_id from file_list order by id asc");
    if ((!$q) || (mysqli_num_rows($q)==0)){
      header('Content-Type: application/json');
      echo json(array(
        'error'     => 'true',
        'message'   => 'File not found.',
        'data'      => array()
      ));
    } else {
      $file_list = array();
      while ($file_data = mysqli_fetch_array($q)){
        $file_list[] = array(
          'file_id'   => $file_data['file_id'],
          'file_name' => $file_data['file_name'],
          'file_ext'  => $file_data['file_ext']
        );
      }
      echo json(array(
        'error'     => 'false',
        'message'   => 'File list.',
        'data'      => $file_list
      ));
    }
    mysqli_free_result($q);
    break;
  case 'info':
    $file_id = get_var('fileid', '');
    $q = mysqli_query($con, "select id, file_name, file_ext, file_id from file_list where file_id = '$file_id'");
    if ((!$q) || (mysqli_num_rows($q)==0)){
      header('Content-Type: application/json');
      echo json(array(
        'error'     => 'true',
        'message'   => 'File not found.',
        'data'      => array()
      ));
    } else {
      $file_list = array();
      $file_data = mysqli_fetch_array($q);
      $file_list[] = array(
        'file_id'   => file_data['file_id'],
        'file_name' => $file_data['file_name'],
        'file_ext'  => $file_data['file_ext']
      );
      echo json(array(
        'error'     => 'false',
        'message'   => 'File list.',
        'data'      => $file_list
      ));
    }
    mysqli_free_result($q);
    break;
  case 'download':
    $file_id = get_var('fileid', '');
    $q = mysqli_query($con, "select id, file_name, file_ext, file_id from file_list where file_id = '$file_id'");
    if ((!$q) || (mysqli_num_rows($q)==0)){
      header('Content-Type: application/json');
      echo json(array(
        'error'     => 'true',
        'message'   => 'File not found.',
        'data'      => array()
      ));
    } else {
      $file_dir = dirname(dirname(__FILE__)).'/files';
      $file_dir = str_replace("\\", "/", $file_dir);
      $file_data = mysqli_fetch_array($q);
      $file_path = $file_dir .'/' .$file_data['file_id'] . '.' . $file_data['file_ext'];
      $real_name = $file_data['file_name'];
      if (is_file($file_path)){
        $fsize = filesize($file_path);
        header('Content-Description: Delphi/PHP File Download');
        header('Content-Type: application/octet-stream');
        header('Content-Disposition: attachment; filename="'.$real_name.'"');
        header('Content-Transfer-Encoding: binary');
        header('Expires: 0');
        header('Cache-Control: must-revalidate');
        header('Pragma: public');
        // header('Content-Length: ' . $fsize);
        readfile($file_path);
        die();
      }
    }
    break;
}
?>