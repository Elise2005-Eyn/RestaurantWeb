<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background-color: #121212;
            color: #fff;
            font-family: 'Segoe UI', sans-serif;
        }
        .container {
            margin-top: 40px;
            max-width: 900px;
        }
        .card {
            background-color: #1e1e1e;
            border: 1px solid #333;
        }
        th {
            background: #E0B841;
            color: #000;
        }
        .btn-gold {
            background: #E0B841;
            color: #000;
            border: none;
            font-weight: 600;
        }
        .btn-gold:hover {
            background: #b99625;
        }
    </style>
</head>
<body>
<div class="container">
    <h2 class="mb-4 text-warning text-center">📋 CHI TIẾT ĐƠN HÀNG</h2>

    <div class="card p-4 mb-4">
        <p><strong>Mã đơn hàng:</strong> #${orderDetail.order_id}</p>
        <p><strong>Khách hàng:</strong> ${orderDetail.customer_name}</p>
        <p><strong>Bàn:</strong> ${orderDetail.table_code}</p>
        <p><strong>Ngày tạo:</strong> ${orderDetail.created_at}</p>
        <p><strong>Trạng thái:</strong> ${orderDetail.status}</p>
        <p><strong>Loại đơn:</strong> ${orderDetail.order_type}</p>
        <p><strong>Ghi chú:</strong> ${orderDetail.note}</p>
    </div>

    <h4 class="text-warning">🍽 Danh sách món ăn</h4>
    <table class="table table-bordered table-hover text-center align-middle">
        <thead>
        <tr>
            <th>Tên món</th>
            <th>Số lượng</th>
            <th>Giá</th>
            <th>Tạm tính</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="i" items="${items}">
            <tr>
                <td>${i.name}</td>
                <td>${i.quantity}</td>
                <td>${i.price} VND</td>
                <td><strong>${i.subtotal}</strong> VND</td>
            </tr>
        </c:forEach>
        </tbody>
        <tfoot>
        <tr>
            <td colspan="3" class="text-end"><strong>Tổng cộng:</strong></td>
            <td><strong>${orderDetail.amount}</strong> VND</td>
        </tr>
        </tfoot>
    </table>

    <div class="text-center mt-4">
        <a href="${pageContext.request.contextPath}/customer/my-orders"
           class="btn btn-outline-light">⬅ Quay lại danh sách</a>
        <a href="${pageContext.request.contextPath}/menu" class="btn btn-gold">🍴 Đặt lại món</a>
    </div>
</div>
</body>
</html>
