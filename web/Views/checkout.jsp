<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, Models.CartItem" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Thanh toán & Chi tiết Đơn hàng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        /* CSS TỔNG QUAN VÀ NỀN */
        body {
            /* Dùng background từ file thứ hai */
            background: url('imgs/mon_an02.png') no-repeat center center fixed;
            background-size: cover;
            color: white;
            min-height: 100vh; /* Đảm bảo đủ chiều cao */
        }
        .container {
            /* Thêm lớp phủ cho container để dễ đọc */
            background-color: rgba(0,0,0,0.85); 
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 0 20px rgba(224, 184, 65, 0.5); /* Thêm box-shadow màu vàng */
            margin-top: 50px;
            margin-bottom: 50px;
        }

        /* CSS BẢNG */
        .table {
            border: 1px solid #e0b841; /* Viền bảng màu vàng */
        }
        .table-dark {
             --bs-table-bg: #1c1c1c; /* Nền bảng tối hơn */
             --bs-table-border-color: #333; /* Viền ô */
             color: white;
        }
        .table th, .table td {
            vertical-align: middle !important;
            border-color: #333;
        }
        .table thead {
            background-color: #6a0dad; /* Màu header cũ */
        }

        /* CSS HỘP TỔNG */
        .total-box {
            background-color: #2a2a2a; /* Hộp tổng tối hơn */
            padding: 15px;
            border-radius: 10px;
            border: 1px solid #e0b841; /* Viền vàng nổi bật */
        }
        .highlight-text {
            color: #e0b841; /* Màu vàng */
            font-weight: bold;
        }

        /* CSS NÚT */
        .btn-primary-custom, .btn-success-custom {
            /* Tên class mới cho nút chính */
            background-color: #e0b841;
            border: none;
            color: #111;
            font-weight: bold;
            transition: background-color 0.3s;
        }
        .btn-primary-custom:hover, .btn-success-custom:hover {
            background-color: #c49f3c;
            color: #111;
        }
        .btn-secondary-custom {
            background-color: #343a40;
            border: none;
            color: white;
        }
        .btn-secondary-custom:hover {
            background-color: #495057;
            color: white;
        }
    </style>
</head>
<body>
<div class="container py-5">
    <h2 class="text-center mb-5 highlight-text">🧾 Chi Tiết Đơn Hàng</h2>

<%
    // Logic tính tổng (từ file thứ nhất)
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    double total = 0;
    if(cart != null) {
        for(CartItem item : cart) {
            // Đảm bảo item.total được tính đúng
            // Hoặc tính lại total nếu item.total không tồn tại trong CartItem
            total += item.getPrice() * item.getQuantity();
        }
    } else {
        // Trường hợp giỏ hàng trống, chuyển hướng hoặc hiển thị thông báo
        // Giữ nguyên logic chuyển hướng của file gốc (Order Details) nếu giỏ hàng trống.
        // Tuy nhiên, logic JSTL phía dưới đã xử lý hiển thị thông báo.
    }
%>

<c:choose>
    <%-- TRƯỜNG HỢP GIỎ HÀNG KHÔNG TRỐNG (Cả 2 file đều có phần hiển thị này) --%>
    <c:when test="${not empty sessionScope.cart}">
        <table class="table table-dark table-bordered text-center">
            <thead>
                <tr>
                    <th>Tên món</th>
                    <th>Giá (VND)</th>
                    <th>Số lượng</th>
                    <th>Tổng (VND)</th>
                </tr>
            </thead>
            <tbody>
                <%-- Sử dụng JSTL để lặp và tính tổng (tương tự file thứ hai) --%>
                <c:set var="totalJSTL" value="0"/>
                <c:forEach var="item" items="${sessionScope.cart}">
                    <tr>
                        <td>${item.name}</td>
                        <td>${item.price}</td>
                        <td>${item.quantity}</td>
                        <%-- Giả định item.total đã được tính trong CartItem hoặc Servlet --%>
                        <td>${item.total}</td> 
                    </tr>
                    <c:set var="totalJSTL" value="${totalJSTL + item.total}"/>
                </c:forEach>
            </tbody>
        </table>

        <div class="text-end mt-4 total-box">
            <h4>Tổng cộng: <span class="highlight-text">${totalJSTL} VND</span></h4>
            <%-- Dùng biến JSTL tính được để đồng bộ --%>
        </div>

        <div class="text-center mt-5">
            <%-- NÚT QUAY LẠI CART (Từ file 1) --%>
            <a href="cart" class="btn btn-secondary-custom btn-lg me-3">⬅ Quay lại Giỏ hàng</a>
            
            <%-- FORM THANH TOÁN (Từ file 1, dẫn đến 'payment') --%>
            <form action="payment" method="post" style="display:inline;">
                <input type="hidden" name="orderInfo" value="Thanh toán đơn hàng tại Nhà hàng Demo">
                <%-- Sử dụng biến JSTL để truyền tổng tiền --%>
                <input type="hidden" name="amount" value="${totalJSTL}"> 
                <button type="submit" class="btn btn-lg btn-primary-custom">Xác nhận thanh toán </button>
            </form>
            

        </div>
    </c:when>

    <%-- TRƯỜNG HỢP GIỎ HÀNG TRỐNG --%>
    <c:otherwise>
        <div class="alert alert-warning text-center" role="alert">
            Giỏ hàng trống. Vui lòng chọn món trước khi thanh toán.
        </div>
        <div class="text-center mt-4">
            <a href="menu?action=list" class="btn btn-primary btn-lg btn-secondary-custom">⬅ Quay lại Menu</a>
        </div>
    </c:otherwise>
</c:choose>

</div>
</body>
</html>