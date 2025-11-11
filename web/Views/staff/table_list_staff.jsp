<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý bàn ăn - Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background-color: #f7f9fc;
            font-family: "Segoe UI", sans-serif;
        }
        .card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }
        h2 {
            font-weight: 700;
            color: #0d6efd;
            margin-bottom: 1rem;
        }
        .status-badge {
            font-weight: 600;
            padding: 0.4rem 0.7rem;
            border-radius: 8px;
            display: inline-block;
        }
        .AVAILABLE { background-color: #d4edda; color: #155724; }
        .SEATED { background-color: #fff3cd; color: #856404; }
        .BOOKED { background-color: #cce5ff; color: #004085; }
        .INACTIVE { background-color: #f8d7da; color: #721c24; }
        .table th {
            background-color: #e9ecef;
            color: #212529;
            text-align: center;
            vertical-align: middle;
        }
        .table td {
            text-align: center;
            vertical-align: middle;
        }
        .flash {
            border-radius: 8px;
            font-weight: 500;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    
    <!-- Header -->
<jsp:include page="/Views/components/staff_header.jsp"/>

<div class="container py-4">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2><i class="fas fa-utensils me-2"></i>Quản lý bàn ăn (Staff)</h2>
    </div>

    <c:if test="${not empty sessionScope.flash}">
        <div class="alert ${sessionScope.flash.contains('✅') ? 'alert-success' : 'alert-danger'} flash alert-dismissible fade show" role="alert">
            ${sessionScope.flash}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="flash" scope="session" />
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-danger flash">${error}</div>
    </c:if>

    <div class="card">
        <div class="card-body table-responsive">
            <table class="table table-hover align-middle">
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
                <c:choose>
                    <c:when test="${not empty tables}">
                        <c:forEach var="t" items="${tables}">
                            <tr>
                                <td>${t.code}</td>
                                <td>${t.areaName}</td>
                                <td>${t.capacity}</td>
                                <td>
                                    <span class="status-badge ${t.status}">
                                        <c:choose>
                                            <c:when test="${t.status == 'AVAILABLE'}">Trống</c:when>
                                            <c:when test="${t.status == 'SEATED'}">Đang phục vụ</c:when>
                                            <c:when test="${t.status == 'BOOKED'}">Đã đặt</c:when>
                                            <c:when test="${t.status == 'INACTIVE'}">Không hoạt động</c:when>
                                            <c:otherwise>${t.status}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td>${t.note}</td>
                                <td class="d-flex justify-content-center gap-2 flex-wrap">
                                    <c:choose>
                                        <c:when test="${t.status == 'AVAILABLE'}">
                                            <a href="${pageContext.request.contextPath}/staff/table-order?action=updateStatus&id=${t.tableId}&status=SEATED"
                                               class="btn btn-success btn-sm"><i class="fas fa-chair"></i> Cho khách ngồi</a>
                                        </c:when>
                                        <c:when test="${t.status == 'SEATED'}">
                                            <a href="${pageContext.request.contextPath}/staff/table-order?action=updateStatus&id=${t.tableId}&status=AVAILABLE"
                                               class="btn btn-danger btn-sm"><i class="fas fa-door-open"></i> Khách rời đi</a>
                                        </c:when>
                                        <c:when test="${t.status == 'BOOKED' || t.status == 'INACTIVE'}">
                                            <button class="btn btn-secondary btn-sm" disabled><i class="fas fa-ban"></i> Không khả dụng</button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-secondary btn-sm" disabled>-</button>
                                        </c:otherwise>
                                    </c:choose>

                                    <a href="${pageContext.request.contextPath}/staff/table-order?action=orderHistory&id=${t.tableId}"
                                       class="btn btn-outline-primary btn-sm">
                                        <i class="fas fa-list"></i> Xem / Đặt món
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="6" class="text-muted py-3">Không có bàn nào để hiển thị.</td></tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
