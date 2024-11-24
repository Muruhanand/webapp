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
            <span class="font-semibold">Cleaning Services PRO</span>
        </div>
    </div>
    
    <!-- Separator with padding -->
    <div class="px-4">
        <div class="h-px bg-gray-200"></div>
    </div>

    <!-- Profile Section -->
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
                    <a href="/JADProject/logout.jsp" class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-lg">
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
        
        <div class="mb-4">
            <a href="userList.jsp" class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-lg">
                <i class="fas fa-users w-5 text-center"></i>
                <span class="ml-3">Users</span>
            </a>
        </div>

        <div class="mb-4">
            <a href="servicesList.jsp" class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-lg">
                <i class="fas fa-cogs w-5 text-center"></i>
                <span class="ml-3">Services</span>
            </a>
        </div>

        <div class="mb-4">
            <a href="categoriesList.jsp" class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-lg">
                <i class="fas fa-calendar-alt w-5 text-center"></i>
                <span class="ml-3">Categories</span>
            </a>
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
            const menu = document.getElementById(clickedMenuId);
            const icon = document.getElementById(clickedMenuId.replace('Menu', 'Icon'));
            
            menu.classList.toggle('dropdown-active');
            icon.style.transform = menu.classList.contains('dropdown-active') 
                ? 'rotate(180deg)' 
                : 'rotate(0deg)';
        }
    </script>
</aside>