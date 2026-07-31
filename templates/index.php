<?php
    $phpVersion = PHP_VERSION;
    $serverTime = date("Y-m-d H:i:s");
?>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>webhost</title>

    <style>
      body {
        margin: 0;
        padding: 40px;
        background: #0d1117;
        color: #ffffff;
        font-family: Arial, Helvetica, sans-serif;
      }

      .container {
        max-width: 850px;
        margin: auto;
        background: #161b22;
        padding: 30px;
        border-radius: 12px;
        border: 1px solid #30363d;
      }

      h1 {
        color: #58a6ff;
        margin-top: 0;
      }

      .success {
        color: #3fb950;
        font-size: 18px;
      }

      table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
      }

      td {
        padding: 10px;
        border-bottom: 1px solid #30363d;
      }

      a {
        color: #58a6ff;
        text-decoration: none;
      }

      .button {
        display: inline-block;

        margin-top: 15px;

        padding: 12px 18px;

        background: #238636;

        color: #fff;

        border-radius: 6px;

        text-decoration: none;

        font-weight: bold;
      }

      .button:hover {
        background: #2ea043;
      }

      .footer {
        margin-top: 35px;

        color: #8b949e;

        font-size: 14px;
      }
    </style>
  </head>

  <body>
    <div class="container">
      <h1>Welcome to webhost</h1>

      <p class="success">Your PHP server is running successfully.</p>

      <p>webhost makes it easy to run PHP projects on Termux and Linux. Choose your project, start the server, and share it with others using a public link.</p>

      <table>
        <tr>
          <td><strong>PHP Version</strong></td>

          <td><?= htmlspecialchars($phpVersion) ?></td>
        </tr>

        <tr>
          <td><strong>Server Time</strong></td>

          <td><?= htmlspecialchars($serverTime) ?></td>
        </tr>

        <tr>
          <td><strong>Status</strong></td>

          <td>Running Successfully ✅</td>
        </tr>
      </table>

      <h3>Quick Start</h3>

      <ul>
          <li>Copy your PHP project into the <strong>Termux</strong> folder.</li>

          <li>Run <strong>start.sh</strong>.</li>

          <li>Select the project you want to open.</li>

          <li>Choose your host and port.</li>

          <li>Open the local or public link in any browser.</li>
      </ul>

      <h3>Like webhost?</h3>

      <p>If webhost saves you time, a GitHub ⭐ means a lot. You can also follow me to see future updates and new open-source projects.</p>

      <p>
        <a
          class="button"
          href="https://github.com/balmikiii/webhost"
          target="_blank"
        >
          ⭐ Star webhost on GitHub
        </a>
      </p>

      <p>
        <a class="button" href="https://github.com/balmikiii" target="_blank">
          👨‍💻 Follow @balmikiii
        </a>
      </p>

      <div class="footer">Built by
      <a href="https://github.com/balmikiii" target="_blank">Balmiki Kumar</a>
      • Happy Coding ❤️
      </div>
    </div>
  </body>
</html>
