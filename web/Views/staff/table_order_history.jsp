<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Models.OrderItem" %>

<html>
<head>
    <title>Lịch sử đặt món</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body class="p-4 bg-light">
    <h2 class="text-center mb-4">Lịch sử đặt món của bàn #<%= request.getAttribute("tableId") %></h2>

    <!-- Form thêm món mới -->
    <form action="manager-table" method="post" class="mb-4 border p-3 bg-white rounded shadow-sm">
        <input type="hidden" name="action" value="addItem">
        <input type="hidden" name="tableId" value="<%= request.getAttribute("tableId") %>">

        <div class="row g-2 align-items-center">
            <div class="col-md-4">
                <input type="number" class="form-control" name="menuItemId" placeholder="ID món ăn" required>
            </div>
            <div class="col-md-3">
                <input type="number" class="form-control" name="quantity" placeholder="Số lượng" required>
            </div>
            <div class="col-md-3">
                <button class="btn btn-success w-100">+ Thêm món</button>
            </div>
            <div class="col-md-2 text-end">
                <a href="manager-table?action=list" class="btn btn-secondary w-100">⬅ Quay lại</a>
            </div>
        </div>
    </form>

    <%
        List<OrderItem> orderHistory = (List<OrderItem>) request.getAttribute("orderHistory");
        if (orderHistory == null || orderHistory.isEmpty()) {
    %>
        <div class="alert alert-warning">Chưa có món nào được đặt cho bàn này.</div>
    <%
        } else {
    %>
        <table class="table table-bordered table-striped shadow-sm bg-white">
            <thead class="table-dark text-center">
                <tr>
                    <th>ID</th>
                    <th>Order ID</th>
                    <th>Món ăn</th>
                    <th>Số lượng</th>
                    <th>Giá</th>
                    <th>Ghi chú</th>
                    <th>Thời gian</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (OrderItem i : orderHistory) {
                %>
                <tr class="text-center">
                    <td><%= i.getId() %></td>
                    <td><%= i.getOrderId() %></td>
                    <td><%= i.getMenuItemId() %></td>
                    <td><%= i.getQuantity() %></td>
                    <td><%= String.format("%,.0f ₫", i.getPrice()) %></td>
                    <td><%= i.getNote() != null ? i.getNote() : "" %></td>
                    <td><%= i.getCreatedAt() %></td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    <%
        }
    %>
</body>
</html>
