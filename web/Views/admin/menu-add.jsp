<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/Views/components/admin_header.jsp" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thêm Món Mới - Admin</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

        <style>
            /* --- HẮC KIM PALETTE (Đồng bộ toàn hệ thống) --- */
            :root {
                --primary-gold: #FFD700;
                --gold-hover: #ffea70;
                --bg-dark: #0c0c0c;
                --bg-panel: #1a1a1a;
                --bg-input: #0a0a0a;
                --text-light: #f5f5f5;
                --text-dim: #bbb;
                --border-gold: rgba(255, 215, 0, 0.3);
                --shadow-dark: rgba(0,0,0,0.6);
                --danger: #ff4d4d;
            }

            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                background-color: var(--bg-dark);
                color: var(--text-light);
                margin: 0;
                padding: 70px;
            }

            /* Style Header (Nếu cần ghi đè) */
            .admin-header {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1000;
            }

            h1 {
                color: var(--primary-gold);
                font-size: 26px;
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 30px;
                text-transform: uppercase;
                letter-spacing: 1px;
                text-shadow: 0 0 15px rgba(255, 215, 0, 0.3);
            }

            /* --- Form Container --- */
            form {
                background: var(--bg-panel);
                padding: 35px 40px;
                max-width: 760px;
                border-radius: 12px;
                box-shadow: 0 10px 30px var(--shadow-dark);
                border: 1px solid var(--border-gold);
            }

            .form-group {
                margin-bottom: 25px;
            }

            label {
                display: block;
                font-weight: 700;
                color: var(--primary-gold);
                margin-bottom: 8px;
                font-size: 14px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .required {
                color: var(--danger);
                margin-left: 4px;
            }

            /* --- Inputs --- */
            input[type="text"],
            input[type="number"],
            textarea,
            select {
                width: 100%;
                padding: 12px 15px;
                border: 1px solid var(--border-gold);
                border-radius: 6px;
                background: var(--bg-input);
                color: var(--text-light);
                font-size: 14px;
                box-sizing: border-box;
                transition: all 0.3s ease;
                outline: none;
            }

            input:focus, textarea:focus, select:focus {
                border-color: var(--primary-gold);
                box-shadow: 0 0 10px rgba(255, 215, 0, 0.25);
                background-color: #111;
            }

            textarea {
                resize: vertical;
                min-height: 100px;
                line-height: 1.5;
            }

            /* --- Validation & Hints --- */
            .hint {
                font-size: 12px;
                color: var(--text-dim);
                margin-top: 6px;
                display: flex;
                justify-content: space-between;
                font-style: italic;
            }

            .error-tip {
                color: var(--danger);
                font-size: 13px;
                margin-top: 6px;
                display: none;
                font-weight: 500;
                text-shadow: 0 0 5px rgba(255, 77, 77, 0.2);
            }

            .is-invalid {
                border-color: var(--danger) !important;
                box-shadow: 0 0 0 2px rgba(255, 77, 77, 0.15) !important;
            }

            /* --- Buttons --- */
            .form-buttons {
                margin-top: 35px;
                display: flex;
                gap: 15px;
                align-items: center;
            }

            .btn-submit {
                background: var(--primary-gold);
                color: #000;
                padding: 12px 24px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 700;
                text-transform: uppercase;
                transition: 0.3s;
                box-shadow: 0 0 10px rgba(255, 215, 0, 0.2);
            }

            .btn-submit:hover {
                background: var(--gold-hover);
                box-shadow: 0 0 20px rgba(255, 215, 0, 0.5);
                transform: translateY(-2px);
            }

            .btn-back {
                background: transparent;
                color: var(--text-dim);
                padding: 11px 20px;
                border: 1px solid #444;
                border-radius: 6px;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                font-weight: 600;
                transition: 0.3s;
            }

            .btn-back:hover {
                background: #333;
                color: #fff;
                border-color: #666;
            }
        </style>
    </head>

    <body>

        <h1><i class="fa-solid fa-circle-plus"></i> Thêm Món Mới</h1>

        <form id="addForm" method="post" action="${pageContext.request.contextPath}/admin/menu?action=add" novalidate>

            <div class="form-group">
                <label>Tên món <span class="required">*</span></label>
                <input type="text" name="name" id="name" maxlength="200" required placeholder="Ví dụ: Bò bít tết sốt tiêu đen...">
                <div class="hint"><span>Tối đa 200 ký tự</span><span id="nameCount">0/200</span></div>
                <div class="error-tip" id="nameErr"><i class="fa-solid fa-circle-exclamation"></i> Tên món không được để trống.</div>
            </div>

            <div class="form-group">
                <label>Mô tả</label>
                <textarea name="description" id="description" rows="3" maxlength="200" placeholder="Mô tả thành phần, hương vị..."></textarea>
                <div class="hint"><span>Tối đa 200 ký tự</span><span id="descCount">0/200</span></div>
                <div class="error-tip" id="descErr"><i class="fa-solid fa-circle-exclamation"></i> Mô tả quá dài.</div>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                <div class="form-group">
                    <label>Giá (VND) <span class="required">*</span></label>
                    <input type="number" name="price" id="price" step="1000" min="0" required placeholder="VD: 150000">
                    <div class="error-tip" id="priceErr"><i class="fa-solid fa-circle-exclamation"></i> Giá không hợp lệ (phải dương và bội số của 1000).</div>
                </div>
                <div class="form-group">
                    <label>Giảm giá (%)</label>
                    <input type="number" name="discount_percent" step="1" min="0" max="100" value="0" placeholder="0 - 100">
                </div>
            </div>

            <div class="form-group">
                <label>Danh mục <span class="required">*</span></label>
                <select name="category_id" required>
                    <option value="">-- Chọn danh mục --</option>
                    <c:forEach var="entry" items="${categoryMap}">
                        <option value="${entry.key}">${entry.value}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label>Ảnh (URL)</label>
                <input type="text" name="image" placeholder="https://example.com/food-image.jpg">
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                <div class="form-group">
                    <label>Mã món (Code)</label>
                    <input type="text" name="code" placeholder="VD: MA001">
                </div>
                <div class="form-group">
                    <label>Trạng thái mặc định</label>
                    <select name="is_active">
                        <option value="true" selected>Hiển thị ngay</option>
                        <option value="false">Tạo nháp (Ẩn)</option>
                    </select>
                </div>
            </div>

            <div class="form-buttons">
                <button type="submit" class="btn-submit"><i class="fa-solid fa-check"></i> Tạo Món Ăn</button>
                <a href="${pageContext.request.contextPath}/admin/menu?action=list" class="btn-back">
                    <i class="fa-solid fa-xmark"></i> Hủy bỏ
                </a>
            </div>
        </form>

        <script>
            const nameInput = document.getElementById('name');
            const descInput = document.getElementById('description');
            const nameCount = document.getElementById('nameCount');
            const descCount = document.getElementById('descCount');

            function updateCounter(el, counterEl) {
                const max = parseInt(el.getAttribute('maxlength')) || 200;
                counterEl.textContent = `${el.value.length}/${max}`;
                        if (el.value.length >= max) {
                            counterEl.style.color = 'var(--danger)';
                        } else {
                            counterEl.style.color = 'var(--text-dim)';
                        }
                    }

                    if (nameInput)
                        nameInput.addEventListener('input', () => updateCounter(nameInput, nameCount));
                    if (descInput)
                        descInput.addEventListener('input', () => updateCounter(descInput, descCount));

                    // Validation Form
                    document.getElementById('addForm').addEventListener('submit', function (e) {
                        let ok = true;

                        // Reset error states
                        const inputs = document.querySelectorAll('.is-invalid');
                        inputs.forEach(el => el.classList.remove('is-invalid'));
                        const errs = document.querySelectorAll('.error-tip');
                        errs.forEach(el => el.style.display = 'none');

                        // Check Name
                        if (!nameInput.value.trim() || nameInput.value.length > 200) {
                            ok = false;
                            nameInput.classList.add('is-invalid');
                            document.getElementById('nameErr').style.display = 'block';
                        }

                        // Check Description
                        if (descInput.value.length > 200) {
                            ok = false;
                            descInput.classList.add('is-invalid');
                            document.getElementById('descErr').style.display = 'block';
                        }

                        // Check Price
                        const price = document.getElementById('price');
                        const p = Number(price.value);
                        if (price.value === '' || isNaN(p) || p < 0 || p % 1000 !== 0) {
                            ok = false;
                            price.classList.add('is-invalid');
                            document.getElementById('priceErr').style.display = 'block';
                        }

                        if (!ok)
                            e.preventDefault();
                    });
        </script>

    </body>
</html>