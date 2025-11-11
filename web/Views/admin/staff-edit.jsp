<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="/Views/components/admin_header.jsp" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chỉnh sửa nhân viên</title>
        <style>
            body {
                background:#f5f6fa;
                font-family: 'Segoe UI';
                padding:40px;
            }
            .admin-header {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1000;
            }
            .container {
                background:white;
                padding:30px;
                border-radius:10px;
                max-width:600px;
                margin:auto;
                box-shadow:0 4px 10px rgba(0,0,0,0.1);
            }
            h2 {
                text-align:center;
                color:#4b0082;
                margin-bottom:20px;
            }
            label {
                display:block;
                margin-top:12px;
                font-weight:600;
            }
            input[type=text], input[type=email], input[type=tel] {
                width:100%;
                padding:10px;
                border:1px solid #ccc;
                border-radius:5px;
            }
            .checkbox {
                margin-top:10px;
            }
            .btn {
                margin-top:20px;
                background:#6a11cb;
                color:white;
                border:none;
                padding:10px 20px;
                border-radius:6px;
                cursor:pointer;
            }
            .btn:hover {
                background:#5012a0;
            }
            .error {
                color:red;
                text-align:center;
                margin-top:10px;
            }
        </style>
    </head>
    <body>

        <div class="container">
            <h2>Chỉnh sửa thông tin nhân viên</h2>
            <form method="post" action="${pageContext.request.contextPath}/admin/staff">
                <input type="hidden" name="action" value="saveEdit">
                <input type="hidden" name="id" value="${staff.id}">

                <label>Tên đăng nhập:</label>
                <input type="text" name="username" value="${staff.username}" required>

                <label>Email:</label>
                <input type="email" name="email" value="${staff.email}" required>

                <label>Số điện thoại:</label>
                <input type="tel" name="phone" value="${staff.telephone}" pattern="0[0-9]{9}" maxlength="10" required>

                <div class="checkbox">
                    <input type="checkbox" name="active" ${staff.actived ? "checked" : ""}> Kích hoạt tài khoản
                </div>

                <button class="btn" type="submit">Cập nhật</button>
                <a href="${pageContext.request.contextPath}/admin/staff" style="margin-left:10px;">Hủy</a>

                <c:if test="${not empty error}">
                    <div class="error">${error}</div>
                </c:if>
            </form>
        </div>

    </body>
</html>
