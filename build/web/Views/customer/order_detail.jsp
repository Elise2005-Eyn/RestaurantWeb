<%@ page contentType="text/html;charset=UTF-8" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng #${order.orderId}</title>
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
        body {
            background-color: var(--color-black);
            color: var(--color-white);
            font-family: 'Lato', sans-serif;
        }
        h2, h3 {
            font-family: 'Oswald', sans-serif;
            color: var(--color-gold);
        }

        /* Header */
        .header-main {
            background-color: var(--color-gray-dark);
            padding: 20px 0;
            border-bottom: 2px solid var(--color-gold);
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
            font-size: 2em;
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
            text-transform: uppercase;
            transition: color 0.2s;
        }
        .main-nav a:hover { color: var(--color-gold); }
        .main-nav span {
            color: var(--color-gold);
            font-weight: 700;
        }
        .header-contact {
            background-color: var(--color-gold);
            color: var(--color-black);
            padding: 10px 20px;
            text-align: center;
            font-family: 'Oswald', sans-serif;
            font-weight: 700;
        }

        /* Content */
        .order-container {
            max-width: 1000px;
            margin: 60px auto;
            background: var(--color-gray-dark);
            padding: 40px 50px;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(255, 255, 255, 0.05);
        }
        .info-label {
            color: var(--color-gold);
            font-weight: bold;
            width: 160px;
            display: inline-block;
        }
        .divider {
            border-top: 2px solid var(--color-gold);
            margin: 25px 0;
        }
        table {
            background: var(--color-gray-dark);
            color: var(--color-white);
            border-color: var(--color-gray-medium);
        }
        th {
            background-color: var(--color-gold);
            color: var(--color-black);
            text-transform: uppercase;
        }
        td {
            background-color: var(--color-gray-medium);
        }
        .total {
            text-align: right;
            font-weight: bold;
            color: var(--color-gold);
            margin-top: 15px;
            font-size: 1.1em;
        }
        .btn-gold {
            background-color: var(--color-gold);
            color: var(--color-black);
            border: 1px solid var(--color-gold);
            font-family: 'Oswald', sans-serif;
            font-weight: 700;
            text-transform: uppercase;
            padding: 10px 25px;
            transition: all 0.2s ease;
        }
        .btn-gold:hover {
            background-color: var(--color-gray-dark);
            color: var(--color-gold);
            border-color: var(--color-gold);
        }

        /* Footer */
        footer {
            background-color: var(--color-gray-dark);
            color: var(--color-gray-light);
            text-align: center;
            padding: 30px;
            margin-top: 60px;
            border-top: 3px solid var(--color-gold);
            font-size: 0.9em;
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
                <span>👋 ${sessionScope.user.username}</span>
                <a href="${pageContext.request.contextPath}/auth?action=logout">Đăng Xuất</a>
            </c:if>
        </nav>
    </div>
</header>
<div class="header-contact">
    <strong>📞 HOTLINE: 0123 456 789</strong>
    <strong>⏰ GIỜ MỞ CỬA: 08:00 - 22:00</strong>
</div>

<main class="order-container">
    <h2>📄 Chi tiết đơn hàng #${order.orderId}</h2>

    <p><span class="info-label">Khách hàng:</span> ${order.customerName}</p>
    <p><span class="info-label">Ngày tạo:</span> ${order.createdAt}</p>
    <p><span class="info-label">Trạng thái:</span> ${order.status}</p>
    <p><span class="info-label">Loại đơn:</span> ${order.orderType}</p>
    <p><span class="info-label">Ghi chú:</span> ${order.note}</p>

    <div class="divider"></div>

    <h3>🍽️ Danh sách món ăn</h3>

    <table class="table table-bordered text-center align-middle mt-3">
        <thead>
            <tr>
                <th>Tên món</th>
                <th>Số lượng</th>
                <th>Đơn giá</th>
                <th>Thành tiền</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="item" items="${items}">
                <tr>
                    <td>${item.note}</td>
                    <td>${item.quantity}</td>
                    <td>${item.price}</td>
                    <td>${item.price * item.quantity}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <div class="total">Tổng cộng: ${order.amount} VND</div>

    <div class="text-center mt-4">
        <a href="${pageContext.request.contextPath}/customer/my-orders" class="btn btn-gold">⬅ Quay lại</a>
    </div>
</main>

<footer>
    © 2025 - Nhà hàng Demo | Liên hệ: info@restaurant.com | Hotline: 0123 456 789
</footer>
</body>
</html>
