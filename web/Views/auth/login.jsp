<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập | Nhà hàng Ngon</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
          
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Oswald:wght@600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --color-black: #121212;
            --color-gray-dark: #222222;
            --color-gray-medium: #444444;
            --color-gray-light: #AAAAAA;
            --color-white: #F0F0F0;
            --color-gold: #E0B841;
        }

        body {
            background-color: var(--color-black);
            color: var(--color-white);
            font-family: 'Lato', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            overflow: hidden;
        }

        .login-wrapper {
            display: flex;
            width: 90%;
            max-width: 1200px;
            height: 80vh;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
        }

.login-image-side {
    flex: 2;
    background-image: url('<%= request.getContextPath() %>/imgs/logo.png');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    position: relative;
}


        .login-image-side::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.3);
        }

        .login-form-side {
            flex: 1;
            background-color: var(--color-gray-dark);
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px;
        }

        .login-title {
            font-family: 'Oswald', sans-serif;
            text-transform: uppercase;
            color: var(--color-gold);
            font-size: 2.5em;
            font-weight: 700;
            text-align: center;
            margin-bottom: 30px;
        }

        .form-label {
            color: var(--color-white);
            font-weight: 700;
        }

        .form-control {
            background-color: var(--color-gray-medium);
            color: var(--color-white);
            border: 1px solid var(--color-gray-light);
            border-radius: 5px;
            padding: 10px 15px;
        }

        .form-control:focus {
            background-color: var(--color-gray-medium);
            border-color: var(--color-gold);
            box-shadow: 0 0 0 0.25rem rgba(224, 184, 65, 0.25);
        }

        .form-control::placeholder {
            color: var(--color-gray-light);
        }

        .btn-gold {
            background-color: var(--color-gold);
            color: var(--color-black);
            border: 1px solid var(--color-gold);
            font-weight: 700;
            font-family: 'Oswald', sans-serif;
            text-transform: uppercase;
            padding: 10px 20px;
            transition: all 0.2s ease;
        }

        .btn-gold:hover {
            background-color: var(--color-gray-dark);
            color: var(--color-gold);
            border-color: var(--color-gold);
        }

        .register-link {
            color: var(--color-gray-light);
            font-size: 1.1em;
        }

        .register-link a {
            color: var(--color-gold);
            text-decoration: none;
            font-weight: 700;
        }

        .register-link a:hover {
            text-decoration: underline;
        }

        .login-error-message {
            background-color: rgba(217, 83, 79, 0.1);
            border: 1px solid #d9534f;
            color: #f0c9c8;
            border-radius: 5px;
            padding: 10px;
            text-align: center;
            margin-bottom: 15px;
        }

        .login-warning-message {
            background-color: rgba(255, 193, 7, 0.15);
            border: 1px solid #ffc107;
            color: #ffe58f;
            border-radius: 5px;
            padding: 10px;
            text-align: center;
            margin-bottom: 15px;
        }

        @media (max-width: 992px) {
            .login-wrapper { flex-direction: column; width: 95%; height: auto; }
            .login-image-side { flex: none; height: 250px; }
            .login-form-side { flex: none; padding: 30px; }
            .login-title { font-size: 2em; }
        }
    </style>
</head>

<body>
<div class="login-wrapper">
    <div class="login-image-side"></div>

    <div class="login-form-side">
        <div class="w-100" style="max-width: 400px;">
            <h3 class="login-title">Đăng nhập</h3>

            <!-- ⚠️ Hiển thị cảnh báo khi bị redirect từ trang đặt bàn -->
            <c:if test="${param.msg == 'login_required'}">
                <div class="login-warning-message">⚠️ Vui lòng đăng nhập trước khi đặt bàn.</div>
            </c:if>

            <!-- ⚠️ Hiển thị thông báo lỗi khác -->
            <c:if test="${not empty error}">
                <div class="login-error-message">${error}</div>
            </c:if>

            <form action="auth?action=login" method="post">
                <div class="mb-3">
                    <label for="email" class="form-label">Email:</label>
                    <input type="email" name="email" id="email" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label">Mật khẩu:</label>
                    <input type="password" name="password" id="password" class="form-control" required>
                </div>

                <button class="btn btn-gold w-100 mt-4">Đăng nhập</button>
                
                <p class="text-center mt-4 register-link">
                    Chưa có tài khoản? <a href="auth?action=register">Đăng ký</a>
                </p>
            </form>
        </div>
    </div>
</div>
</body>
</html>
