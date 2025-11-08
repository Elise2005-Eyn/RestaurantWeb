<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý đơn hàng - Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body { background-color: #f6f8fa; }

        .status-badge {
            font-size: 0.85rem;
            padding: 0.35rem 0.6rem;
            border-radius: 8px;
            font-weight: 600;
        }
        .status-PENDING { background: #fff3cd; color: #7a6000; }
        .status-IN_PROGRESS { background: #e3f2fd; color: #0d47a1; }
        .status-COMPLETED { background: #e8f5e9; color: #1b5e20; }
        .status-CANCELLED { background: #ffebee; color: #b71c1c; }

        .table thead th {
            font-size: 0.95rem;
            background-color: #e3f2fd !important;
        }
        .table-hover tbody tr:hover {
            background-color: #f8fbff;
        }
        .table td {
            vertical-align: middle;
        }
        .action-btns {
            display: flex;
            gap: 6px;
            justify-content: center;
            align-items: center;
        }
        .btn-sm {
            padding: 0.25rem 0.55rem;
            font-size: 0.85rem;
        }
        .filter-form select {
            min-width: 180px;
        }
    </style>
</head>

<body>

<!-- Header -->
<jsp:include page="/Views/components/staff_header.jsp" />

<div class="container mt-4">
    <!-- Tiêu đề + Nút thêm -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold text-primary mb-0"><i class="fas fa-receipt me-2"></i> Quản lý Đơn hàng</h3>
        <a href="${pageContext.request.contextPath}/staff/orders?action=add" class="btn btn-success shadow-sm">
            <i class="fas fa-plus-circle me-1"></i> Thêm Đơn hàng
        </a>
    </div>

    <!-- Bộ lọc trạng thái -->
    <form method="get" action="${pageContext.request.contextPath}/staff/orders"
          class="filter-form mb-3 d-flex align-items-center gap-2">
        <label for="status" class="fw-semibold text-secondary">Lọc theo trạng thái:</label>
        <select name="status" id="status" class="form-select w-auto shadow-sm border-0"
                onchange="this.form.submit()">
            <option value="">Tất cả</option>
            <option value="PENDING" ${currentStatus == 'PENDING' ? 'selected' : ''}>PENDING</option>
            <option value="IN_PROGRESS" ${currentStatus == 'IN_PROGRESS' ? 'selected' : ''}>IN_PROGRESS</option>
            <option value="COMPLETED" ${currentStatus == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
            <option value="CANCELLED" ${currentStatus == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
        </select>
    </form>

    <!-- Bảng danh sách đơn hàng -->
    <div class="card shadow-sm border-0">
        <div class="card-body table-responsive p-0">
            <table class="table table-hover align-middle mb-0">
                <thead class="text-center text-secondary fw-semibold">
                <tr>
                    <th style="width: 5%;">Mã Đơn</th>
                    <th style="width: 15%;">Khách hàng</th>
                    <th style="width: 5%;">Bàn</th>
                    <th style="width: 10%;">Số tiền (₫)</th>
                    <th style="width: 10%;">Loại</th>
                    <th style="width: 10%;">Trạng thái</th>
                    <th style="width: 20%;">Ngày tạo</th>
                    <th style="width: 20%;">Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="o" items="${orders}">
                    <tr id="order-${o.orderId}">
                        <td class="text-center fw-semibold text-secondary">${o.orderId}</td>
                        <td>${o.customerName}</td>
                        <td class="text-center">${o.tableId}</td>
                        <td class="fw-semibold text-success text-center">${o.amount}</td>
                        <td class="text-center">${o.orderType}</td>
                        <td class="text-center">
                            <span class="status-badge status-${o.status}" id="status-${o.orderId}">
                                ${o.status}
                            </span>
                        </td>
                        <td class="text-center">${o.createdAt}</td>
                        <td>
                            <div class="action-btns">
                                <!-- Form đổi trạng thái -->
                                <form action="${pageContext.request.contextPath}/staff/orders" method="get" class="d-flex align-items-center">
                                    <input type="hidden" name="action" value="changeStatus">
                                    <input type="hidden" name="id" value="${o.orderId}">
                                    <select name="status" class="form-select form-select-sm w-auto me-1" required>
                                        <option disabled selected>Đổi</option>
                                        <option value="IN_PROGRESS">IN_PROGRESS</option>
                                        <option value="COMPLETED">COMPLETED</option>
                                        <option value="CANCELLED">CANCELLED</option>
                                    </select>
                                    <button type="submit" class="btn btn-outline-primary btn-sm" title="Cập nhật trạng thái">
                                        <i class="fas fa-sync-alt"></i>
                                    </button>
                                </form>

                                <!-- Nút xem chi tiết -->
                                <a href="${pageContext.request.contextPath}/staff/orders?action=detail&id=${o.orderId}"
                                   class="btn btn-sm btn-info text-white" title="Xem chi tiết">
                                    <i class="fas fa-eye"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty orders}">
                    <tr>
                        <td colspan="8" class="text-center text-muted py-3">
                            <i class="fas fa-box-open me-1"></i> Không có đơn hàng nào.
                        </td>
                    </tr>
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
                    <a class="page-link" href="?page=${currentPage - 1}${currentStatus != null ? '&status=' + currentStatus : ''}">« Trước</a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                        <a class="page-link" href="?page=${i}${currentStatus != null ? '&status=' + currentStatus : ''}">${i}</a>
                    </li>
                </c:forEach>
                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${currentPage + 1}${currentStatus != null ? '&status=' + currentStatus : ''}">Sau »</a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
