<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login Form</title>
<link rel="stylesheet" href="css/login.css">
<link rel="stylesheet" href="css/styles.css">
</head>
<body>
	<%@ include file="navbar.jsp"%>
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
	<form action="loginprocess.jsp" method="post">
		<ul class="login-form">
			<li><label for="email">Member ID:</label> <input type="text"
				id="loginid" name="email"></li>
			<li><label for="password">Password:</label> <input
				type="password" id="password" name="password"></li>
			<li>
				<button type="submit" name="btnSubmit">Login</button>
				<button type="reset">Reset</button>
			</li>
		</ul>
	</form>
	<%@ include file="footer.jsp"%>
</body>
</html>