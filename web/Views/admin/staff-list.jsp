<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="/Views/components/admin_header.jsp" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý nhân viên</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: #f5f6fa;
            margin: 0;
            padding: 40px 60px;
        }

        h1 {
            color: #4b0082;
            font-size: 26px;
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 25px;
        }

        .filters {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 25px;
        }

        .filters input[type="text"],
        .filters select {
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }

        .filters button {
            background-color: #6a11cb;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 8px 16px;
            cursor: pointer;
        }

        .filters button:hover {
            background-color: #5012a0;
        }

        .btn-add {
            background-color: #6a11cb;
            color: white;
            padding: 10px 18px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 500;
            margin-left: auto;
        }

        .btn-add:hover {
            background-color: #5012a0;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 14px 16px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        th {
            background-color: #6a11cb;
            color: white;
        }

        tr:hover {
            background-color: #f8f8f8;
        }

        .actions a {
            margin: 0 6px;
            text-decoration: none;
            font-size: 16px;
        }

        .actions a.edit { color: #007bff; }
        .actions a.ban { color: #e67e22; }
        .actions a.delete { color: #e74c3c; }

        .pagination {
            text-align: center;
            margin-top: 25px;
        }

        .pagination a, .pagination span {
            margin: 0 4px;
            padding: 8px 12px;
            border-radius: 5px;
            background: #eee;
            color: #333;
            text-decoration: none;
        }

        .pagination .current {
            background: #6a11cb;
            color: white;
            font-weight: bold;
        }

        .no-data {
            text-align: center;
            color: #777;
            padding: 20px 0;
        }

        .status-active {
            color: green;
            font-weight: 500;
        }

        .status-inactive {
            color: red;
            font-weight: 500;
        }
    </style>
</head>

<body>
<h1><i class="fa-solid fa-user-gear"></i> Quản lý nhân viên</h1>

<form method="get" action="${pageContext.request.contextPath}/admin/staff">
    <div class="filters">
        <input type="text" name="keyword" placeholder="Tìm theo tên hoặc email..." value="${param.keyword}">
        <select name="status">
            <option value="">-- Tất cả trạng thái --</option>
            <option value="active" ${param.status == 'active' ? 'selected' : ''}>Đang hoạt động</option>
            <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Đã vô hiệu</option>
        </select>
        <button type="submit"><i class="fa-solid fa-filter"></i> Lọc</button>

        <a href="${pageContext.request.contextPath}/admin/staff?action=add" class="btn-add">
            <i class="fa-solid fa-plus"></i> Thêm nhân viên
        </a>
    </div>
</form>

<table>
    <thead>
    <tr>
        <th>ID</th>
        <th>Tên đăng nhập</th>
        <th>Email</th>
        <th>Số điện thoại</th>
        <th>Trạng thái</th>
        <th style="width: 150px; text-align: center;">Hành động</th>
    </tr>
    </thead>

    <tbody>
    <c:forEach var="s" items="${staffs}">
        <tr>
            <td>${s.id}</td>
            <td>${s.username}</td>
            <td>${s.email}</td>
            <td>${s.telephone}</td>
            <td>
                <c:choose>
                    <c:when test="${s.actived}">
                        <span class="status-active">Đang hoạt động</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-inactive">Đã vô hiệu</span>
                    </c:otherwise>
                </c:choose>
            </td>
            <td class="actions" style="text-align:center;">
                <a href="${pageContext.request.contextPath}/admin/staff?action=edit&id=${s.id}" class="edit" title="Chỉnh sửa">
                    <i class="fa-solid fa-pen-to-square"></i>
                </a>
                <a href="${pageContext.request.contextPath}/admin/staff?action=ban&id=${s.id}"
                   onclick="return confirm('Bạn có chắc muốn vô hiệu hóa nhân viên này không?')"
                   class="ban" title="Vô hiệu hóa">
                    <i class="fa-solid fa-user-slash"></i>
                </a>
                <a href="${pageContext.request.contextPath}/admin/staff?action=delete&id=${s.id}"
                   onclick="return confirm('Bạn có chắc muốn xóa vĩnh viễn nhân viên này không?')"
                   class="delete" title="Xóa">
                    <i class="fa-solid fa-trash-can"></i>
                </a>
            </td>
        </tr>
    </c:forEach>

    <c:if test="${empty staffs}">
        <tr>
            <td colspan="6" class="no-data">Không có nhân viên nào</td>
        </tr>
    </c:if>
    </tbody>
</table>

<div class="pagination">
    <c:forEach var="i" begin="1" end="${totalPages}">
        <c:choose>
            <c:when test="${i == currentPage}">
                <span class="current">${i}</span>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/admin/staff?page=${i}&keyword=${param.keyword}&status=${param.status}">
                    ${i}
                </a>
            </c:otherwise>
        </c:choose>
    </c:forEach>
</div>

</body>
</html>
