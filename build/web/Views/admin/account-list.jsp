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
                background-color: #0c0c0c;
                color: #f5f5f5;
                margin: 0;
                padding: 120px 60px 60px; /* cách header 1 khoảng */
            }

            h1 {
                color: #FFD700;
                font-size: 28px;
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 30px;
                text-shadow: 0 0 10px rgba(255, 215, 0, 0.4);
            }

            .admin-header {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1000;
            }
            /* Ô tìm kiếm */
            .search-bar {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
                align-items: center;
                margin-bottom: 30px;
                background: #1a1a1a;
                padding: 20px 25px;
                border-radius: 10px;
                border: 1px solid rgba(255, 215, 0, 0.2);
                box-shadow: 0 0 20px rgba(255, 215, 0, 0.1);
            }

            .search-bar form {
                display: flex;
                flex-wrap: wrap;
                gap: 20px;
                width: 100%;
            }

            .search-group {
                display: flex;
                flex-direction: column;
            }

            label {
                font-size: 13px;
                color: #FFD700;
                margin-bottom: 5px;
                font-weight: 600;
            }

            input[type="text"], select {
                padding: 8px 10px;
                border: 1px solid rgba(255, 215, 0, 0.3);
                border-radius: 6px;
                background-color: #111;
                color: #fff;
                font-size: 14px;
                width: 200px;
            }

            input[type="text"]::placeholder {
                color: #888;
            }

            .btn-search {
                background-color: #FFD700;
                color: #000;
                border: none;
                padding: 10px 18px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 600;
                transition: 0.3s;
            }

            .btn-search:hover {
                background-color: #ffea70;
            }

            .btn-reset {
                background-color: transparent;
                color: #FFD700;
                border: 1px solid #FFD700;
                padding: 10px 16px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 600;
                text-decoration: none;
                transition: 0.3s;
            }

            .btn-reset:hover {
                background-color: #FFD700;
                color: #000;
            }

            /* Nút thêm tài khoản */
            .btn-add {
                display: inline-block;
                background-color: #FFD700;
                color: #000;
                padding: 10px 20px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: 600;
                box-shadow: 0 0 10px rgba(255, 215, 0, 0.3);
                transition: 0.3s;
                margin-bottom: 20px;
            }

            .btn-add:hover {
                background-color: #ffea70;
                box-shadow: 0 0 15px rgba(255, 215, 0, 0.6);
            }

            /* Bảng dữ liệu */
            table {
                width: 100%;
                border-collapse: collapse;
                background: #121212;
                border-radius: 10px;
                overflow: hidden;
                border: 1px solid rgba(255, 215, 0, 0.2);
                box-shadow: 0 0 25px rgba(255, 215, 0, 0.1);
            }

            th, td {
                padding: 14px 16px;
                text-align: left;
                border-bottom: 1px solid rgba(255, 215, 0, 0.1);
            }

            th {
                background-color: #1a1a1a;
                color: #FFD700;
                font-weight: 600;
                text-transform: uppercase;
            }

            tr:hover {
                background-color: rgba(255, 215, 0, 0.05);
                transition: 0.2s;
            }

            .status-active {
                color: #00ff88;
                font-weight: 600;
            }

            .status-inactive {
                color: #ff4d4d;
                font-weight: 600;
            }

            .role-admin {
                color: #FFD700;
                font-weight: bold;
            }

            .role-staff {
                color: #1e90ff;
                font-weight: bold;
            }

            .role-customer {
                color: #00ff88;
                font-weight: bold;
            }

            .actions a {
                margin: 0 8px;
                text-decoration: none;
                font-size: 16px;
                transition: 0.2s;
            }

            .actions i:hover {
                transform: scale(1.25);
                filter: drop-shadow(0 0 5px #FFD700);
            }

            /* Phân trang */
            .pagination {
                text-align: center;
                margin-top: 30px;
            }

            .pagination a, .pagination span {
                margin: 0 5px;
                padding: 8px 12px;
                border-radius: 5px;
                background: #1a1a1a;
                color: #FFD700;
                text-decoration: none;
                border: 1px solid rgba(255, 215, 0, 0.3);
                transition: 0.2s;
            }

            .pagination a:hover {
                background: #FFD700;
                color: #000;
            }

            .pagination .current {
                background: #FFD700;
                color: #000;
                font-weight: bold;
            }

            .no-data {
                text-align: center;
                color: #aaa;
                padding: 20px 0;
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
