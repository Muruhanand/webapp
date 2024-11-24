<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Navbar</title>
<link rel="stylesheet" href="css/navbar.css">
</head>
<body>
	<nav>
		<ul id="nav-container">
			<li><a href="index.jsp"><img src="media/brand-logo.png"
					alt="WebsiteLogo" class="navbarLogo"></a></li>
			<li><a href="serviceCategory.jsp">Browse Services</a></li>

			<%
			String userid = (String) session.getAttribute("userid");

			if (userid != null) {
				// Database variables
				Connection conn = null;
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				boolean isAdmin = false;

				try {
					Class.forName("com.mysql.cj.jdbc.Driver");
					String connURL = "jdbc:mysql://localhost:3306/JADCA1?user=root&password=BlaBla968@gmail.com!&serverTimezone=UTC";
					conn = DriverManager.getConnection(connURL);

					// Query to check admin status
					pstmt = conn.prepareStatement("SELECT admin FROM user WHERE customer_id = ?");
					pstmt.setString(1, userid);
					rs = pstmt.executeQuery();

					if (rs.next()) {
				isAdmin = rs.getBoolean("admin");
					}
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
					} catch (SQLException e) {
				e.printStackTrace();
					}
				}
			%>
			<li><a href="bookAppointment.jsp">Book an Appointment</a></li>
			<li><a href="cart.jsp">Cart</a></li>
			<li><a href="profilelogic.jsp">Profile</a></li>
			<li><a href="logout.jsp">Logout</a></li>
			<%
			if (isAdmin) {
			%>
			<li><a href="admin/dashBoard.jsp">Dashboard</a></li>
			<%
			}
			%>
			<%
			} else {
			%>
			<li><a href="newlogin.jsp">Login</a></li>
			<%
			}
			%>
		</ul>
	</nav>
</body>
</html>