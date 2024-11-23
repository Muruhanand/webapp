<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
    .dropdown-active {
        max-height: 200px !important;
        opacity: 1 !important;
    }
</style>
<aside class="w-64 bg-white border-r rounded-lg shadow-sm mr-4">
    <!-- Header -->
    <div class="px-6 py-4">
        <div class="flex items-center gap-2">
            <i class="fas fa-cube text-blue-600 w-5 text-center"></i>
            <span class="font-semibold">Material Tailwind PRO</span>
        </div>
    </div>
    
    <!-- Separator with padding -->
    <div class="px-4">
        <div class="h-px bg-gray-200"></div>
    </div>
	<div class="px-4 py-4">
    	<div class="mb-4">
        	<button onclick="toggleDropdown('profileMenu')" 
                	class="w-full flex items-center justify-between px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-lg">
            	<div class="flex items-center">
                	<i class="fas fa-user w-5 text-center"></i>
                	<span class="ml-3">Isaac Low</span>
            	</div>
            	<i id="profileIcon" class="fas fa-chevron-down transform transition-transform duration-300"></i>
        	</button>

        	<div id="profileMenu" class="overflow-hidden transition-all duration-300 max-h-0 opacity-0">
            	<div class="ml-8 mt-2 space-y-1 py-2">
                	<a href="profile.jsp" class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-lg">
                    	<span class="font-medium w-5 text-center">P</span>
                    	<span class="ml-3">Profile</span>
                	</a>
                	<a href="settings.jsp" class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-lg">
                    	<span class="font-medium w-5 text-center">S</span>
                    	<span class="ml-3">Profile Settings</span>
                	</a>
                	<a href="logout.jsp" class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-lg">
                    	<span class="font-medium w-5 text-center">L</span>
                    	<span class="ml-3">Logout</span>
                	</a>
            	</div>
        	</div>
    	</div>
	</div>

    <!-- Separator with padding -->
    <div class="px-4">
        <div class="h-px bg-gray-200"></div>
    </div>

    <!-- Navigation Menu -->
    <nav class="p-4">
        <!-- Main Dashboard -->
        <h6 class="px-3 mb-4 text-xs font-semibold text-gray-600 uppercase">MAIN DASHBOARD</h6>
        <div class="mb-4">
            <a href="dashBoard.jsp" class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-lg">
                <i class="fas fa-chart-pie w-5 text-center"></i>
                <span class="ml-3">Dashboard</span>
            </a>
        </div>

        <!-- Management Section -->
        <h6 class="px-3 mb-4 text-xs font-semibold text-gray-600 uppercase">MANAGEMENT</h6>
        
        <!-- Users Dropdown -->
        <div class="mb-4">
            <button onclick="toggleDropdown('usersMenu')" 
                    class="w-full flex items-center justify-between px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-lg">
                <div class="flex items-center">
                    <i class="fas fa-users w-5 text-center"></i>
                    <span class="ml-3">Users</span>
                </div>
                <i id="usersIcon" class="fas fa-chevron-down transform transition-transform duration-300"></i>
            </button>

            <div id="usersMenu" class="overflow-hidden transition-all duration-300 max-h-0 opacity-0">
                <div class="ml-8 mt-2 space-y-1 py-2">
                    <a href="userList.jsp" class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-lg">
                        <span class="font-medium w-5 text-center">V</span>
                        <span class="ml-3">View Users</span>
                    </a>
                    <a href="products.jsp" class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-lg">
                        <span class="font-medium w-5 text-center">N</span>
                        <span class="ml-3">Create User</span>
                    </a>
                    <a href="orders.jsp" class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-lg">
                        <span class="font-medium w-5 text-center">E</span>
                        <span class="ml-3">Edit User</span>
                    </a>
                </div>
            </div>
        </div>

        <!-- Services Dropdown -->
        <div class="mb-4">
            <button onclick="toggleDropdown('servicesMenu')" 
                    class="w-full flex items-center justify-between px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-lg">
                <div class="flex items-center">
                    <i class="fas fa-cogs w-5 text-center"></i>
                    <span class="ml-3">Services</span>
                </div>
                <i id="servicesIcon" class="fas fa-chevron-down transform transition-transform duration-300"></i>
            </button>

            <div id="servicesMenu" class="overflow-hidden transition-all duration-300 max-h-0 opacity-0">
                <div class="ml-8 mt-2 space-y-1 py-2">
                    <a href="servicesList.jsp" class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-lg">
                        <span class="font-medium w-5 text-center">V</span>
                        <span class="ml-3">View Services</span>
                    </a>
                    <a href="products.jsp" class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-lg">
                        <span class="font-medium w-5 text-center">N</span>
                        <span class="ml-3">New Service</span>
                    </a>
                    <a href="orders.jsp" class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-lg">
                        <span class="font-medium w-5 text-center">E</span>
                        <span class="ml-3">Edit Service</span>
                    </a>
                </div>
            </div>
        </div>

        <!-- Bookings Dropdown -->
        <div class="mb-4">
            <button onclick="toggleDropdown('bookingsMenu')" 
                    class="w-full flex items-center justify-between px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-lg">
                <div class="flex items-center">
                    <i class="fas fa-calendar-alt w-5 text-center"></i>
                    <span class="ml-3">Bookings</span>
                </div>
                <i id="bookingsIcon" class="fas fa-chevron-down transform transition-transform duration-300"></i>
            </button>

            <div id="bookingsMenu" class="overflow-hidden transition-all duration-300 max-h-0 opacity-0">
                <div class="ml-8 mt-2 space-y-1 py-2">
                    <a href="services.jsp" class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-lg">
                        <span class="font-medium w-5 text-center">V</span>
                        <span class="ml-3">View Bookings</span>
                    </a>
                    <a href="products.jsp" class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-lg">
                        <span class="font-medium w-5 text-center">N</span>
                        <span class="ml-3">New Booking</span>
                    </a>
                    <a href="orders.jsp" class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-lg">
                        <span class="font-medium w-5 text-center">E</span>
                        <span class="ml-3">Edit Bookings</span>
                    </a>
                </div>
            </div>
        </div>

        <!-- Docs Section -->
        <h6 class="px-3 mb-4 text-xs font-semibold text-gray-600 uppercase">DOCS</h6>
        <div class="space-y-1">
            <a href="basic.jsp" class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-lg">
                <i class="fas fa-book w-5 text-center"></i>
                <span class="ml-3">Basic</span>
            </a>
            <a href="components.jsp" class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-lg">
                <i class="fas fa-puzzle-piece w-5 text-center"></i>
                <span class="ml-3">Components</span>
            </a>
        </div>
    </nav>
    
    <script>
		function toggleDropdown(clickedMenuId) {
    		const allMenus = ['profileMenu', 'usersMenu', 'servicesMenu', 'bookingsMenu'];
    		const allIcons = ['profileIcon', 'usersIcon', 'servicesIcon', 'bookingsIcon'];
    
    		const clickedMenu = document.getElementById(clickedMenuId);
    		const clickedIcon = document.getElementById(clickedMenuId.replace('Menu', 'Icon'));
    
    		// Close all menus except this one basically only open this one and reset icons
    		allMenus.forEach((menuId, index) => {
        		if (menuId !== clickedMenuId) {
            		const menu = document.getElementById(menuId);
            		const icon = document.getElementById(allIcons[index]);
            		if (menu) {
                		menu.classList.remove('dropdown-active');
            		}
            		if (icon) {
                		icon.style.transform = 'rotate(0deg)';
            		}
        		}
    		});
    
    		clickedMenu.classList.toggle('dropdown-active');
    
    		clickedIcon.style.transform = clickedMenu.classList.contains('dropdown-active') 
        		? 'rotate(180deg)' 
        		: 'rotate(0deg)';
		}
	</script>
</aside>