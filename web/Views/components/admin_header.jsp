<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    .admin-header {
        background-color: #fff;
        box-shadow: 0 2px 6px rgba(0,0,0,0.08);
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 14px 40px;
        font-family: 'Segoe UI', Arial, sans-serif;
    }

    .admin-header-left {
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .admin-header-left h2 {
        color: #007bff;
        font-weight: 600;
        font-size: 20px;
        margin: 0;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .admin-header-left h2 i {
        color: #007bff;
        font-size: 18px;
    }

    .admin-nav {
        display: flex;
        align-items: center;
        gap: 28px;
    }

    .admin-nav a {
        text-decoration: none;
        color: #444;
        font-weight: 500;
        transition: color 0.2s;
    }

    .admin-nav a:hover {
        color: #007bff;
    }

    .admin-user {
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .admin-user img {
        width: 34px;
        height: 34px;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid #e0e0e0;
    }

    .admin-user-name {
        font-weight: 500;
        color: #333;
    }

    .admin-dropdown {
        position: relative;
        display: inline-block;
    }

    .admin-dropdown-btn {
        background: none;
        border: none;
        cursor: pointer;
        font-size: 18px;
        color: #555;
    }

    .admin-dropdown-content {
        display: none;
        position: absolute;
        right: 0;
        top: 40px;
        background-color: #fff;
        min-width: 150px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        border-radius: 6px;
        z-index: 10;
    }

    .admin-dropdown-content a {
        display: block;
        color: #333;
        padding: 10px 15px;
        text-decoration: none;
        font-size: 14px;
    }

    .admin-dropdown-content a:hover {
        background-color: #f0f0f0;
    }

    .admin-dropdown:hover .admin-dropdown-content {
        display: block;
    }
</style>

<div class="admin-header">
    <div class="admin-header-left">
        <h2><i class="fa-solid fa-utensils"></i> Nhà Hàng (Admin)</h2>
    </div>

    <div class="admin-nav">
        <a href="#">Dashboard</a>
        <a href="#">Quản lý món ăn</a>
        <a href="#">Quản lý đơn hàng</a>
        <a href="#">Quản lý nhân viên</a>
        <a href="#">Thống kê</a>
    </div>

    <div class="admin-user">
        <img src="<c:out value='${sessionScope.user.photoUrl}' default='/imgs/default-avatar.png'/>" alt="Avatar">
        <span class="admin-user-name">
            <c:out value="${sessionScope.user.username}" default="Admin"/>
        </span>

        <div class="admin-dropdown">
            <button class="admin-dropdown-btn">
                <i class="fa-solid fa-gear"></i>
            </button>
            <div class="admin-dropdown-content">
                <a href="#">Hồ sơ</a>
                <a href="#">Cài đặt</a>
                <a href="${pageContext.request.contextPath}/auth?action=logout">Đăng xuất</a>
            </div>
        </div>
    </div>
</div>
