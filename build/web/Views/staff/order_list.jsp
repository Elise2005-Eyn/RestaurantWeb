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
            :root {
                --color-black: #121212;
                --color-gray-dark: #222222;
                --color-gray-medium: #444444;
                --color-gray-light: #AAAAAA;
                --color-white: #F0F0F0;
                --color-gold: #E0B841;
                --color-gold-light: #f9d423;
                --gold-gradient: linear-gradient(135deg, #E0B841 0%, #d4a017 100%);
                --shadow-sm: 0 8px 25px rgba(0, 0, 0, 0.6);
                --shadow-md: 0 15px 40px rgba(224, 184, 65, 0.2);
                --radius: 18px;
                --transition: all 0.3s ease;
            }

            body {
                background: var(--color-black);
                color: var(--color-white);
                font-family: 'Lato', sans-serif;
                padding: 2rem 1rem;
            }

            .container {
                max-width: 1400px;
            }

            /* Tiêu đề + Nút thêm */
            .page-title {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 2rem;
                flex-wrap: wrap;
                gap: 1rem;
            }

            .page-title h3 {
                font-family: 'Oswald', sans-serif;
                font-weight: 700;
                font-size: 2rem;
                color: var(--color-gold);
                text-transform: uppercase;
                letter-spacing: 1.5px;
                margin: 0;
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            .btn-add {
                background: var(--gold-gradient);
                color: var(--color-black);
                border: none;
                padding: 0.75rem 1.5rem;
                border-radius: 12px;
                font-weight: 700;
                font-size: 0.95rem;
                box-shadow: 0 4px 15px rgba(224, 184, 65, 0.3);
                transition: var(--transition);
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .btn-add:hover {
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(224, 184, 65, 0.4);
                color: var(--color-black);
            }

            /* Bộ lọc */
            .filter-form {
                display: flex;
                align-items: center;
                gap: 1rem;
                margin-bottom: 1.5rem;
                flex-wrap: wrap;
            }

            .filter-form label {
                color: var(--color-gray-light);
                font-weight: 600;
                font-size: 0.95rem;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .filter-form select {
                background: var(--color-gray-medium);
                border: 1.5px solid var(--color-gray-light);
                color: var(--color-white);
                border-radius: 12px;
                padding: 0.5rem 1rem;
                font-size: 0.9rem;
                min-width: 180px;
                transition: var(--transition);
            }

            .filter-form select:focus {
                border-color: var(--color-gold);
                box-shadow: 0 0 0 4px rgba(224, 184, 65, 0.25);
                outline: none;
            }

            /* Bảng */
            .table-card {
                background: var(--color-gray-dark);
                border-radius: var(--radius);
                overflow: hidden;
                box-shadow: var(--shadow-sm);
                border: 1px solid var(--color-gray-medium);
            }

            .table thead {
                background: var(--color-gray-medium);
                color: var(--color-gold);
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                font-size: 0.9rem;
            }

            .table thead th {
                padding: 1rem 0.75rem;
                text-align: center;
                border-bottom: 2px solid var(--color-gold);
            }

            .table tbody td {
                padding: 1rem 0.75rem;
                vertical-align: middle;
                color: var(--color-white);
                font-size: 0.95rem;
                border-bottom: 1px solid var(--color-gray-medium);
            }

            .table tbody tr:hover {
                background: rgba(224, 184, 65, 0.1);
                box-shadow: 0 2px 10px rgba(224, 184, 65, 0.15);
            }

            .table .text-center {
                text-align: center;
            }
            .table .text-end {
                text-align: right;
            }

            /* Badge trạng thái */
            .status-badge {
                font-size: 0.8rem;
                padding: 0.4rem 0.75rem;
                border-radius: 8px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .status-PENDING {
                background: rgba(33, 150, 243, 0.15);
                color: #2196F3;
                border: 1.5px solid #2196F3;
            }

            .status-IN_PROGRESS {
                background: rgba(25, 135, 84, 0.2);
                color: #198754;
                border: 1px solid #198754;
            }

            .status-COMPLETED {
                background: rgba(25, 135, 84, 0.2);
                color: #28a745;
                border: 1px solid #28a745;
            }

            .status-CANCELLED {
                background: rgba(220, 53, 69, 0.2);
                color: #dc3545;
                border: 1px solid #dc3545;
            }

            /* Nút hành động */
            .action-btns {
                display: flex;
                gap: 0.5rem;
                justify-content: center;
                align-items: center;
            }

            .action-btns select {
                background: var(--color-gray-medium);
                border: 1px solid var(--color-gray-light);
                color: var(--color-white);
                border-radius: 8px;
                padding: 0.35rem 0.5rem;
                font-size: 0.85rem;
            }

            .action-btns select:focus {
                border-color: var(--color-gold);
                box-shadow: 0 0 0 3px rgba(224, 184, 65, 0.2);
            }

            .btn-sync {
                background: transparent;
                color: var(--color-gold);
                border: 1.5px solid var(--color-gold);
                padding: 0.35rem 0.6rem;
                border-radius: 8px;
                font-size: 0.85rem;
                transition: var(--transition);
            }

            .btn-sync:hover {
                background: var(--color-gold);
                color: var(--color-black);
            }

            .btn-view {
                background: var(--color-gold);
                color: var(--color-black);
                border: none;
                padding: 0.35rem 0.6rem;
                border-radius: 8px;
                font-size: 0.85rem;
                transition: var(--transition);
            }

            .btn-view:hover {
                background: var(--color-gold-light);
                transform: translateY(-1px);
            }

            /* Phân trang */
            .pagination .page-link {
                background: var(--color-gray-medium);
                border: 1px solid var(--color-gray-light);
                color: var(--color-white);
                padding: 0.6rem 1rem;
                border-radius: 10px;
                margin: 0 4px;
                font-weight: 600;
                transition: var(--transition);
            }

            .pagination .page-link:hover {
                background: var(--color-gold);
                color: var(--color-black);
                border-color: var(--color-gold);
            }

            .pagination .page-item.active .page-link {
                background: var(--gold-gradient);
                color: var(--color-black);
                border-color: var(--color-gold);
                font-weight: 700;
            }

            .pagination .page-item.disabled .page-link {
                opacity: 0.5;
                cursor: not-allowed;
            }

            /* Empty state */
            .empty-state {
                text-align: center;
                padding: 3rem 1rem;
                color: var(--color-gray-light);
                font-size: 1.1rem;
            }

            .empty-state i {
                font-size: 2.5rem;
                color: var(--color-gray-medium);
                margin-bottom: 1rem;
            }

            @media (max-width: 992px) {
                .page-title {
                    flex-direction: column;
                    align-items: stretch;
                }
                .page-title h3 {
                    font-size: 1.8rem;
                    justify-content: center;
                }
                .btn-add {
                    width: 100%;
                    text-align: center;
                }
                .filter-form {
                    justify-content: center;
                }
            }

            @media (max-width: 768px) {
                .table thead {
                    display: none;
                }
                .table tbody tr {
                    display: block;
                    margin-bottom: 1rem;
                    border: 1px solid var(--color-gray-medium);
                    border-radius: 12px;
                    padding: 1rem;
                }
                .table tbody td {
                    display: block;
                    text-align: right;
                    padding: 0.5rem 0;
                    border: none;
                }
                .table tbody td::before {
                    content: attr(data-label);
                    float: left;
                    font-weight: 700;
                    color: var(--color-gold);
                    text-transform: uppercase;
                    font-size: 0.8rem;
                }
                .action-btns {
                    justify-content: flex-end;
                }
            }
        </style>
    </head>

    <body>

        <!-- Header -->
        <jsp:include page="/Views/components/staff_header.jsp" />

        <div class="container">
            <!-- Tiêu đề + Nút thêm -->
            <div class="page-title">
                <h3><i class="fas fa-receipt"></i> Quản lý Đơn hàng</h3>
                <a href="${pageContext.request.contextPath}/staff/orders?action=add" class="btn btn-add">
                    <i class="fas fa-plus-circle"></i> Thêm Đơn hàng
                </a>
            </div>

            <!-- Bộ lọc trạng thái -->
            <form method="get" action="${pageContext.request.contextPath}/staff/orders"
                  class="filter-form">
                <label for="status" class="fw-semibold text-secondary">Lọc theo trạng thái:</label>
                <select name="status" id="status" class="form-select w-auto shadow-sm border-0"
                        onchange="this.form.submit()">
                    <option value="">Tất cả</option>
                    <option value="PENDING" ${currentStatus == 'PENDING' ? 'selected' : ''}>Chờ xử lý</option>
                    <option value="IN_PROGRESS" ${currentStatus == 'IN_PROGRESS' ? 'selected' : ''}>Đang làm</option>
                    <option value="COMPLETED" ${currentStatus == 'COMPLETED' ? 'selected' : ''}>Hoàn tất</option>
                    <option value="CANCELLED" ${currentStatus == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
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
                                                    <option disabled selected>Đổi trạng thái</option>
                                                    <option value="IN_PROGRESS">Đang làm</option>
                                                    <option value="COMPLETED">Hoàn tất</option>
                                                    <option value="CANCELLED">Đã hủy</option>
                                                </select>
                                                <button type="submit" class="btn-sync" title="Cập nhật trạng thái">
                                                    <i class="fas fa-sync-alt"></i>
                                                </button>
                                            </form>

                                            <!-- Nút xem chi tiết -->
                                            <a href="${pageContext.request.contextPath}/staff/orders?action=detail&id=${o.orderId}"
                                               class="btn-view" title="Xem chi tiết">
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
