<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- ================= STAFF HEADER ================= -->
<nav class="navbar navbar-expand-lg"
     style="background: #fff; border-radius: 18px; box-shadow: 0 4px 15px rgba(94, 59, 183, 0.08);
     padding: 0.8rem 1.5rem; margin: 20px 0 40px; border: 1px solid #e2e8f0;">
    <div class="container-fluid">

        <!-- Logo -->
        <a class="navbar-brand d-flex align-items-center gap-2 fw-bold text-primary"
           href="#">
            <i class="fas fa-utensils"></i>
            Nhà Hàng
        </a>

        <!-- Toggle for mobile -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#staffNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Menu -->
        <div class="collapse navbar-collapse justify-content-center" id="staffNav">
            <ul class="navbar-nav gap-3">
                 <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/staff/dashboard">
                        Staff Dashboard
                    </a>
                </li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/staff/table-order">Quản lý Đặt bàn</a></li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/staff/orders">
                        Quản lý Đơn hàng
                    </a>
                </li>

                <li class="nav-item"><a class="nav-link" href="#">Khu vực bàn</a></li>
            </ul>
        </div>

        <!-- User info -->
        <div class="d-flex align-items-center gap-2">
            <img src="${sessionScope.user.photoUrl != null ? sessionScope.user.photoUrl : '/images/default-avatar.png'}"
                 alt="Staff Avatar"
                 style="width:40px; height:40px; border-radius:50%; border:2px solid #d9c8ff; object-fit:cover;">
            <span class="fw-semibold text-dark">${sessionScope.user.username}</span>

            <!-- Dropdown -->
            <div class="dropdown ms-2">
                <button class="btn btn-light btn-sm dropdown-toggle" type="button" id="dropdownMenuButton"
                        data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fas fa-cog"></i>
                </button>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMenuButton">
                    <li><a class="dropdown-item" href="#">Hồ sơ cá nhân</a></li>
                    <li><a class="dropdown-item" href="#">Đổi mật khẩu</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/auth?action=logout">
                            <i class="fas fa-sign-out-alt"></i> Đăng xuất
                        </a></li>
                </ul>
            </div>
        </div>
    </div>
</nav>
