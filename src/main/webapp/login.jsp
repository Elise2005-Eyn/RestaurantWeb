<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  String ctx = request.getContextPath();
  String error = (String) request.getAttribute("error");
  String vUser = (String) request.getAttribute("v_username");
%>
<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<title>Sign In</title>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<style>
  :root{--primary:#e11d48;--primary2:#ec4899;--muted:#6b7280;--ring:#ffe2e8}
  *{box-sizing:border-box}
  body{margin:0;background:#faf7fb;font:16px/1.5 system-ui,Segoe UI,Roboto,Arial}
  .wrap{min-height:100vh;display:grid;place-items:center;padding:24px}
  .card{width:100%;max-width:420px;background:#fff;border:1px solid #f1f5f9;border-radius:18px;
        box-shadow:0 10px 30px rgba(0,0,0,.06);padding:26px}
  h1{margin:0 0 16px;text-align:center;color:#7a1b28}
  label{display:block;margin:12px 0 6px;font-weight:700;color:#7a1b28}
  .field{position:relative}
  .icon{position:absolute;left:12px;top:50%;transform:translateY(-50%);width:18px;height:18px;opacity:.7}
  input{width:100%;height:48px;padding:12px 14px 12px 40px;border:2px solid #fecaca;border-radius:12px;outline:none;font-size:15px}
  input::placeholder{color:#c58593}
  input:focus{border-color:#f4aab8;box-shadow:0 0 0 4px var(--ring)}
  .btn{width:100%;height:50px;border:none;border-radius:12px;margin-top:14px;color:#fff;font-weight:800;
       background:linear-gradient(90deg,var(--primary),var(--primary2));cursor:pointer;box-shadow:0 8px 18px rgba(236,72,153,.22)}
  .center{text-align:center;margin-top:12px}
  .link{color:var(--primary);text-decoration:none;font-weight:800}
  .error{margin:6px 0 10px;padding:10px 12px;border-radius:10px;border:1px solid #fecaca;background:#fff1f2;color:#7f1d1d}
</style>
</head>
<body>
<div class="wrap">
  <div class="card">
    <h1>Welcome Back</h1>

    <% if (error != null) { %>
      <div class="error">⚠ <%= error %></div>
    <% } %>

    <form method="post" action="<%=ctx%>/login">
      <label>Username</label>
      <div class="field">
        <svg class="icon" viewBox="0 0 24 24" fill="currentColor"><path d="M12 12a5 5 0 1 0-5-5 5 5 0 0 0 5 5Zm0 2c-5 0-9 2.5-9 5.5A1.5 1.5 0 0 0 4.5 21h15A1.5 1.5 0 0 0 21 19.5C21 16.5 17 14 12 14Z"/></svg>
        <input name="username" placeholder="Enter your username" required value="<%= vUser==null? "": vUser %>">
      </div>

      <label>Password</label>
      <div class="field">
        <svg class="icon" viewBox="0 0 24 24" fill="currentColor"><path d="M17 9V7a5 5 0 1 0-10 0v2H5a1 1 0 0 0-1 1v10a1 1 0 0 0 1 1h14a1 1 0 0 0 1-1V10a1 1 0 0 0-1-1Zm-8-2a3 3 0 0 1 6 0v2H9Z"/></svg>
        <input type="password" name="password" placeholder="Enter your password" required>
      </div>

      <button class="btn">Sign In →</button>

      <p class="center">Don't have an account? <a class="link" href="<%=ctx%>/register">Sign Up</a></p>
    </form>
  </div>
</div>
</body>
</html>
