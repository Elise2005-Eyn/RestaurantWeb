<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/Views/components/admin_header.jsp" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản Lý Thực Đơn - Admin</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

        <style>
            /* --- HẮC KIM PALETTE --- */
            :root {
                --primary-gold: #FFD700;       /* Vàng hoàng gia */
                --gold-hover: #ffea70;         /* Vàng sáng khi hover */
                --bg-dark: #0c0c0c;            /* Nền body đen sâu */
                --bg-panel: #1a1a1a;           /* Nền bảng/khung */
                --bg-input: #0a0a0a;           /* Nền input tối */
                --text-light: #f5f5f5;         /* Chữ trắng ngà */
                --text-dim: #bbb;              /* Chữ xám nhạt */
                --border-gold: rgba(255, 215, 0, 0.3);
                --shadow-dark: rgba(0,0,0,0.6);
            }

            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                background-color: var(--bg-dark);
                color: var(--text-light);
                margin: 0;
                padding: 70px; /* Padding lớn để tránh header fixed */
            }

            /* Tiêu đề trang */
            h1 {
                color: var(--primary-gold);
                font-size: 28px;
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 30px;
                text-transform: uppercase;
                letter-spacing: 1px;
                text-shadow: 0 0 15px rgba(255, 215, 0, 0.3);
            }

            .admin-header {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1000;
            }

            /* --- Nút Thêm Mới (Nổi bật) --- */
            .btn-add {
                display: inline-block;
                background-color: var(--primary-gold);
                color: #000;
                padding: 10px 20px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: 700;
                margin-bottom: 25px;
                transition: 0.3s;
                box-shadow: 0 0 10px rgba(255, 215, 0, 0.2);
            }

            .btn-add:hover {
                background-color: var(--gold-hover);
                box-shadow: 0 0 20px rgba(255, 215, 0, 0.5);
                transform: translateY(-2px);
            }

            /* --- Thanh Tìm Kiếm --- */
            .search-bar {
                background: var(--bg-panel);
                padding: 25px;
                border-radius: 10px;
                border: 1px solid var(--border-gold);
                box-shadow: 0 10px 30px var(--shadow-dark);
                margin-bottom: 30px;
            }

            .search-bar form {
                display: flex;
                align-items: flex-end;
                flex-wrap: wrap;
                gap: 20px;
                width: 100%;
            }

            .search-group {
                display: flex;
                flex-direction: column;
            }

            label {
                font-size: 13px;
                color: var(--primary-gold);
                margin-bottom: 8px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            input[type="text"],
            input[type="number"],
            select {
                padding: 10px 12px;
                border: 1px solid var(--border-gold);
                border-radius: 6px;
                font-size: 14px;
                width: 180px;
                background-color: var(--bg-input); /* Nền tối (inset) */
                color: var(--text-light);
                outline: none;
                transition: 0.3s;
            }

            input:focus, select:focus {
                border-color: var(--primary-gold);
                box-shadow: 0 0 10px rgba(255, 215, 0, 0.2);
                background-color: #111;
            }

            .search-buttons {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 1px; /* Căn chỉnh với input */
            }

            /* Nút Tìm kiếm */
            .btn-search {
                background: var(--primary-gold);
                color: #000;
                border: none;
                padding: 10px 18px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 700;
                transition: 0.3s;
            }
            .btn-search:hover {
                background: var(--gold-hover);
                box-shadow: 0 0 15px rgba(255, 215, 0, 0.4);
            }

            /* Nút Reset (Dạng Outline) */
            .btn-reset {
                background: transparent;
                color: var(--primary-gold);
                border: 1px solid var(--primary-gold);
                padding: 9px 16px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 600;
                text-decoration: none;
                transition: 0.3s;
            }
            .btn-reset:hover {
                background: rgba(255, 215, 0, 0.1);
                box-shadow: 0 0 10px rgba(255, 215, 0, 0.2);
            }

            /* --- Bảng Dữ Liệu --- */
            table {
                width: 100%;
                border-collapse: collapse;
                background: var(--bg-panel);
                border-radius: 10px;
                overflow: hidden;
                border: 1px solid var(--border-gold);
                box-shadow: 0 5px 20px rgba(0,0,0,0.5);
            }

            th, td {
                padding: 16px;
                text-align: center;
                border-bottom: 1px solid rgba(255, 215, 0, 0.1);
                font-size: 14px;
            }

            th {
                background-color: #222;
                color: var(--primary-gold);
                font-weight: 700;
                text-transform: uppercase;
                font-size: 13px;
                letter-spacing: 1px;
            }

            tr:hover {
                background-color: rgba(255, 215, 0, 0.03);
            }

            /* Trạng thái */
            .status-active {
                color: #00ff88; /* Xanh neon */
                font-weight: 600;
                text-shadow: 0 0 5px rgba(0, 255, 136, 0.3);
            }

            .status-hidden {
                color: #ff4d4d; /* Đỏ neon */
                font-weight: 600;
                text-shadow: 0 0 5px rgba(255, 77, 77, 0.3);
            }

            /* Hành động (Icons) */
            .actions a {
                margin: 0 8px;
                text-decoration: none;
                font-size: 16px;
                color: var(--text-dim);
                transition: 0.2s;
            }

            .actions .edit:hover {
                color: var(--primary-gold);
                transform: scale(1.2);
                filter: drop-shadow(0 0 5px var(--primary-gold));
            }

            .actions .delete:hover {
                color: #ff4d4d;
                transform: scale(1.2);
                filter: drop-shadow(0 0 5px #ff4d4d);
            }

            /* --- Phân Trang --- */
            .pagination {
                text-align: center;
                margin-top: 40px;
            }

            .pagination a, .pagination span {
                display: inline-block;
                margin: 0 5px;
                padding: 8px 14px;
                border-radius: 4px;
                background: var(--bg-panel);
                color: var(--text-light);
                text-decoration: none;
                border: 1px solid var(--border-gold);
                transition: 0.3s;
            }

            .pagination a:hover {
                background-color: var(--primary-gold);
                color: #000;
                box-shadow: 0 0 15px rgba(255, 215, 0, 0.4);
            }

            .pagination .current {
                background-color: var(--primary-gold);
                color: #000;
                font-weight: 800;
                border-color: var(--primary-gold);
                box-shadow: 0 0 10px rgba(255, 215, 0, 0.3);
            }

            .no-data {
                text-align: center;
                color: var(--text-dim);
                padding: 30px 0;
                font-style: italic;
            }
        </style>
    </head>

    <body>
        <h1><i class="fa-solid fa-utensils"></i> Quản Lý Thực Đơn</h1>

        <a href="${pageContext.request.contextPath}/admin/menu?action=add" class="btn-add">
            <i class="fa-solid fa-plus"></i> Thêm Món Mới
        </a>

        <div class="search-bar">
            <form method="get" action="${pageContext.request.contextPath}/admin/menu">
                <input type="hidden" name="action" value="search"/>

                <div class="search-group">
                    <label for="keyword">Tên món</label>
                    <input type="text" id="keyword" name="keyword" placeholder="Nhập tên món..." value="${keyword}">
                </div>

                <div class="search-group">
                    <label>Giá từ</label>
                    <input type="number" name="minPrice" min="0" max="10000000" step="1000" placeholder="0" value="${minPrice}">
                </div>

                <div class="search-group">
                    <label>Giá đến</label>
                    <input type="number" name="maxPrice" min="0" max="10000000" step="1000" placeholder="Tối đa" value="${maxPrice}">
                </div>

                <div class="search-group">
                    <label for="categoryId">Danh mục</label>
                    <select name="categoryId" id="categoryId">
                        <option value="">-- Tất cả --</option>
                        <c:forEach var="entry" items="${categoryMap}">
                            <option value="${entry.key}" ${selectedCategory == entry.key ? 'selected' : ''}>${entry.value}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="search-buttons">
                    <button type="submit" class="btn-search"><i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm</button>
                    <a href="${pageContext.request.contextPath}/admin/menu?action=list" class="btn-reset">Đặt lại</a>
                </div>
            </form>
        </div>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên món</th>
                    <th>Giá</th>
                    <th>Giảm (%)</th>
                    <th>Danh mục</th>
                    <th>Tồn kho</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${menuList}">
                    <tr>
                        <td>${item.id}</td>
                        <td style="text-align: left; font-weight: 500;">${item.name}</td>
                        <td style="color: var(--primary-gold);">${item.price}</td>
                        <td>${item.discountPercent}</td>
                        <td>
                            <c:choose>
                                <c:when test="${categoryMap[item.categoryId] != null}">${categoryMap[item.categoryId]}</c:when>
                                <c:otherwise><span style="color: #777;">N/A</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>${item.inventory}</td>
                        <td>
                            <c:choose>
                                <c:when test="${item.active}"><span class="status-active"><i class="fa-solid fa-circle-check"></i> Hiển thị</span></c:when>
                                <c:otherwise><span class="status-hidden"><i class="fa-solid fa-circle-xmark"></i> Ẩn</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td class="actions">
                            <a href="${pageContext.request.contextPath}/admin/menu?action=edit&id=${item.id}" title="Chỉnh sửa">
                                <i class="fa-solid fa-pen-to-square edit"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/menu?action=delete&id=${item.id}"
                               onclick="return confirm('Bạn có chắc chắn muốn xóa món này không?')" title="Xóa">
                                <i class="fa-solid fa-trash-can delete"></i>
                            </a>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty menuList}">
                    <tr><td colspan="8" class="no-data">Không tìm thấy dữ liệu phù hợp.</td></tr>
                </c:if>
            </tbody>
        </table>

        <div class="pagination">
            <c:forEach begin="1" end="${totalPages}" var="i">
                <c:choose>
                    <c:when test="${i == currentPage}"><span class="current">${i}</span></c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/admin/menu?action=list&page=${i}&keyword=${keyword}&minPrice=${minPrice}&maxPrice=${maxPrice}&categoryId=${selectedCategory}">
                            ${i}
                        </a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </div>

        <script>
            // Logic JS cũ vẫn giữ nguyên vì chỉ xử lý logic
            document.addEventListener("DOMContentLoaded", () => {
                const form = document.querySelector(".search-bar form");
                const minInput = form.querySelector('input[name="minPrice"]');
                const maxInput = form.querySelector('input[name="maxPrice"]');

                form.addEventListener("submit", (e) => {
                    const min = parseFloat(minInput.value);
                    const max = parseFloat(maxInput.value);

                    if ((!isNaN(min) && min < 0) || (!isNaN(max) && max < 0)) {
                        alert("Giá không được nhỏ hơn 0!");
                        e.preventDefault();
                        return;
                    }

                    if (!isNaN(min) && !isNaN(max) && min > max) {
                        alert("Giá tối thiểu không được lớn hơn giá tối đa!");
                        e.preventDefault();
                        return;
                    }
                });
            });
        </script>
    </body>
</html>