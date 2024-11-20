<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100">
    <div class="flex min-h-screen p-4">
    <%@ include file="components/adminSideBar/adminSideBar.jsp" %>
    <div class="flex-1">
        <%@ include file="components/adminNavbar/adminNavbar.jsp" %>
        <!-- Metrics container -->
        <div class="font-bold text-3xl">Hello, Isaac Low</div>
        <div class="w-full p-4">
            <div class="flex gap-6">
                <!-- Products Sold -->
                <div class="bg-white rounded-lg shadow-sm p-6 flex-1">
                	<div class="flex items-center gap-4">
                		<div class="text-blue-500">
                			<i class="fas fa-tag text-2xl"></i>
                		</div>
                		<div>
                			<div class="text-2xl font-bold">237</div>
                			<div class="text-gray-500 text-sm">Products sold</div>
                		</div>
                	</div>
                </div>
                
                <!-- Product Reviews -->
                <div class="bg-white rounded-lg shadow-sm p-6 flex-1">
                    <div class="flex items-center gap-4">
                        <div class="text-yellow-500">
                            <i class="fas fa-star text-2xl"></i>
                        </div>
                        <div>
                            <div class="text-2xl font-bold">177</div>
                            <div class="text-gray-500 text-sm">Product Reviews</div>
                        </div>
                    </div>
                </div>

                <!-- New Enquiries -->
                <div class="bg-white rounded-lg shadow-sm p-6 flex-1">
                    <div class="flex items-center gap-4">
                        <div class="text-green-500">
                            <i class="fas fa-comment text-2xl"></i>
                        </div>
                        <div>
                            <div class="text-2xl font-bold">31</div>
                            <div class="text-gray-500 text-sm">New Enquiries</div>
                        </div>
                    </div>
                </div>

                <!-- Product Views -->
                <div class="bg-white rounded-lg shadow-sm p-6 flex-1">
                    <div class="flex items-center gap-4">
                        <div class="text-purple-500">
                            <i class="fas fa-chart-line text-2xl"></i>
                        </div>
                        <div>
                            <div class="text-2xl font-bold">1,653</div>
                            <div class="text-gray-500 text-sm">Product Views</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>