<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/Views/components/admin_header.jsp" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý Báo cáo</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <style>
            :root {
                --primary-gold: #FFD700;       /* Vàng chủ đạo */
                --gold-hover: #ffea70;         /* Vàng sáng khi hover */
                --bg-dark: #0c0c0c;            /* Nền body */
                --bg-panel: #1a1a1a;           /* Nền khung/bảng */
                --text-light: #f5f5f5;         /* Chữ trắng */
                --border-gold: rgba(255, 215, 0, 0.3);
                --shadow-gold: rgba(255, 215, 0, 0.15);
            }

            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                background-color: var(--bg-dark);
                color: var(--text-light);
                margin: 0;
                padding: 70px;
            }

            h1 {
                color: var(--primary-gold);
                font-size: 26px;
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 30px;
                text-shadow: 0 0 15px rgba(255, 215, 0, 0.3);
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            .admin-header {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1000;
            }

            /* --- Thanh Lọc (Filter Bar) --- */
            .filter-bar {
                display: flex;
                align-items: center;
                gap: 15px;
                background: var(--bg-panel);
                padding: 15px 20px;
                border-radius: 8px;
                border: 1px solid var(--border-gold);
                box-shadow: 0 5px 15px rgba(0,0,0,0.5); /* Bóng đen sâu */
                margin-bottom: 25px;
            }

            label {
                font-size: 14px;
                font-weight: 700;
                color: var(--primary-gold);
                text-transform: uppercase;
            }

            select {
                padding: 8px 12px;
                border: 1px solid var(--border-gold);
                border-radius: 6px;
                font-size: 14px;
                background-color: #0a0a0a; /* Input tối hơn nền panel */
                color: #fff;
                outline: none;
                transition: 0.3s;
            }

            select:focus {
                border-color: var(--primary-gold);
                box-shadow: 0 0 10px rgba(255, 215, 0, 0.2);
            }

            /* --- Nút Thêm (Add Button) --- */
            .btn-add {
                display: inline-block;
                background-color: var(--primary-gold);
                color: #000; /* Chữ đen trên nền vàng */
                padding: 10px 20px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: 700;
                margin-bottom: 25px;
                transition: 0.3s;
                box-shadow: 0 0 10px var(--shadow-gold);
            }

            .btn-add:hover {
                background-color: var(--gold-hover);
                box-shadow: 0 0 20px rgba(255, 215, 0, 0.5);
                transform: translateY(-2px);
            }

            /* --- Bảng (Table) --- */
            table {
                width: 100%;
                border-collapse: collapse;
                background: var(--bg-panel);
                border-radius: 10px;
                overflow: hidden;
                border: 1px solid var(--border-gold);
                box-shadow: 0 5px 20px rgba(0,0,0,0.5);
            }

            th, td {
                padding: 16px;
                text-align: left;
                border-bottom: 1px solid rgba(255, 215, 0, 0.1); /* Viền mờ màu vàng */
            }

            th {
                background-color: #222; /* Header tối màu */
                color: var(--primary-gold); /* Chữ vàng */
                font-weight: 700;
                text-transform: uppercase;
                font-size: 13px;
            }

            tr:hover {
                background-color: rgba(255, 215, 0, 0.03); /* Hover vàng rất nhẹ */
            }

            /* --- Hành động (Actions) --- */
            .actions a {
                margin: 0 8px;
                text-decoration: none;
                font-size: 16px;
                color: var(--text-light);
                transition: 0.2s;
            }

            /* Icon thùng rác/sửa khi hover sẽ sáng màu vàng */
            .actions a:hover {
                color: var(--primary-gold);
                transform: scale(1.2);
                display: inline-block;
                filter: drop-shadow(0 0 5px var(--primary-gold));
            }

            .no-data {
                text-align: center;
                color: #888;
                padding: 30px 0;
                font-style: italic;
            }
        </style>
    </head>

    <body>
        <h1><i class="fa-solid fa-chart-line"></i> Quản lý Báo cáo</h1>

        <!-- Nút tạo báo cáo mới -->
        <a href="${pageContext.request.contextPath}/admin/reports?action=create" class="btn-add">
            <i class="fa-solid fa-plus"></i> Tạo báo cáo mới
        </a>

        <!-- Thanh lọc báo cáo -->
        <div class="filter-bar">
            <form method="get" action="${pageContext.request.contextPath}/admin/reports" style="display:flex;align-items:center;gap:10px;">
                <label for="type">Loại báo cáo:</label>
                <select name="type" id="type" onchange="this.form.submit()">
                    <option value="">-- Tất cả --</option>
                    <c:forEach var="t" items="${types}">
                        <option value="${t}" ${selectedType == t ? 'selected' : ''}>${t}</option>
                    </c:forEach>
                </select>
            </form>
        </div>

        <!-- Bảng danh sách báo cáo -->
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tiêu đề</th>
                    <th>Loại báo cáo</th>
                    <th>Từ ngày</th>
                    <th>Đến ngày</th>
                    <th>Mô tả</th>
                    <th>Ngày tạo</th>
                    <th style="width:120px;text-align:center;">Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="r" items="${reports}">
                    <tr>
                        <td>${r.reportId}</td>
                        <td>${r.title}</td>
                        <td>${r.reportType}</td>
                        <td>${r.fromDate}</td>
                        <td>${r.toDate}</td>
                        <td>${r.description}</td>
                        <td>${r.createdAt}</td>
                        <td class="actions" style="text-align:center;">
                            <a href="${pageContext.request.contextPath}/admin/reports?action=view&id=${r.reportId}" title="Xem chi tiết">
                                <i class="fa-solid fa-eye" style="color:#2980b9;"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/reports?action=delete&id=${r.reportId}"
                               onclick="return confirm('Bạn có chắc muốn xóa báo cáo này?')" title="Xóa">
                                <i class="fa-solid fa-trash-can" style="color:#e74c3c;"></i>
                            </a>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty reports}">
                    <tr><td colspan="8" class="no-data">Không có báo cáo nào</td></tr>
                </c:if>
            </tbody>
        </table>

    </body>
</html>
