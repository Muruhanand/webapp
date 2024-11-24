<%@ page import="java.sql.*"%>
<%@ page import="java.security.MessageDigest"%>
<%@ page import="java.security.NoSuchAlgorithmException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<!-- userId and admin check -->
	<%@ page import="utils.DBFunctions" %>
	<%
	    String customerId = (String)session.getAttribute("userid");
	    if (customerId == null || !DBFunctions.checkAdminAuth(customerId)) {
	        response.sendRedirect("/JADProject/newlogin.jsp");
	        return;
	    }
	%>
	<%
	boolean status = Boolean.valueOf(request.getParameter("status"));
	String userId = request.getParameter("customerId");
	
	Connection conn = null;
	PreparedStatement pstmt = null;

	try {
		// Load the JDBC driver
		Class.forName("com.mysql.cj.jdbc.Driver");

		// Connect to the database
		String connURL = "jdbc:mysql://localhost:3306/JADCA1?user=root&password=BlaBla968@gmail.com!&serverTimezone=UTC";
		conn = DriverManager.getConnection(connURL);

		String sql = "UPDATE user SET status = ? WHERE customer_id = ?;";

		pstmt = conn.prepareStatement(sql);

		// Set parameters for the prepared statement
		pstmt.setBoolean(1, !status);
		pstmt.setString(2, userId);
				
		
		int rows = pstmt.executeUpdate();

		String operation = status ? "deactivated" : "activated";
		String errorOperation = status ? "deactivating" : "activating";
		String statusMessage = (rows > 0) ? "success" : "error";
		String message = (rows > 0) 
		    ? "User " + operation + " successfully" 
		    : "Error " + errorOperation + " user";

		response.sendRedirect("/JADProject/admin/userList.jsp?status=" + statusMessage + "&message=" + message);

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