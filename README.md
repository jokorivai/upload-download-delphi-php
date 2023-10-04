# upload-download-delphi-php
Upload and download file from Delphi (Indy) with PHP backend.

![Screenshot](https://github.com/jokorivai/upload-download-delphi-php/blob/main/screenshot/Screenshot-2023-10-04-17.32.06.png?raw=true)

Akses (upload dan download) file yang disimpan di remote server via PHP dari Delphi client.

* File informations are stored in database
* Files are stored in server storage, accessed trough PHP script
* File uploaded File via PHP
* The sample database is included
* Only for proof of concept, without error handling, no access authentication, etc.
* Using Indy on Delphi side, SuperObject [https://github.com/hgourvest/superobject](https://github.com/hgourvest/superobject)
* Compiled & tested on MySQL/MariaDB+PHP7.4 on nginx, Delphi XE8

# Usage
Please copy backend and files folder to you server (accessible through HTTP) and adjust hard-coded URIs on Delphi code 
