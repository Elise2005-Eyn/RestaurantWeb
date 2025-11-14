<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Danh sách đơn đặt bàn hôm nay</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            /* Copy CSS gốc của bạn từ file trước (root, page-title, table-card, status-badge, btn-checkin, etc.) */
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

            .container { max-width: 1400px; }

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

            .btn-todayReservation {
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
                text-decoration: none;
            }

            .btn-todayReservation:hover {
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(224, 184, 65, 0.4);
                color: var(--color-black);
            }

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

            .status-badge {
                font-size: 0.8rem;
                padding: 0.4rem 0.75rem;
                border-radius: 8px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .status-CONFIRMED {
                background: rgba(25, 135, 84, 0.2);
                color: #198754;
                border: 1px solid #198754;
            }

            .btn-checkin {
                background: #198754;
                color: white;
                border: none;
                padding: 0.5rem 1rem;
                border-radius: 8px;
                font-size: 0.85rem;
                font-weight: 600;
                transition: var(--transition);
                min-width: 140px;
            }

            .btn-checkin:hover {
                background: #146c43;
                transform: translateY(-2px);
            }

            .action-btns {
                display: flex;
                gap: 0.5rem;
                justify-content: center;
            }
        </style>
    </head>

    <body>
        <!-- Header -->
        <jsp:include page="/Views/components/staff_header.jsp" />

        <div class="container">
            <!-- Tiêu đề -->
            <div class="page-title">
                <h3><i class="fas fa-calendar-check"></i> Đơn Đặt Bàn Hôm Nay (CONFIRMED)</h3>
                <a href="${pageContext.request.contextPath}/staff/reservation_list" class="btn-todayReservation">
                    <i class="fas fa-arrow-left"></i> Quay về danh sách
                </a>
            </div>

            <!-- Hiển thị thông báo -->
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

            <!-- Bảng danh sách đơn hôm nay -->
            <div class="table-card">
                <div class="card-body table-responsive p-0">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="text-center text-secondary fw-semibold">
                            <tr>
                                <th style="width: 8%;">Mã Đặt Bàn</th>
                                <th style="width: 15%;">Khách Hàng</th>
                                <th style="width: 15%;">Thời Gian Dùng Bữa</th>
                                <th style="width: 8%;">Số Khách</th>
                                <th style="width: 20%;">Ghi Chú</th>
                                <th style="width: 10%;">Trạng Thái</th>
                                <th style="width: 24%;">Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="r" items="${todayReservations}">
                                <tr id="reservation-${r.reservation_id}">  <!-- An toàn cho Map hoặc Model -->
                                    <td class="text-center fw-semibold text-secondary">${r.reservation_id}</td>
                                    <td class="text-center fw-semibold text-secondary">${r.customerName}</td>
                                    <td class="text-center fw-semibold text-secondary">${r.reservedAtFormatted}</td>
                                    <td class="text-center fw-semibold text-secondary">${r.guest_count}</td>
                                    <td class="text-center fw-semibold text-secondary">${r.note}</td>
                                    <td class="text-center">
                                        <span class="status-badge status-${r['status'] or r.status}" id="status-${r.reservationId}">
                                            ${r.status}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="action-btns">
                                            <form action="${pageContext.request.contextPath}/staff/reservation_list" method="post" style="display: inline;">
                                                <input type="hidden" name="action" value="checkin">
                                                <input type="hidden" name="id" value="${r.reservation_id}">
                                                <button type="submit" class="btn-checkin">
                                                    <i class="fas fa-check me-1"></i> Bắt đầu bữa ăn
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>  <!-- Đóng <tr> đúng trong loop -->
                            </c:forEach>

                            <c:if test="${empty todayReservations}">  <!-- Fix: Dùng todaysReservations -->
                                <tr>
                                    <td colspan="7" class="text-center text-muted py-3">  <!-- Fix: Colspan=7 -->
                                        <i class="fas fa-calendar-times me-1"></i> Hôm nay không có đơn đặt bàn trước.
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
                            <a class="page-link" href="?page=${currentPage - 1}">« Trước</a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="?page=${i}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${currentPage + 1}">Sau »</a>
                        </li>
                    </ul>
                </nav>
            </c:if>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>