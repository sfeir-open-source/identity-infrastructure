<?php

session_start();
setcookie("PHPSESSID", uniqid(), time() + (86400 * 30), "/");
header("Location: http://127.0.0.1:4455/app/home");
