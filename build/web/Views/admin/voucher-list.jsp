<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/Views/components/admin_header.jsp" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý Voucher</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

        <style>
            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                background-color: #000;
                color: #fff;
                margin: 0;
                padding: 70px; /* đẩy nội dung xuống để tránh header */
            }

            .admin-header {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1000;
            }

            h1 {
                color: #FFD700;
                font-size: 28px;
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 25px;
                text-shadow: 0 0 8px rgba(255, 215, 0, 0.4);
            }

            /* --- Nút thêm --- */
            .btn-add {
                display: inline-block;
                background: linear-gradient(90deg, #FFD700, #b8860b);
                color: #000;
                padding: 10px 20px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: 600;
                margin-bottom: 20px;
                transition: 0.25s;
            }

            .btn-add:hover {
                background: linear-gradient(90deg, #ffea00, #daa520);
                box-shadow: 0 0 10px rgba(255, 215, 0, 0.6);
                transform: translateY(-1px);
            }

            /* --- Form tìm kiếm --- */
            .search-bar {
                display: flex;
                flex-wrap: wrap;
                align-items: flex-end;
                gap: 15px;
                margin-bottom: 25px;
                background: #111;
                padding: 20px 25px;
                border-radius: 10px;
                box-shadow: 0 0 15px rgba(255, 215, 0, 0.1);
                border: 1px solid rgba(255, 215, 0, 0.2);
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

            input[type="text"],
            input[type="number"],
            select {
                padding: 8px 10px;
                border: 1px solid rgba(255, 215, 0, 0.4);
                border-radius: 6px;
                font-size: 14px;
                width: 180px;
                background-color: #1a1a1a;
                color: #fff;
                transition: 0.25s;
            }

            input:focus,
            select:focus {
                border-color: #FFD700;
                box-shadow: 0 0 8px rgba(255, 215, 0, 0.4);
                outline: none;
            }

            .btn-search {
                background: linear-gradient(90deg, #FFD700, #b8860b);
                color: #000;
                border: none;
                padding: 10px 18px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 600;
                transition: 0.25s;
            }

            .btn-search:hover {
                background: linear-gradient(90deg, #ffea00, #daa520);
                box-shadow: 0 0 8px rgba(255, 215, 0, 0.6);
            }

            .btn-reset {
                background-color: transparent;
                color: #FFD700;
                border: 1px solid rgba(255, 215, 0, 0.4);
                padding: 10px 16px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 500;
                text-decoration: none;
                transition: 0.25s;
            }

            .btn-reset:hover {
                background-color: rgba(255, 215, 0, 0.1);
                box-shadow: 0 0 8px rgba(255, 215, 0, 0.4);
            }

            /* --- Bảng --- */
            table {
                width: 100%;
                border-collapse: collapse;
                background: #111;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 0 25px rgba(255, 215, 0, 0.1);
                border: 1px solid rgba(255, 215, 0, 0.15);
            }

            th, td {
                padding: 14px 16px;
                text-align: center;
                border-bottom: 1px solid rgba(255, 215, 0, 0.1);
                font-size: 14px;
            }

            th {
                background-color: #FFD700;
                color: #000;
                text-transform: uppercase;
            }

            tr:hover {
                background-color: rgba(255, 215, 0, 0.05);
            }

            .status-active {
                color: #00ff7f;
                font-weight: 600;
            }

            .status-hidden {
                color: #ff4c4c;
                font-weight: 600;
            }

            .actions a {
                margin: 0 6px;
                color: #FFD700;
                text-decoration: none;
                font-size: 16px;
                transition: 0.2s;
            }

            .actions a:hover {
                color: #fff;
                transform: scale(1.2);
            }

            /* --- Phân trang --- */
            .pagination {
                text-align: center;
                margin-top: 25px;
            }

            .pagination a, .pagination span {
                margin: 0 4px;
                padding: 8px 12px;
                border-radius: 5px;
                background: #1a1a1a;
                color: #FFD700;
                text-decoration: none;
                border: 1px solid rgba(255, 215, 0, 0.3);
                transition: 0.25s;
            }

            .pagination .current {
                background: linear-gradient(90deg, #FFD700, #b8860b);
                color: #000;
                font-weight: bold;
            }

            .pagination a:hover {
                background: rgba(255, 215, 0, 0.1);
            }

            .no-data {
                text-align: center;
                color: #bbb;
                padding: 25px 0;
            }
        </style>

    </head>

    <body>

        <h1><i class="fa-solid fa-ticket"></i> Quản lý Voucher</h1>

        <a href="${pageContext.request.contextPath}/admin/voucher?action=add" class="btn-add">
            <i class="fa-solid fa-plus"></i> Thêm voucher mới
        </a>

        <!-- Form tìm kiếm -->
        <div class="search-bar">
            <form method="get" action="${pageContext.request.contextPath}/admin/voucher">
                <input type="hidden" name="action" value="search"/>

                <div class="search-group">
                    <label for="keyword">Mã voucher</label>
                    <input type="text" id="keyword" name="keyword" placeholder="Nhập mã..." value="${keyword}">
                </div>

                <div class="search-group">
                    <label>Giảm giá từ (%)</label>
                    <input type="number" step="1" name="minDiscount" placeholder="Từ" value="${minDiscount}">
                </div>

                <div class="search-group">
                    <label>Đến (%)</label>
                    <input type="number" step="1" name="maxDiscount" placeholder="Đến" value="${maxDiscount}">
                </div>

                <div class="search-group">
                    <label>Trạng thái</label>
                    <select name="isActive">
                        <option value="">-- Tất cả --</option>
                        <option value="1" ${selectedStatus == '1' ? 'selected' : ''}>Hiển thị</option>
                        <option value="0" ${selectedStatus == '0' ? 'selected' : ''}>Ẩn</option>
                    </select>
                </div>

                <div class="search-group" style="align-self:flex-end;">
                    <button type="submit" class="btn-search"><i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm</button>
                    <a href="${pageContext.request.contextPath}/admin/voucher?action=list" class="btn-reset">Đặt lại</a>
                </div>
            </form>
        </div>

        <!-- Bảng dữ liệu -->
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Mã</th>
                    <th>Mô tả</th>
                    <th>Giảm (%)</th>
                    <th>Ngày bắt đầu</th>
                    <th>Ngày kết thúc</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="v" items="${vouchers}">
                    <tr>
                        <td>${v.id}</td>
                        <td>${v.code}</td>
                        <td>${v.description}</td>
                        <td>${v.discountPercent}</td>
                        <td>${v.startDate}</td>
                        <td>${v.endDate}</td>
                        <td>
                            <c:choose>
                                <c:when test="${v.active}">
                                    <span class="status-active">Hiển thị</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-hidden">Ẩn</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="actions">
                            <a href="${pageContext.request.contextPath}/admin/voucher?action=edit&id=${v.id}" title="Chỉnh sửa">
                                <i class="fa-solid fa-pen-to-square" style="color:#2980b9;"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/voucher?action=delete&id=${v.id}"
                               onclick="return confirm('Xóa voucher này?')" title="Xóa">
                                <i class="fa-solid fa-trash-can" style="color:#e74c3c;"></i>
                            </a>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty vouchers}">
                    <tr><td colspan="8" class="no-data">Không có voucher nào</td></tr>
                </c:if>
            </tbody>
        </table>

        <!-- Phân trang -->
        <div class="pagination">
            <c:forEach begin="1" end="${totalPages}" var="i">
                <c:choose>
                    <c:when test="${i == currentPage}">
                        <span class="current">${i}</span>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/admin/voucher?action=list&page=${i}
                           &keyword=${keyword}&minDiscount=${minDiscount}&maxDiscount=${maxDiscount}&isActive=${selectedStatus}">
                            ${i}
                        </a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </div>

    </body>
</html>
