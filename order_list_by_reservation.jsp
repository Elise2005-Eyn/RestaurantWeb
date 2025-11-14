<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách orders theo đặt bàn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        /* Copy toàn bộ CSS từ occupied_table_list.jsp (để đồng bộ) */
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

        .btn-back {
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
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-back:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(224, 184, 65, 0.4);
            color: var(--color-black);
        }

        .btn-add-order {
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
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-add-order:hover {
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

        .text-center { text-align: center; }

        .status-badge {
            font-size: 0.8rem;
            padding: 0.4rem 0.75rem;
            border-radius: 8px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-PENDING { background: rgba(33, 150, 243, 0.15); color: #2196F3; border: 1.5px solid #2196F3; }
        .status-COMPLETED { background: rgba(25, 135, 84, 0.2); color: #28a745; border: 1px solid #28a745; }

        @media (max-width: 768px) {
            .table thead { display: none; }
            .table tbody tr { display: block; margin-bottom: 1rem; border: 1px solid var(--color-gray-medium); border-radius: 12px; padding: 1rem; }
            .table tbody td { display: block; text-align: right; padding: 0.5rem 0; border: none; }
            .table tbody td::before { content: attr(data-label); float: left; font-weight: 700; color: var(--color-gold); text-transform: uppercase; font-size: 0.8rem; }
        }
    </style>
</head>
<body>
    <jsp:include page="/Views/components/staff_header.jsp" />

    <div class="container">
        <div class="page-title">
            <h3><i class="fas fa-list-alt"></i> Danh sách orders - Đặt bàn #${reservationId}</h3>
            <div>
                <a href="${pageContext.request.contextPath}/staff/tables?action=occupiedTables" class="btn-back me-2">
                    <i class="fas fa-arrow-left"></i> Quay về
                </a>
                <a href="${pageContext.request.contextPath}/staff/tables?action=addOrder&id=${reservationId}" class="btn-add-order">
                    <i class="fas fa-plus"></i> Add order
                </a>
            </div>
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

        <!-- Bảng danh sách orders -->
        <div class="table-card">
            <table class="table">
                <thead>
                    <tr>
                        <th class="text-center">Mã order</th>
                        <th class="text-center">Tổng tiền</th>
                        <th class="text-center">Trạng thái</th>
                        <th class="text-center">Thời gian tạo</th>
                        <th class="text-center">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${orders}">
                        <tr>
                            <td class="text-center" data-label="Mã order">${order.orderId}</td>
                            <td class="text-center" data-label="Tổng tiền">${order.amount}₫</td>
                            <td class="text-center" data-label="Trạng thái">
                                <span class="status-badge status-${order.status}">${order.status}</span>
                            </td>
                            <td class="text-center" data-label="Thời gian tạo">${order.createdAt}</td>
                            <td data-label="Hành động" class="text-center">
                                <a href="${pageContext.request.contextPath}/staff/tables?action=viewOrderDetail&id=${order.orderId}" class="btn-view" title="Xem chi tiết order">
                                    <i class="fas fa-eye"></i> Xem chi tiết
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty orders}">
                        <tr>
                            <td colspan="5" class="text-center text-muted py-3">
                                <i class="fas fa-box-open me-1"></i> Chưa có order nào cho đặt bàn này.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>