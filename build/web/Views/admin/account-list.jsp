<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="/Views/components/admin_header.jsp" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý tài khoản</title>
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
            .admin-header {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1000;
            }
            .search-bar {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
                align-items: center;
                margin-bottom: 25px;
                background: white;
                padding: 15px 20px;
                border-radius: 10px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            }
            .search-bar form {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
                width: 100%;
            }
            .search-group {
                display: flex;
                flex-direction: column;
            }
            label {
                font-size: 13px;
                color: #555;
                margin-bottom: 5px;
                font-weight: 600;
            }
            input[type="text"], select {
                padding: 8px 10px;
                border: 1px solid #ccc;
                border-radius: 6px;
                font-size: 14px;
                width: 180px;
            }
            .btn-search {
                background-color: #6a11cb;
                color: white;
                border: none;
                padding: 10px 18px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 500;
            }
            .btn-reset {
                background-color: #ccc;
                color: #333;
                border: none;
                padding: 10px 16px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 500;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                background: white;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 3px 10px rgba(0,0,0,0.1);
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
            .status-active {
                color: green;
                font-weight: 500;
            }
            .status-inactive {
                color: red;
                font-weight: 500;
            }
            .role-admin {
                color: #e67e22;
                font-weight: bold;
            }
            .role-staff {
                color: #2980b9;
                font-weight: bold;
            }
            .role-customer {
                color: #27ae60;
                font-weight: bold;
            }
            .actions a {
                margin: 0 6px;
                text-decoration: none;
                font-size: 16px;
            }
            .actions i:hover {
                transform: scale(1.2);
                transition: 0.2s;
            }
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
            .btn-add {
                display: inline-block;
                background-color: #6a11cb;
                color: white;
                padding: 10px 18px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: 500;
                margin-bottom: 20px;
            }
            .btn-add:hover {
                background-color: #5012a0;
            }
        </style>
    </head>

    <body>
        <h1><i class="fa-solid fa-users"></i> Quản lý tài khoản</h1>

        <div class="search-bar">
            <form method="get" action="${pageContext.request.contextPath}/admin/accounts">
                <div class="search-group">
                    <label for="username">Tên đăng nhập</label>
                    <input type="text" id="username" name="username" value="${param.username}">
                </div>

                <div class="search-group">
                    <label for="email">Email</label>
                    <input type="text" id="email" name="email" value="${param.email}">
                </div>

                <div class="search-group">
                    <label for="roleFilter">Vai trò</label>
                    <select name="roleFilter" id="roleFilter">
                        <option value="">-- Tất cả --</option>
                        <option value="1" ${param.roleFilter == '1' ? 'selected' : ''}>Admin</option>
                        <option value="2" ${param.roleFilter == '2' ? 'selected' : ''}>Nhân viên</option>
                        <option value="3" ${param.roleFilter == '3' ? 'selected' : ''}>Khách hàng</option>
                    </select>
                </div>

                <div class="search-group">
                    <label for="statusFilter">Trạng thái</label>
                    <select name="statusFilter" id="statusFilter">
                        <option value="">-- Tất cả --</option>
                        <option value="active" ${param.statusFilter == 'active' ? 'selected' : ''}>Đang hoạt động</option>
                        <option value="inactive" ${param.statusFilter == 'inactive' ? 'selected' : ''}>Đã khóa</option>
                    </select>
                </div>

                <div class="search-group" style="align-self: flex-end;">
                    <button type="submit" class="btn-search"><i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm</button>
                    <a href="${pageContext.request.contextPath}/admin/accounts" class="btn-reset">Đặt lại</a>
                </div>
            </form>
        </div>

        <a href="${pageContext.request.contextPath}/admin/accounts?action=add" class="btn-add">
            <i class="fa-solid fa-plus"></i> Thêm tài khoản
        </a>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên đăng nhập</th>
                    <th>Email</th>
                    <th>Số điện thoại</th>
                    <th>Vai trò</th>
                    <th>Trạng thái</th>
                    <th style="width:150px;text-align:center;">Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="a" items="${accounts}">
                    <tr>
                        <td>${a.id}</td>
                        <td>${a.username}</td>
                        <td>${a.email}</td>
                        <td>${a.telephone}</td>
                        <td>
                            <c:choose>
                                <c:when test="${a.roleId == 1}">
                                    <span class="role-admin">Admin</span>
                                </c:when>
                                <c:when test="${a.roleId == 2}">
                                    <span class="role-staff">Nhân viên</span>
                                </c:when>
                                <c:when test="${a.roleId == 3}">
                                    <span class="role-customer">Khách hàng</span>
                                </c:when>
                                <c:otherwise>
                                    <span>Không xác định</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${a.actived}">
                                    <span class="status-active">Đang hoạt động</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-inactive">Đã khóa</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="actions" style="text-align:center;">
                            <a href="${pageContext.request.contextPath}/admin/accounts?action=edit&id=${a.id}" title="Chỉnh sửa">
                                <i class="fa-solid fa-pen-to-square" style="color:#2980b9;"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/accounts?action=ban&id=${a.id}"
                               onclick="return confirm('Khóa tài khoản này?')" title="Khóa">
                                <i class="fa-solid fa-user-slash" style="color:#e67e22;"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/accounts?action=delete&id=${a.id}"
                               onclick="return confirm('Xóa vĩnh viễn tài khoản này?')" title="Xóa">
                                <i class="fa-solid fa-trash-can" style="color:#e74c3c;"></i>
                            </a>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty accounts}">
                    <tr><td colspan="7" class="no-data">Không có tài khoản nào</td></tr>
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
                        <a href="?page=${i}&username=${param.username}&email=${param.email}&roleFilter=${param.roleFilter}&statusFilter=${param.statusFilter}">
                            ${i}
                        </a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </div>

    </body>
</html>
