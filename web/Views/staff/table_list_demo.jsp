<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Tình trạng bàn | Nhà hàng Ngon</title>
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

            .container-fluid {
                max-width: 1700px;
            }

            .page-title h3 {
                font-family: 'Oswald', sans-serif;
                font-weight: 700;
                font-size: 2.2rem;
                color: var(--color-gold);
                text-transform: uppercase;
                letter-spacing: 1.5px;
                margin-bottom: 2.5rem;
                text-align: center;
            }

            /* 2 cột bên cạnh nhau */
            .main-row {
                display: flex;
                gap: 2rem;
                flex-wrap: wrap;
            }

            .section {
                flex: 1;
                min-width: 500px;
                background: var(--color-gray-dark);
                border-radius: var(--radius);
                padding: 1.8rem;
                box-shadow: var(--shadow-sm);
                border: 1px solid var(--color-gray-medium);
            }

            .section-title {
                font-family: 'Oswald', sans-serif;
                color: var(--color-gold);
                font-size: 1.5rem;
                text-transform: uppercase;
                letter-spacing: 1.2px;
                margin-bottom: 1.2rem;
                border-bottom: 2px solid var(--color-gold);
                padding-bottom: 0.5rem;
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            /* Bảng đơn đặt bàn */
            .reservation-table {
                font-size: 0.95rem;
            }

            .reservation-table thead {
                background: var(--color-gray-medium);
                color: var(--color-gold);
            }

            .status-badge {
                padding: 0.4rem 0.8rem;
                border-radius: 8px;
                font-weight: 700;
                font-size: 0.85rem;
            }

            .status-PENDING {
                background: rgba(255, 193, 7, 0.2);
                color: #ffc107;
                border: 1px solid #ffc107;
            }
            .status-CONFIRMED {
                background: rgba(25, 135, 84, 0.2);
                color: #198754;
                border: 1px solid #198754;
            }
            .status-CANCELLED {
                background: rgba(220, 53, 69, 0.2);
                color: #dc3545;
                border: 1px solid #dc3545;
            }

            /* Grid bàn */
            .table-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
                gap: 1rem;
            }

            .table-item {
                background: var(--color-gray-medium);
                border-radius: var(--radius);
                padding: 1rem;
                text-align: center;
                box-shadow: var(--shadow-sm);
                transition: var(--transition);
                border: 2px solid transparent;
            }

            .table-item:hover {
                transform: translateY(-6px);
                box-shadow: var(--shadow-md);
            }

            .table-status-AVAILABLE {
                border-color: #198754;
                background: rgba(25, 135, 84, 0.15);
            }
            .table-status-RESERVED {
                border-color: #ffc107;
                background: rgba(255, 193, 7, 0.15);
            }
            .table-status-OCCUPIED {
                border-color: #dc3545;
                background: rgba(220, 53, 69, 0.15);
            }
            .table-status-MAINTENANCE {
                border-color: #6c757d;
                background: rgba(108, 117, 125, 0.15);
            }

            .table-label {
                font-family: 'Oswald', sans-serif;
                font-size: 1.3rem;
                font-weight: 700;
                margin-bottom: 0.4rem;
            }

            .table-info {
                font-size: 0.85rem;
                color: var(--color-gray-light);
            }

            /* Responsive */
            @media (max-width: 992px) {
                .main-row {
                    flex-direction: column;
                }
                .section {
                    min-width: 100%;
                }
                .table-grid {
                    grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
                }
            }
        </style>
    </head>
    <body>

        <!-- Header -->
        <jsp:include page="/Views/components/staff_header.jsp" />

        <div class="container-fluid">
            <div class="main-row">               
                <!-- Cột 2: Tình trạng bàn -->
                <div class="section">
                    <div class="table-grid">
                        <c:forEach var="t" items="${tables}">
                            <div class="table-item table-status-${t.status}">
                                <div class="table-label">Bàn ${t.code}</div>
                                <div class="table-info"> Tầng ${t.area_id}</div>
                                <div class="table-info">${t.capacity} người</div>
                                <div class="table-info">
                                    ${t.status == 'AVAILABLE' ? 'Trống' : 
                                      t.status == 'RESERVED' ? 'Đã đặt' : 
                                      t.status == 'OCCUPIED' ? 'Đang dùng' : 'Bảo trì'}                                
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty tables}">
                            <p class="text-center text-muted">Không có bàn</p>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>