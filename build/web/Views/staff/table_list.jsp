<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý bàn - Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body { background-color: #f7f9fc; }
        .status-active { background-color: #c8e6c9; color: #256029; font-weight: 600; border-radius: 8px; padding: 0.3rem 0.6rem; }
        .status-inactive { background-color: #ffcdd2; color: #b71c1c; font-weight: 600; border-radius: 8px; padding: 0.3rem 0.6rem; }
    </style>
</head>

<body class="bg-light">

<!-- Header -->
<jsp:include page="/Views/components/staff_header.jsp"/>

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="fw-bold text-primary mb-0"><i class="fas fa-chair"></i> Quản lý Bàn</h3>
    </div>

    <!-- Hiển thị thông báo thành công / thất bại -->
    <c:if test="${not empty sessionScope.successMsg}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${sessionScope.successMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="successMsg" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.errorMsg}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${sessionScope.errorMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="errorMsg" scope="session"/>
    </c:if>

    <!-- Bộ lọc trạng thái -->
    <form method="get" action="${pageContext.request.contextPath}/staff/tables" class="mb-3 d-flex align-items-center gap-2">
        <label for="status" class="fw-semibold">Lọc theo trạng thái:</label>
        <select name="status" id="status" class="form-select w-auto" onchange="this.form.submit()">
            <option value="">Tất cả</option>
            <option value="active" ${currentStatus == 'active' ? 'selected' : ''}>Đang hoạt động</option>
            <option value="inactive" ${currentStatus == 'inactive' ? 'selected' : ''}>Ngừng hoạt động</option>
        </select>
    </form>

    <!-- Bảng danh sách bàn -->
    <div class="card shadow-sm">
        <div class="card-body table-responsive">
            <table class="table table-hover align-middle text-center">
                <thead class="table-primary">
                <tr>
                    <th>Mã bàn</th>
                    <th>Khu vực</th>
                    <th>Sức chứa</th>
                    <th>Ghi chú</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="t" items="${tables}">
                    <tr>
                        <td>${t.code}</td>
                        <td>${t.area_id}</td>
                        <td>${t.capacity}</td>
                        <td>${t.note}</td>
                        <td>
                            <span class="${t.is_active ? 'status-active' : 'status-inactive'}">
                                ${t.is_active ? 'Đang hoạt động' : 'Ngừng hoạt động'}
                            </span>
                        </td>
                        <td class="d-flex justify-content-center gap-2 flex-wrap">

                            <!-- Đổi trạng thái -->
                            <form action="${pageContext.request.contextPath}/staff/tables" method="post" class="d-inline">
                                <input type="hidden" name="action" value="changeStatus">
                                <input type="hidden" name="id" value="${t.id}">
                                <input type="hidden" name="is_active" value="${!t.is_active}">
                                <button type="submit" class="btn btn-sm ${t.is_active ? 'btn-danger' : 'btn-success'}">
                                    ${t.is_active ? 'Ngưng' : 'Kích hoạt'}
                                </button>
                            </form>

                            <!-- Lịch sử đặt bàn -->
                            <a href="${pageContext.request.contextPath}/staff/tables?action=history&id=${t.id}"
                               class="btn btn-sm btn-info text-white">
                                <i class="fas fa-clock"></i> Lịch sử
                            </a>

                            <!-- Gán bàn -->
                            <a href="${pageContext.request.contextPath}/staff/tables/assign?id=${t.id}"
                               class="btn btn-sm btn-warning text-white">
                                <i class="fas fa-link"></i> Gán bàn
                            </a>

                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty tables}">
                    <tr><td colspan="6" class="text-center text-muted py-3">Không có bàn nào được tìm thấy.</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Phân trang -->
    <c:if test="${totalPages > 1}">
        <nav aria-label="Page navigation" class="mt-4">
            <ul class="pagination justify-content-center">
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link"
                       href="?page=${currentPage - 1}${currentStatus != null ? '&status=' + currentStatus : ''}">
                        « Trước
                    </a>
                </li>

                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                        <a class="page-link"
                           href="?page=${i}${currentStatus != null ? '&status=' + currentStatus : ''}">
                            ${i}
                        </a>
                    </li>
                </c:forEach>

                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link"
                       href="?page=${currentPage + 1}${currentStatus != null ? '&status=' + currentStatus : ''}">
                        Sau »
                    </a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
