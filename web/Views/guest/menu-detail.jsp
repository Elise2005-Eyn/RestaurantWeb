<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết món ăn</title>
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
        /* CSS HEADER (TỪ TRANG CHỦ)         */
        /* --------------------------------- */
        .header-main {
            background-color: var(--color-gray-dark); 
            padding: 20px 0;
            box-shadow: 0 2px 5px rgba(0,0,0,0.3);
            border-bottom: 2px solid var(--color-gold);
        }

        .header-container {
            max-width: 1200px;
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
        /* MỚI: GHI ĐÈ CARD CHI TIẾT         */
        /* --------------------------------- */
        .detail-card.card {
            background-color: var(--color-gray-dark);
            border: 1px solid var(--color-gray-medium);
            color: var(--color-white);
        }
        
        .detail-card-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            /* Phân cách ảnh và chữ */
            border-right: 1px solid var(--color-gray-medium);
        }
        
        /* Ghi đè tiêu đề to, màu vàng */
        .detail-card .card-title {
            font-family: 'Oswald', sans-serif;
            text-transform: uppercase;
            color: var(--color-gold);
            font-size: 2.5em; /* To hơn tiêu đề ở list */
            font-weight: 700;
        }
        
        /* Ghi đè mô tả (text-muted) */
        .detail-card .card-text.text-muted {
            color: var(--color-gray-light) !important;
            font-size: 1.1em;
        }
        
        /* --------------------------------- */
        /* MỚI: CLASS GIÁ TIỀN VÀ NÚT BẤM   */
        /* --------------------------------- */
        .dish-price {
            color: var(--color-gold);
            font-weight: 700;
            font-size: 2em; /* Giá tiền to, rõ ràng */
            font-family: 'Oswald', sans-serif;
        }
        
        /* Ghi đè các class thông báo */
        .detail-card .text-success {
            color: var(--color-gold) !important; /* Đổi màu xanh lá thành vàng */
            font-weight: 700;
        }
        .detail-card .text-muted {
            color: var(--color-gray-light) !important; /* Đổi màu xám bootstrap thành xám nhạt */
        }

        .btn-gold {
            background-color: var(--color-gold);
            color: var(--color-black);
            border: 1px solid var(--color-gold);
            font-weight: 700;
            font-family: 'Oswald', sans-serif;
            text-transform: uppercase;
            transition: all 0.2s ease;
        }
        
        .btn-gold:hover {
            background-color: var(--color-gray-dark);
            color: var(--color-gold);
            border-color: var(--color-gold);
        }
        
        /* --------------------------------- */
        /* CSS FOOTER (TỪ TRANG CHỦ)         */
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

<body> <header class="header-main">
    <div class="header-container">
        <a href="home" class="logo">NHÀ HÀNG <span>NGON</span></a>
        
        <nav class="main-nav">
            <a href="home">Trang Chủ</a>
            <a href="menu" style="color: var(--color-gold);">Thực Đơn</a> 
            <a href="book-table">Đặt Bàn</a>
            <a href="login">Đăng Nhập</a>
        </nav>
    </div>
</header>
<div class="header-contact">
    <strong>📞 HOTLINE: 0123 456 789</strong>
    <strong>⏰ GIỜ MỞ CỬA: 08:00 - 22:00</strong>
</div>
<div class="container py-5">
    <a href="menu?action=list" class="btn btn-gold mb-3">⬅ Quay lại thực đơn</a>

    <div class="card shadow-sm detail-card">
        <div class="row g-0">
            <div class="col-md-5">
                <img src="${menuItem.image}" class="img-fluid rounded-start detail-card-image" alt="${menuItem.name}">
            </div>
            <div class="col-md-7">
                <div class="card-body p-4"> <h3 class="card-title">${menuItem.name}</h3>
                    
                    <p class="card-text text-muted">${menuItem.description}</p>
                    
                    <p class="dish-price">${menuItem.price} VND</p>

                    <c:if test="${menuItem.discountPercent != null && menuItem.discountPercent > 0}">
                        <p class="text-success fs-5">Giảm giá: ${menuItem.discountPercent}%</p>
                    </c:if>

                    <c:if test="${menuItem.inventory != null}">
                        <p class="text-muted fs-5">Còn lại: ${menuItem.inventory} suất</p>
                    </c:if>
                    
                    <a href="#" class="btn btn-gold btn-lg mt-3">Thêm vào giỏ hàng</a>
                </div>
            </div>
        </div>
    </div>
</div>

<footer>
    © 2025 - Nhà hàng Demo | Liên hệ: info@restaurant.com | Hotline: 0123 456 789
</footer>
</body>
</html>