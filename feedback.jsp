<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Clean Slate Services</title>
<link rel="stylesheet" href="css/styles.css">
</head>
<body>
	<%@ include file="navbar.jsp"%>
	<%
String userId = (String) session.getAttribute("userid");
if (userId == null) {
    response.sendRedirect("newlogin.jsp");
    return;
}
%>

	<div class="container">
    <h2>Feedback Form</h2>
    <form action="submitFeedback.jsp" method="post">
        <div class="form-group">
            <label for="serviceName">Service Name</label>
            <input type="text" class="form-control" id="serviceName" name="serviceName" value="<%= request.getParameter("serviceName") %>" readonly>
        </div>
        <div class="form-group">
            <label for="serviceId">Service ID</label>
            <input type="text" class="form-control" id="serviceId" name="serviceId" value="<%= request.getParameter("serviceId") %>" readonly>
        </div>
        <div class="form-group">
            <label for="rating">Rating</label>
            <select class="form-control" id="rating" name="rating">
                <option value="1">1 - Very Poor</option>
                <option value="2">2 - Poor</option>
                <option value="3">3 - Average</option>
                <option value="4">4 - Good</option>
                <option value="5">5 - Excellent</option>
            </select>
        </div>
        <div class="form-group">
            <label for="comments">Comments</label>
            <textarea class="form-control" id="comments" name="comments" rows="4"></textarea>
        </div>
        <button type="submit" class="btn btn-primary">Submit Feedback</button>
    </form>
	</div>
	<%@ include file="footer.jsp"%>
</body>
</html>