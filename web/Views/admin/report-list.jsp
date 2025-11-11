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
            .filter-bar {
                display: flex;
                align-items: center;
                gap: 10px;
                background: #fff;
                padding: 12px 16px;
                border-radius: 8px;
                box-shadow: 0 2px 6px rgba(0,0,0,0.08);
                margin-bottom: 20px;
            }
            label {
                font-size: 14px;
                font-weight: 600;
                color: #333;
            }
            select {
                padding: 8px 12px;
                border: 1px solid #ccc;
                border-radius: 6px;
                font-size: 14px;
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
            .actions a {
                margin: 0 6px;
                text-decoration: none;
                font-size: 16px;
            }
            .actions i:hover {
                transform: scale(1.2);
                transition: 0.2s;
            }
            .no-data {
                text-align: center;
                color: #777;
                padding: 20px 0;
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
