<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login Form</title>
<style>
    ul {
        list-style-type: none;
        padding: 0;
    }
    li {
        margin-bottom: 10px;
    }
</style>
</head>
<body>
	<script>
        window.onload = function() {
		const queryString = window.location.search;
            if (queryString.includes('errCode')) {
                const params = new URLSearchParams(queryString);
                const errCode = params.get('errCode');
                if (errCode) {
                    alert('You have entered an invalid ID/Password');
                }
            }
        }
    </script>
	<form action = "/Practical/Prac2/verifyUser.jsp" method="post">
		<ul>
			<li>
				<label for="memberid">Member ID:</label>
				<input type="text" id="loginid" name="memberid">
			</li>
			<li>
				<label for="password">Password:</label>
				<input type="password" id="password" name="password">
			</li>
			<li>
				<button type="submit" name="btnSubmit">Login</button>
				<button type="reset">Reset</button>
			</li>
		</ul>
	</form>
</body>
</html>