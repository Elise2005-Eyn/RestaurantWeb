<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Dish" %>
<%
  String ctx = request.getContextPath();
  String mode = (String) request.getAttribute("mode"); // "create" or "edit"
  Dish dish = (Dish) request.getAttribute("dish");
  boolean editing = "edit".equals(mode);
  String error = (String) request.getAttribute("error");
%>
<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title><%= editing? "Edit Dish" : "Create Dish" %></title>
<style>
  body{font-family:system-ui,Arial;margin:22px}
  .form{max-width:640px}
  .row{display:grid;grid-template-columns:1fr 1fr;gap:12px}
  label{display:block;margin-top:12px;font-weight:700}
  input,textarea{width:100%;padding:10px;border:1px solid #e5e7eb;border-radius:10px}
  .btn{margin-top:14px;background:#e11d48;color:#fff;border:none;padding:10px 16px;border-radius:10px;cursor:pointer}
  .error{margin:8px 0;padding:10px 12px;border-radius:10px;border:1px solid #fecaca;background:#fff1f2;color:#7f1d1d}
</style>
</head>
<body>
  <h2><%= editing? "Edit Dish" : "Create Dish" %></h2>

  <% if (error != null) { %>
    <div class="error">⚠ <%= error %></div>
  <% } %>

  <form class="form" method="post"
        action="<%= editing? ctx + "/admin/dishes/edit?id="+dish.getId() : ctx + "/admin/dishes/create" %>">
    <label>Name</label>
    <input name="name" required value="<%= editing? dish.getName() : "" %>">

    <div class="row">
      <div>
        <label>Category</label>
        <input name="category" required value="<%= editing? dish.getCategory() : "" %>">
      </div>
      <div>
        <label>Price</label>
        <input name="price" type="number" step="0.01" min="0" required
               value="<%= editing? dish.getPrice() : "" %>">
      </div>
    </div>

    <label>Description</label>
    <textarea name="description" rows="4"><%= editing? dish.getDescription() : "" %></textarea>

    <label>Image filename (in <code>assets/images/dishes</code>)</label>
    <input id="imagePath" name="imagePath" placeholder="e.g. banh-mi.jpg" required
           value="<%= editing? dish.getImagePath() : "" %>"
           oninput="preview(this.value)">

    <div style="margin-top:8px">
      <img id="preview"
           src="<%= editing && dish.getImagePath()!=null ? ctx + "/assets/images/dishes/" + dish.getImagePath() : "" %>"
           alt="" height="100"
           style="border:1px solid #eee;border-radius:10px;<%= editing && dish.getImagePath()!=null ? "" : "display:none" %>">
    </div>

    <button class="btn"><%= editing? "Update" : "Create" %></button>
    <a href="<%=ctx%>/admin/dishes">Cancel</a>
  </form>

<script>
  function preview(fn){
    const img = document.getElementById('preview');
    if(!fn){ img.style.display='none'; return; }
    img.src = '<%=ctx%>/assets/images/dishes/' + fn;
    img.style.display = 'inline-block';
  }
</script>
</body>
</html>
