<%@ page import="java.sql.*"%>
<%@ page import="java.security.MessageDigest"%>
<%@ page import="java.security.NoSuchAlgorithmException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update Existing User</title>
</head>
<body>
	<%
	// get from hidden field basically
	int customerId = Integer.valueOf(request.getParameter("userId"));
	
	// Get parameters from the request
	String firstName = request.getParameter("first_name");
	String lastName = request.getParameter("last_name");
	String email = request.getParameter("email");
	String phoneNumber = request.getParameter("phone_number");
	String address = request.getParameter("address");
	String password = request.getParameter("password");
	String admin = request.getParameter("admin");

	boolean checkAdmin = Boolean.valueOf(admin);

	// Hash the password with SHA-256
	String hashedPassword = null;
	try {
		MessageDigest md = MessageDigest.getInstance("SHA-256");
		byte[] hashedBytes = md.digest(password.getBytes("UTF-8"));
		StringBuilder sb = new StringBuilder();
		for (byte b : hashedBytes) {
			sb.append(String.format("%02x", b)); // Convert each byte to a hex string
		}
		hashedPassword = sb.toString();
	} catch (NoSuchAlgorithmException | java.io.UnsupportedEncodingException e) {
		e.printStackTrace();
	}

	Connection conn = null;
	PreparedStatement pstmt = null;

	try {
		// Load the JDBC driver
		Class.forName("com.mysql.cj.jdbc.Driver");

		// Connect to the database
		String connURL = "jdbc:mysql://localhost:3306/JADCA1?user=root&password=BlaBla968@gmail.com!&serverTimezone=UTC";
		conn = DriverManager.getConnection(connURL);

		// just checks if password is left blank or nah
		String sql = password.equals("")
			? "UPDATE user SET admin=?, first_name=?, last_name=?, email=?, phone_number=?, address=? WHERE customer_id=?"
			: "UPDATE user SET admin=?, first_name=?, last_name=?, email=?, phone_number=?, address=?, password=? WHERE customer_id=?";
		
		pstmt = conn.prepareStatement(sql);

		pstmt.setBoolean(1, checkAdmin);
		pstmt.setString(2, firstName);
		pstmt.setString(3, lastName);
		pstmt.setString(4, email);
		pstmt.setString(5, phoneNumber);
		pstmt.setString(6, address);
		if (!password.equals("")) {
			pstmt.setString(7, hashedPassword);
			pstmt.setInt(8, customerId);
		} else {
			pstmt.setInt(7, customerId);
		}

		int rows = pstmt.executeUpdate();

		if (rows > 0) {
			response.sendRedirect("/JADProject/admin/userList.jsp?status=success&message=Updated User successfully");
		} else {
			response.sendRedirect("/JADProject/admin/userList.jsp?status=error&message=Error Updating user"); 
		}
	} catch (Exception e) {
		e.printStackTrace();
		response.sendRedirect("/JADProject/admin/userList.jsp?status=error&message=" + e.getMessage());
	} finally {
		// Close resources
		if (pstmt != null)
			pstmt.close();
		if (conn != null)
			conn.close();
	}
	%>
</body>
</html>
