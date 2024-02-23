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

#emailStatus {
            display: none; /* Initially hide the tick mark */
            color: green;
        }
        .disabled-style {
    opacity: 0.5; /* Reduce opacity to create a faded effect */
    pointer-events: none; /* Disable pointer events to prevent interaction */
}
input[disabled] {
        opacity: 0.6; /* Reduce opacity to give it a disabled appearance */
        box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.2); /* Add a subtle shadow effect */
    }
    </style>
</head>
<body>
    <h2>User Login</h2>
    <form id="loginForm" action="/login" method="post">
        <div class="email-section">
            <label for="email">Email:</label>
            <input type="email" id="email" name="email">
            <span id="emailStatus" style='font-size:15px;'>&#9989;</span>
            <button type="button" id="verifyEmail">Verify Email</button>
        </div>
        <div class="otp-section">
            <label for="otp">OTP:</label>
            <input type="text" id="otp" name="otp" disabled>
            <button type="button" id="generateOTP">Generate OTP</button>
            <button type="button" id="verifyOTP">Verify OTP</button>
        </div>
        <div class="timer" id="timer">Time left: 2:00</div>
        <input type="hidden" id="generatedOTP" value="${genOtp}">
        <input type="submit" id="loginButton" value="Login" disabled>
        <div class="error-message" id="errorMessage"></div>
    </form>

    <script>
        $(document).ready(function() {
        	$("#emailStatus").hide();
        	
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
		                    $("#emailStatus").show();
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

            var generatedOTP = ""; // Variable to store the most recent OTP
            var invalidOTPCount = 0; // Counter for consecutive invalid OTP attempts

            // Generate OTP button click event
            $("#generateOTP").click(function() {
                var email = $("#email").val(); // Get the email from the input field
                $.ajax({
                    type: "POST",
                    url: "/generate-otp",
                    data: { email: email },
                    success: function(response) {
                        // OTP generated successfully
                        generatedOTP = response.trim(); // Set the most recent generated OTP
                        $("#generatedOTP").val(generatedOTP); // Set the generated OTP value
                        alert("OTP generated successfully: " + generatedOTP);
                        timerValue = 120; // Reset the timer value to 2 minutes
                        startTimer(); // Restart the timer
                        $("#otp").prop("disabled", false);
                        $("#loginButton").prop("disabled", true); // Disable login button until OTP verification
                    },
                    error: function(xhr, status, error) {
                        console.error(error);
                        alert("Failed to generate OTP. Please try again.");
                    }
                });
            });

            // Verify OTP function
            function verifyOTP() {
                $("#verifyOTP").click(function() {
                    var enteredOTP = $("#otp").val(); // Get the entered OTP
                    
                    if (timerValue <= 0) {
                        alert("OTP is expired! Please regenerate to proceed.");
                        $("#otp").prop("disabled", true); // Disable the OTP input field
                        return; // Stop further execution
                    }
                    
                    if (/^\d{6}$/.test(enteredOTP)) {
                        if (enteredOTP === generatedOTP) {
                            alert("OTP Verified Successfully!");
                            clearInterval(timer); // Stop the timer
                            $("#timer").hide(); // Hide the timer display
                            $("#loginButton").prop("disabled", false); // Enable login button
                            invalidOTPCount = 0; // Reset invalid OTP count on successful verification
                        } else {
                            alert("Invalid OTP. Please try again.");
                            invalidOTPCount++; // Increment the counter for consecutive invalid attempts
                            if (invalidOTPCount >= 3) {
                                alert("You have made 3 consecutive incorrect attempts. Please try again later.");
                                clearInterval(timer);
                                $("#timer").addClass("disabled-style");
                                $(".email-section input").addClass("disabled-style").prop("disabled", true);
                                $(".otp-section input").addClass("disabled-style").prop("disabled", true);
                                $(".email-section button").addClass("disabled-style").prop("disabled", true);
                                $(".otp-section button").addClass("disabled-style").prop("disabled", true);
                                $("#loginButton").addClass("disabled-style").prop("disabled", true);
                                $("#errorMessage").text("This user account is blocked for 5 minutes.");
                            }
                        }
                    } else {
                        alert("Invalid OTP format. Please enter a 6-digit number.");
                        $("#loginButton").prop("disabled", true); // Disable login button
                    }
                });
            }

            // Call verifyOTP function
            verifyOTP();
            
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

                        
                    }
                }, 1000);
            }
        });
    </script>
</body>
</html>
