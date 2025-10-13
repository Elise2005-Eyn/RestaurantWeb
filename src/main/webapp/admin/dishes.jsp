<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, model.Dish" %>
<%
  String ctx = request.getContextPath();
  List<Dish> dishes = (List<Dish>) request.getAttribute("dishes");
  String q = (String) request.getAttribute("q"); // servlet setAttribute("q", q)
%>
<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Admin • Dishes</title>
<style>
  body{font-family:system-ui,Arial;margin:22px}
  .toolbar{display:flex;gap:12px;align-items:center;justify-content:space-between;flex-wrap:wrap}
  .left{display:flex;align-items:center;gap:12px}
  .search{display:flex;gap:8px;align-items:center}
  .search input{height:38px;padding:8px 10px;border:1px solid #e5e7eb;border-radius:8px;min-width:280px}
  a.btn, button.btn{background:#e11d48;color:#fff;padding:8px 12px;border:none;border-radius:8px;text-decoration:none;cursor:pointer}
  a.btn.secondary{background:#64748b}
  table{width:100%;border-collapse:collapse;margin-top:14px}
  th,td{border:1px solid #eee;padding:10px;text-align:left}
  th{background:#f8fafc}
  img.thumb{height:60px;border-radius:8px}
  .muted{color:#6b7280;font-size:14px;margin:8px 0}
</style>
</head>
<body>

  <div class="toolbar">
    <div class="left">
      <h2 style="margin:0">Dishes</h2>
      <form class="search" method="get" action="<%=ctx%>/admin/dishes">
        <input type="text" name="q" placeholder="Search by name, category, description..."
               value="<%= q==null? "" : q %>">
        <button class="btn" type="submit">Search</button>
        <% if (q != null && !q.trim().isEmpty()) { %>
          <a class="btn secondary" href="<%=ctx%>/admin/dishes">Clear</a>
        <% } %>
      </form>
    </div>
    <a class="btn" href="<%=ctx%>/admin/dishes/create">+ New Dish</a>
  </div>

  <% if (q != null && !q.trim().isEmpty()) { %>
    <div class="muted">
      Showing <b><%= dishes == null ? 0 : dishes.size() %></b> result(s) for "<b><%= q %></b>".
    </div>
  <% } %>

  <table>
    <thead>
      <tr>
        <th>ID</th><th>Image</th><th>Name</th><th>Category</th><th>Price</th><th>Actions</th>
      </tr>
    </thead>
    <tbody>
    <% if (dishes != null && !dishes.isEmpty()) {
         for (Dish d: dishes) { %>
      <tr>
        <td><%= d.getId() %></td>
        <td>
          <img class="thumb"
               src="<%=ctx%>/assets/images/dishes/<%= d.getImagePath()==null? "no-image.png" : d.getImagePath() %>"
               alt="">
        </td>
        <td><%= d.getName() %></td>
        <td><%= d.getCategory() %></td>
        <td>$<%= d.getPrice() %></td>
        <td>
          <a class="btn secondary" href="<%=ctx%>/admin/dishes/edit?id=<%=d.getId()%>">Edit</a>
          <form action="<%=ctx%>/admin/dishes/delete" method="post" style="display:inline"
                onsubmit="return confirm('Delete this dish?');">
            <input type="hidden" name="id" value="<%=d.getId()%>">
            <button class="btn" style="background:#ef4444">Delete</button>
          </form>
        </td>
      </tr>
    <% } } else { %>
      <tr><td colspan="6">No dishes yet.</td></tr>
    <% } %>
    </tbody>
  </table>
</body>
</html>
