<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard</title>
<link
	href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css"
	rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
	rel="stylesheet">
</head>
<body class="bg-gray-100">
	<!-- userId and admin check -->
	<%@ page import="utils.DBFunctions" %>
	<%
	    String userId = (String)session.getAttribute("userid");
	    if (userId == null || !DBFunctions.checkAdminAuth(userId)) {
	        response.sendRedirect("/JADProject/newlogin.jsp");
	        return;
	    }
	%>
	<div class="flex min-h-screen p-4">
		<%@ include file="components/adminSideBar/adminSideBar.jsp"%>
		<div class="flex-1">
			<%@ include file="components/adminNavbar/adminNavbar.jsp"%>
			<!-- Metrics container -->
			<div class="font-bold text-3xl py-2">Hello, Isaac Low</div>
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
			<!-- Top Selling Products Table -->
			<div class="w-full px-4 flex flex-col gap-6">
				<div class="bg-white rounded-lg shadow-sm p-6 mt-6">
					<div class="mb-4">
						<h2 class="text-xl font-bold">Top Services Provided</h2>
					</div>
					<div class="overflow-x-auto">
						<table class="w-full">
							<thead>
								<tr class="text-left text-gray-500 text-sm border-b">
									<th class="pb-4">SERVICE</th>
									<th class="pb-4">CATEGORY</th>
									<th class="pb-4">PRICE</th>
								</tr>
							</thead>
							<tbody>
								<!-- Nike v22 Running -->
								<tr class="border-b">
									<td class="py-4">
										<div class="flex items-center gap-3">
											<div class="w-12 h-12 bg-gray-200 rounded-lg overflow-hidden">
												<img src="path-to-nike-image.jpg" alt="Nike v22"
													class="w-full h-full object-cover">
											</div>
											<div>
												<div class="font-medium">Nike v22 Running</div>
												<div class="text-sm text-green-600">8,232 orders</div>
											</div>
										</div>
									</td>
									<td class="py-4">Footwear</td>
									<td class="py-4">$130,992</td>
								</tr>

								<!-- Business Kit -->
								<tr class="border-b">
									<td class="py-4">
										<div class="flex items-center gap-3">
											<div class="w-12 h-12 bg-gray-200 rounded-lg overflow-hidden">
												<img src="path-to-business-kit-image.jpg" alt="Business Kit"
													class="w-full h-full object-cover">
											</div>
											<div>
												<div class="font-medium">Business Kit (Mug + Notebook)</div>
												<div class="text-sm text-green-600">12,821 orders</div>
											</div>
										</div>
									</td>
									<td class="py-4">Office</td>
									<td class="py-4">$80,250</td>
								</tr>

								<!-- Black Chair -->
								<tr class="border-b">
									<td class="py-4">
										<div class="flex items-center gap-3">
											<div class="w-12 h-12 bg-gray-200 rounded-lg overflow-hidden">
												<img src="path-to-chair-image.jpg" alt="Black Chair"
													class="w-full h-full object-cover">
											</div>
											<div>
												<div class="font-medium">Black Chair</div>
												<div class="text-sm text-green-600">2,421 orders</div>
											</div>
										</div>
									</td>
									<td class="py-4">Furniture</td>
									<td class="py-4">$40,600</td>
								</tr>

								<!-- Wireless Charger -->
								<tr class="border-b">
									<td class="py-4">
										<div class="flex items-center gap-3">
											<div class="w-12 h-12 bg-gray-200 rounded-lg overflow-hidden">
												<img src="path-to-charger-image.jpg" alt="Wireless Charger"
													class="w-full h-full object-cover">
											</div>
											<div>
												<div class="font-medium">Wireless Charger</div>
												<div class="text-sm text-green-600">5,921 orders</div>
											</div>
										</div>
									</td>
									<td class="py-4">Electronics</td>
									<td class="py-4">$91,300</td>
								</tr>

								<!-- Mountain Trip Kit -->
								<tr>
									<td class="py-4">
										<div class="flex items-center gap-3">
											<div class="w-12 h-12 bg-gray-200 rounded-lg overflow-hidden">
												<img src="path-to-mountain-kit-image.jpg"
													alt="Mountain Trip Kit" class="w-full h-full object-cover">
											</div>
											<div>
												<div class="font-medium">Mountain Trip Kit (Camera +
													Backpack)</div>
												<div class="text-sm text-green-600">921 orders</div>
											</div>
										</div>
									</td>
									<td class="py-4">Outdoor</td>
									<td class="py-4">$140,925</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!-- Container for both tables -->
				<div class="flex gap-6">
					<!-- Recent Bookings Table -->
					<div class="w-1/2 bg-white rounded-lg shadow-sm p-6">
						<div class="mb-4">
							<h2 class="text-xl font-bold">Most Recent Bookings Completed</h2>
						</div>
						<div class="overflow-x-auto">
							<table class="w-full">
								<thead>
									<tr class="text-left text-gray-500 text-sm border-b">
										<th class="pb-4">NAME</th>
										<th class="pb-4">PRICE</th>
										<th class="pb-4">DATE COMPLETED</th>
									</tr>
								</thead>
								<tbody>
									<!-- Nike v22 Running -->
									<tr class="border-b">
										<td class="py-4">
											<div class="flex items-center gap-3">
												<div
													class="w-12 h-12 bg-gray-200 rounded-lg overflow-hidden">
													<img src="path-to-nike-image.jpg" alt="Nike v22"
														class="w-full h-full object-cover">
												</div>
												<div>
													<div class="font-medium">Nike v22 Running</div>
													<div class="text-sm text-green-600">8,232 orders</div>
												</div>
											</div>
										</td>
										<td class="py-4">Footwear</td>
										<td class="py-4">$130,992</td>
									</tr>

									<!-- Business Kit -->
									<tr class="border-b">
										<td class="py-4">
											<div class="flex items-center gap-3">
												<div
													class="w-12 h-12 bg-gray-200 rounded-lg overflow-hidden">
													<img src="path-to-business-kit-image.jpg"
														alt="Business Kit" class="w-full h-full object-cover">
												</div>
												<div>
													<div class="font-medium">Business Kit (Mug +
														Notebook)</div>
													<div class="text-sm text-green-600">12,821 orders</div>
												</div>
											</div>
										</td>
										<td class="py-4">Office</td>
										<td class="py-4">$80,250</td>
									</tr>

									<!-- Black Chair -->
									<tr class="border-b">
										<td class="py-4">
											<div class="flex items-center gap-3">
												<div
													class="w-12 h-12 bg-gray-200 rounded-lg overflow-hidden">
													<img src="path-to-chair-image.jpg" alt="Black Chair"
														class="w-full h-full object-cover">
												</div>
												<div>
													<div class="font-medium">Black Chair</div>
													<div class="text-sm text-green-600">2,421 orders</div>
												</div>
											</div>
										</td>
										<td class="py-4">Furniture</td>
										<td class="py-4">$40,600</td>
									</tr>

									<!-- Wireless Charger -->
									<tr class="border-b">
										<td class="py-4">
											<div class="flex items-center gap-3">
												<div
													class="w-12 h-12 bg-gray-200 rounded-lg overflow-hidden">
													<img src="path-to-charger-image.jpg" alt="Wireless Charger"
														class="w-full h-full object-cover">
												</div>
												<div>
													<div class="font-medium">Wireless Charger</div>
													<div class="text-sm text-green-600">5,921 orders</div>
												</div>
											</div>
										</td>
										<td class="py-4">Electronics</td>
										<td class="py-4">$91,300</td>
									</tr>

									<!-- Mountain Trip Kit -->
									<tr>
										<td class="py-4">
											<div class="flex items-center gap-3">
												<div
													class="w-12 h-12 bg-gray-200 rounded-lg overflow-hidden">
													<img src="path-to-mountain-kit-image.jpg"
														alt="Mountain Trip Kit" class="w-full h-full object-cover">
												</div>
												<div>
													<div class="font-medium">Mountain Trip Kit (Camera +
														Backpack)</div>
													<div class="text-sm text-green-600">921 orders</div>
												</div>
											</div>
										</td>
										<td class="py-4">Outdoor</td>
										<td class="py-4">$140,925</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>

					<!-- High-Value Bookings Table -->
					<div class="w-1/2 bg-white rounded-lg shadow-sm p-6">
						<div class="mb-4">
							<h2 class="text-xl font-bold">High-Value Bookings (>$100)</h2>
						</div>
						<div class="overflow-x-auto">
							<table class="w-full">
								<thead>
									<tr class="text-left text-gray-500 text-sm border-b">
										<th class="pb-4">NAME</th>
										<th class="pb-4">PRICE</th>
										<th class="pb-4">DATE COMPLETED</th>
									</tr>
								</thead>
								<tbody>
									<!-- Booking 1 -->
									<tr class="border-b">
										<td class="py-4">
											<div class="flex items-center gap-3">
												<div
													class="w-10 h-10 bg-gray-200 rounded-full overflow-hidden">
													<img src="path-to-avatar6.jpg" alt="John Anderson"
														class="w-full h-full object-cover">
												</div>
												<div class="font-medium">John Anderson</div>
											</div>
										</td>
										<td class="py-4">$850</td>
										<td class="py-4 text-gray-500">Nov 16, 2024</td>
									</tr>

									<!-- Booking 2 -->
									<tr class="border-b">
										<td class="py-4">
											<div class="flex items-center gap-3">
												<div
													class="w-10 h-10 bg-gray-200 rounded-full overflow-hidden">
													<img src="path-to-avatar7.jpg" alt="Rachel Green"
														class="w-full h-full object-cover">
												</div>
												<div class="font-medium">Rachel Green</div>
											</div>
										</td>
										<td class="py-4">$645</td>
										<td class="py-4 text-gray-500">Nov 15, 2024</td>
									</tr>

									<!-- Booking 3 -->
									<tr class="border-b">
										<td class="py-4">
											<div class="flex items-center gap-3">
												<div
													class="w-10 h-10 bg-gray-200 rounded-full overflow-hidden">
													<img src="path-to-avatar8.jpg" alt="Tom Wilson"
														class="w-full h-full object-cover">
												</div>
												<div class="font-medium">Tom Wilson</div>
											</div>
										</td>
										<td class="py-4">$520</td>
										<td class="py-4 text-gray-500">Nov 15, 2024</td>
									</tr>

									<!-- Booking 4 -->
									<tr class="border-b">
										<td class="py-4">
											<div class="flex items-center gap-3">
												<div
													class="w-10 h-10 bg-gray-200 rounded-full overflow-hidden">
													<img src="path-to-avatar9.jpg" alt="Emma Davis"
														class="w-full h-full object-cover">
												</div>
												<div class="font-medium">Emma Davis</div>
											</div>
										</td>
										<td class="py-4">$495</td>
										<td class="py-4 text-gray-500">Nov 14, 2024</td>
									</tr>

									<!-- Booking 5 -->
									<tr>
										<td class="py-4">
											<div class="flex items-center gap-3">
												<div
													class="w-10 h-10 bg-gray-200 rounded-full overflow-hidden">
													<img src="path-to-avatar10.jpg" alt="Alex Martinez"
														class="w-full h-full object-cover">
												</div>
												<div class="font-medium">Alex Martinez</div>
											</div>
										</td>
										<td class="py-4">$430</td>
										<td class="py-4 text-gray-500">Nov 14, 2024</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>