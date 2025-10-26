<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark px-4 py-3 shadow-sm">
    <div class="container-fluid">
        <!-- Logo -->
        <a class="navbar-brand fw-bold text-warning" href="menu?action=list">
            🍽 Nhà Hàng VIP
        </a>

        <!-- Nút toggle khi mobile -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                data-bs-target="#navbarNav" aria-controls="navbarNav"
                aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Menu chính -->
        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav align-items-center">

                <li class="nav-item">
                    <a class="nav-link" href="menu?action=list">Thực đơn</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="#">Giới thiệu</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="#">Liên hệ</a>
                </li>

                <!-- 🧾 Đơn đặt bàn của tôi -->
                <li class="nav-item">
                    <c:choose>
                        <!-- ✅ Nếu user đã đăng nhập -->
                        <c:when test="${not empty sessionScope.user}">
                            <a class="nav-link text-warning fw-semibold" href="my-reservations">
                                🧾 Đơn của tôi
                            </a>
                        </c:when>

                        <!-- ❌ Nếu chưa đăng nhập -->
                        <c:otherwise>
                            <a class="nav-link text-warning fw-semibold" href="auth?action=login"
                               onclick="alert('Vui lòng đăng nhập để xem đơn đặt bàn của bạn!')">
                                🧾 Đơn của tôi
                            </a>
                        </c:otherwise>
                    </c:choose>
                </li>

                <!-- ✅ Nếu người dùng đã đăng nhập -->
                <c:if test="${not empty sessionScope.user}">
                    <li class="nav-item dropdown ms-3">
                        <a class="nav-link dropdown-toggle text-warning fw-semibold"
                           href="#" id="userDropdown" role="button"
                           data-bs-toggle="dropdown" aria-expanded="false">
                            👋 Xin chào, ${sessionScope.user.username}
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end bg-dark border-0 shadow">
                            <li><a class="dropdown-item text-light" href="#">Tài khoản</a></li>
                            <li><a class="dropdown-item text-light" href="auth?action=logout">Đăng xuất</a></li>
                        </ul>
                    </li>
                </c:if>

                <!-- ❌ Nếu chưa đăng nhập -->
                <c:if test="${empty sessionScope.user}">
                    <li class="nav-item ms-3">
                        <a href="auth?action=login" class="btn btn-outline-warning fw-semibold px-3">
                            Đăng nhập
                        </a>
                    </li>
                    <li class="nav-item ms-2">
                        <a href="auth?action=register" class="btn btn-warning fw-semibold text-dark px-3">
                            Đăng ký
                        </a>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
</nav>
