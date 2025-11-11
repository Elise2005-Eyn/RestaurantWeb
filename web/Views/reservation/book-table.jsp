<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Đặt bàn trước</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@600&family=Lato:wght@400;700&display=swap" rel="stylesheet">
  <style>
    :root{
      --black:#121212; --g1:#1f1f1f; --g2:#2e2e2e; --g3:#bbbbbb;
      --gold:#E0B841; --white:#f5f5f5; --danger:#FF6B6B;
    }
    body{background:var(--black);color:var(--white);font-family:'Lato',sans-serif;min-height:100vh;display:flex;flex-direction:column;align-items:center;padding:50px 12px}
    h1{font-family:'Oswald',sans-serif;color:var(--gold);text-transform:uppercase;margin-bottom:28px}
    form{background:var(--g1);padding:32px;border-radius:12px;max-width:900px;width:100%;box-shadow:0 12px 32px rgba(0,0,0,.55)}
    label{font-weight:700;color:var(--gold)}
    .form-control,.form-select{background:var(--g2);border:1px solid #444;color:var(--white)}
    .form-control:focus,.form-select:focus{border-color:var(--gold);box-shadow:0 0 0 .25rem rgba(224,184,65,.25)}
    .btn-gold{background:var(--gold);color:var(--black);font-weight:800;font-family:'Oswald',sans-serif;text-transform:uppercase;border:none;border-radius:8px;padding:.9rem 1rem}
    .btn-gold:hover{background:var(--g1);color:var(--gold)}
    .alert{border-radius:10px;font-weight:700}
    .hint{font-size:.9rem;color:var(--g3)}
    .err{color:var(--danger);display:none}
    /* Menu section */
    #menu-section{display:none;background:var(--g2);border-radius:12px;padding:16px;margin-top:16px;border:1px solid #3b3b3b}
    #menu-section h5{font-family:'Oswald',sans-serif;color:var(--gold);margin-bottom:12px}
    .menu-item{background:var(--g1);border:1px solid #4a4a4a;border-radius:10px;padding:14px 16px;margin-bottom:12px}
    .menu-title{font-weight:700}
    .menu-price{color:var(--gold);font-weight:700}
    .qty-wrap{display:flex;gap:10px;align-items:center;margin-top:8px}
    .qty-wrap input{max-width:110px}
    footer{margin:30px 0 10px;text-align:center;color:var(--g3);font-size:.9rem}
  </style>
</head>
<body>

<h1>Đặt bàn trước</h1>

<c:if test="${not empty success}">
  <div class="alert alert-success text-center">
    ${success}<br><small>Bạn sẽ được chuyển về <a href="home">trang chủ</a> sau 10 giây...</small>
  </div>
  <script>setTimeout(()=>location.href="home",10000);</script>
</c:if>
<c:if test="${not empty error}">
  <div class="alert alert-danger text-center">${error}</div>
</c:if>

<form id="reserveForm" method="post" action="book-table" novalidate>
  <!-- Ngày + Ca giờ -->
  <div class="row g-3">
    <div class="col-md-6">
      <label class="form-label">Ngày đặt</label>
      <input type="date" id="reserveDate" name="date" class="form-control" required>
      <div id="dateErr" class="err">Ngày đặt không được ở quá khứ.</div>
    </div>
    <div class="col-md-6">
      <label class="form-label">Giờ đặt (theo ca)</label>
      <select id="timeSlot" class="form-select" required>
        <option value="">-- Chọn ca --</option>
        <option data-start="08:00" data-end="10:00">08:00 - 10:00</option>
        <option data-start="10:00" data-end="12:00">10:00 - 12:00</option>
        <option data-start="12:00" data-end="14:00">12:00 - 14:00</option>
        <option data-start="18:00" data-end="20:00">18:00 - 20:00</option>
        <option data-start="20:00" data-end="22:00">20:00 - 22:00</option>
      </select>
      <div id="slotHint" class="hint">💡 Chỉ nhận đặt bàn từ 08:00 - 22:00</div>
      <!-- Gửi lên BE -->
      <input type="hidden" name="time" id="time">
      <input type="hidden" name="duration" id="duration" value="120">
    </div>
  </div>

  <!-- Số khách -->
  <div class="row g-3 mt-2">
    <div class="col-md-6">
      <label class="form-label">Số khách</label>
      <input type="number" name="guestCount" class="form-control" min="1" step="1" required>
    </div>
  </div>

  <!-- Hình thức gọi món -->
  <div class="mt-3">
    <label class="form-label">Hình thức gọi món</label><br>
    <div class="form-check form-check-inline">
      <input class="form-check-input" type="radio" name="orderType" id="orderBefore" value="BEFORE" checked>
      <label class="form-check-label" for="orderBefore">Đặt món trước</label>
    </div>
    <div class="form-check form-check-inline">
      <input class="form-check-input" type="radio" name="orderType" id="orderAtTable" value="AT_TABLE">
      <label class="form-check-label" for="orderAtTable">Gọi món tại nơi</label>
    </div>

    <!-- Danh sách món -->
    <div id="menu-section">
      <h5>Chọn món ăn bạn muốn đặt trước:</h5>
      <c:forEach var="m" items="${menuList}">
        <div class="menu-item">
          <div class="d-flex justify-content-between align-items-start flex-wrap">
            <div class="form-check">
              <input class="form-check-input food-check" type="checkbox"
                     name="menuItem" value="${m.id}" id="menu_${m.id}">
              <label class="form-check-label menu-title" for="menu_${m.id}">
                🍽️ ${m.name}
              </label>
            </div>
            <div class="menu-price">${m.price} VNĐ</div>
          </div>

          <div class="qty-wrap">
            <label class="small mb-0" for="qty_${m.id}">Số lượng:</label>
            <input type="number" class="form-control form-control-sm food-qty"
                   name="qty_${m.id}" id="qty_${m.id}" min="1" value="1" disabled>
          </div>
        </div>
      </c:forEach>
      <div id="menuErr" class="err">Vui lòng chọn ít nhất 1 món hoặc chọn “Gọi món tại nơi”.</div>
    </div>
  </div>

  <!-- Ghi chú -->
  <div class="mt-3">
    <label class="form-label">Ghi chú (tùy chọn)</label>
    <textarea id="note" name="note" class="form-control" maxlength="200" rows="4"
              placeholder="VD: Dị ứng hải sản, cần bàn gần cửa sổ..."></textarea>
    <div class="d-flex justify-content-between">
      <small class="hint">Tối đa 200 ký tự</small>
      <small id="noteCount" class="hint">0/200</small>
    </div>
    <div id="noteErr" class="err">Ghi chú tối đa 200 ký tự.</div>
  </div>

  <button type="submit" class="btn-gold w-100 mt-4">Xác nhận đặt bàn</button>
</form>

<footer>© 2025 - Nhà hàng Demo | Hotline: 0123 456 789 | Email: info@restaurant.com</footer>

<script>
(function(){
  const form = document.getElementById('reserveForm');
  const dateInput = document.getElementById('reserveDate');
  const slot = document.getElementById('timeSlot');
  const timeHidden = document.getElementById('time');
  const durationHidden = document.getElementById('duration');
  const slotHint = document.getElementById('slotHint');

  const note = document.getElementById('note');
  const noteCount = document.getElementById('noteCount');
  const noteErr = document.getElementById('noteErr');
  const dateErr = document.getElementById('dateErr');

  const orderBefore = document.getElementById('orderBefore');
  const orderAtTable = document.getElementById('orderAtTable');
  const menuSection = document.getElementById('menu-section');
  const menuErr = document.getElementById('menuErr');

  // set min date = hôm nay
  const today = new Date();
  const yyyy = today.getFullYear();
  const mm = String(today.getMonth()+1).padStart(2,'0');
  const dd = String(today.getDate()).padStart(2,'0');
  const todayStr = `${yyyy}-${mm}-${dd}`;
  dateInput.min = todayStr;

  // ca giờ -> hidden time + duration
  function toMin(hm){ const [h,m]=hm.split(':').map(Number); return h*60+m; }
  slot.addEventListener('change', () => {
    const opt = slot.options[slot.selectedIndex];
    const s = opt?.dataset?.start, e = opt?.dataset?.end;
    if (s && e){
      timeHidden.value = s;
      durationHidden.value = toMin(e) - toMin(s);
      slotHint.textContent = `⏱️ Ca đã chọn: ${s} - ${e} (thời lượng ${durationHidden.value} phút)`;
      slotHint.style.color = '#E0B841';
    } else {
      timeHidden.value = '';
      durationHidden.value = 120;
      slotHint.textContent = '💡 Chỉ nhận đặt bàn từ 08:00 - 22:00';
      slotHint.style.color = '#E0B841';
    }
  });

  // Ẩn/hiện + disable khối menu theo radio
  function setDisabled(container, disabled){
    container.querySelectorAll('input,select,textarea,button').forEach(el=>{
      // không disable checkbox/qty khi container ẩn? -> tắt hết để không submit
      el.disabled = disabled || (el.classList.contains('food-qty') && !el.previousElementSibling?.checked);
    });
  }
  function toggleMenuSection(){
    if (orderBefore.checked){
      menuSection.style.display='block';
      setDisabled(menuSection,false);
      menuErr.style.display='none';
    } else {
      menuSection.style.display='none';
      setDisabled(menuSection,true);
      menuErr.style.display='none';
    }
  }
  orderBefore.addEventListener('change', toggleMenuSection);
  orderAtTable.addEventListener('change', toggleMenuSection);
  toggleMenuSection();

  // Bật/tắt ô số lượng theo từng checkbox món
  function wireFoodRows(){
    document.querySelectorAll('.food-check').forEach(chk=>{
      const qty = chk.closest('.menu-item').querySelector('.food-qty');
      const sync = ()=>{ qty.disabled = !chk.checked; if(!chk.checked) qty.value = 1; };
      chk.addEventListener('change', sync);
      sync();
    });
  }
  wireFoodRows();

  // Note counter
  const updateNoteCount = ()=> noteCount.textContent = `${note.value.length}/200`;
  updateNoteCount();
  note.addEventListener('input', ()=>{ updateNoteCount(); noteErr.style.display = (note.value.length>200)?'block':'none'; });

  // Validate submit
  form.addEventListener('submit', (e)=>{
    let ok = true;

    // ngày không quá khứ
    if (dateInput.value && dateInput.value < todayStr){ ok=false; dateErr.style.display='block'; }
    else { dateErr.style.display='none'; }

    // chọn ca
    if (!slot.value || !timeHidden.value){ ok=false; slotHint.textContent='⚠️ Vui lòng chọn ca đặt bàn.'; slotHint.style.color='#FF6B6B'; }
    else { slotHint.style.color='#E0B841'; }

    // nếu đặt món trước -> phải chọn ít nhất 1 món
    if (orderBefore.checked){
      const any = Array.from(document.querySelectorAll('.food-check')).some(c=>c.checked);
      if (!any){ ok=false; menuErr.style.display='block'; }
      else menuErr.style.display='none';
    } else {
      menuErr.style.display='none';
    }

    // note <= 200
    if (note.value.length>200){ ok=false; noteErr.style.display='block'; }

    if (!ok) e.preventDefault();
  });
})();
</script>
</body>
</html>
