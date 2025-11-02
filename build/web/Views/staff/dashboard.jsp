<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Staff Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <!-- Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        :root {
            --primary: #5e3bb7;
            --primary-light: #d9c8ff;
            --secondary: #00d2d3;
            --success: #2ecc71;
            --warning: #f39c12;
            --danger: #e74c3c;
            --dark: #2c3e50;
            --light: #f8f9fa;
            --bg: #f0f2ff;
            --card-bg: #ffffff;
            --text: #2d3436;
            --text-light: #636e72;
            --border: #e0e6ed;
            --shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
            --radius: 16px;
            --transition: all 0.3s ease;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: linear-gradient(135deg, #f0f2ff 0%, #e6e9ff 100%);
            color: var(--text);
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            padding: 20px;
        }

        .container-fluid {
            max-width: 1400px;
        }

        h1 {
            font-family: 'Poppins', sans-serif;
            font-weight: 700;
            color: var(--primary);
            text-align: center;
            margin: 20px 0 40px;
            font-size: 2.4rem;
            letter-spacing: -0.5px;
        }

        .dashboard-header {
            background: var(--card-bg);
            padding: 20px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
            text-align: center;
            border: 1px solid var(--border);
        }

        .stat-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .stat-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 25px;
            box-shadow: var(--shadow);
            border: 1px solid var(--border);
            transition: var(--transition);
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 5px;
            height: 100%;
            background: var(--primary);
            transition: width 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.12);
        }

        .stat-card:hover::before {
            width: 100%;
            opacity: 0.1;
        }

        .stat-icon {
            font-size: 2rem;
            margin-bottom: 15px;
            color: var(--primary);
            display: block;
        }

        .stat-card h3 {
            font-size: 1rem;
            color: var(--text-light);
            margin-bottom: 10px;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stat-card .value {
            font-size: 2.4rem;
            font-weight: 700;
            color: var(--text);
            margin-bottom: 10px;
        }

        .detail-list {
            list-style: none;
            padding: 0;
            margin: 15px 0 0;
            font-size: 0.9rem;
        }

        .detail-list li {
            display: flex;
            justify-content: space-between;
            padding: 6px 0;
            border-bottom: 1px dashed #eee;
            color: var(--text-light);
        }

        .detail-list li:last-child {
            border-bottom: none;
        }

        .detail-list strong {
            color: var(--primary);
            font-weight: 600;
        }

        footer {
            text-align: center;
            padding: 20px;
            color: var(--text-light);
            font-size: 0.9rem;
            margin-top: 40px;
            border-top: 1px solid var(--border);
        }

        @media (max-width: 768px) {
            h1 {
                font-size: 2rem;
            }
            .stat-card .value {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>

<div class="container-fluid">

    <!-- Tiêu đề -->
    <div class="dashboard-header">
        <h1><i class="fas fa-tachometer-alt"></i> STAFF DASHBOARD</h1>
        <p class="text-muted">Tổng quan hoạt động nhà hàng - Cập nhật theo thời gian thực</p>
    </div>

    <!-- Thống kê nhanh -->
    <div class="stat-grid">
        <!-- Tổng số bàn -->
        <div class="stat-card">
            <i class="fas fa-chair stat-icon"></i>
            <h3>Tổng số bàn</h3>
            <div class="value">${totalTables}</div>
            <small class="text-success"><i class="fas fa-check-circle"></i> Đã sẵn sàng phục vụ</small>
        </div>

        <!-- Tổng đặt bàn -->
        <div class="stat-card">
            <i class="fas fa-calendar-check stat-icon"></i>
            <h3>Tổng đặt bàn hôm nay</h3>
            <div class="value">
                <c:set var="totalRes" value="0"/>
                <c:forEach var="r" items="${reservationDetails}">
                    <c:set var="totalRes" value="${totalRes + r.value}"/>
                </c:forEach>
                ${totalRes}
            </div>
            <ul class="detail-list">
                <c:forEach var="r" items="${reservationDetails}">
                    <li><strong>${r.key}</strong> <span>${r.value} lượt</span></li>
                </c:forEach>
            </ul>
        </div>

        <!-- Tổng đơn hàng -->
        <div class="stat-card">
            <i class="fas fa-receipt stat-icon"></i>
            <h3>Tổng đơn hàng</h3>
            <div class="value">${totalOrders}</div>
            <small class="text-info"><i class="fas fa-arrow-up"></i> Đang xử lý</small>
        </div>
    </div>

</div>

<footer>
    © 2025 Nhà hàng Demo | Staff Portal - Powered by JSP
</footer>

</body>
</html>