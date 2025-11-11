<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
  :root {
    --yellow: #F5C518;        /* vàng ánh kim */
    --yellow-dark: #D6A800;   /* hover vàng đậm */
    --black: #111111;         /* đen nền */
    --gray: #2B2B2B;          /* xám đậm */
    --gray-light: #AAAAAA;    /* chữ phụ */
    --white: #FFFFFF;
  }

  .admin-header {
      background-color: var(--black);
      border-bottom: 2px solid var(--yellow);
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 14px 40px;
      font-family: 'Segoe UI', Arial, sans-serif;
      box-shadow: 0 2px 6px rgba(0,0,0,0.4);
  }

  /* Logo và tiêu đề */
  .admin-header-left {
      display: flex;
      align-items: center;
      gap: 10px;
  }

  .admin-header-left h2 {
      color: var(--yellow);
      font-weight: 700;
      font-size: 20px;
      margin: 0;
      display: flex;
      align-items: center;
      gap: 8px;
      text-transform: uppercase;
      letter-spacing: .5px;
  }

  .admin-header-left h2 i {
      color: var(--yellow);
      font-size: 18px;
  }

  /* Menu điều hướng */
  .admin-nav {
      display: flex;
      align-items: center;
      gap: 30px;
  }

  .admin-nav a {
      text-decoration: none;
      color: var(--white);
      font-weight: 500;
      font-size: 15px;
      transition: color 0.25s, border-bottom 0.25s;
      position: relative;
  }

  .admin-nav a:hover {
      color: var(--yellow);
  }

  .admin-nav a.active {
      color: var(--yellow);
      font-weight: 600;
  }

  /* Khu vực người dùng */
  .admin-user {
      display: flex;
      align-items: center;
      gap: 10px;
  }

  .admin-user img {
      width: 34px;
      height: 34px;
      border-radius: 50%;
      object-fit: cover;
      border: 2px solid var(--yellow);
  }

  .admin-user-name {
      color: var(--yellow);
      font-weight: 600;
  }

  /* Dropdown */
  .admin-dropdown {
      position: relative;
      display: inline-block;
  }

  .admin-dropdown-btn {
      background: none;
      border: none;
      cursor: pointer;
      font-size: 18px;
      color: var(--yellow);
      transition: transform 0.2s;
  }

  .admin-dropdown-btn:hover {
      transform: rotate(90deg);
  }

  .admin-dropdown-content {
      display: none;
      position: absolute;
      right: 0;
      top: 40px;
      background-color: var(--gray);
      min-width: 160px;
      box-shadow: 0 3px 10px rgba(0,0,0,0.5);
      border-radius: 6px;
      z-index: 10;
  }

  .admin-dropdown-content a {
      display: block;
      color: var(--white);
      padding: 10px 15px;
      text-decoration: none;
      font-size: 14px;
      border-bottom: 1px solid rgba(255,255,255,0.1);
      transition: background 0.2s, color 0.2s;
  }

  .admin-dropdown-content a:hover {
      background-color: var(--yellow);
      color: var(--black);
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
        <a href="${pageContext.request.contextPath}/admin/voucher">Quản lý vourcher</a>

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
