<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đơn hàng của tôi</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Oswald:wght@600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --color-black: #121212;
            --color-gray-dark: #222222;
            --color-gray-medium: #444444;
            --color-gray-light: #AAAAAA;
            --color-white: #F0F0F0;
            --color-gold: #E0B841;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Lato', sans-serif;
            background-color: var(--color-black);
            color: var(--color-white);
            line-height: 1.6;
        }
        h1, h2 {
            font-family: 'Oswald', sans-serif;
            text-transform: uppercase;
            color: var(--color-gold);
        }

        /* Header */
        .header-main {
            background-color: var(--color-gray-dark);
            padding: 20px 0;
            border-bottom: 2px solid var(--color-gold);
            box-shadow: 0 2px 5px rgba(0,0,0,0.3);
        }
        .header-container {
            max-width: 1200px;
            margin: auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .logo {
            font-family: 'Oswald', sans-serif;
            font-size: 2.2em;
            color: var(--color-white);
            text-decoration: none;
            font-weight: 700;
        }
        .logo span { color: var(--color-gold); }
        .main-nav {
            display: flex;
            gap: 25px;
            align-items: center;
        }
        .main-nav a {
            text-decoration: none;
            color: var(--color-white);
            font-weight: 700;
            font-family: 'Oswald', sans-serif;
            font-size: 1.1em;
            text-transform: uppercase;
            transition: color 0.2s;
        }
        .main-nav a:hover { color: var(--color-gold); }
        .main-nav span {
            color: var(--color-gold);
            font-weight: 700;
            font-size: 1.05em;
        }
        .header-contact {
            background-color: var(--color-gold);
            color: var(--color-black);
            padding: 10px 20px;
            text-align: center;
            font-family: 'Oswald', sans-serif;
            font-weight: 700;
        }

        /* Table */
        .table-custom {
            background-color: var(--color-gray-dark);
            border-color: var(--color-gray-medium);
            color: var(--color-white);
        }
        .table-custom th {
            color: var(--color-black);
            background-color: var(--color-gold);
            text-transform: uppercase;
            border-bottom: 2px solid var(--color-gold);
        }
        .table-custom td {
            border-color: var(--color-gray-medium);
        }
        .table-custom tbody tr:hover {
            background-color: var(--color-gray-medium);
        }

        /* Buttons */
        .btn-gold {
            background-color: var(--color-gold);
            color: var(--color-black);
            border: 1px solid var(--color-gold);
            font-weight: 700;
            font-family: 'Oswald', sans-serif;
            text-transform: uppercase;
            font-size: 0.9em;
            padding: 0.3rem 0.75rem;
            transition: all 0.2s ease;
        }
        .btn-gold:hover {
            background-color: var(--color-gray-dark);
            color: var(--color-gold);
            border-color: var(--color-gold);
        }

        /* Status */
        .status {
            font-weight: bold;
            font-family: 'Oswald', sans-serif;
        }
        .status.COMPLETED { color: #4caf50; }
        .status.PENDING { color: var(--color-gold); }
        .status.CANCELLED { color: #f44336; }

        /* Footer */
        footer {
            background-color: var(--color-gray-dark);
            color: var(--color-gray-light);
            text-align: center;
            padding: 30px;
            margin-top: 50px;
            font-size: 0.9em;
            border-top: 3px solid var(--color-gold);
        }
    </style>
</head>
<body>
<header class="header-main">
    <div class="header-container">
        <a href="${pageContext.request.contextPath}/home" class="logo">NHÀ HÀNG <span>NGON</span></a>
        <nav class="main-nav">
            <a href="${pageContext.request.contextPath}/home">Trang Chủ</a>
            <a href="${pageContext.request.contextPath}/menu?action=list">Thực Đơn</a>
            <a href="${pageContext.request.contextPath}/book-table">Đặt Bàn</a>
            <a href="${pageContext.request.contextPath}/customer/my-orders" style="color: var(--color-gold);">Đơn Hàng</a>
            <c:if test="${empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/auth?action=login">Đăng Nhập</a>
                <a href="${pageContext.request.contextPath}/auth?action=register">Đăng Ký</a>
            </c:if>
            <c:if test="${not empty sessionScope.user}">
                <span>👋 Xin chào, ${sessionScope.user.username}</span>
                <a href="${pageContext.request.contextPath}/auth?action=logout">Đăng Xuất</a>
            </c:if>
        </nav>
    </div>
</header>
<div class="header-contact">
    <strong>📞 HOTLINE: 0123 456 789</strong>
    <strong>⏰ GIỜ MỞ CỬA: 08:00 - 22:00</strong>
</div>

<main class="container py-5">
    <h2 class="text-center mb-5">📦 Đơn hàng của tôi</h2>

    <c:if test="${empty orders}">
        <div class="alert alert-secondary text-center bg-dark text-light border border-gold">
            Bạn chưa có đơn hàng nào!
        </div>
    </c:if>

    <c:if test="${not empty orders}">
        <div class="table-responsive">
            <table class="table table-custom table-hover align-middle text-center">
                <thead>
                <tr>
                    <th>Mã đơn</th>
                    <th>Ngày tạo</th>
                    <th>Loại đơn</th>
                    <th>Trạng thái</th>
                    <th>Tổng tiền</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="o" items="${orders}">
                    <tr>
                        <td>#${o.orderId}</td>
                        <td>${o.createdAt}</td>
                        <td>${o.orderType}</td>
                        <td><span class="status ${o.status}">${o.status}</span></td>
                        <td><strong>${o.amount}</strong> VND</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/customer/order-detail?orderId=${o.orderId}"
                               class="btn btn-gold btn-sm">Chi tiết</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>
</main>

<footer>
    © 2025 - Nhà hàng Demo | Liên hệ: info@restaurant.com | Hotline: 0123 456 789
</footer>
</body>
</html>
