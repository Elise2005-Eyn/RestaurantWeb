<%@ page import="com.restaurant.restaurantmanager.model.User" %>
<%
User user = (User) session.getAttribute("user");
if (user == null) {
    response.sendRedirect("login.jsp");
    return;
}
%>
<html>
<head><title>Home</title></head>
<body>
<h2>Xin ch�o, <%= user.getUsername() %>!</h2>
<p>Vai tr�: <%= user.getRoleName() %></p>
<a href="logout">??ng xu?t</a>
</body>
</html>
