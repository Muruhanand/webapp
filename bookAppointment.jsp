<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.sql.*, java.util.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Book an Appointment</title>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="css/form.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="js/appointment.js"></script>
</head>
<body>
    <%@ include file="navbar.jsp"%>
    
    <div class="container mt-5">
        <form action="appointmentProcess.jsp" method="post">
            <h3>Book an Appointment with us today!</h3>
            
            <%
            // Display any error or success messages
            String error = request.getParameter("error");
            String success = request.getParameter("success");
            if (error != null) {
            %>
                <div class="alert alert-danger"><%=error%></div>
            <%
            }
            if (success != null) {
            %>
                <div class="alert alert-success"><%=success%></div>
            <%
            }
            
            String serviceId = request.getParameter("serviceid");

            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            Map<String, List<String[]>> servicesByCategory = new HashMap<>();

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                String connURL = "jdbc:mysql://localhost:3306/jadca1?user=root&password=root123&serverTimezone=UTC";
                conn = DriverManager.getConnection(connURL);

                if (serviceId != null && !serviceId.isEmpty()) {
                    // Specific service selected
                    String sqlStr = "SELECT sc.category_name, s.service_name, s.service_id FROM service s " +
                                    "JOIN service_category sc ON s.category_id = sc.category_id WHERE s.service_id = ?";
                    pstmt = conn.prepareStatement(sqlStr);
                    pstmt.setString(1, serviceId);
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
                        String categoryName = rs.getString("category_name");
                        String serviceName = rs.getString("service_name");
                        String selectedServiceId = rs.getString("service_id");
            %>
                <div class="mb-3">
                    <label for="email">Email Address:</label> 
                    <input type="email" id="email" name="email" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label>Cleaning Category:</label> 
                    <select name="categoryOptions" class="form-select" disabled>
                        <option><%=categoryName%></option>
                    </select>
                    <input type="hidden" name="categoryOptions" value="<%=selectedServiceId%>">
                </div>
                <div class="mb-3">
                    <label>Service:</label> 
                    <select name="serviceOptions" class="form-select" disabled>
                        <option><%=serviceName%></option>
                    </select>
                    <input type="hidden" name="serviceOptions" value="<%=selectedServiceId%>">
                </div>
            <%
                    }
                } else {
                    // Populate categories and services dropdowns
                    String sqlStrCategories = "SELECT category_id, category_name FROM service_category";
                    pstmt = conn.prepareStatement(sqlStrCategories);
                    rs = pstmt.executeQuery();

                    while (rs.next()) {
                        String categoryId = rs.getString("category_id");
                        servicesByCategory.put(categoryId, new ArrayList<>());
                    }

                    String sqlStrServices = "SELECT s.category_id, s.service_id, s.service_name, c.category_name FROM service s JOIN service_category c ON s.category_id = c.category_id";
                    pstmt = conn.prepareStatement(sqlStrServices);
                    rs = pstmt.executeQuery();

                    while (rs.next()) {
                        String categoryId = rs.getString("category_id");
                        String serviceIdFromDb = rs.getString("service_id");
                        String serviceName = rs.getString("service_name");
                        String categoryName = rs.getString("category_name");

                        servicesByCategory.get(categoryId).add(new String[]{serviceIdFromDb, serviceName, categoryName});
                    }
            %>
                <div class="mb-3">
                    <label for="email">Email Address:</label> 
                    <input type="email" id="email" name="email" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label for="categoryOptions">Cleaning Category:</label> 
                    <select id="categoryOptions" name="categoryOptions" class="form-select" onchange="populateServices()">
                        <option value="" selected>Select a category</option>
                        <%
                        for (Map.Entry<String, List<String[]>> entry : servicesByCategory.entrySet()) {
                            String categoryId = entry.getKey();
                            String categoryName = entry.getValue().get(0)[2]; 
                        %>
                        <option value="<%=categoryId%>"><%=categoryName%></option>
                        <%
                        }
                        %>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="serviceOptions">Service:</label> 
                    <select id="serviceOptions" name="serviceOptions" class="form-select" required></select>
                </div>
                <script>
                    var servicesByCategory = {
                        <%for (Map.Entry<String, List<String[]>> entry : servicesByCategory.entrySet()) {
                            String categoryId = entry.getKey();
                            List<String[]> services = entry.getValue();
                        %>
                            "<%=categoryId%>": [
                                <%for (String[] service : services) {%>
                                    ["<%=service[0]%>", "<%=service[1]%>"],
                                <%}%>
                            ],
                        <%}%>
                    };
                </script>
            <%
                }
            %>
            <div class="mb-3">
                <label for="dateSelector" class="form-label">Select Date</label> 
                <input type="date" class="form-control" id="dateSelector" name="selectedDate" required>
            </div>
            <div class="mb-3">
                <label for="timeSelectorStart" class="form-label">From:</label>
                <input type="time" class="form-control" id="timeSelectorStart" name="selectedTimeStart" min="09:00" max="18:00" required>
            </div>
            <div class="mb-3">
                <label for="timeSelectorEnd" class="form-label">To:</label>
                <input type="time" class="form-control" id="timeSelectorEnd" name="selectedTimeEnd" min="09:00" max="18:00" required>
            </div>
            <button type="submit" class="btn btn-primary mt-3">Submit Appointment</button>
        </form>
    </div>

    <%@ include file="footer.jsp"%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<%
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>