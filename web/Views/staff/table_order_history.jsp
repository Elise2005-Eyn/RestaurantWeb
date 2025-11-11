<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý món cho bàn</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background: #f6f6f6;
        }
        h2 {
            color: #333;
        }
        .flash {
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 5px;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
        }
        form {
            margin-top: 15px;
            background: #fff;
            padding: 15px;
            border-radius: 6px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            margin-top: 15px;
        }
        table th, table td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }
        table th {
            background-color: #f2f2f2;
        }
        button, input[type=submit] {
            background: #28a745;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover, input[type=submit]:hover {
            background: #218838;
        }
        a.button {
            background: #007bff;
            color: white;
            text-decoration: none;
            padding: 6px 10px;
            border-radius: 4px;
        }
        a.button:hover {
            background: #0056b3;
        }
    </style>
</head>
<body>

    <h2>🍽️ Quản lý món cho bàn số: <strong>${tableId}</strong></h2>
    <p><strong>Mã Order hiện tại:</strong> ${orderId}</p>

    <!-- 🔔 Thông báo flash -->
    <c:if test="${not empty sessionScope.flash}">
        <div class="flash ${sessionScope.flash.contains('✅') ? 'success' : 'error'}">
            ${sessionScope.flash}
        </div>
        <c:remove var="flash" scope="session" />
    </c:if>

    <!-- ➕ Form thêm món mới -->
    <form action="table-order?action=addItem" method="post">
        <input type="hidden" name="tableId" value="${tableId}" />

        <label for="menuItemId"><strong>Chọn món ăn:</strong></label>
        <select name="menuItemId" id="menuItemId" required>
            <option value="">-- Chọn món --</option>
            <c:forEach var="item" items="${menuList}">
                <option value="${item[0]}">
                    ${item[1]} (${item[2]}đ)
                </option>
            </c:forEach>
        </select>

        <label for="quantity"><strong>Số lượng:</strong></label>
        <input type="number" name="quantity" id="quantity" value="1" min="1" required />

        <input type="submit" value="Thêm món" />
    </form>

    <!-- 📋 Danh sách món đã đặt -->
    <h3>📋 Danh sách món đã đặt:</h3>
    <table>
        <thead>
            <tr>
                <th>Tên món</th>
                <th>Số lượng</th>
                <th>Giá (₫)</th>
                <th>Thành tiền (₫)</th>
                <th>Thời gian</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty orderHistory}">
                    <tr>
                        <td colspan="5">Chưa có món nào trong bàn này.</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="it" items="${orderHistory}">
                        <tr>
                            <td>${it.note}</td>
                            <td>${it.quantity}</td>
                            <td>${it.price}</td>
                            <td>${it.price * it.quantity}</td>
                            <td>${it.createdAt}</td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <!-- ⬅️ Quay lại -->
    <p style="margin-top:20px;">
        <a href="table-order?action=list" class="button">⬅️ Quay lại danh sách bàn</a>
    </p>

</body>
</html>
