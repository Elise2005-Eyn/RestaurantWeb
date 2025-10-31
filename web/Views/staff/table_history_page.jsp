<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch sử đặt bàn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body class="bg-light">

<jsp:include page="/Views/components/staff_header.jsp"/>

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="fw-bold text-primary mb-0">
            <i class="fas fa-clock"></i> Lịch sử đặt bàn (Mã bàn #${tableId})
        </h3>
        <a href="${pageContext.request.contextPath}/staff/tables" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Quay lại danh sách
        </a>
    </div>

    <div class="card shadow-sm">
        <div class="card-body table-responsive">
            <table class="table table-bordered table-striped align-middle text-center">
                <thead class="table-primary">
                    <tr>
                        <th>Mã đặt bàn</th>
                        <th>Khách hàng</th>
                        <th>Thời gian đặt</th>
                        <th>Thời lượng (phút)</th>
                        <th>Số khách</th>
                        <th>Trạng thái</th>
                        <th>Ghi chú</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="r" items="${history}">
                    <tr>
                        <td>${r.reservation_id}</td>
                        <td>${r.customer_name}</td>
                        <td><fmt:formatDate value="${r.reserved_at}" pattern="dd/MM/yyyy HH:mm" /></td>
                        <td>${r.reserved_duration}</td>
                        <td>${r.guest_count}</td>
                        <td>
                            <span class="badge 
                                ${r.status == 'CONFIRMED' ? 'bg-success' :
                                  r.status == 'PENDING' ? 'bg-warning text-dark' :
                                  r.status == 'CANCELLED' ? 'bg-danger' : 'bg-secondary'}">
                                ${r.status}
                            </span>
                        </td>
                        <td>${r.note}</td>
                    </tr>
                </c:forEach>

                <c:if test="${empty history}">
                    <tr><td colspan="7" class="text-center text-muted py-3">Không có lịch sử đặt bàn nào.</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
