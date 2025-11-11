<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- ================= STAFF HEADER ================= -->
<nav class="navbar navbar-expand-lg"
     style="background: #222222; 
            border-radius: 18px; 
            padding: 1rem 1.5rem; 
            margin: 20px 0 40px; 
            border: 1px solid #444444;">
    <div class="container-fluid">

        <!-- Logo -->
        <a class="navbar-brand d-flex align-items-center gap-2 fw-bold"
           href="#"
           style="color: #E0B841;
           font-family: 'Oswald', sans-serif;
           font-size: 1.45rem;
           text-transform: uppercase;
           letter-spacing: 1.5px;
           transition: color 0.3s ease;"
           >
            <i class="fas fa-utensils"></i>
            Nhà Hàng
        </a>

        <!-- Toggle for mobile -->
        <button class="navbar-toggler border-0" 
                type="button" 
                data-bs-toggle="collapse" 
                data-bs-target="#staffNav">
            <span class="navbar-toggler-icon"
                  style="filter: brightness(0) invert(1);"></span>
        </button>

        <!-- Menu -->
        <div class="collapse navbar-collapse justify-content-center" id="staffNav">
            <ul class="navbar-nav gap-4" style="font-weight: 600;">
                <li class="nav-item">
                    <a class="nav-link position-relative text-white" 
                       href="${pageContext.request.contextPath}/staff/dashboard">
                        Staff Dashboard
                        <span class="position-absolute bottom-0 start-0 w-100 h-1px bg-warning opacity-0" 
                              style="transition: opacity 0.3s ease; height: 2px;"></span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link position-relative text-white" 
                       href="${pageContext.request.contextPath}/staff/reservation_list">
                        Quản lý Đặt bàn
                        <span class="position-absolute bottom-0 start-0 w-100 h-1px bg-warning opacity-0" 
                              style="transition: opacity 0.3s ease; height: 2px;"></span>
                    </a>
                </li>
                <li class="nav-item"><a class="nav-link position-relative text-white" 
                                        href="${pageContext.request.contextPath}/staff/tables">Khu vực bàn
                        <span class="position-absolute bottom-0 start-0 w-100 h-1px bg-warning opacity-0" 
                              style="transition: opacity 0.3s ease; height: 2px;"></span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link position-relative text-white" 
                       href="${pageContext.request.contextPath}/staff/orders">
                        Quản lý Đơn hàng
                        <span class="position-absolute bottom-0 start-0 w-100 h-1px bg-warning opacity-0" 
                              style="transition: opacity 0.3s ease; height: 2px;"></span>
                    </a>
                </li>               
            </ul>
        </div>

        <!-- User info -->
        <div class="d-flex align-items-center gap-3">
            <img src="${sessionScope.user.photoUrl != null ? sessionScope.user.photoUrl : '/images/default-avatar.png'}"
                 alt="Staff Avatar"
                 style="width:44px;
                 height:44px;
                 border-radius:50%; 
                 border:2.5px solid #E0B841; 
                 object-fit:cover;
                 box-shadow: 0 0 20px rgba(224, 184, 65, 0.4);">
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
