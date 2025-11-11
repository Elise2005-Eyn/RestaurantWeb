<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/Views/components/admin_header.jsp" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Chỉnh sửa món ăn</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

  <style>
    :root{
      --yellow:#F5C518;
      --yellow-dark:#D6A800;
      --black:#111111;
      --gray-dark:#2B2B2B;
      --gray:#3A3A3A;
      --white:#FFFFFF;
      --danger:#FF6B6B;
    }

    body{
      font-family:'Segoe UI',Arial,sans-serif;
      background:#1a1a1a;
      color:var(--white);
      margin:0; padding:40px 60px;
    }

    h1{
      color:var(--yellow);
      font-size:26px;
      display:flex; align-items:center; gap:10px;
      margin-bottom:25px;
    }

    form{
      background:var(--gray-dark);
      padding:28px 32px;
      max-width:760px;
      border-radius:12px;
      box-shadow:0 6px 20px rgba(0,0,0,.45);
      border:1px solid #262626;
    }

    .form-group{ margin-bottom:18px; }
    label{
      display:block; font-weight:700; color:var(--yellow);
      margin-bottom:6px; font-size:14px;
    }

    input[type="text"], input[type="number"], textarea, select{
      width:100%; padding:10px 12px;
      border:1px solid #444; border-radius:8px;
      background:var(--black); color:var(--white);
      font-size:14px; box-sizing:border-box;
      transition:border-color .2s, box-shadow .2s;
    }
    input:focus, textarea:focus, select:focus{
      outline:none; border-color:var(--yellow);
      box-shadow:0 0 0 3px rgba(245,197,24,.15);
    }

    textarea{ resize:vertical; min-height:90px; }

    .hint{
      font-size:12px; color:#bfbfbf; margin-top:6px;
      display:flex; justify-content:space-between;
    }
    .error-tip{ color:var(--danger); font-size:12px; margin-top:6px; display:none; }
    .is-invalid{ border-color:var(--danger)!important; box-shadow:0 0 0 3px rgba(255,107,107,.15)!important; }

    .form-buttons{ margin-top:24px; display:flex; gap:10px; }

    .btn-save{
      background:var(--yellow); color:var(--black);
      padding:10px 20px; border:none; border-radius:8px;
      cursor:pointer; font-weight:700;
    }
    .btn-save:hover{ background:var(--yellow-dark); }

    .btn-back{
      background:#4a4a4a; color:#fff; padding:10px 18px;
      border:none; border-radius:8px; text-decoration:none;
      display:inline-flex; align-items:center; gap:6px; font-weight:600;
    }
    .btn-back:hover{ background:#5a5a5a; }

    .required{ color:var(--danger); }
  </style>
</head>

<body>

<h1><i class="fa-solid fa-pen-to-square"></i> Chỉnh sửa món ăn</h1>

<form id="editForm" method="post" action="${pageContext.request.contextPath}/admin/menu?action=edit" novalidate>
  <input type="hidden" name="id" value="${item.id}">

  <div class="form-group">
    <label>Tên món <span class="required">*</span></label>
    <input type="text" name="name" id="name" value="${item.name}" maxlength="200" required>
    <div class="hint"><span>Tối đa 200 ký tự</span><span id="nameCount">0/200</span></div>
    <div class="error-tip" id="nameErr">Tên món không được để trống và tối đa 200 ký tự.</div>
  </div>

  <div class="form-group">
    <label>Mô tả</label>
    <textarea name="description" id="description" rows="3" maxlength="200">${item.description}</textarea>
    <div class="hint"><span>Tối đa 200 ký tự</span><span id="descCount">0/200</span></div>
    <div class="error-tip" id="descErr">Mô tả tối đa 200 ký tự.</div>
  </div>

  <div class="form-group">
    <label>Giá (VND) <span class="required">*</span></label>
    <input type="number" name="price" id="price" step="1000" min="0" value="${item.price}" required>
    <div class="error-tip" id="priceErr">Giá không được âm và phải bội số 1000.</div>
  </div>

  <div class="form-group">
    <label>Giảm giá (%)</label>
    <input type="number" name="discount_percent" step="1" min="0" max="100" value="${item.discountPercent}">
  </div>

  <div class="form-group">
    <label>Danh mục <span class="required">*</span></label>
    <select name="category_id" required>
      <option value="">-- Chọn danh mục --</option>
      <c:forEach var="entry" items="${categoryMap}">
        <option value="${entry.key}" ${item.categoryId == entry.key ? 'selected' : ''}>${entry.value}</option>
      </c:forEach>
    </select>
  </div>

<!--  <div class="form-group">
    <label>Tồn kho</label>
    <input type="number" name="inventory" id="inventory" min="0" value="${item.inventory}">
    <div class="error-tip" id="invErr">Tồn kho không được âm.</div>
  </div>-->

  <div class="form-group">
    <label>Ảnh (URL)</label>
    <input type="text" name="image" value="${item.image}">
  </div>

  <div class="form-group">
    <label>Mã món</label>
    <input type="text" name="code" value="${item.code}">
  </div>

  <div class="form-group">
    <label>Trạng thái hiển thị</label>
    <select name="is_active">
      <option value="true" ${item.active ? 'selected' : ''}>Hiển thị</option>
      <option value="false" ${!item.active ? 'selected' : ''}>Ẩn</option>
    </select>
  </div>

  <div class="form-buttons">
    <button type="submit" class="btn-save"><i class="fa-solid fa-floppy-disk"></i> Lưu thay đổi</button>
    <a href="${pageContext.request.contextPath}/admin/menu?action=list" class="btn-back">
      <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
    </a>
  </div>
</form>

<script>
  // đếm ký tự realtime
  const nameInput = document.getElementById('name');
  const descInput = document.getElementById('description');
  const nameCount = document.getElementById('nameCount');
  const descCount = document.getElementById('descCount');

  function updateCounter(el, counterEl){
    const max = parseInt(el.getAttribute('maxlength')) || 200;
    counterEl.textContent = `${el.value.length}/${max}`;
  }
  updateCounter(nameInput, nameCount);
  updateCounter(descInput, descCount);

  nameInput.addEventListener('input', () => updateCounter(nameInput, nameCount));
  descInput.addEventListener('input', () => updateCounter(descInput, descCount));

  // validate trước khi submit
  document.getElementById('editForm').addEventListener('submit', function(e){
    let ok = true;

    // reset
    const errs = ['nameErr','descErr','priceErr','invErr'].map(id => document.getElementById(id));
    [nameInput, descInput, price, inventory].forEach(el => el && el.classList.remove('is-invalid'));
    errs.forEach(el => el.style.display = 'none');

    // name: required & <= 200
    if(!nameInput.value.trim() || nameInput.value.length > 200){
      ok = false;
      nameInput.classList.add('is-invalid');
      document.getElementById('nameErr').style.display = 'block';
    }

    // desc: <= 200
    if(descInput.value.length > 200){
      ok = false;
      descInput.classList.add('is-invalid');
      document.getElementById('descErr').style.display = 'block';
    }

    // price: >= 0 và bội 1000
    const price = document.getElementById('price');
    const p = Number(price.value);
    if(isNaN(p) || p < 0 || p % 1000 !== 0){
      ok = false;
      price.classList.add('is-invalid');
      document.getElementById('priceErr').style.display = 'block';
    }

    // inventory: >= 0
    const inventory = document.getElementById('inventory');
    const inv = Number(inventory.value);
    if(inventory.value !== '' && (isNaN(inv) || inv < 0)){
      ok = false;
      inventory.classList.add('is-invalid');
      document.getElementById('invErr').style.display = 'block';
    }

    if(!ok) e.preventDefault();
  });
</script>

</body>
</html>
