<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Staff Dashboard - Nhà Hàng</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@500;600;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <!-- Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <style>
            :root {
                --primary: #E0B841;
                --primary-light: #f9d423;
                --primary-gradient: linear-gradient(135deg, #E0B841 0%, #d4a017 100%);
                --bg: #121212;
                --card-bg: #222222;
                --text: #F0F0F0;
                --text-light: #AAAAAA;
                --border: #444444;
                --shadow-sm: 0 4px 15px rgba(224, 184, 65, 0.15);
                --shadow-md: 0 10px 30px rgba(224, 184, 65, 0.25);
                --radius: 18px;
                --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                background: var(--bg);
                color: var(--text);
                font-family: 'Lato', sans-serif;
                min-height: 100vh;
                padding: 24px 16px;
                background-image:
                    radial-gradient(circle at 10% 20%, rgba(94, 59, 183, 0.05) 0%, transparent 20%),
                    radial-gradient(circle at 90% 80%, rgba(124, 92, 214, 0.05) 0%, transparent 20%);
            }

            .dashboard-header {
                text-align: center;
                margin-bottom: 3rem;
            }

            .dashboard-header h1 {
                font-family: 'Oswald', sans-serif;
                font-weight: 700;
                font-size: 2.6rem;
                background: var(--primary-gradient);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                margin: 0;
                display: inline-block;
                text-transform: uppercase;
                letter-spacing: 1.5px;
            }

            .dashboard-header p {
                color: var(--text-light);
                font-size: 1.05rem;
                margin-top: 0.75rem;
                font-weight: 500;
            }

            .stat-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                gap: 1.5rem;
                margin-bottom: 2.5rem;
            }

            .stat-card {
                background: var(--card-bg);
                border-radius: var(--radius);
                padding: 1.75rem;
                box-shadow: var(--shadow-sm);
                border: 1px solid var(--border);
                text-align: center;
                transition: var(--transition);
                position: relative;
                overflow: hidden;
            }

            .stat-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 4px;
                background: var(--primary-gradient);
                transform: scaleX(0);
                transform-origin: left;
                transition: transform 0.4s ease;
            }

            .stat-card:hover::before {
                transform: scaleX(1);
            }

            .stat-card:hover {
                transform: translateY(-8px);
                box-shadow: var(--shadow-md);
                border-color: var(--primary-light);
            }

            .stat-icon {
                font-size: 2.2rem;
                color: var(--primary);
                margin-bottom: 0.75rem;
                display: block;
            }

            .stat-card h5 {
                font-size: 1rem;
                color: var(--text-light);
                margin-bottom: 0.5rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .stat-card h2 {
                font-family: 'Oswald', sans-serif;
                font-size: 2.4rem;
                font-weight: 700;
                color: var(--primary);
                margin: 0;
                line-height: 1.2;
            }

            .chart-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 1.5rem;
                margin-top: 2rem;
            }

            .chart-card {
                background: var(--card-bg);
                border-radius: var(--radius);
                padding: 1.75rem;
                box-shadow: var(--shadow-sm);
                border: 1px solid var(--border);
                transition: var(--transition);
            }

            .chart-card:hover {
                box-shadow: var(--shadow-md);
                border-color: var(--primary-light);
            }

            .chart-card h5 {
                font-weight: 700;
                color: var(--text);
                margin-bottom: 1rem;
                font-size: 1.1rem;
                display: flex;
                align-items: center;
                gap: 8px;
                font-family: 'Oswald', sans-serif;
                text-transform: uppercase;
            }

            .chart-card h5 i {
                color: var(--primary);
            }

            canvas {
                max-height: 220px !important;
                width: 100% !important;
            }

            footer {
                text-align: center;
                padding: 2rem 1rem;
                color: var(--text-light);
                font-size: 0.9rem;
                margin-top: 3rem;
                border-top: 1px solid var(--border);
            }

            .logo-icon {
                font-size: 2.8rem;
                color: var(--primary);
                margin-bottom: 0.5rem;
            }

            @media (max-width: 768px) {
                .dashboard-header h1 {
                    font-size: 2.2rem;
                }
                canvas {
                    max-height: 180px !important;
                }
                .stat-card h2 {
                    font-size: 2rem;
                }
            }

            @media (max-width: 480px) {
                body {
                    padding: 16px 12px;
                }
                .stat-grid, .chart-grid {
                    gap: 1rem;
                }
                .stat-card, .chart-card {
                    padding: 1.5rem;
                }
            }
        </style>
    </head>

    <body>

        <jsp:include page="/Views/components/staff_header.jsp" />

        <div class="container-fluid">

            <!-- Header -->
            <div class="dashboard-header">
                <div class="logo-icon">
                    <i class="fas fa-utensils"></i>
                </div>
                <h1>STAFF DASHBOARD</h1>
                <p>Nhà hàng cao cấp • Cập nhật thời gian thực</p>
            </div>

            <!-- Thống kê nhanh -->
            <div class="stat-grid">
                <div class="stat-card">
                    <i class="fas fa-chair stat-icon"></i>
                    <h5>Tổng số bàn</h5>
                    <h2>${totalTables}</h2>
                </div>
                <div class="stat-card">
                    <i class="fas fa-calendar-check stat-icon"></i>
                    <h5>Tổng đặt bàn</h5>
                    <h2>${totalReservations}</h2>
                </div>
                <div class="stat-card">
                    <i class="fas fa-receipt stat-icon"></i>
                    <h5>Tổng đơn hàng</h5>
                    <h2>${totalOrders}</h2>
                </div>
                <div class="stat-card">
                    <i class="fas fa-clock stat-icon"></i>
                    <h5>Đặt bàn đang hoạt động</h5>
                    <h2>${activeBookings}</h2>
                </div>
            </div>

            <!-- Biểu đồ -->
            <div class="chart-grid">
                <div class="chart-card">
                    <h5><i class="fas fa-chart-pie"></i> Trạng thái Đặt bàn</h5>
                    <canvas id="reservationChart"></canvas>
                </div>

                <div class="chart-card">
                    <h5><i class="fas fa-donut-large"></i> Trạng thái Đơn hàng</h5>
                    <canvas id="orderChart"></canvas>
                </div>

                <div class="chart-card">
                    <h5><i class="fas fa-chart-bar"></i> Trạng thái Thanh toán</h5>
                    <canvas id="paymentChart"></canvas>
                </div>

                <div class="chart-card">
                    <h5><i class="fas fa-map-marker-alt"></i> Bàn theo khu vực</h5>
                    <canvas id="tableAreaChart"></canvas>
                </div>
            </div>

        </div>

        <footer>
            © 2025 Nhà hàng Cao Cấp | Staff Portal • Powered by JSP + Chart.js
        </footer>

        <!-- Chart.js Script -->
        <script>
            const reservationLabels = [<c:forEach var="r" items="${reservationStatus}">"${r.key}",</c:forEach>];
            const reservationData = [<c:forEach var="r" items="${reservationStatus}">${r.value},</c:forEach>];

            const orderLabels = [<c:forEach var="r" items="${orderStatus}">"${r.key}",</c:forEach>];
            const orderData = [<c:forEach var="r" items="${orderStatus}">${r.value},</c:forEach>];

            const paymentLabels = [<c:forEach var="r" items="${paymentStatus}">"${r.key}",</c:forEach>];
            const paymentData = [<c:forEach var="r" items="${paymentStatus}">${r.value},</c:forEach>];

            const areaLabels = [<c:forEach var="a" items="${tableCountByArea}">"${a.key}",</c:forEach>];
            const areaData = [<c:forEach var="a" items="${tableCountByArea}">${a.value},</c:forEach>];

            const chartConfig = {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {padding: 20, font: {size: 12}}
                    }
                },
                animation: {
                    duration: 1200,
                    easing: 'easeOutQuart'
                }
            };

            const colors = ['#E0B841', '#d4a017', '#f1c40f', '#f9d423', '#f5c842', '#e67e22'];

            new Chart(document.getElementById('reservationChart'), {
                type: 'pie',
                data: {labels: reservationLabels, datasets: [{data: reservationData, backgroundColor: colors, borderWidth: 2, borderColor: '#fff'}]},
                options: chartConfig
            });

            new Chart(document.getElementById('orderChart'), {
                type: 'doughnut',
                data: {labels: orderLabels, datasets: [{data: orderData, backgroundColor: colors, borderWidth: 3, borderColor: '#fff', cutout: '68%'}]},
                options: chartConfig
            });

            new Chart(document.getElementById('paymentChart'), {
                type: 'bar',
                data: {labels: paymentLabels, datasets: [{label: 'Số lượng', data: paymentData, backgroundColor: '#E0B841', borderRadius: 8}]},
                options: {...chartConfig, scales: {y: {beginAtZero: true, grid: {display: false}}}}
            });

            new Chart(document.getElementById('tableAreaChart'), {
                type: 'bar',
                data: {labels: areaLabels, datasets: [{label: 'Số bàn', data: areaData, backgroundColor: '#d4a017', borderRadius: 8}]},
                options: {...chartConfig, scales: {y: {beginAtZero: true, grid: {display: false}}}}
            });
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>