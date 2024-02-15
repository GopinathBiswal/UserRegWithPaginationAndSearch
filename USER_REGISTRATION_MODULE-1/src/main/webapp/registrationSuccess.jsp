<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Registration Success</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            padding: 20px;
        }

        .success-container {
            max-width: 400px;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .success-container h2 {
            color: #4CAF50;
        }

        .success-container p {
            color: #333;
            font-size: 18px;
            margin-top: 20px;
        }

        .button {
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 5px;
            padding: 10px 20px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin-top: 20px;
            margin-right: 10px;
        }

        .button:hover {
            background-color: #0056b3;
        }

        .login-button {
            background-color: #00bcd4;
        }

        .login-button:hover {
            background-color: #00a5b5;
        }
    </style>
</head>
<body>
    <div class="success-container">
        <h2>Registration Successful</h2>
        <p>Congratulations! User successfully registered.</p>
        <button class="button" onclick="window.location.href='/register'">Back</button>
        <button class="button login-button" onclick="window.location.href='/login'">Login</button>
    </div>
</body>
</html>
