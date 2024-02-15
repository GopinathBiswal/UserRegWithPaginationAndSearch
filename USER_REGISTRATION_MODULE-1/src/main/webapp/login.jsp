<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body {
    font-family: Arial, sans-serif;
    background-color: #f2f2f2;
    padding: 20px;
}

h2 {
    text-align: center;
}

form {
    max-width: 400px;
    margin: 0 auto;
    background-color: #fff;
    border-radius: 10px;
    padding: 20px;
    box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
}

label {
    display: block;
    margin-bottom: 5px;
}

input[type="email"],
input[type="text"],
input[type="submit"],
button {
    width: calc(100% - 100px);
    padding: 10px;
    margin-bottom: 15px;
    border: 1px solid #ccc;
    border-radius: 5px;
    box-sizing: border-box;
}

input[type="email"],
input[type="text"],
#otp {
    padding-left: 10px;
}

input[type="submit"],
button {
    background-color: #4CAF50;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

input[type="submit"]:hover,
button:hover {
    background-color: #45a049;
}

.button-container {
    display: flex;
    justify-content: space-between;
}

.timer {
    text-align: center;
    font-weight: bold;
    font-size: 18px;
    margin-bottom: 20px;
}

.otp-section {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}

.otp-section button {
    width: 100px;
    margin-left: 10px;
}

.disabled {
    pointer-events: none;
    background-color: #ddd !important;
}

.error-message {
    color: red;
    font-size: 14px;
}
    </style>
</head>
<body>
    <h2>Login</h2>
    <form id="loginForm" action="/login" method="post">
        <div class="email-section">
            <label for="email">Email:</label>
            <input type="email" id="email" name="email">
            <button type="button" id="verifyEmail">Verify Email</button>
        </div>
        <div class="otp-section">
            <label for="otp">OTP:</label>
            <input type="text" id="otp" name="otp">
            <button type="button" id="generateOTP">Generate OTP</button>
        </div>
        <div class="timer" id="timer">Time left: 2:00</div>
        <input type="submit" id="loginButton" value="Login" disabled>
        <div class="error-message" id="errorMessage"></div>
    </form>

    <script>
        $(document).ready(function() {
            var timer;
            var timerValue = 120; // 2 minutes

            // Verify Email button click event
            function verifyEmail() {
		        var email = $("#email").val(); // Get the value of the email input field
		        $.ajax({
		            type: "POST",
		            url: "/verify-email",
		            data: { email: email },
		            success: function(response) {
		                if (response === "true") {
		                    alert("Email Verified Successfully!");
		                } else {
		                    alert("Email not found. Please register first.");
		                }
		            },
		            error: function(xhr, status, error) {
		                console.error(error);
		            }
		        });
		    }
            
         	// Verify Email button click event
            $("#verifyEmail").click(function() {
                verifyEmail(); // Call the verifyEmail function when the button is clicked
            });

            // Generate OTP button click event
            $("#generateOTP").click(function() {
		        var email = $("#email").val(); // Get the email from the input field
		        $.ajax({
		            type: "POST",
		            url: "/generate-otp",
		            data: { email: email },
		            success: function(response) {
		                alert("OTP generated successfully!");
		                // Start timer countdown
		                startTimer();
		            },
		            error: function(xhr, status, error) {
		                console.error(error);
		            }
		        });
		    });

            // Start timer countdown
            function startTimer() {
                var minutes, seconds;

                timer = setInterval(function() {
                    minutes = parseInt(timerValue / 60, 10);
                    seconds = parseInt(timerValue % 60, 10);

                    minutes = minutes < 10 ? "0" + minutes : minutes;
                    seconds = seconds < 10 ? "0" + seconds : seconds;

                    $("#timer").text("Time left: " + minutes + ":" + seconds);

                    if (--timerValue < 0) {
                        clearInterval(timer);
                        $("#timer").text("Time's up!");

                        // Disable OTP input field after time's up
                        $("#otp").prop("disabled", true);
                        $("#generateOTP").addClass("disabled");

                        // Show error message and block login button
                        $("#errorMessage").text("This user account is blocked for 5 minutes.");
                        $("#loginButton").prop("disabled", true);
                    }
                }, 1000);
            }
        });
    </script>
</body>
</html>
