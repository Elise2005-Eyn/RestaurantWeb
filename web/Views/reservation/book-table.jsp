<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt bàn trước</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@600&family=Lato:wght@400;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --color-black: #121212;
            --color-gray-dark: #1f1f1f;
            --color-gray-medium: #2e2e2e;
            --color-gray-light: #bbbbbb;
            --color-gold: #E0B841;
            --color-white: #f5f5f5;
        }

        body {
            background-color: var(--color-black);
            color: var(--color-white);
            font-family: 'Lato', sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 50px 0;
        }

        h1 {
            font-family: 'Oswald', sans-serif;
            text-transform: uppercase;
            color: var(--color-gold);
            margin-bottom: 30px;
        }

        form {
            background: var(--color-gray-dark);
            padding: 40px;
            border-radius: 10px;
            width: 90%;
            max-width: 800px;
            box-shadow: 0 0 20px rgba(0,0,0,0.6);
        }

        label {
            font-weight: 700;
            color: var(--color-gold);
        }

        .form-control, .form-select {
            background-color: var(--color-gray-medium);
            border: 1px solid var(--color-gray-light);
            color: var(--color-white);
        }

        .form-control:focus {
            border-color: var(--color-gold);
            box-shadow: 0 0 0 0.25rem rgba(224,184,65,0.25);
        }

        .btn-gold {
            background-color: var(--color-gold);
            color: var(--color-black);
            font-weight: 700;
            font-family: 'Oswald', sans-serif;
            text-transform: uppercase;
            border: none;
            width: 100%;
            padding: 12px;
            transition: all 0.2s ease;
            border-radius: 5px;
        }

        .btn-gold:hover {
            background-color: var(--color-gray-dark);
            color: var(--color-gold);
        }

        .alert {
            border-radius: 8px;
            font-weight: 600;
        }

        #menu-section {
            display: none;
            background: var(--color-gray-medium);
            border-radius: 8px;
            padding: 15px;
            margin-top: 20px;
        }

        #menu-section h5 {
            font-family: 'Oswald', sans-serif;
            color: var(--color-gold);
            margin-bottom: 15px;
        }

        .menu-item {
            background-color: var(--color-gray-dark);
            border: 1px solid var(--color-gray-light);
            border-radius: 6px;
            padding: 10px;
            margin-bottom: 10px;
        }

        .menu-item label {
            color: var(--color-white);
            font-weight: 500;
        }

        footer {
            margin-top: 40px;
            text-align: center;
            color: var(--color-gray-light);
            font-size: 0.9em;
        }
    </style>
</head>
<body>

<h1>Đặt bàn trước</h1>

<c:if test="${not empty success}">
    <div class="alert alert-success text-center">${success}</div>
</c:if>
<c:if test="${not empty error}">
    <div class="alert alert-danger text-center">${error}</div>
</c:if>

<form action="book-table" method="post">
    <div class="row g-3">
        <div class="col-md-6">
            <label for="date">Ngày đặt</label>
            <input type="date" id="date" name="date" class="form-control" required>
        </div>
        <div class="col-md-6">
            <label for="time">Giờ đặt</label>
            <input type="time" id="time" name="time" class="form-control" required>
        </div>

        <div class="col-md-6">
            <label for="duration">Thời lượng (phút)</label>
            <input type="number" id="duration" name="duration" class="form-control" value="90" required>
        </div>
        <div class="col-md-6">
            <label for="guestCount">Số khách</label>
            <input type="number" id="guestCount" name="guestCount" class="form-control" required>
        </div>

        <div class="col-md-12 mt-3">
            <label>Hình thức gọi món</label><br>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="orderType" id="orderBefore" value="Đặt món trước" required>
                <label class="form-check-label" for="orderBefore">Đặt món trước</label>
            </div>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="orderType" id="orderAtTable" value="Gọi món tại nơi">
                <label class="form-check-label" for="orderAtTable">Gọi món tại nơi</label>
            </div>
        </div>

        <!-- Danh sách món ăn -->
        <div id="menu-section" class="col-md-12">
            <h5>Chọn món ăn bạn muốn đặt trước:</h5>
            <c:forEach var="m" items="${menuList}">
                <div class="menu-item">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="menuItem" value="${m.id}" id="menu_${m.id}">
                        <label class="form-check-label" for="menu_${m.id}">
                            🍽️ ${m.name} — <span style="color: var(--color-gold);">${m.price} VNĐ</span>
                        </label>
                    </div>
                    <div class="mt-2">
                        <label for="qty_${m.id}" class="form-label small">Số lượng:</label>
                        <input type="number" name="qty_${m.id}" id="qty_${m.id}" class="form-control form-control-sm" min="1" value="1" style="max-width:100px;">
                    </div>
                </div>
            </c:forEach>
        </div>

        <div class="col-md-12 mt-3">
            <label for="note">Ghi chú (tùy chọn)</label>
            <textarea id="note" name="note" class="form-control" rows="3"></textarea>
        </div>

        <div class="col-12 mt-4">
            <button type="submit" class="btn-gold">Xác nhận đặt bàn</button>
        </div>
    </div>
</form>

<footer>
    © 2025 - Nhà hàng Demo | Hotline: 0123 456 789 | Email: info@restaurant.com
</footer>

<script>
    // Ẩn/hiện phần chọn món ăn khi chọn "Đặt món trước"
    document.addEventListener("DOMContentLoaded", () => {
        const orderBefore = document.getElementById("orderBefore");
        const orderAtTable = document.getElementById("orderAtTable");
        const menuSection = document.getElementById("menu-section");

        function toggleMenuSection() {
            menuSection.style.display = orderBefore.checked ? "block" : "none";
        }

        orderBefore.addEventListener("change", toggleMenuSection);
        orderAtTable.addEventListener("change", toggleMenuSection);
    });
</script>

</body>
</html>
