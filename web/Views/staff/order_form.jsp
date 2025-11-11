<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đặt món ăn cho khách vãng lai</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-4">
    <h3 class="mb-3">Đặt món ăn cho bàn <span class="text-primary">${tableId}</span></h3>

    <form method="post" action="order">
        <input type="hidden" name="tableId" value="${tableId}" />
        <table class="table table-bordered table-hover bg-white shadow-sm">
            <thead class="table-dark text-center">
                <tr>
                    <th>Chọn</th>
                    <th>Tên món</th>
                    <th>Giá (VNĐ)</th>
                    <th>Số lượng</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="m" items="${menuItems}">
                    <tr>
                        <td class="text-center">
                            <input type="checkbox" name="itemId" value="${m.id}">
                        </td>
                        <td>${m.name}</td>
                        <td class="text-end">${m.price}</td>
                        <td style="width: 100px;">
                            <input type="number" name="quantity" value="1" min="1" class="form-control form-control-sm text-center">
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <div class="text-center mt-3">
            <button type="submit" class="btn btn-success px-4">Xác nhận đặt món</button>
            <a href="manager-table?action=list" class="btn btn-secondary px-4">Quay lại</a>
        </div>
    </form>
</div>
</body>
</html>
