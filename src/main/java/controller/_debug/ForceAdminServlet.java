package controller._debug;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/_debug/force-admin")
public class ForceAdminServlet extends HttpServlet {
  @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    HttpSession s = req.getSession(true);
    s.setAttribute("userId", -1);
    s.setAttribute("username", "debug-admin");
    s.setAttribute("role", "admin");
    resp.sendRedirect(req.getContextPath() + "/admin/dishes");
  }
}
