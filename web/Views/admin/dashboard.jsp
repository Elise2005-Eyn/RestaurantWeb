<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <style>
            :root {
                --color-black: #121212;
                --color-gray-dark: #1e1e1e;
                --color-gray-medium: #2a2a2a;
                --color-gray-light: #aaaaaa;
                --color-white: #f0f0f0;
                --color-gold: #E0B841;
            }

            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                background-color: var(--color-black);
                color: var(--color-white);
                margin: 0;
                padding: 40px 60px;
            }

            h1 {
                color: var(--color-gold);
                font-size: 28px;
                font-weight: 700;
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 25px;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            /* --- Thống kê nhỏ --- */
            .stats-container {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
                gap: 20px;
                margin-bottom: 40px;
            }

            .stat-box {
                background: var(--color-gray-dark);
                border-radius: 12px;
                border: 1px solid var(--color-gray-medium);
                box-shadow: 0 3px 10px rgba(0, 0, 0, 0.4);
                padding: 25px;
                text-align: center;
                transition: all 0.3s ease;
            }

            .stat-box:hover {
                transform: translateY(-6px);
                box-shadow: 0 6px 15px rgba(224, 184, 65, 0.2);
                border-color: var(--color-gold);
            }

            .stat-icon {
                font-size: 36px;
                color: var(--color-gold);
                margin-bottom: 10px;
            }

            .stat-box h3 {
                font-size: 1.1em;
                color: var(--color-white);
                margin-bottom: 8px;
            }

            .stat-box p {
                font-size: 1.3em;
                color: var(--color-gold);
                font-weight: 700;
            }

            /* --- Khu vực biểu đồ --- */
            .chart-section {
                background: var(--color-gray-dark);
                border-radius: 12px;
                border: 1px solid var(--color-gray-medium);
                box-shadow: 0 3px 10px rgba(0, 0, 0, 0.5);
                padding: 25px 30px;
                margin: 0 auto 50px;
                width: 90%;
                max-width: 900px;
            }

            .chart-section h2 {
                text-align: center;
                color: var(--color-gold);
                margin-bottom: 20px;
                text-transform: uppercase;
            }

            canvas {
                width: 100%;
            }

            /* --- Biểu đồ tròn --- */
            .pie-container {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
                gap: 25px;
                margin-top: 40px;
            }

            .pie-box {
                background: var(--color-gray-dark);
                border-radius: 12px;
                border: 1px solid var(--color-gray-medium);
                box-shadow: 0 3px 8px rgba(0, 0, 0, 0.4);
                padding: 25px;
                text-align: center;
                transition: transform 0.2s, border-color 0.3s;
            }

            .pie-box:hover {
                transform: translateY(-4px);
                border-color: var(--color-gold);
                box-shadow: 0 6px 15px rgba(224, 184, 65, 0.15);
            }

            .pie-box h3 {
                color: var(--color-gold);
                font-size: 17px;
                margin-bottom: 15px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .pie-box canvas {
                width: 220px !important;
                height: 220px !important;
                margin: 0 auto;
            }

            .no-data {
                font-size: 14px;
                color: var(--color-gray-light);
                text-align: center;
                padding: 30px 0;
            }
        </style>

    </head>

    <body>

        <h1><i class="fa-solid fa-chart-pie"></i> Tổng quan hệ thống</h1>

        <div class="stats-container">
            <div class="stat-box">
                <div class="stat-icon"><i class="fa-solid fa-utensils"></i></div>
                <div>Tổng món ăn</div>
                <div class="stat-value"><c:out value="${totalMenuItems}" default="0"/></div>
            </div>
            <div class="stat-box">
                <div class="stat-icon"><i class="fa-solid fa-file-invoice"></i></div>
                <div>Tổng đơn hàng</div>
                <div class="stat-value"><c:out value="${totalOrders}" default="0"/></div>
            </div>
            <div class="stat-box">
                <div class="stat-icon"><i class="fa-solid fa-users"></i></div>
                <div>Khách hàng</div>
                <div class="stat-value"><c:out value="${totalCustomers}" default="0"/></div>
            </div>
            <div class="stat-box">
                <div class="stat-icon"><i class="fa-solid fa-calendar-check"></i></div>
                <div>Đặt bàn</div>
                <div class="stat-value"><c:out value="${totalReservations}" default="0"/></div>
            </div>
        </div>

        <!-- Biểu đồ doanh thu -->
        <div class="chart-section">
            <h2><i class="fa-solid fa-chart-column"></i> Doanh thu theo tháng</h2>
            <canvas id="revenueChart"></canvas>
        </div>

        <!-- Biểu đồ tròn -->
        <div class="pie-container">
            <div class="pie-box">
                <h3>🍜 Trạng thái món ăn</h3>
                <canvas id="menuPie"></canvas>
            </div>
            <div class="pie-box">
                <h3>🧾 Trạng thái đơn hàng</h3>
                <canvas id="orderPie"></canvas>
            </div>
            <div class="pie-box">
                <h3>👥 Trạng thái khách hàng</h3>
                <canvas id="customerPie"></canvas>
            </div>
            <div class="pie-box">
                <h3>📅 Trạng thái đặt bàn</h3>
                <canvas id="reservationPie"></canvas>
            </div>
        </div>

        <script>
            // ========== BIỂU ĐỒ DOANH THU ==========
            const revenueLabels = ${revenueLabelsJSON};
            const revenueValues = ${revenueValuesJSON};

            const ctxBar = document.getElementById('revenueChart');
            if (ctxBar && revenueValues.length > 0) {
                new Chart(ctxBar, {
                    type: 'bar',
                    data: {
                        labels: revenueLabels,
                        datasets: [{
                                label: 'Doanh thu (VNĐ)',
                                data: revenueValues,
                                backgroundColor: [
                                    '#7E57C2', '#AB47BC', '#42A5F5', '#26A69A',
                                    '#FFA726', '#EC407A', '#66BB6A', '#5C6BC0',
                                    '#FF7043', '#26C6DA', '#8D6E63', '#D4E157'
                                ],
                                borderRadius: 6
                            }]
                    },
                    options: {
                        responsive: true,
                        scales: {y: {beginAtZero: true}},
                        plugins: {legend: {display: false}}
                    }
                });
            } else {
                ctxBar.outerHTML = "<div class='no-data'>Không có dữ liệu doanh thu</div>";
            }

            // ========== HÀM TẠO BIỂU ĐỒ TRÒN ==========
            function createPie(id, labels, values, colors) {
                const ctx = document.getElementById(id);
                if (!ctx)
                    return;
                if (!values || values.length === 0) {
                    ctx.outerHTML = "<div class='no-data'>Không có dữ liệu</div>";
                    return;
                }

                new Chart(ctx, {
                    type: 'doughnut',
                    data: {
                        labels: labels,
                        datasets: [{
                                data: values,
                                backgroundColor: colors,
                                borderWidth: 0
                            }]
                    },
                    options: {
                        plugins: {
                            legend: {
                                position: 'bottom',
                                labels: {boxWidth: 15, padding: 15}
                            }
                        },
                        cutout: '70%'
                    }
                });
            }

            // 🎨 Màu sắc đa dạng hơn, riêng biệt cho từng loại biểu đồ
            createPie("menuPie", ${menuStatusLabels}, ${menuStatusValues},
                    ['#6A11CB', '#B983FF', '#FF80AB', '#00E5FF', '#FFD54F']);

            createPie("orderPie", ${orderStatusLabels}, ${orderStatusValues},
                    ['#FFA726', '#66BB6A', '#EF5350', '#42A5F5', '#D4E157']);

            createPie("customerPie", ${customerStatusLabels}, ${customerStatusValues},
                    ['#8E24AA', '#5C6BC0', '#F06292', '#26A69A', '#FFCA28']);

            createPie("reservationPie", ${reservationStatusLabels}, ${reservationStatusValues},
                    ['#29B6F6', '#66BB6A', '#FF7043', '#AB47BC', '#FFEE58']);
        </script>
    </body>
</html>
