<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			// obtain the user id from the session attribute
			String customerId = (String)session.getAttribute("userid");
			
			if (customerId == null) {
				response.sendRedirect("login.jsp");
			} else {
				
				int userId = Integer.valueOf(customerId);
				
				Class.forName("com.mysql.cj.jdbc.Driver");
				String connURL = "jdbc:mysql://localhost:3306/JADCA1?user=root&password=BlaBla968@gmail.com!&serverTimezone=UTC";
				conn = DriverManager.getConnection(connURL);
				
				
				// Query using customer_id
				String sqlStr = "SELECT admin FROM user WHERE customer_id = ? AND admin = true;";
				pstmt = conn.prepareStatement(sqlStr);
				pstmt.setInt(1, userId);
				
				rs = pstmt.executeQuery();
				
				if (!rs.next()) {
					response.sendRedirect("login.jsp");
				}
			}
		} catch (Exception e) {
			System.err.println("Error: " + e);
			e.printStackTrace();
		} finally {
			try {
				// Close resources
				if (rs != null) rs.close();
				if (pstmt != null) pstmt.close();
				if (conn != null) conn.close();
			} catch (Exception e) {
				System.err.println("Error closing resources: " + e);
				e.printStackTrace();
			}
			
		}
	%>
</body>
</html>