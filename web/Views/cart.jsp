<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Giỏ hàng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background: url('imgs/mon_an.png') no-repeat center center fixed;
            background-size: cover;
            color: white;
        }
        .container {
            background-color: rgba(0,0,0,0.6);
            padding: 30px;
            border-radius: 12px;
        }
        .table thead {
            background-color: #6a0dad;
        }
        .btn-warning {
            font-weight: bold;
            color: #111;
        }
        .btn-primary {
            font-weight: bold;
        }
    </style>
</head>
<body>
<div class="container py-5">
    <h2 class="text-center mb-4" style="color:#e0b841;">🛒 Giỏ hàng của bạn</h2>

    <c:if test="${empty sessionScope.cart}">
        <p class="text-center">Giỏ hàng đang trống</p>
        <div class="text-center mt-4">
            <a href="menu?action=list" class="btn btn-primary btn-lg">⬅ Quay lại Menu</a>
        </div>
    </c:if>

    <c:if test="${not empty sessionScope.cart}">
        <table class="table table-dark table-bordered text-center">
            <thead>
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
                        <td>
                            <form action="cart" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="decrement"/>
                                <input type="hidden" name="id" value="${item.id}"/>
                                <button class="btn btn-sm btn-secondary">-</button>
                            </form>
                            <span style="margin:0 10px;">${item.quantity}</span>
                            <form action="cart" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="increment"/>
                                <input type="hidden" name="id" value="${item.id}"/>
                                <button class="btn btn-sm btn-secondary">+</button>
                            </form>
                        </td>
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

        <div class="text-center mt-4">
            <a href="menu?action=list" class="btn btn-primary btn-lg me-3">⬅ Quay lại Menu</a>
            <a href="checkout" class="btn btn-warning btn-lg">Tiến hành thanh toán</a>
        </div>
    </c:if>
</div>
</body>
</html>
