<?php
error_reporting(E_ALL);
ini_set("display_errors", 1);

$username = getenv("USERNAME");
$password = getenv("PASSWORD");
$domain = getenv("DOMAIN");

if (!is_null($username) && !is_null($password)) {
  if (isset($_POST['username']) && isset($_POST['password'])) {
    if ($_POST['username'] == $username && $_POST['password'] == $password) {
      session_start();
      setcookie("PHPSESSID", uniqid(), time() + (86400 * 30), "/", $domain);
      parse_str($_SERVER["QUERY_STRING"], $qs);
      if (headers_sent()) {
        die("Headers already sent");
      } else {
        exit(header("Location: " . $qs["redirect"]));
      }
    } else {
      http_response_code(400);
      exit;
    }
  }
} else {
  http_response_code(500);
  exit;
}
?>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8" />
  <title>Sign In | Account</title>
  <link rel="stylesheet" href="/auth/css/global.css">
</head>

<body>
  <div class="bg-grey-lighter min-h-screen flex flex-col">
    <div class="container max-w-sm mx-auto flex-1 flex flex-col items-center justify-center px-2">
      <form class="bg-white px-6 py-8 rounded shadow-md text-black w-full" method="POST">
        <h1 class="mb-8 text-3xl text-center">Sign In</h1>
        <input type="text" class="block border border-grey-light w-full p-3 rounded mb-4" name="username" placeholder="Username" />
        <input type="password" class="block border border-grey-light w-full p-3 rounded mb-4" name="password" placeholder="Password" />
        <button type="submit" class="w-full text-center py-3 rounded bg-green-400 text-white hover:bg-green-400-dark focus:outline-none my-1">Sign In</button>
      </form>

      <div class="text-grey-dark mt-6">
        Don't have an account?
        <a class="no-underline border-b border-blue text-blue" href="/auth/signup.php">
          Sign Up
        </a>.
      </div>
    </div>
  </div>
</body>

</html>
