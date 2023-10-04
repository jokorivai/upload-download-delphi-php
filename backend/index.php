<?php

function json($data){
  return json_encode($data);
}

function post_var($var_name, $default = NULL)
{
  return (isset($_POST[$var_name]) ? $_POST[$var_name] : $default);
}

function get_var($var_name, $default = NULL)
{
  return (isset($_GET[$var_name]) ? $_GET[$var_name] : $default);
}

$con = mysqli_connect('localhost', 'root', 'root', 'file_storage');
if (!$con){
  die(json(array(
    'error'     => 'true',
    'message'   => 'Database connection failed.',
    'data'      => array()
  )));
}
if ($_POST){
  include 'post.php';
}
else 
if ($_GET){
  include 'get.php';
}
?>