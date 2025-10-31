<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thêm đơn hàng mới</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@500;600;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">

        <style>
            :root {
                --primary: #E0B841;
                --primary-light: #f9d423;
                --primary-gradient: linear-gradient(135deg, #E0B841 0%, #d4a017 100%);
                --success: #2e7d32;
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

            body {
                background: var(--bg);
                font-family: 'Lato', sans-serif;
                color: var(--text);
                min-height: 100vh;
                padding: 2rem 1rem;
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


            .form-card {
                max-width: 960px;
                margin: 0 auto;
                background: var(--card-bg);
                border-radius: var(--radius);
                overflow: hidden;
                box-shadow: var(--shadow-sm);
                border: 1px solid var(--border);
                transition: var(--transition);
            }

            .form-card:hover {
                box-shadow: var(--shadow-md);
                transform: translateY(-4px);
            }

            .card-header {
                background: var(--primary-gradient);
                color: white;
                padding: 1.25rem 1.5rem;
                font-family: 'Poppins', sans-serif;
                font-weight: 700;
                font-size: 1.4rem;
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            .card-header i {
                font-size: 1.5rem;
            }

            .card-body {
                padding: 2rem;
            }

            .form-label {
                font-weight: 600;
                color: var(--text);
                margin-bottom: 0.5rem;
                font-size: 0.95rem;
            }

            .form-select, .form-control {
                border-radius: 12px;
                border: 1.5px solid var(--border);
                padding: 0.65rem 1rem;
                font-size: 0.95rem;
                transition: var(--transition);
            }

            .form-select:focus, .form-control:focus {
                border-color: var(--primary);
                box-shadow: 0 0 0 4px rgba(94, 59, 183, 0.15);
            }

            /* Bảng món ăn */
            .menu-table {
                border-collapse: separate;
                border-spacing: 0;
                margin-bottom: 1.5rem;
                font-size: 0.92rem;
            }

            .menu-table thead {
                background: #f1f0ff;
                color: var(--primary);
                font-weight: 600;
            }

            .menu-table th {
                padding: 1rem 0.75rem;
                text-align: center;
                border-bottom: 2px solid var(--primary-light);
            }

            .menu-table td {
                padding: 1rem 0.75rem;
                vertical-align: middle;
                border-bottom: 1px solid var(--border);
                transition: var(--transition);
            }

            .menu-table tr:hover {
                background-color: #f8f5ff;
                box-shadow: 0 2px 8px rgba(94, 59, 183, 0.05);
            }

            .form-check-input {
                width: 1.2em;
                height: 1.2em;
                margin-top: 0.2em;
                border-radius: 6px;
                border: 2px solid var(--border);
                cursor: pointer;
            }

            .form-check-input:checked {
                background-color: var(--primary);
                border-color: var(--primary);
            }

            .qty-input {
                width: 70px;
                text-align: center;
                border-radius: 10px;
                padding: 0.35rem 0.5rem;
                font-weight: 600;
            }

            .subtotal {
                font-weight: 700;
                color: var(--success);
                font-family: 'Poppins', sans-serif;
            }

            .total-amount {
                font-size: 1.5rem;
                font-weight: 700;
                color: var(--success);
                font-family: 'Poppins', sans-serif;
                text-align: right;
                padding: 1rem;
                background: #f1f8e9;
                border-radius: 12px;
                border: 2px dashed #81c784;
            }

            .btn-group {
                display: flex;
                justify-content: flex-end;
                gap: 1rem;
                margin-top: 2rem;
            }

            .btn-back {
                background: #f8f9fa;
                color: var(--text);
                border: 1.5px solid var(--border);
                padding: 0.75rem 1.5rem;
                border-radius: 12px;
                font-weight: 600;
                transition: var(--transition);
            }

            .btn-back:hover {
                background: #e9ecef;
                border-color: var(--primary);
                color: var(--primary);
            }

            .btn-submit {
                background: var(--primary-gradient);
                color: white;
                border: none;
                padding: 0.75rem 1.8rem;
                border-radius: 12px;
                font-weight: 600;
                transition: var(--transition);
                box-shadow: 0 4px 15px rgba(94, 59, 183, 0.2);
            }

            .btn-submit:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(94, 59, 183, 0.3);
            }

            @media (max-width: 768px) {
                .card-body {
                    padding: 1.5rem;
                }
                .menu-table {
                    font-size: 0.85rem;
                }
                .qty-input {
                    width: 60px;
                }
                .btn-group {
                    flex-direction: column;
                }
                .btn-back, .btn-submit {
                    width: 100%;
                }
            }
        </style>
    </head>
    <body>

        <!-- Header -->
        <jsp:include page="/Views/components/staff_header.jsp" />

        <div class="container mt-4">
            <div class="form-card">
                <div class="card-header">
                    <i class="fas fa-plus-circle"></i> Thêm Đơn Hàng Mới
                </div>

                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/staff/orders" method="post" id="orderForm">

                        <!-- RESERVATION DROPDOWN -->
                        <div class="mb-4">
                            <label class="form-label">Khách hàng (đã đặt bàn)</label>
                            <select name="reservationId" id="reservationId" class="form-select" required>
                                <option value="">-- Chọn khách hàng --</option>
                                <c:forEach var="r" items="${reservations}">
                                    <option value="${r.reservation_id}" data-customer="${r.customer_id}">
                                        ${r.customer_name} - ${r.note} (Mã đặt: ${r.reservation_id})
                                    </option>
                                </c:forEach>
                            </select>
                            <input type="hidden" name="customerId" id="customerId">
                        </div>

                        <!-- TABLE DROPDOWN -->
                        <div class="mb-4">
                            <label class="form-label">Chọn bàn</label>
                            <select name="tableId" class="form-select" required>
                                <option value="">-- Chọn bàn --</option>
                                <c:forEach var="t" items="${tables}">
                                    <option value="${t.id}">${t.label}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- ORDER TYPE -->
                        <div class="mb-4">
                            <label class="form-label">Loại đơn hàng</label>
                            <select name="orderType" class="form-select" required>
                                <option value="DINE_IN">Ăn tại chỗ</option>
                                <option value="TAKE_AWAY">Mang đi</option>
                            </select>
                        </div>

                        <!-- ORDER STATUS -->
                        <div class="mb-4">
                            <label class="form-label">Trạng thái</label>
                            <select name="status" class="form-select" required>
                                <option value="PENDING">Chờ xử lý</option>
                                <option value="IN_PROGRESS">Đang làm</option>
                                <option value="COMPLETED">Hoàn tất</option>
                                <option value="CANCELLED">Đã hủy</option>
                            </select>
                        </div>

                        <!-- MENU ITEMS -->
                        <div class="mb-4">
                            <label class="form-label fw-bold">Chọn món ăn</label>
                            <div class="table-responsive">
                                <table class="table menu-table">
                                    <thead>
                                        <tr>
                                            <th>Tên món</th>
                                            <th>Giá (₫)</th>
                                            <th>Số lượng</th>
                                            <th>Tổng</th>
                                        </tr>
                                    </thead>
                                    <tbody id="menuTableBody">
                                        <c:forEach var="m" items="${menuItems}">
                                            <tr>
                                                <td>
                                                    <div class="form-check">
                                                        <input type="checkbox" class="form-check-input menu-check"
                                                               name="menuItemId" value="${m.id}"
                                                               data-price="${m.price}" id="menu-${m.id}">
                                                        <label class="form-check-label" for="menu-${m.id}">
                                                            ${m.name}
                                                        </label>
                                                    </div>
                                                </td>
                                                <td class="text-end fw-medium">${m.price}</td>
                                                <td>
                                                    <input type="number" name="quantity" class="form-control qty-input"
                                                           min="1" value="1" disabled>
                                                </td>
                                                <td class="subtotal text-end">0</td>
                                        <input type="hidden" name="price" value="${m.price}">
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- TOTAL AMOUNT -->
                        <div class="mb-4">
                            <label class="form-label fw-bold">Tổng tiền (₫)</label>
                            <div class="total-amount" id="totalAmount">0</div>
                            <input type="hidden" name="amount" id="totalAmountHidden">
                        </div>

                        <!-- NOTE -->
                        <div class="mb-4">
                            <label class="form-label">Ghi chú</label>
                            <textarea name="note" rows="3" class="form-control" placeholder="Nhập ghi chú (nếu có)..."></textarea>
                        </div>

                        <!-- BUTTONS -->
                        <div class="btn-group">
                            <a href="${pageContext.request.contextPath}/staff/orders" class="btn btn-back">
                                <i class="fas fa-arrow-left"></i> Quay lại
                            </a>
                            <button type="submit" class="btn btn-submit">
                                <i class="fas fa-save"></i> Lưu đơn hàng
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- === GIỮ NGUYÊN TOÀN BỘ LOGIC JS === -->
        <script>
            // Gán customerId theo reservation chọn
            document.getElementById("reservationId").addEventListener("change", function () {
                const selected = this.options[this.selectedIndex];
                document.getElementById("customerId").value = selected.getAttribute("data-customer") || "";
            });

            // Bật/tắt số lượng khi tick món
            const checkboxes = document.querySelectorAll(".menu-check");
            checkboxes.forEach(cb => {
                cb.addEventListener("change", function () {
                    const row = this.closest("tr");
                    const qtyInput = row.querySelector(".qty-input");
                    qtyInput.disabled = !this.checked;
                    if (!this.checked)
                        qtyInput.value = 1;
                    updateTotal();
                });
            });

            // Tính lại khi thay đổi số lượng
            const qtyInputs = document.querySelectorAll(".qty-input");
            qtyInputs.forEach(input => {
                input.addEventListener("input", updateTotal);
            });

            // Hàm tính tổng tiền
            function updateTotal() {
                let total = 0;
                document.querySelectorAll("#menuTableBody tr").forEach(row => {
                    const checkbox = row.querySelector(".menu-check");
                    const qty = parseInt(row.querySelector(".qty-input").value || 0);
                    const price = parseFloat(checkbox.getAttribute("data-price"));
                    const subtotalCell = row.querySelector(".subtotal");

                    if (checkbox.checked && qty > 0) {
                        const subtotal = qty * price;
                        subtotalCell.textContent = subtotal.toLocaleString('vi-VN');
                        total += subtotal;
                    } else {
                        subtotalCell.textContent = "0";
                    }
                });
                const display = total.toLocaleString('vi-VN');
                document.getElementById("totalAmount").textContent = display;
                document.getElementById("totalAmountHidden").value = total;
            }

            // Gọi lần đầu khi load
            updateTotal();
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>