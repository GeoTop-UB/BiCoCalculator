<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>bbCalculator</title>
  </head>
  <body>
    Test<br/>
    <?php
      // outputs the username that owns the running php/httpd process
      // (on a system with the "whoami" executable in the path)
      $output=null;
      $retval=null;
      // exec('whoami', $output, $retval);
      // exec('./hello 2>&1', $output, $retval);
      exec('getent passwd "$USER" 2>&1', $output, $retval);
      echo "Returned with status $retval and output:\n";
      print_r($output);
    ?>
  </body>
</html>