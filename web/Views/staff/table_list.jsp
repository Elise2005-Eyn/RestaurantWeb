<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Danh sách đơn đặt bàn</title>
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

            .status-CONFIRMED {
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
                justify-content: right;
                align-items: center;
            }

            .btn-confirm {
                background: #198754;
                color: white;
                border: none;
                padding: 0.5rem 1rem;
                border-radius: 8px;
                font-size: 0.85rem;
                font-weight: 600;
                transition: var(--transition);
                min-width: 100px;
            }
            .btn-confirm:hover {
                background: #146c43;
                transform: translateY(-2px);
            }

            .btn-cancel {
                background: #dc3545;
                color: white;
                border: none;
                padding: 0.5rem 1rem;
                border-radius: 8px;
                font-size: 0.85rem;
                font-weight: 600;
                transition: var(--transition);
                min-width: 100px;
            }

            .btn-cancel:hover {
                background: #b02a37;
                transform: translateY(-2px);
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
                    flex-direction: column;
                    gap: 0.5rem;
                }
                .btn-confirm, .btn-cancel {
                    width: 100%;
                }
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

        <div class="container">
            <!-- Tiêu đề + Nút thêm -->
            <div class="page-title">
                <h3><i class="fas fa-chair"></i>Tình Trạng Bàn</h3>
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

            <!-- Bảng danh sách đơn hàng -->
            <div class="main-row">               
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
