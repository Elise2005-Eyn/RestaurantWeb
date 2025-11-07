<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết đơn hàng</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <!-- Google Fonts: Lato & Oswald -->
        <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Oswald:wght@600;700&display=swap" rel="stylesheet">

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
                min-height: 100vh;
                padding: 2rem 1rem;
            }

            .detail-card {
                max-width: 860px;
                margin: 0 auto;
                background: var(--color-gray-dark);
                border-radius: var(--radius);
                overflow: hidden;
                box-shadow: var(--shadow-sm);
                border: 1px solid var(--color-gray-medium);
                transition: var(--transition);
            }

            .detail-card:hover {
                box-shadow: var(--shadow-md);
                transform: translateY(-6px);
                border-color: var(--color-gold);
            }

            .card-header {
                background: var(--gold-gradient);
                color: var(--color-black);
                padding: 1.25rem 1.5rem;
                font-family: 'Oswald', sans-serif;
                font-weight: 700;
                font-size: 1.5rem;
                display: flex;
                align-items: center;
                gap: 0.75rem;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            .card-header i {
                font-size: 1.6rem;
            }

            .card-body {
                padding: 2rem;
            }

            .info-row {
                display: flex;
                justify-content: space-between;
                padding: 0.75rem 0;
                border-bottom: 1px dashed var(--color-gray-medium);
                font-size: 1rem;
            }

            .info-row:last-child {
                border-bottom: none;
                margin-bottom: 1.5rem;
            }

            .info-label {
                font-weight: 700;
                color: var(--color-gray-light);
                text-transform: uppercase;
                letter-spacing: 0.5px;
                font-size: 0.9rem;
            }

            .info-value {
                color: var(--color-white);
                font-weight: 600;
            }

            .status-badge {
                padding: 0.45rem 0.9rem;
                border-radius: 10px;
                font-weight: 700;
                font-size: 0.85rem;
                text-transform: uppercase;
                letter-spacing: 0.8px;
                display: inline-block;
                min-width: 100px;
                text-align: center;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
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

            /* Bảng món ăn */
            .items-table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
                margin: 1.5rem 0;
                font-size: 0.95rem;
            }

            .items-table thead {
                background: var(--color-gray-medium);
                color: var(--color-gold);
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .items-table th {
                padding: 1rem 0.75rem;
                text-align: center;
                border-bottom: 2px solid var(--color-gold);
            }

            .items-table td {
                padding: 1rem 0.75rem;
                text-align: center;
                border-bottom: 1px solid var(--color-gray-medium);
                color: var(--color-white);
            }

            .items-table tbody tr:hover {
                background: rgba(224, 184, 65, 0.1);
            }

            .total-row {
                font-family: 'Oswald', sans-serif;
                font-size: 1.6rem;
                font-weight: 700;
                color: var(--color-gold);
                text-align: right;
                padding: 1.25rem 0;
                border-top: 2px dashed var(--color-gold);
                margin-top: 1rem;
            }

            .btn-back {
                background: var(--color-gray-medium);
                color: var(--color-white);
                border: 1.5px solid var(--color-gray-light);
                padding: 0.75rem 1.5rem;
                border-radius: 12px;
                font-weight: 600;
                transition: var(--transition);
                text-transform: uppercase;
                font-size: 0.9rem;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
            }

            .btn-back:hover {
                background: var(--color-gray-dark);
                border-color: var(--color-gold);
                color: var(--color-gold);
                transform: translateY(-2px);
            }

            @media (max-width: 768px) {
                .card-body {
                    padding: 1.5rem;
                }
                .info-row {
                    flex-direction: column;
                    gap: 0.5rem;
                }
                .info-label {
                    font-size: 0.85rem;
                }
                .total-row {
                    font-size: 1.4rem;
                    text-align: center;
                }
                .items-table {
                    font-size: 0.85rem;
                }
            }
        </style>
    </head>
    <body class="bg-light">

        <jsp:include page="/Views/components/staff_header.jsp" />

        <div class="container mt-4">
            <div class="detail-card">
                <div class="card-header">
                    <i class="fas fa-receipt"></i> Chi tiết đơn hàng #${order.order_id}
                </div>
                <div class="card-body">
                    <!-- Thông tin cơ bản -->
                    <p><strong>Khách hàng:</strong> ${order.customer_name}</p>
                    <p><strong>Bàn:</strong> ${order.table_code}</p>
                    <p><strong>Trạng thái:</strong> ${order.status}</p>
                    <p><strong>Loại đơn hàng:</strong> ${order.order_type}</p>
                    <p><strong>Ngày tạo:</strong> ${order.createdAtFormatted}</p>
                    <p><strong>Ghi chú:</strong> ${order.note}</p>
                    <hr style="border-color: var(--color-gray-medium); margin: 2rem 0;">

                    <h6 class="fw-bold mb-3" style="color: var(--color-gold); text-transform: uppercase; letter-spacing: 1px;">Danh sách món ăn</h6>
                    <table class="items-table">
                        <thead>
                            <tr>
                                <th>Tên món</th>
                                <th>Số lượng</th>
                                <th>Giá (₫)</th>
                                <th>Tổng (₫)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${items}">
                                <tr>
                                    <td>${item.name}</td>
                                    <td>${item.quantity}</td>
                                    <td>${item.price}</td>
                                    <td>${item.subtotal}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <div class="total-row">
                        <p>Tổng cộng: <span>${order.amount}</span> ₫</p>
                    </div>

                    <div class="text-end">
                        <a href="${pageContext.request.contextPath}/staff/orders" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Quay lại
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
