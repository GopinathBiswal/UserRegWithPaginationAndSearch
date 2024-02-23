<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Records</title>
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/sweetalert2@10/dist/sweetalert2.min.css">
    <!-- Include jQuery library -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <!-- Include DataTables CSS and JavaScript files -->
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.11.5/css/jquery.dataTables.css">
    <script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            padding: 20px;
        }

        h1 {
            text-align: center;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }

        th {
            background-color: #4CAF50;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        tr:hover {
            background-color: #ddd;
        }
        
        .edit-icon {
            width: 24px;
            height: 24px;
            fill: #333; 
            cursor: pointer;
            transition: fill 0.3s;
        }

        .edit-icon:hover {
            fill: purple;
        }
        
        .delete-icon {
            width: 24px;
            height: 24px;
            fill: #333; 
            cursor: pointer;
            transition: fill 0.3s;
        }

        .delete-icon:hover {
            fill: red;
        }
        
        /* Modal styles */
		.modal {
		    display: none;
		    position: fixed;
		    z-index: 1;
		    left: 0;
		    top: 0;
		    width: 100%;
		    height: 100%;
		    overflow: auto;
		    background-color: rgba(0, 0, 0, 0.4);
		}
		
		.modal-content {
		    background-color: #fefefe;
		    margin: 10% auto;
		    padding: 20px;
		    border-radius: 10px;
		    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
		    width: 80%;
		    max-width: 500px;
		}
		
		.close {
		    color: #aaa;
		    float: right;
		    font-size: 24px;
		    font-weight: bold;
		    cursor: pointer;
		}
		
		.close:hover,
		.close:focus {
		    color: #333;
		    text-decoration: none;
		}
		
		h2 {
		    margin-top: 0;
		    margin-bottom: 20px;
		    color: #333;
		}
		
		label {
		    display: block;
		    margin-bottom: 5px;
		    color: #333;
		}
		
		input[type="text"],
		input[type="email"] {
		    width: 100%;
		    padding: 10px;
		    margin-bottom: 20px;
		    border: 1px solid #ccc;
		    border-radius: 5px;
		    box-sizing: border-box;
		}
		
		button {
		    background-color: #4CAF50;
		    color: white;
		    padding: 10px 20px;
		    border: none;
		    border-radius: 5px;
		    cursor: pointer;
		}
		
		button:hover {
		    background-color: #45a049;
		}

    </style>
</head>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<body>
    <h1>User Records</h1>
    <table border="1" id="userTable" class="display" style="width:100%">
        <thead>
            <tr>
                <th>Sl No.</th>
                <th>Registration No</th>
                <th>User Name</th>
                <th>Email</th>
                <th>Mobile No</th>
                <th>Edit</th>
                <th>Delete</th>
            </tr>
        </thead>
        <tbody>
        	<c:choose>
		        <c:when test="${empty users}">
		            <tr>
		                <td colspan="7" style="text-align: center; font-size: 40px; font-weight: bold; color: grey; height: 450px">
                    No Records Found!
                </td>
		            </tr>
		        </c:when>
		        <c:otherwise>
		            <c:forEach items="${users}" var="user" varStatus="status">
		                <tr>
		                    <td>${status.index + 1}</td>
		                    <td>${user.registrationNo}</td>
		                    <td>${user.userName.toUpperCase()}</td>
		                    <td>${user.email}</td>
		                    <td>${user.mobileNumber}</td>
		                    <td>
		                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" class="edit-icon" onclick="openModal('${user.id}', '${user.userName}', '${user.email}', '${user.mobileNumber}')" width="22" height="22"><path d="M471.6 21.7c-21.9-21.9-57.3-21.9-79.2 0L362.3 51.7l97.9 97.9 30.1-30.1c21.9-21.9 21.9-57.3 0-79.2L471.6 21.7zm-299.2 220c-6.1 6.1-10.8 13.6-13.5 21.9l-29.6 88.8c-2.9 8.6-.6 18.1 5.8 24.6s15.9 8.7 24.6 5.8l88.8-29.6c8.2-2.7 15.7-7.4 21.9-13.5L437.7 172.3 339.7 74.3 172.4 241.7zM96 64C43 64 0 107 0 160V416c0 53 43 96 96 96H352c53 0 96-43 96-96V320c0-17.7-14.3-32-32-32s-32 14.3-32 32v96c0 17.7-14.3 32-32 32H96c-17.7 0-32-14.3-32-32V160c0-17.7 14.3-32 32-32h96c17.7 0 32-14.3 32-32s-14.3-32-32-32H96z"/></svg>
		                    </td>
		                    <td>
							    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" class="delete-icon" onclick="confirmDelete(${user.id})" width="22" height="22">
							    	<path d="M135.2 17.7C140.6 6.8 151.7 0 163.8 0H284.2c12.1 0 23.2 6.8 28.6 17.7L320 32h96c17.7 0 32 14.3 32 32s-14.3 32-32 32H32C14.3 96 0 81.7 0 64S14.3 32 32 32h96l7.2-14.3zM32 128H416V448c0 35.3-28.7 64-64 64H96c-35.3 0-64-28.7-64-64V128zm96 64c-8.8 0-16 7.2-16 16V432c0 8.8 7.2 16 16 16s16-7.2 16-16V208c0-8.8-7.2-16-16-16zm96 0c-8.8 0-16 7.2-16 16V432c0 8.8 7.2 16 16 16s16-7.2 16-16V208c0-8.8-7.2-16-16-16zm96 0c-8.8 0-16 7.2-16 16V432c0 8.8 7.2 16 16 16s16-7.2 16-16V208c0-8.8-7.2-16-16-16z"/>
							    </svg>
							</td>
		                </tr>
		            </c:forEach>
            	</c:otherwise>
    		</c:choose>
        </tbody>
    </table>
    
    <!-- Modal -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h2>Edit User Details</h2>
            <form id="editForm">
                <input type="hidden" id="editUserId" />
                <label for="editUserName">User Name:</label>
                <input type="text" id="editUserName" name="editUserName" required><br><br>
                <label for="editEmail">Email:</label>
                <input type="email" id="editEmail" name="editEmail" required><br><br>
                <label for="editMobileNumber">Mobile Number:</label>
                <input type="text" id="editMobileNumber" name="editMobileNumber" required><br><br>
                <button type="button" onclick="saveChanges()">Save Changes</button>
            </form>
        </div>
    </div>
    
    <script>
	    $(document).ready(function() {
	        // Initialize DataTable
	        $('#userTable').DataTable();
	    });
    	
    	/* Edit Part Starts */
        var modal = document.getElementById('editModal');
        var span = document.getElementsByClassName("close")[0];

        function openModal(userId, userName, email, mobileNumber) {
            document.getElementById("editUserId").value = userId;
            document.getElementById("editUserName").value = userName;
            document.getElementById("editEmail").value = email;
            document.getElementById("editMobileNumber").value = mobileNumber;
            modal.style.display = "block";
        }

        function closeModal() {
            modal.style.display = "none";
        }

        function saveChanges() {
            var userId = document.getElementById("editUserId").value;
            var userName = document.getElementById("editUserName").value;
            var email = document.getElementById("editEmail").value;
            var mobileNumber = document.getElementById("editMobileNumber").value;
            
            if (userName === '') {
                alert('Please enter a user name.');
                return false;
            }

            if (mobileNumber === '') {
                alert('Please enter a mobile number.');
                return false;
            }

            if (!/^[6-9]\d*$/.test(mobileNumber)) {
                alert('Please enter a valid mobile number starting with 6, 7, 8, or 9.');
                return false;
            }
            
            if (mobileNumber.length !== 10) {
                alert('Mobile number must have 10 digits.');
                return false;
            }

            if (email === '') {
                alert('Please enter an email address.');
                return false;
            }

            if (!/\S+@\S+\.\S+/.test(email)) {
                alert('Please enter a valid email address.');
                return false;
            }
            
            var data = {
                id: userId,
                userName: userName,
                email: email,
                mobileNumber: mobileNumber
            };

         	// Function to confirm the update action using Swal.fire
            Swal.fire({
                icon: 'question',
                title: 'Confirmation',
                text: 'Do you want to update?',
                showCancelButton: true,
                confirmButtonText: 'Yes, update',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    // User confirmed the update action
                    // Proceed with sending the update request
                    var xhr = new XMLHttpRequest();
                    xhr.open('POST', '/update', true);
                    xhr.setRequestHeader('Content-Type', 'application/json');
                    xhr.onreadystatechange = function() {
                        if (xhr.readyState === 4) {
                            if (xhr.status === 200) {
                            	Swal.fire({
                                    icon: 'success',
                                    title: 'Success',
                                    text: 'Data updated successfully!',
                                    showConfirmButton: true
                                }).then((result) => {
                                    if (result.isConfirmed) {
                                        closeModal();
                                        location.reload();
                                    }
                                });
                            } else {
                                // Handle failure
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Technical Error',
                                    text: 'Failed to update record. Please try again.'
                                });
                            }
                        }
                    };
                    xhr.send(JSON.stringify(data));
                }
            });

        }

        // Close the modal when the user clicks outside of it
        window.onclick = function(event) {
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }
        
        /* Delete Part Starts */
        function confirmDelete(id) {
        	var userName = document.getElementById("editUserName").value;
		    Swal.fire({
		        icon: 'warning',
		        title: 'Confirmation',
		        text: 'Do you want to remove?',
		        showCancelButton: true,
		        confirmButtonText: 'Yes, delete it!',
		        cancelButtonText: 'Cancel'
		    }).then((result) => {
		        if (result.isConfirmed) {
		            deleteRecord(id);
		        }
		    });
		}

        function deleteRecord(id) {
            var xhr = new XMLHttpRequest();
            xhr.open('POST', '/delete?id=' + id, true);
            xhr.setRequestHeader('Content-Type', 'application/json');
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        Swal.fire({
                            icon: 'success',
                            title: 'Success',
                            text: 'Data deleted successfully!'
                        }).then(() => {
                            location.reload(); // Refresh the page
                        });
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Error',
                            text: 'Failed to delete record. Please try again.'
                        });
                    }
                }
            };
            xhr.send();
        }
    </script>
    
</body>
</html>
