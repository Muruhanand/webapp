<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <link href="css/tab.css" rel="stylesheet" />
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <div class="form-wrapper">
        <div class="container">
            <div id="error-message" style="color: red; display: none;"></div>
            <div class="tab">
                <button class="tablink active" onclick="openTab('login')">Login</button>
                <button class="tablink" onclick="openTab('register')">Register</button>
            </div>

            <div id="login" class="form-container">
                <form action="loginprocess.jsp" method="post">
                    <ul class="login-form">
                        <li><label for="email">Member ID:</label> <input type="text" id="loginid" name="email"></li>
                        <li><label for="password">Password:</label> <input type="password" id="password" name="password"></li>
                    </ul>
                    <button type="submit" name="btnSubmit">Login</button>
                </form>
            </div>

            <!-- Register Form -->
            <div id="register" class="form-container" style="display: none;">
                <form action="registerprocess.jsp" method="post">
                    <ul class="register-form" id="tabform">
                        <li><label for="first_name">First Name:</label> <input type="text" id="first_name" name="first_name" required></li>
                        <li><label for="last_name">Last Name:</label> <input type="text" id="last_name" name="last_name" required></li>
                        <li><label for="email">Email:</label> <input type="email" id="email" name="email" required></li>
                        <li><label for="phone_number">Phone Number:</label> <input type="text" id="phone_number" name="phone_number" required></li>
                        <li><label for="address">Address:</label> <input type="text" id="address" name="address" required></li>
                        <li><label for="password">Password:</label> <input type="password" id="newpassword" name="password" required></li>
                    </ul>
                    <button type="submit" name="btnSubmit">Login</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        // This function shows the correct form based on the tab clicked
        function openTab(tabName) {
            const forms = document.getElementsByClassName("form-container");
            const tabs = document.getElementsByClassName("tablink");

            // Hide all form containers
            for (let i = 0; i < forms.length; i++) {
                forms[i].style.display = "none";
            }

            // Remove active class from all tab buttons
            for (let i = 0; i < tabs.length; i++) {
                tabs[i].classList.remove("active");
            }

            // Show the selected form container
            const selectedTab = document.getElementById(tabName);
            if (selectedTab) {
                selectedTab.style.display = "block";
            }

            // Add active class to the selected tab button
            const activeTab = document.querySelector(`button[onclick="openTab('${tabName}')"]`);
            if (activeTab) {
                activeTab.classList.add("active");
            }
        }

        // Handle error message display on page load if an error code is present
        window.onload = function() {
            const queryString = window.location.search;
            if (queryString.includes('errCode')) {
                const params = new URLSearchParams(queryString);
                const errCode = params.get('errCode');
                if (errCode) {
                    document.getElementById('error-message').textContent = 'You have entered an invalid ID/Password';
                    document.getElementById('error-message').style.display = 'block';
                }
            }
        }

        // Set default tab to login on page load
        document.addEventListener("DOMContentLoaded", function() {
            openTab('login');
        });
    </script>

    <%@ include file="footer.jsp" %>
</body>
</html>
