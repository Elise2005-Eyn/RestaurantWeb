<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<jsp:include page="/Views/components/staff_header.jsp" />

<div class="container mt-5">
    <div class="card shadow-sm mx-auto" style="max-width: 800px;">
        <div class="card-header bg-primary text-white fw-bold">
            <i class="fas fa-receipt"></i> Chi tiết đơn hàng #${order.order_id}
        </div>
        <div class="card-body">
            <p><strong>Khách hàng:</strong> ${order.customer_name}</p>
            <p><strong>Bàn:</strong> ${order.table_code}</p>
            <p><strong>Trạng thái:</strong> ${order.status}</p>
            <p><strong>Loại đơn hàng:</strong> ${order.order_type}</p>
            <p><strong>Ngày tạo:</strong> ${order.created_at}</p>
            <p><strong>Ghi chú:</strong> ${order.note}</p>

            <hr>

            <h6 class="fw-bold mb-3">Danh sách món ăn</h6>
            <table class="table table-bordered align-middle text-center">
                <thead class="table-light">
                    <tr>
                        <th>Tên món</th>
                        <th>Số lượng</th>
                        <th>Giá (₫)</th>
                        <th>Tổng (₫)</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${items}">
                        <tr>
                            <td>${item.name}</td>
                            <td>${item.quantity}</td>
                            <td>${item.price}</td>
                            <td>${item.subtotal}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div class="text-end fw-bold">
                <p class="fs-5">Tổng cộng: <span class="text-success">${order.amount}</span> ₫</p>
            </div>

            <div class="text-end">
                <a href="${pageContext.request.contextPath}/staff/orders" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Quay lại
                </a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
