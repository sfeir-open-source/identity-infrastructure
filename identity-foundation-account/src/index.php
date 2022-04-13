<?php

session_start();
setcookie("PHPSESSID", uniqid(), time() + (86400 * 30), "/");
header("Location: " . getenv('IDENTITY_FOUNDATION_APP_URL'));
