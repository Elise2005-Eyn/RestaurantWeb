<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, Models.RestaurantTable" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý bàn ăn (Staff)</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #fafafa;
            font-family: "Segoe UI", sans-serif;
        }
        .container {
            margin-top: 40px;
            max-width: 1100px;
        }
        h2 {
            text-align: center;
            margin-bottom: 25px;
            font-weight: 600;
        }
        .table th {
            background: #212529;
            color: #fff;
            text-align: center;
        }
        .table td {
            vertical-align: middle;
            text-align: center;
        }
        .status {
            font-weight: bold;
        }
        .status.AVAILABLE { color: green; }
        .status.OCCUPIED { color: orange; }
        .status.BOOKED { color: blue; }
        .status.INACTIVE { color: gray; }
        .alert {
            max-width: 700px;
            margin: 0 auto 15px auto;
        }
        .btn-sm {
            padding: 4px 10px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Quản lý bàn ăn (Staff)</h2>

    <!-- Hiển thị thông báo Flash -->
    <%
        String flash = (String) session.getAttribute("flash");
        if (flash != null) {
    %>
        <div class="alert alert-info alert-dismissible fade show text-center" role="alert">
            <%= flash %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <%
            session.removeAttribute("flash");
        }
    %>

    <c:if test="${not empty error}">
        <div class="alert alert-danger text-center">${error}</div>
    </c:if>

    <table class="table table-bordered table-hover shadow-sm bg-white">
        <thead>
        <tr>
            <th>Mã bàn</th>
            <th>Khu vực</th>
            <th>Sức chứa</th>
            <th>Trạng thái</th>
            <th>Ghi chú</th>
            <th>Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="t" items="${tables}">
            <tr>
                <td>${t.code}</td>
                <td>${t.areaName}</td>
                <td>${t.capacity}</td>
                <td class="status ${t.status}">
                    <c:choose>
                        <c:when test="${t.status == 'AVAILABLE'}">Trống</c:when>
                        <c:when test="${t.status == 'OCCUPIED' || t.status == 'SEATED'}">Đang phục vụ</c:when>
                        <c:when test="${t.status == 'BOOKED' || t.status == 'CONFIRMED'}">Đã đặt</c:when>
                        <c:when test="${t.status == 'INACTIVE'}">Không hoạt động</c:when>
                        <c:otherwise>${t.status}</c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:choose>
                        <c:when test="${empty t.note}">Không xác định</c:when>
                        <c:otherwise>${t.note}</c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:choose>
                        <c:when test="${t.status == 'AVAILABLE'}">
                            <a href="manager-table?action=updateStatus&id=${t.tableId}&status=OCCUPIED"
                               class="btn btn-success btn-sm">Cho khách ngồi</a>
                        </c:when>

                        <c:when test="${t.status == 'OCCUPIED' || t.status == 'SEATED'}">
                            <a href="manager-table?action=updateStatus&id=${t.tableId}&status=AVAILABLE"
                               class="btn btn-danger btn-sm">Khách đã rời đi</a>
                        </c:when>

                        <c:when test="${t.status == 'BOOKED' || t.status == 'CONFIRMED'}">
                            <button class="btn btn-secondary btn-sm" disabled>Đã đặt</button>
                        </c:when>

                        <c:when test="${t.status == 'INACTIVE'}">
                            <button class="btn btn-secondary btn-sm" disabled>Khóa</button>
                        </c:when>

                        <c:otherwise>
                            <button class="btn btn-secondary btn-sm" disabled>-</button>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </c:forEach>

        <c:if test="${empty tables}">
            <tr><td colspan="6" class="text-center text-muted">Không có dữ liệu bàn nào.</td></tr>
        </c:if>
        </tbody>
    </table>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
