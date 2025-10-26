<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách thực đơn</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
<div class="container py-4">
    <h2 class="text-center mb-4">🍽️ Quản lý thực đơn</h2>
    <a href="menu?action=new" class="btn btn-success mb-3">➕ Thêm món mới</a>
    <table class="table table-bordered table-hover bg-white">
        <thead class="table-light">
        <tr>
            <th>ID</th>
            <th>Tên món</th>
            <th>Giá</th>
            <th>Giảm giá (%)</th>
            <th>Danh mục</th>
            <th>Tồn kho</th>
            <th>Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="item" items="${menuList}">
            <tr>
                <td>${item.id}</td>
                <td>${item.name}</td>
                <td>${item.price}</td>
                <td>${item.discountPercent}</td>
                <td>${item.categoryId}</td>
                <td>${item.inventory}</td>
                <td>
                    <a href="menu?action=detail&id=${item.id}" class="btn btn-info btn-sm">Xem</a>
                    <a href="menu?action=edit&id=${item.id}" class="btn btn-warning btn-sm">Sửa</a>
                    <a href="menu?action=delete&id=${item.id}" class="btn btn-danger btn-sm"
                       onclick="return confirm('Xóa món này?');">Xóa</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
