<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Feedback Submission</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
</head>
<body>
<%@ include file="navbar.jsp"%>
<div class="container">
<%
String userId = (String) session.getAttribute("userid");
    String serviceId = request.getParameter("serviceId");
    String serviceName = request.getParameter("serviceName");
    String rating = request.getParameter("rating");
    String comments = request.getParameter("comments");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String connURL = "jdbc:mysql://localhost:3306/jad_ca?user=root&password=root1234&serverTimezone=UTC";
        conn = DriverManager.getConnection(connURL);

        String sqlInsert = "INSERT INTO feedback (customer_id ,service_id, rating, comment) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sqlInsert);
        pstmt.setString(1, userId);
        pstmt.setString(2, serviceId);
        pstmt.setInt(3, Integer.parseInt(rating));
        pstmt.setString(4, comments);
        pstmt.executeUpdate();
%>
        <div class="alert alert-success" role="alert">
            Feedback submitted successfully.
        </div>
<%
    } catch (Exception e) {
%>
        <div class="alert alert-danger" role="alert">
            Error occurred: <%= e.getMessage() %>
        </div>
<%
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
    <a href="index.jsp" class="btn btn-primary">Return to Home</a>
</div>
<%@ include file="footer.jsp"%>
</body>
</html>