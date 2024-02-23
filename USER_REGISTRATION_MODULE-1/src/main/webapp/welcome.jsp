<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" integrity="sha384-htSGoYaRuZv1ZssN82K12lViweW43hwg71WXvXH6llZSfmRW0H/yoGoqO3fGIPV9" crossorigin="anonymous">
    <title>Welcome</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            padding: 20px;
        }

        .container {
            max-width: 600px;
            margin: 0 auto;
            background-color: #fff;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            margin-bottom: 20px;
        }

        .welcome-message {
            text-align: center;
            font-size: 24px;
            margin-bottom: 30px;
        }

        .home-button, .show-button {
            display: block;
            width: 90px;
            margin: 0 auto;
            padding: 10px;
            text-align: center;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 9px;
            cursor: pointer;
            text-decoration: none;
            font-size: 16px;
        }

        .home-button:hover, .show-button:hover {
            background-color: #45a049;
        }
        
        .button-container {
            display: flex;
            justify-content: space-around;;
            width: 50%;
            margin-top: 20px;
            margin-left: 140px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome</h1>
        <p class="welcome-message">Hello, <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" width="22" height="22">
  <path fill="purple" d="M224 256A128 128 0 1 0 224 0a128 128 0 1 0 0 256zm-45.7 48C79.8 304 0 383.8 0 482.3C0 498.7 13.3 512 29.7 512H418.3c16.4 0 29.7-13.3 29.7-29.7C448 383.8 368.2 304 269.7 304H178.3z"/>
</svg>
<strong>${username.toUpperCase()} !</strong> Hoping You're Having A Great Day!</p>
        <div class="button-container">
	        <a href="/register" class="home-button">Home</a>
	        <a href="/show-records" class="show-button">Show</a>
	    </div>
    </div>
</body>
</html>
