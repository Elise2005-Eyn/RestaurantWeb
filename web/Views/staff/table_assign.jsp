<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Gán bàn cho khách hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body { background-color: #f7f9fc; }
        .form-card {
            max-width: 700px;
            margin: 40px auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .form-card h4 {
            background: #0d6efd;
            color: white;
            padding: 15px;
            border-radius: 12px 12px 0 0;
        }
    </style>
</head>

<body>

<!-- Header -->
<jsp:include page="/Views/components/staff_header.jsp"/>

<div class="container">
    <div class="form-card">
        <h4><i class="fas fa-link"></i> Gán bàn cho khách hàng</h4>

        <form method="post" action="${pageContext.request.contextPath}/staff/tables/assign" class="p-4">
            <input type="hidden" name="table_id" value="${tableId}">

            <!-- Mã bàn -->
            <div class="mb-3">
                <label class="form-label fw-semibold">Mã bàn</label>
                <input type="text" class="form-control" value="${tableId}" readonly>
            </div>

            <!-- Chọn khách hàng -->
            <div class="mb-3">
                <label for="customer_id" class="form-label fw-semibold">Chọn khách hàng</label>
                <select name="customer_id" id="customer_id" class="form-select" required>
                    <option value="">-- Chọn khách hàng --</option>
                    <c:forEach var="c" items="${customers}">
                        <!-- ✅ Truyền UUID chính xác -->
                        <option value="${c.id}">${c.name} (${c.email})</option>
                    </c:forEach>
                </select>
            </div>

            <!-- Thời gian đặt & Thời lượng -->
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="reserved_at" class="form-label fw-semibold">Thời gian đặt</label>
                    <!-- ✅ Cho phép chọn bằng lịch + giờ -->
                    <input type="datetime-local" name="reserved_at" id="reserved_at"
                           class="form-control" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label for="reserved_duration" class="form-label fw-semibold">Thời lượng (phút)</label>
                    <input type="number" name="reserved_duration" id="reserved_duration"
                           class="form-control" value="90" min="30" required>
                </div>
            </div>

            <!-- Số khách -->
            <div class="mb-3">
                <label for="guest_count" class="form-label fw-semibold">Số khách</label>
                <input type="number" name="guest_count" id="guest_count"
                       class="form-control" value="2" min="1" required>
            </div>

            <!-- Ghi chú -->
            <div class="mb-3">
                <label for="note" class="form-label fw-semibold">Ghi chú</label>
                <textarea name="note" id="note" class="form-control" rows="3"
                          placeholder="Ví dụ: Khách quen, cần góc yên tĩnh..."></textarea>
            </div>

            <!-- Nút điều hướng -->
            <div class="d-flex justify-content-between mt-4">
                <a href="${pageContext.request.contextPath}/staff/tables" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Quay lại
                </a>
                <button type="submit" class="btn btn-success px-4">
                    <i class="fas fa-check-circle"></i> Xác nhận gán bàn
                </button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
