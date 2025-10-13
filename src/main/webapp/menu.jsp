<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, model.Dish" %>
<%
  String ctx = request.getContextPath();
  List<Dish> dishes = (List<Dish>) request.getAttribute("dishes");
%>
<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Our Menu</title>
<style>
  body{font-family:system-ui,Arial;margin:22px}
  h2{margin-bottom:12px}
  .grid{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:16px}
  @media(max-width:900px){.grid{grid-template-columns:repeat(2,1fr)}}
  .card{border:1px solid #eee;border-radius:12px;overflow:hidden;background:#fff}
  .card img{width:100%;height:160px;object-fit:cover}
  .p{padding:12px}
  .title{font-weight:800;margin:0 0 6px}
  .muted{color:#6b7280;font-size:14px;margin:0 0 6px}
  .price{color:#e11d48;font-weight:900}
</style>
</head>
<body>
  <h2>Our Menu</h2>
  <div class="grid">
    <% if (dishes != null) {
         for (Dish d : dishes) { %>
      <div class="card">
        <img src="<%=ctx%>/assets/images/dishes/<%= d.getImagePath()==null? "no-image.png" : d.getImagePath() %>" alt="">
        <div class="p">
          <div class="title"><%= d.getName() %></div>
          <p class="muted"><%= d.getCategory() %></p>
          <div class="price">$<%= d.getPrice() %></div>
        </div>
      </div>
    <% } } %>
  </div>
</body>
</html>
