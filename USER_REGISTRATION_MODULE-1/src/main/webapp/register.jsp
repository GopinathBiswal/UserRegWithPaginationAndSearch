<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Registration</title>
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/sweetalert2@10/dist/sweetalert2.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            padding: 20px;
        }

        .form-container {
            max-width: 400px;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }

        .form-container h2 {
            text-align: center;
        }

        .form-container label {
            display: block;
            margin-bottom: 5px;
        }

        .form-container input[type="email"],
        .form-container input[type="text"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }

        .form-container input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 10px 20px;
            cursor: pointer;
            width: 50%;
        }

        .form-container input[type="submit"]:hover {
            background-color: #45a049;
        }
        .form-container input[type="reset"] {
    background-color: #f44336;
    color: white;
    border: none;
    border-radius: 5px;
    padding: 10px 20px;
    cursor: pointer;
    width: 50%;
}

.form-container input[type="reset"]:hover {
    background-color: #d32f2f;
}
        .button-container {
    display: flex;
}

.button-container input[type="submit"],
.button-container input[type="reset"] {
    flex: 1;
    margin-right: 5px;
}
        
    </style>
</head>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<script>
    function validateForm() {
        var userName = document.getElementById('userName').value.trim();
        var mobileNumber = document.getElementById('mobileNumber').value.trim();
        var email = document.getElementById('email').value.trim();

        if (userName === '') {
            //alert('Please enter a user name.');
            Swal.fire({
                icon: 'error',
                title: 'Validation Error',
                text: 'Please enter a user name.'
            });
            return false;
        }

        if (mobileNumber === '') {
            //alert('Please enter a mobile number.');
            Swal.fire({
                icon: 'error',
                title: 'Validation Error',
                text: 'Please enter a mobile number.'
            });
            return false;
        }

        if (!/^[6-9]\d*$/.test(mobileNumber)) {
            //alert('Please enter a valid mobile number starting with 6, 7, 8, or 9.');
            Swal.fire({
                icon: 'error',
                title: 'Validation Error',
                text: 'Please enter a valid mobile number starting with 6, 7, 8, or 9.'
            });
            return false;
        }
        
        if (mobileNumber.length !== 10) {
            //alert('Mobile number must have 10 digits.');
            Swal.fire({
                icon: 'error',
                title: 'Validation Error',
                text: 'Mobile number must have 10 digits.'
            });
            return false;
        }

        if (email === '') {
            //alert('Please enter an email address.');
            Swal.fire({
                icon: 'error',
                title: 'Validation Error',
                text: 'Please enter an email address.'
            });
            return false;
        }

        if (!/\S+@\S+\.\S+/.test(email)) {
            //alert('Please enter a valid email address.');
            Swal.fire({
                icon: 'error',
                title: 'Validation Error',
                text: 'Please enter a valid email address.'
            });
            return false;
        }

     	// Make AJAX request to verify email
        var xhr = new XMLHttpRequest();
		xhr.open("POST", "/verify-email", true);
		xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		xhr.onreadystatechange = function () {
		    if (xhr.readyState === 4 && xhr.status === 200) {
		        if (xhr.responseText === 'true') {
		            //alert('Email already registered. Please use a different email.');
		            Swal.fire({
                        icon: 'error',
                        title: 'Validation Error',
                        text: 'Email already registered. Please use a different email.'
                    });
		            return false; // Stop form submission
		        } else {
		            /* var confirmed = confirm("Do you want to submit?");
		            if (confirmed) {
		                // Proceed with form submission
		                submitRegistrationForm();
		            } */
		        	Swal.fire({
                        icon: 'question',
                        title: 'Confirmation',
                        text: 'Do you want to submit?',
                        showCancelButton: true,
                        confirmButtonText: 'Submit'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            submitRegistrationForm();
                        }
                    });
		        }
		    }
		};
		xhr.send("email=" + encodeURIComponent(email));
		
		function submitRegistrationForm() {
		    var registerXhr = new XMLHttpRequest();
		    registerXhr.open("POST", "/register", true);
		    registerXhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		    registerXhr.onreadystatechange = function () {
		        if (registerXhr.readyState === 4) {
		            if (registerXhr.status === 200) {
		                if (registerXhr.responseText === 'success') {
		                    Swal.fire({
		                        icon: 'success',
		                        title: 'Registration Successful!',
		                        text: 'User successfully registered.',
		                        showConfirmButton: false,
		                        timer: 3500
		                    }).then(() => {
		                    	window.location.href = '/login';
		                    });
		                } else {
		                    Swal.fire({
		                        icon: 'error',
		                        title: 'Registration Failed',
		                        text: 'An error occurred during registration. Please try again later.'
		                    });
		                }
		            } else {
		                Swal.fire({
		                    icon: 'error',
		                    title: 'Server Error',
		                    text: 'An error occurred on the server. Please try again later.'
		                });
		            }
		        }
		    };
		    registerXhr.send("userName=" + encodeURIComponent(userName) + "&mobileNumber=" + encodeURIComponent(mobileNumber) + "&email=" + encodeURIComponent(email));
		}
        
        // Prevent default form submission
        return false;
    }
</script>
<body>
    <div class="form-container">
        <h2>User Registration</h2>
        <form id="registrationForm" action="/register" method="post" onsubmit="return validateForm()">
        	<label for="userName">User Name:</label>
            <input type="text" id="userName" name="userName">
            <label for="mobileNumber">Mobile Number:</label>
            <input type="text" id="mobileNumber" name="mobileNumber">
            <label for="email">Email:</label>
            <input type="email" id="email" name="email">
            <div class="button-container">
		        <input type="submit" value="Register">
		        <input type="reset" value="Reset" class="reset-button">
		    </div>
        </form>
    </div>
</body>
</html>