<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  String ctx = request.getContextPath();
  Object error = request.getAttribute("error");
  Object success = request.getAttribute("success");
  String v = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Create Your Account</title>
<style>
  :root{
    --bg:#f6f7fb; --card:#ffffff; --text:#1f2937; --muted:#6b7280;
    --primary:#ef476f; --primary2:#e11d48; --ring:#fde2e7; --border:#e5e7eb;
    --ok:#10b981; --err:#ef4444;
  }
  *{box-sizing:border-box}
  html,body{height:100%}
  body{margin:0;background:var(--bg);color:var(--text);font:16px/1.5 system-ui,Segoe UI,Roboto,Arial}
  .wrap{min-height:100%;display:grid;place-items:center;padding:24px}
  .card{width:100%;max-width:620px;background:var(--card);border:1px solid var(--border);
        border-radius:18px;box-shadow:0 12px 30px rgba(31,41,55,.08);padding:26px 26px 22px}
  h1{margin:0 0 16px;font-weight:800;letter-spacing:.2px;text-align:center}
  .sub{margin:-6px 0 14px;text-align:center;color:var(--muted);font-size:14px}

  .grid{display:grid;gap:14px}
  .grid-2{grid-template-columns:1fr 1fr}
  @media (max-width:640px){.grid-2{grid-template-columns:1fr}}

  label{display:block;font-size:14px;color:#7a1b28;font-weight:700;margin:2px 0 6px}
  .field{position:relative}
  .icon{position:absolute;left:12px;top:50%;transform:translateY(-50%);width:18px;height:18px;opacity:.7}
  .eye{position:absolute;right:12px;top:50%;transform:translateY(-50%);width:20px;height:20px;border:0;background:transparent;cursor:pointer;opacity:.7}
  input[type="text"],input[type="email"],input[type="tel"],input[type="password"]{
    width:100%;height:48px;padding:12px 40px;border:2px solid #fbd2da;border-radius:12px;background:#fff;
    outline:none;transition:.15s; font-size:15px;
  }
  input::placeholder{color:#c58593}
  input:focus{border-color:#f4aab8;box-shadow:0 0 0 4px var(--ring)}
  .hint{font-size:12px;color:#c14b5f;margin-top:6px}

  .alert{padding:10px 12px;border-radius:10px;margin:6px 0 14px;font-weight:600}
  .alert.err{border:1px solid #fecaca;background:#fff1f2;color:#7f1d1d}
  .alert.ok{border:1px solid #bbf7d0;background:#ecfdf5;color:#064e3b}

  .terms{display:flex;align-items:center;gap:10px;margin:6px 0 2px;font-weight:600}
  .terms a{color:var(--primary2);text-decoration:none}
  .terms a:hover{text-decoration:underline}

  .btn{
    width:100%;height:50px;border:0;border-radius:14px;cursor:pointer;
    color:#fff;font-weight:800;letter-spacing:.2px;
    background:linear-gradient(90deg,var(--primary),var(--primary2));
    box-shadow:0 10px 22px rgba(225,29,72,.22);
  }
  .btn:hover{filter:brightness(1.04)}
  .foot{text-align:center;margin-top:10px}
  .link{color:var(--primary2);text-decoration:none;font-weight:700}
  .link:hover{text-decoration:underline}
  /* Unified control style for all inputs */
.control{
  width:100%; height:48px; padding:12px 40px;
  border:2px solid #fecaca; border-radius:12px; background:#fff;
  font-size:15px; outline:none; transition:.15s;
}
.control::placeholder{ color:#c58593 }
.control:focus{ border-color:#f4aab8; box-shadow:0 0 0 4px #ffe2e8 }

/* keep icons aligned */
.field{ position:relative }
.field .icon{ position:absolute; left:12px; top:50%; transform:translateY(-50%); width:18px; height:18px; opacity:.7 }
.field .eye{ position:absolute; right:12px; top:50%; transform:translateY(-50%); width:20px; height:20px; border:0; background:transparent; cursor:pointer; opacity:.7 }

/* two-column row */
.row{ display:grid; grid-template-columns:1fr 1fr; gap:14px }
@media (max-width:560px){ .row{ grid-template-columns:1fr } }

</style>
</head>
<body>
<div class="wrap">
  <div class="card">
    <h1>Create Your Account</h1>
    <p class="sub">Book tables faster & manage your orders easily</p>

    <% if (error != null) { %>
      <div class="alert err">⚠ <%= error %></div>
    <% } else if (success != null) { %>
      <div class="alert ok">✅ <%= success %></div>
    <% } %>

    <form method="post" action="<%= ctx %>/register" class="grid">
        <!-- Username (required) -->
        <div class="field">
          <svg class="icon" viewBox="0 0 24 24" fill="currentColor"><path d="M12 12a5 5 0 1 0-5-5 5 5 0 0 0 5 5Zm0 2c-5 0-9 2.5-9 5.5A1.5 1.5 0 0 0 4.5 21h15A1.5 1.5 0 0 0 21 19.5C21 16.5 17 14 12 14Z"/></svg>
          <input class="control" name="username" placeholder="Username"
                 required minlength="4" maxlength="20"
                 value="<%= request.getAttribute("v_username")!=null?request.getAttribute("v_username"):"" %>">
        </div>

        <!-- First / Last name (required, NO digits) -->
        <div class="row">
          <div class="field">
            <svg class="icon" viewBox="0 0 24 24" fill="currentColor"><path d="M12 12a5 5 0 1 0-5-5 5 5 0 0 0 5 5Zm0 2c-5 0-9 2.5-9 5.5A1.5 1.5 0 0 0 4.5 21h15A1.5 1.5 0 0 0 21 19.5C21 16.5 17 14 12 14Z"/></svg>
            <input class="control" name="firstName" placeholder="Your first name"
                   required
                   pattern="^[A-Za-zÀ-ỹĐđ\s'’-]+$"
                   title="Letters only (no digits)"
                   value="<%= request.getAttribute("v_first")!=null?request.getAttribute("v_first"):"" %>">
          </div>
          <div class="field">
            <svg class="icon" viewBox="0 0 24 24" fill="currentColor"><path d="M12 12a5 5 0 1 0-5-5 5 5 0 0 0 5 5Zm0 2c-5 0-9 2.5-9 5.5A1.5 1.5 0 0 0 4.5 21h15A1.5 1.5 0 0 0 21 19.5C21 16.5 17 14 12 14Z"/></svg>
            <input class="control" name="lastName" placeholder="Your last name"
                   required
                   pattern="^[A-Za-zÀ-ỹĐđ\s'’-]+$"
                   title="Letters only (no digits)"
                   value="<%= request.getAttribute("v_last")!=null?request.getAttribute("v_last"):"" %>">
          </div>
        </div>

        <!-- Email (required) -->
        <div class="field">
          <svg class="icon" viewBox="0 0 24 24" fill="currentColor"><path d="M2 6a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v.4l-10 6.25L2 6.4V6Zm0 3.15V18a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9.15l-9.3 5.8a2 2 0 0 1-2.4 0L2 9.15Z"/></svg>
          <input class="control" type="email" name="email" placeholder="your.email@example.com" required
                 value="<%= request.getAttribute("v_email")!=null?request.getAttribute("v_email"):"" %>">
        </div>

        <!-- Phone (required) -->
        <div class="field">
          <svg class="icon" viewBox="0 0 24 24" fill="currentColor"><path d="M6.6 10.8a15.9 15.9 0 0 0 6.6 6.6l2.2-2.2a1 1 0 0 1 1.02-.24 11.9 11.9 0 0 0 3.78.6 1 1 0 0 1 1 1V20a1 1 0 0 1-1 1A17 17 0 0 1 3 8a1 1 0 0 1 1-1h3.44a1 1 0 0 1 1 1 11.9 11.9 0 0 0 .6 3.78 1 1 0 0 1-.24 1.02L6.6 10.8Z"/></svg>
          <input class="control" type="tel" name="phone" placeholder="10-digit phone number"
                 required pattern="^\d{10}$" title="10 digits">
        </div>

        <!-- Password (required) -->
        <div class="field">
          <svg class="icon" viewBox="0 0 24 24" fill="currentColor"><path d="M17 9V7a5 5 0 1 0-10 0v2H5a1 1 0 0 0-1 1v10a1 1 0 0 0 1 1h14a1 1 0 0 0 1-1V10a1 1 0 0 0-1-1Zm-8-2a3 3 0 0 1 6 0v2H9Zm3 6a1.5 1.5 0 1 1-1.5 1.5A1.5 1.5 0 0 1 12 13Z"/></svg>
          <input id="pwd" class="control" type="password" name="password" placeholder="Create a password"
                 required minlength="6">
          <button type="button" class="eye" id="togglePwd" aria-label="Toggle password">•</button>
        </div>

        <!-- Terms (required) -->
        <label class="terms">
          <input type="checkbox" name="acceptTerms" required
                 <%= Boolean.TRUE.equals(request.getAttribute("v_terms")) ? "checked" : "" %> />
          I agree to the <a href="#">Terms</a> &amp; <a href="#">Privacy Policy</a>
        </label>


      <button class="btn">Create Account</button>

      <p class="foot">Already have an account? <a class="link" href="<%= ctx %>/login">Log In</a></p>
    </form>
  </div>
</div>

<script>
  const btn = document.getElementById('togglePwd');
  const pwd = document.getElementById('pwd');
  const icon = document.getElementById('eyeIcon');
  btn.addEventListener('click', () => {
    const show = pwd.type === 'password';
    pwd.type = show ? 'text' : 'password';
    icon.setAttribute('d',''); // reset (required by some browsers)
    icon.outerHTML = show
      ? '<svg id="eyeIcon" viewBox="0 0 24 24" fill="currentColor"><path d="M12 5C7 5 2.73 8.11 1 12c1.73 3.89 6 7 11 7s9.27-3.11 11-7c-1.73-3.89-6-7-11-7Zm0 12a5 5 0 1 1 5-5 5 5 0 0 1-5 5Z"/></svg>'
      : '<svg id="eyeIcon" viewBox="0 0 24 24" fill="currentColor"><path d="M2.1 3.51 1 4.62l4.09 4.1A13.7 13.7 0 0 0 1 12c1.73 3.89 6 7 11 7a11.9 11.9 0 0 0 6.67-2l3.71 3.71 1.11-1.11L2.1 3.51ZM12 17c-3 0-5.5-2.5-5.5-5.5a5.5 5.5 0 0 1 .22-1.56l1.73 1.73A3.5 3.5 0 0 0 12 15.5 3.47 3.47 0 0 0 14.33 14l1.7 1.7A11 11 0 0 1 12 17Zm8.94-5c-.5 1.05-1.25 2-2.17 2.83l-2.2-2.2A5.48 5.48 0 0 0 17.5 11 5.5 5.5 0 0 0 12 5.5a5.48 5.48 0 0 0-1.63.24L8.47 3.84A11.9 11.9 0 0 1 12 3c5 0 9.27 3.11 11 7-.27.61-.61 1.2-1.06 2Z"/></svg>';
  });
</script>
</body>
</html>
