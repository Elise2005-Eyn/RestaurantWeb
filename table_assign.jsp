<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Gán bàn cho khách hàng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

        <style>
            :root {
                --color-gold: #e0b841;
                --color-gold-light: #f5d76e;
                --color-black: #1a1a1a;
                --gold-gradient: linear-gradient(135deg, #e0b841, #f5d76e);
                --transition: all 0.25s ease;
            }

            body {
                background-color: var(--color-black);
                color: white;
                font-family: 'Poppins', sans-serif;
            }

            .form-card {
                max-width: 720px;
                margin: 50px auto;
                background: #2b2b2b;
                border-radius: 18px;
                box-shadow: 0 8px 20px rgba(0,0,0,0.6);
                overflow: hidden;
                border: 2px solid rgba(224, 184, 65, 0.4);
            }

            .form-card h4 {
                background: var(--gold-gradient);
                color: var(--color-black);
                font-weight: 700;
                padding: 16px;
                font-size: 1.3rem;
                text-align: center;
                letter-spacing: 0.5px;
            }

            label {
                color: var(--color-gold-light);
                font-weight: 600;
                margin-bottom: 5px;
            }

            input.form-control, select.form-select, textarea.form-control {
                background-color: #3a3a3a;
                color: white;
                border: 1px solid rgba(255,255,255,0.2);
                border-radius: 10px;
                transition: var(--transition);
            }

            input:focus, select:focus, textarea:focus {
                background-color: #444;
                border-color: var(--color-gold);
                box-shadow: 0 0 8px rgba(224,184,65,0.3);
                color: white;
            }

            .btn-secondary {
                background-color: #3a3a3a;
                color: var(--color-gold-light);
                border: 1px solid rgba(224,184,65,0.4);
                border-radius: 10px;
                padding: 0.5rem 1.2rem;
                font-weight: 600;
                transition: var(--transition);
            }
            .btn-secondary:hover {
                background-color: #2a2a2a;
                transform: translateY(-3px);
                box-shadow: 0 6px 16px rgba(224,184,65,0.3);
            }

            .btn-confirm {
                background: var(--gold-gradient);
                color: var(--color-black);
                border: none;
                border-radius: 10px;
                padding: 0.5rem 1.2rem;
                font-weight: 700;
                transition: var(--transition);
                box-shadow: 0 4px 12px rgba(224,184,65,0.3);
            }
            .btn-confirm:hover {
                background: var(--color-gold-light);
                transform: translateY(-3px);
                box-shadow: 0 6px 16px rgba(224,184,65,0.4);
            }

            textarea::placeholder {
                color: #bbb;
                font-style: italic;
            }
        </style>
    </head>

    <body>

        <!-- Header -->
        <jsp:include page="/Views/components/staff_header.jsp"/>

        <div class="container">
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

            <div class="form-card">
                <h4><i class="fa-solid fa-chair"></i> Gán bàn cho khách hàng</h4>
                <form method="get" action="${pageContext.request.contextPath}/staff/reservation_list" class="p-4">
                    <input type="hidden" name="action" value="assignTable">

                    <input type="hidden" name="id" value="${reservation.reservationId}">
                    <!-- Tên khách hàng -->
                    <div class="mb-3">
                        <label class="form-label">Tên khách hàng</label>
                        <input type="text" class="form-control" value="${reservation.customerName}" readonly>
                    </div>
                    <!-- Thời gian dùng bữa -->
                    <div class="mb-3">
                        <label class="form-label">Thời gian dùng bữa</label>
                        <input type="text" class="form-control" value="${reservation.reservedAtFormatted}" readonly>
                    </div>
                    <!-- Số khách -->
                    <div class="mb-3">
                        <label class="form-label">Số lượng khách</label>
                        <input type="text" class="form-control" value="${reservation.guestCount}" readonly>
                    </div>
                    <!-- Ghi chú -->
                    <div class="mb-3">
                        <label class="form-label">Ghi chú</label>
                        <input type="text" class="form-control" value="${reservation.note}" readonly>
                    </div>
                    <!-- Chọn bàn -->
                    <div class="mb-3">
                        <label class="form-label">Chọn bàn</label>
                        <select name="tableId" class="form-select" required>
                            <option value="">Chọn bàn</option>
                            <c:forEach var="table" items="${tables}">
                                <option value="${table.table_id}"> ${table.table_code} (${table.capacity} người)</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Nút điều hướng -->
                    <div class="d-flex justify-content-between mt-4">
                        <a href="${pageContext.request.contextPath}/staff/reservation_list" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Quay lại
                        </a>
                        <button type="submit" class="btn-confirm">
                            <i class="fas fa-check-circle"></i> Xác nhận gán bàn
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
