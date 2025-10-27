<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thực đơn nhà hàng</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
          
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Oswald:wght@600;700&display=swap" rel="stylesheet">

    <style>
        /* --------------------------------- */
        /* BẢNG MÀU ĐEN - VÀNG - XÁM         */
        /* --------------------------------- */
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
        }
        
        /* --------------------------------- */
        /* MỚI: CSS HEADER (TỪ TRANG CHỦ)   */
        /* --------------------------------- */
        .header-main {
            background-color: var(--color-gray-dark); 
            padding: 20px 0;
            box-shadow: 0 2px 5px rgba(0,0,0,0.3);
            border-bottom: 2px solid var(--color-gold);
        }

        .header-container {
            max-width: 1200px; /* Đồng bộ với trang chủ */
            margin: auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-family: 'Oswald', sans-serif;
            font-size: 2.2em;
            color: var(--color-white); 
            text-decoration: none;
            font-weight: 700;
        }
        .logo span {
            color: var(--color-gold); 
        }

        .main-nav {
            display: flex;
            gap: 25px;
        }

        .main-nav a {
            text-decoration: none;
            color: var(--color-white); 
            font-weight: 700;
            font-family: 'Oswald', sans-serif;
            font-size: 1.1em;
            text-transform: uppercase;
            transition: color 0.2s;
        }

        .main-nav a:hover {
            color: var(--color-gold); 
        }

        .header-contact {
            background-color: var(--color-gold); 
            color: var(--color-black);
            padding: 10px 20px;
            text-align: center;
            font-family: 'Oswald', sans-serif;
            font-weight: 700;
        }

        .header-contact strong {
            font-size: 1.2em;
            margin: 0 10px;
        }

        /* --------------------------------- */
        /* TIÊU ĐỀ SECTION (Trang thực đơn)   */
        /* --------------------------------- */
        .section-title {
            font-family: 'Oswald', sans-serif;
            text-transform: uppercase;
            color: var(--color-gold);
            font-size: 2.5em;
            text-align: center;
            /* Tăng margin top để tách khỏi header */
            margin: 50px 0; 
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 20px;
        }

        .section-title::before,
        .section-title::after {
            content: '';
            height: 3px;
            width: 100px;
            background-color: var(--color-gold);
        }
        
        /* --------------------------------- */
        /* GHI ĐÈ BOOTSTRAP CARD           */
        /* --------------------------------- */
        .menu-card.card {
            background-color: var(--color-gray-dark);
            border: 1px solid var(--color-gray-medium);
            border-radius: 8px;
            color: var(--color-white);
            transition: all 0.3s ease;
            height: 100%;
        }
        
        .menu-card.card:hover {
            transform: translateY(-6px);
            box-shadow: 0 6px 20px rgba(224, 184, 65, 0.15);
            border-color: var(--color-gold);
        }

        .menu-card img {
            height: 220px;
            object-fit: cover;
            border-bottom: 1px solid var(--color-gray-medium);
        }
        
        .menu-card .card-title {
            font-family: 'Oswald', sans-serif;
            text-transform: uppercase;
            color: var(--color-gold);
            font-size: 1.4em;
        }
        
        .menu-card .card-text {
            color: var(--color-gray-light);
            font-size: 0.9em;
        }
        
        /* --------------------------------- */
        /* CLASS GIÁ TIỀN VÀ NÚT BẤM         */
        /* --------------------------------- */
        .dish-price {
            color: var(--color-gold);
            font-weight: 700;
            font-size: 1.3em;
            font-family: 'Oswald', sans-serif;
        }

        .btn-gold {
            background-color: var(--color-gold);
            color: var(--color-black);
            border: 1px solid var(--color-gold);
            font-weight: 700;
            font-family: 'Oswald', sans-serif;
            text-transform: uppercase;
            font-size: 0.9em;
            padding: 0.3rem 0.75rem;
            transition: all 0.2s ease;
        }
        
        .btn-gold:hover {
            background-color: var(--color-gray-dark);
            color: var(--color-gold);
            border-color: var(--color-gold);
        }
        
        /* --------------------------------- */
        /* MỚI: CSS FOOTER (TỪ TRANG CHỦ)   */
        /* --------------------------------- */
        footer {
            background-color: var(--color-gray-dark); 
            color: var(--color-gray-light); 
            text-align: center;
            padding: 30px;
            margin-top: 50px;
            font-size: 0.9em;
            border-top: 3px solid var(--color-gold); 
        }

    </style>
</head>

<body> 

<header class="header-main">
    <div class="header-container">
        <a href="home.jsp" class="logo">NHÀ HÀNG <span>NGON</span></a>
        
        <nav class="main-nav">
            <a href="home">Trang Chủ</a>
            <a href="menu?action=list" style="color: var(--color-gold);">Thực Đơn</a> 
            <a href="book-table">Đặt Bàn</a>

            <!-- Nếu chưa đăng nhập -->
            <c:if test="${empty sessionScope.user}">
                <a href="auth?action=login">Đăng Nhập</a>
                <a href="auth?action=register">Đăng Ký</a>
            </c:if>

            <!-- Nếu đã đăng nhập -->
            <c:if test="${not empty sessionScope.user}">
                <span>👋 Xin chào, ${sessionScope.user.username}</span>
                <a href="auth?action=logout">Đăng Xuất</a>
            </c:if>
        </nav>
    </div>
</header>
<div class="header-contact">
    <strong>📞 HOTLINE: 0123 456 789</strong>
    <strong>⏰ GIỜ MỞ CỬA: 08:00 - 22:00</strong>
</div>
<div class="container py-5">
    <h2 class="section-title">🍽️ Thực đơn Nhà Hàng</h2>

    <div class="row">
        <c:forEach var="item" items="${menuList}">
            <div class="col-md-4 mb-4">
                <div class="card shadow-sm menu-card">
                    <img src="${item.image}" class="card-img-top" alt="${item.name}">
                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title">${item.name}</h5>
                        <p class="card-text text-muted small">
                            ${fn:length(item.description) > 70
                                ? fn:substring(item.description, 0, 70) + "..."
                                : item.description}
                        </p>
                        
                        <p class="dish-price mb-2">${item.price} VND</p>
                        
                        <a href="menu?action=detail&id=${item.id}" 
                           class="btn btn-sm btn-gold mt-auto align-self-start">
                            Xem chi tiết
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<footer>
    © 2025 - Nhà hàng Demo | Liên hệ: info@restaurant.com | Hotline: 0123 456 789
</footer>
</body>
</html>