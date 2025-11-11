<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/Views/components/admin_header.jsp" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Quản lý Thực đơn</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

  <style>
    :root{
      --yellow:#F5C518;
      --yellow-dark:#D6A800;
      --black:#111111;
      --gray-dark:#2B2B2B;
      --gray:#444;
      --white:#FFFFFF;
    }
    body{font-family:'Segoe UI',Arial,sans-serif;background:#1a1a1a;color:var(--white);margin:0;padding:40px 60px;}
    h1{color:var(--yellow);font-size:26px;display:flex;align-items:center;gap:10px;margin-bottom:25px;}

    /* --- Thanh tìm kiếm 1 hàng --- */
    .search-bar{
      display:flex;align-items:flex-end;gap:20px;flex-wrap:wrap;margin-bottom:25px;
      background:var(--gray-dark);padding:15px 25px;border-radius:10px;box-shadow:0 2px 8px rgba(0,0,0,.3);
    }
    .search-bar form{display:flex;align-items:flex-end;flex-wrap:wrap;gap:20px;width:100%;}
    .search-group{display:flex;flex-direction:column;}
    .search-group input,.search-group select{height:38px;}

    label{font-size:13px;color:var(--yellow);margin-bottom:5px;font-weight:600;}
    input[type="text"],input[type="number"],select{
      padding:8px 10px;border:1px solid var(--gray);border-radius:6px;font-size:14px;width:180px;
      background:var(--black);color:var(--white);
    }
    input:focus,select:focus{outline:none;border-color:var(--yellow);box-shadow:0 0 4px var(--yellow);}

    .search-buttons{display:flex;align-items:center;gap:10px;}
    .btn-search{background:var(--yellow);color:var(--black);border:none;padding:10px 18px;border-radius:6px;cursor:pointer;font-weight:600;}
    .btn-search:hover{background:var(--yellow-dark);}
    .btn-reset{background:var(--gray);color:var(--white);border:none;padding:10px 16px;border-radius:6px;cursor:pointer;font-weight:500;}
    .btn-reset:hover{background:#666;}

    /* --- Nút thêm --- */
    .btn-add{display:inline-block;background:var(--yellow);color:var(--black);padding:10px 18px;border-radius:6px;text-decoration:none;font-weight:600;margin-bottom:20px;}
    .btn-add:hover{background:var(--yellow-dark);}

    /* --- Bảng --- */
    table{width:100%;border-collapse:collapse;background:var(--gray-dark);border-radius:10px;overflow:hidden;box-shadow:0 3px 10px rgba(0,0,0,.4);}
    th,td{padding:14px 16px;text-align:center;border-bottom:1px solid #333;font-size:14px;}
    th{background:var(--black);color:var(--yellow);}
    tr:hover{background:#242424;}

    .status-active{color:var(--yellow);font-weight:600;}
    .status-hidden{color:#aaa;font-weight:500;}

    .actions a{margin:0 6px;text-decoration:none;font-size:16px;}
    .actions i{transition:transform .2s;}
    .actions i:hover{transform:scale(1.2);}
    .actions .edit{color:var(--yellow);}
    .actions .delete{color:#E03131;}

    /* --- Phân trang --- */
    .pagination{text-align:center;margin-top:25px;}
    .pagination a,.pagination span{margin:0 4px;padding:8px 12px;border-radius:5px;background:#2B2B2B;color:var(--white);text-decoration:none;border:1px solid #333;}
    .pagination .current{background:var(--yellow);color:var(--black);font-weight:bold;}

    .no-data{text-align:center;color:#aaa;padding:20px 0;}
  </style>
</head>

<body>
<h1><i class="fa-solid fa-utensils"></i> Quản lý Thực đơn</h1>

<!-- Nút thêm -->
<a href="${pageContext.request.contextPath}/admin/menu?action=add" class="btn-add">
  <i class="fa-solid fa-plus"></i> Thêm món mới
</a>

<!-- Thanh tìm kiếm -->
<div class="search-bar">
  <form method="get" action="${pageContext.request.contextPath}/admin/menu">
    <input type="hidden" name="action" value="search"/>

    <div class="search-group">
      <label for="keyword">Tên món</label>
      <input type="text" id="keyword" name="keyword" placeholder="Nhập tên món..." value="${keyword}">
    </div>

    <div class="search-group">
      <label>Giá từ</label>
      <input type="number" name="minPrice" min="0" max="100000" step="1000" placeholder="0" value="${minPrice}">
    </div>

    <div class="search-group">
      <label>Giá đến</label>
      <input type="number" name="maxPrice" min="0" max="100000" step="1000" placeholder="100000" value="${maxPrice}">
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

<!-- Bảng danh sách -->
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
      <td>${item.name}</td>
      <td>${item.price}</td>
      <td>${item.discountPercent}</td>
      <td>
        <c:choose>
          <c:when test="${categoryMap[item.categoryId] != null}">${categoryMap[item.categoryId]}</c:when>
          <c:otherwise>Không xác định</c:otherwise>
        </c:choose>
      </td>
      <td>${item.inventory}</td>
      <td>
        <c:choose>
          <c:when test="${item.active}"><span class="status-active">Hiển thị</span></c:when>
          <c:otherwise><span class="status-hidden">Ẩn</span></c:otherwise>
        </c:choose>
      </td>
      <td class="actions">
        <a href="${pageContext.request.contextPath}/admin/menu?action=edit&id=${item.id}" title="Chỉnh sửa">
          <i class="fa-solid fa-pen-to-square edit"></i>
        </a>
        <a href="${pageContext.request.contextPath}/admin/menu?action=delete&id=${item.id}"
           onclick="return confirm('Xóa món này?')" title="Xóa">
          <i class="fa-solid fa-trash-can delete"></i>
        </a>
      </td>
    </tr>
  </c:forEach>

  <c:if test="${empty menuList}">
    <tr><td colspan="8" class="no-data">Không có món ăn nào</td></tr>
  </c:if>
  </tbody>
</table>

<!-- Phân trang -->
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
  document.addEventListener("DOMContentLoaded", () => {
    const form = document.querySelector(".search-bar form");
    const minInput = form.querySelector('input[name="minPrice"]');
    const maxInput = form.querySelector('input[name="maxPrice"]');

    form.addEventListener("submit", (e) => {
      const min = parseFloat(minInput.value);
      const max = parseFloat(maxInput.value);

      // --- 1️⃣ Kiểm tra giá trị âm ---
      if ((!isNaN(min) && min < 0) || (!isNaN(max) && max < 0)) {
        console.log("⚠️ Giá không được nhỏ hơn 0!");
        e.preventDefault();
        return;
      }

      // --- 2️⃣ Kiểm tra min > max ---
      if (!isNaN(min) && !isNaN(max) && min > max) {
        console.log(`❌ Lỗi: minPrice (${min}) > maxPrice (${max}) — không hợp lệ.`);
        e.preventDefault();
        return;
      }

      // --- 3️⃣ Trường hợp min = max ---
      if (!isNaN(min) && !isNaN(max) && min === max) {
        console.log(`ℹ️ Thông tin: minPrice = maxPrice = ${min} (tìm chính xác giá này).`);
      }
    });
  });
</script>
</body>
</html>
