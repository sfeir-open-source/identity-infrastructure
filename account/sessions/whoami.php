<?php

echo json_encode(["identity" => ["id" => $_COOKIE["PHPSESSID"]]], true);
