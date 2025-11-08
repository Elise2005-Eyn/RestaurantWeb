<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Thực đơn - Admin</title>
    <style>
        /* ========== CSS riêng cho phần nội dung ========== */
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: #f5f6fa;
            margin: 0;
            padding: 0;
        }

        main {
            margin-left: 240px;
            padding: 80px 30px 100px 30px;
            background: #f5f6fa;
            min-height: 100vh;
        }

        h2 {
            color: #222;
            margin-bottom: 15px;
            font-size: 22px;
        }

        a.button {
            background: #007bff;
            color: white;
            padding: 8px 12px;
            text-decoration: none;
            border-radius: 4px;
        }

        a.button:hover {
            background: #0056b3;
        }

        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 20px;
            background: white;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
            font-size: 14px;
        }

        th {
            background: #222;
            color: #fff;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .pagination {
            margin-top: 20px;
            text-align: center;
        }

        .pagination a {
            padding: 6px 12px;
            border: 1px solid #ccc;
            margin: 0 3px;
            text-decoration: none;
            color: #333;
        }

        .pagination a.active {
            background: #007bff;
            color: #fff;
            border-color: #007bff;
        }
    </style>
</head>
<body>



    <main>
        <h2>📋 Danh sách món ăn</h2>

        <a href="${pageContext.request.contextPath}/admin/menu?action=add" class="button">➕ Thêm món mới</a>

        <table>
            <tr>
                <th>ID</th>
                <th>Tên món</th>
                <th>Giá</th>
                <th>Giảm (%)</th>
                <th>Danh mục</th>
                <th>Tồn kho</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>

            <c:forEach var="item" items="${menuList}">
                <tr>
                    <td>${item.id}</td>
                    <td>${item.name}</td>
                    <td>${item.price}</td>
                    <td>${item.discountPercent}</td>
                    <td>${item.categoryId}</td>
                    <td>${item.inventory}</td>
                    <td>${item.active ? "Hiển thị" : "Ẩn"}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/menu?action=edit&id=${item.id}">✏️ Sửa</a> |
                        <a href="${pageContext.request.contextPath}/admin/menu?action=delete&id=${item.id}"
                           onclick="return confirm('Xóa món này?')">🗑️ Xóa</a>
                    </td>
                </tr>
            </c:forEach>
        </table>

        <div class="pagination">
            <c:forEach begin="1" end="${totalPages}" var="i">
                <a href="${pageContext.request.contextPath}/admin/menu?action=list&page=${i}"
                   class="${i == currentPage ? 'active' : ''}">
                    ${i}
                </a>
            </c:forEach>
        </div>
    </main>

 

</body>
</html>
