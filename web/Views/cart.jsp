<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Giỏ hàng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body style="background-color:#111;color:white;">
<div class="container py-5">
    <h2 class="text-center mb-4" style="color:#e0b841;">🛒 Giỏ hàng của bạn</h2>

    <c:if test="${empty sessionScope.cart}">
        <p class="text-center">Giỏ hàng đang trống</p>
    </c:if>

    <c:if test="${not empty sessionScope.cart}">
        <table class="table table-dark table-bordered text-center">
            <thead style="background-color:#6a0dad;">
                <tr>
                    <th>Tên món</th>
                    <th>Giá</th>
                    <th>Số lượng</th>
                    <th>Tổng</th>
                    <th>Xóa</th>
                </tr>
            </thead>
            <tbody>
                <c:set var="total" value="0" />
                <c:forEach var="item" items="${sessionScope.cart}">
                    <tr>
                        <td>${item.name}</td>
                        <td>${item.price}</td>
                        <td>${item.quantity}</td>
                        <td>${item.total}</td>
                        <td>
                            <form action="cart" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="remove"/>
                                <input type="hidden" name="id" value="${item.id}"/>
                                <button class="btn btn-danger btn-sm">X</button>
                            </form>
                        </td>
                    </tr>
                    <c:set var="total" value="${total + item.total}" />
                </c:forEach>
            </tbody>
        </table>

        <h4 class="text-end">Tổng cộng: <span style="color:#e0b841;">${total} VND</span></h4>

        <form action="payment" method="post" class="text-center mt-4">
            <input type="hidden" name="orderInfo" value="Thanh toán giỏ hàng">
            <input type="hidden" name="amount" value="${total}">
            <button type="submit" class="btn btn-warning btn-lg">Thanh toán qua VNPay</button>
        </form>
    </c:if>
</div>
</body>
</html>
