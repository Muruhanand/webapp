<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<nav class="bg-white border rounded-lg shadow-sm mb-4">
    <div class="flex justify-between items-center p-4">
        <!-- Breadcrumb -->
        <div class="flex items-center gap-2">
            <a href="/JADProject/admin/dashBoard.jsp" class="text-gray-400 hover:text-gray-900">/</a>
            <span class="text-gray-400">Pages</span>
        </div>

        <!-- Right Section -->
        <div class="flex items-center gap-4">
            <div class="relative">
                <input type="text" 
                    placeholder="Search" 
                    class="pl-3 pr-10 py-1.5 border rounded-lg text-sm">
                <i class="fas fa-search absolute right-3 top-2 text-gray-400"></i>
            </div>

            <div class="flex items-center gap-4">
                <button class="p-1.5 hover:bg-gray-100 rounded-lg">
                    <i class="fas fa-cog text-gray-600"></i>
                </button>
                <button class="p-1.5 hover:bg-gray-100 rounded-lg">
                    <i class="fas fa-bell text-gray-600"></i>
                </button>
                <button class="flex items-center gap-2">
                    <img src="assets/avatar.jpg" alt="Profile" class="w-8 h-8 rounded-full">
                </button>
            </div>
        </div>
    </div>
</nav>