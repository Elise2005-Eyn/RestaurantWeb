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
                background-color: #0c0c0c;
                color: #f5f5f5;
                margin: 0;
                padding: 70px;
            }

            h1 {
                color: #FFD700;
                font-size: 26px;
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 25px;
                text-shadow: 0 0 8px rgba(255, 215, 0, 0.5);
            }
            .admin-header {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1000;
            }

            /* Bộ lọc và nút thêm */
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
                border: 1px solid rgba(255, 215, 0, 0.3);
                border-radius: 6px;
                background-color: #1a1a1a;
                color: #fff;
                font-size: 14px;
                transition: 0.3s;
            }

            .filters input[type="text"]:focus,
            .filters select:focus {
                border-color: #FFD700;
                box-shadow: 0 0 6px rgba(255, 215, 0, 0.3);
                outline: none;
            }

            .filters button {
                background-color: #FFD700;
                color: #000;
                border: none;
                border-radius: 6px;
                padding: 8px 16px;
                cursor: pointer;
                font-weight: 600;
                transition: 0.3s;
            }

            .filters button:hover {
                background-color: #ffea70;
                transform: scale(1.05);
            }

            .btn-add {
                background-color: #FFD700;
                color: #000;
                padding: 10px 18px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: 600;
                margin-left: auto;
                transition: 0.3s;
                box-shadow: 0 0 12px rgba(255, 215, 0, 0.25);
            }

            .btn-add:hover {
                background-color: #ffea70;
                box-shadow: 0 0 18px rgba(255, 215, 0, 0.5);
                transform: scale(1.05);
            }

            /* Bảng */
            table {
                width: 100%;
                border-collapse: collapse;
                background: #111;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 0 20px rgba(255, 215, 0, 0.15);
            }

            th, td {
                padding: 14px 16px;
                text-align: left;
                border-bottom: 1px solid rgba(255, 215, 0, 0.1);
            }

            th {
                background-color: #222;
                color: #FFD700;
                text-transform: uppercase;
                font-weight: 600;
                letter-spacing: 0.5px;
            }

            tr:hover {
                background-color: rgba(255, 215, 0, 0.08);
                transition: 0.2s;
            }

            .actions a {
                margin: 0 6px;
                text-decoration: none;
                font-size: 16px;
                transition: 0.2s;
            }

            .actions a.edit {
                color: #1e90ff;
            }
            .actions a.ban {
                color: #e67e22;
            }
            .actions a.delete {
                color: #ff4d4d;
            }

            .actions a:hover {
                opacity: 0.8;
                transform: scale(1.1);
            }

            .pagination {
                text-align: center;
                margin-top: 25px;
            }

            .pagination a, .pagination span {
                margin: 0 4px;
                padding: 8px 12px;
                border-radius: 5px;
                background: #1a1a1a;
                color: #f5f5f5;
                text-decoration: none;
                border: 1px solid rgba(255, 215, 0, 0.3);
                transition: 0.3s;
            }

            .pagination .current {
                background: #FFD700;
                color: #000;
                font-weight: bold;
                box-shadow: 0 0 10px rgba(255, 215, 0, 0.4);
            }

            .pagination a:hover {
                background: #FFD700;
                color: #000;
            }

            .no-data {
                text-align: center;
                color: #aaa;
                padding: 20px 0;
            }

            .status-active {
                color: #00ff7f;
                font-weight: 600;
            }

            .status-inactive {
                color: #ff4d4d;
                font-weight: 600;
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
