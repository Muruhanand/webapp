<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*, java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Book an Appointment!</title>
<link rel="stylesheet" href="css/styles.css">
<link rel="stylesheet" href="css/form.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Josefin+Sans&family=Libre+Baskerville:ital,wght@0,400;0,700;1,400&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="js/appointment.js"></script>
</head>
<body>
    <%@ include file="navbar.jsp"%>
    <h3 class="display-3 text-center">Book an Appointment with us today!</h3>
    <form action="appointmentProcess.jsp" method="post">
        <%
        String serviceId = request.getParameter("serviceid");

        String errMsg = request.getParameter("error");
        if (errMsg != null && !errMsg.isEmpty()) {
        %>
        <div class="alert alert-danger" role="alert">
            <%=errMsg%>
        </div>
        <%
        }

        String succMsg = request.getParameter("success");
        if (succMsg != null && !succMsg.isEmpty()) {
        %>
        <div class="alert alert-success" role="alert">
            <%=succMsg%>
        </div>
        <%
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Map<String, List<String[]>> servicesByCategory = new HashMap<>();

        String email = null;
        PreparedStatement pstmt2 = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String connURL = "jdbc:mysql://localhost:3306/jadca1?user=root&password=root123&serverTimezone=UTC";
            conn = DriverManager.getConnection(connURL);

            if(session.getAttribute("userid") != null) {
                String customerid = (String) session.getAttribute("userid");
                String sqlStr2 = "SELECT email FROM user WHERE customer_id = ?";
                pstmt2 = conn.prepareStatement(sqlStr2);
                pstmt2.setString(1, customerid);
                rs = pstmt2.executeQuery();
                if (rs.next()) {
                    email = rs.getString("email");
        %>
        <div class="mb-3" style="display: none;">
            <label for="email" class="form-label">Email:</label>
            <input type="email" class="form-control" id="email" name="email" value="<%=email%>" required>
        </div>
        <%
                }
            } else {
                out.println("<script>alert('Please log in to book an appointment.');window.location.href = 'index.jsp';</script>");
            }

            if (serviceId != null && !serviceId.isEmpty()) {
                String sqlStr = "SELECT sc.category_id, sc.category_name, s.service_name FROM service s "
                + "JOIN service_category sc ON s.category_id = sc.category_id WHERE s.service_id = ?";
                pstmt = conn.prepareStatement(sqlStr);
                pstmt.setString(1, serviceId);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    String categoryId = rs.getString("category_id");
                    String categoryName = rs.getString("category_name");
                    String serviceName = rs.getString("service_name");
        %>
        <div class="mb-3">
            <label>Cleaning Category:</label>
            <select class="form-select" disabled>
                <option><%=categoryName%></option>
            </select>
        </div>
        <div class="mb-3">
            <label>Service:</label>
            <select class="form-select" disabled>
                <option><%=serviceName%></option>
            </select>
        </div>
        <input type="hidden" name="categoryOptions" value="<%=categoryId%>">
        <input type="hidden" name="serviceOptions" value="<%=serviceId%>">
        <%
                }
            } else {
                // Query for all categories and services
                String sqlStrCategories = "SELECT category_id, category_name FROM service_category";
                pstmt = conn.prepareStatement(sqlStrCategories);
                rs = pstmt.executeQuery();

                while (rs.next()) {
                    String categoryId = rs.getString("category_id");
                    String categoryName = rs.getString("category_name");
                    servicesByCategory.put(categoryId, new ArrayList<>());
                }

                String sqlStrServices = "SELECT s.category_id, s.service_id, s.service_name, c.category_name FROM service s JOIN service_category c ON s.category_id = c.category_id ORDER BY c.category_id";
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
            <label>Cleaning Category:</label>
            <select name="categoryOptions" id="categoryOptions" class="form-select" onchange="populateServices()">
                <option value="" selected>Select a category</option>
                <%
                if (servicesByCategory != null && !servicesByCategory.isEmpty()) {
                    for (Map.Entry<String, List<String[]>> entry : servicesByCategory.entrySet()) {
                        String categoryId = entry.getKey();
                        List<String[]> categories = entry.getValue();
                        if (categories != null && !categories.isEmpty()) {
                            String categoryName = categories.get(0)[2]; // Assuming the first entry has the category name
                %>
                <option value="<%=categoryId%>"><%=categoryName%></option>
                <%
                        }
                    }
                }
                %>
            </select>
        </div>
        <div class="mb-3">
            <label>Service:</label>
            <select id="serviceOptions" class="form-select" name="serviceOptions"></select>
        </div>
        <script>
            var servicesByCategory = {
                <%for (Map.Entry<String, List<String[]>> entry : servicesByCategory.entrySet()) {
                    String categoryId = entry.getKey();
                    List<String[]> services = entry.getValue();%>
                    "<%=categoryId%>": [
                        <%for (String[] service : services) {%>
                            ["<%=service[0]%>", "<%=service[1]%>"],
                        <%}%>
                    ],
                <%}%>
            };

            function populateServices() {
                var categorySelect = document.getElementById("categoryOptions");
                var serviceSelect = document.getElementById("serviceOptions");
                var selectedCategory = categorySelect.value;

                serviceSelect.innerHTML = "";

                if (servicesByCategory[selectedCategory]) {
                    servicesByCategory[selectedCategory].forEach(function(service) {
                        var option = document.createElement("option");
                        option.value = service[0];
                        option.text = service[1];
                        serviceSelect.appendChild(option);
                    });
                }
            }
        </script>
        <%
            }
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
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
        <button type="submit" class="btn btn-primary mt-3" id="submitBtn">Submit</button>
    </form>
    <%@ include file="footer.jsp"%>
</body>
</html>