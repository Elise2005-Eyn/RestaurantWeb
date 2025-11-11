<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    .admin-header {
        background-color: #0e0e0e;
        box-shadow: 0 2px 10px rgba(255, 215, 0, 0.15);
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 16px 45px;
        font-family: 'Segoe UI', Arial, sans-serif;
        border-bottom: 1px solid rgba(255, 215, 0, 0.25);
    }

    .admin-header-left {
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .admin-header-left h2 {
        color: #FFD700;
        font-weight: 600;
        font-size: 20px;
        margin: 0;
        display: flex;
        align-items: center;
        gap: 10px;
        text-shadow: 0 0 10px rgba(255, 215, 0, 0.6);
    }

    .admin-header-left h2 i {
        color: #FFD700;
        font-size: 18px;
    }

    .admin-nav {
        display: flex;
        align-items: center;
        gap: 30px;
    }

    .admin-nav a {
        text-decoration: none;
        color: #e6e6e6;
        font-weight: 500;
        transition: color 0.3s, text-shadow 0.3s;
        letter-spacing: 0.2px;
    }

    .admin-nav a:hover {
        color: #FFD700;
        text-shadow: 0 0 8px rgba(255, 215, 0, 0.7);
    }

    .admin-user {
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .admin-user img {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid #FFD700;
        box-shadow: 0 0 10px rgba(255, 215, 0, 0.3);
    }

    .admin-user-name {
        font-weight: 500;
        color: #f1f1f1;
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
        color: #FFD700;
        transition: transform 0.3s;
    }

    .admin-dropdown-btn:hover {
        transform: rotate(25deg);
    }

    .admin-dropdown-content {
        display: none;
        position: absolute;
        right: 0;
        top: 42px;
        background-color: #1a1a1a;
        min-width: 160px;
        box-shadow: 0 2px 10px rgba(255, 215, 0, 0.15);
        border: 1px solid rgba(255, 215, 0, 0.3);
        border-radius: 8px;
        z-index: 10;
    }

    .admin-dropdown-content a {
        display: block;
        color: #f5f5f5;
        padding: 10px 15px;
        text-decoration: none;
        font-size: 14px;
        transition: background 0.2s, color 0.2s;
    }

    .admin-dropdown-content a:hover {
        background-color: rgba(255, 215, 0, 0.15);
        color: #FFD700;
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
        <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/menu">Quản lý món ăn</a>
        <a href="${pageContext.request.contextPath}/admin/orders">Quản lý đơn hàng</a>
        <a href="${pageContext.request.contextPath}/admin/staff">Quản lý nhân viên</a>
        <a href="${pageContext.request.contextPath}/admin/accounts">Quản lý người dùng</a>
        <a href="${pageContext.request.contextPath}/admin/voucher">Quản lý voucher</a>
        <a href="${pageContext.request.contextPath}/admin/reports">Thống kê</a>
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
                <a href="${pageContext.request.contextPath}/admin/profile">Hồ sơ</a>
                <a href="${pageContext.request.contextPath}/admin/settings">Cài đặt</a>
                <a href="${pageContext.request.contextPath}/auth?action=logout">Đăng xuất</a>
            </div>
        </div>
    </div>
</div>
