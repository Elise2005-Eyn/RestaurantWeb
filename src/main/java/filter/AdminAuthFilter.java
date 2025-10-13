package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*"})
public class AdminAuthFilter implements Filter {
  private static final boolean DISABLED = true; // <— set true để tắt

  @Override
  public void doFilter(ServletRequest r, ServletResponse s, FilterChain chain)
      throws IOException, ServletException {
    if (DISABLED) { chain.doFilter(r, s); return; }

    HttpServletRequest req = (HttpServletRequest) r;
    HttpSession session = req.getSession(false);
    boolean ok = session != null && "admin".equals(session.getAttribute("role"));
    if (!ok) {
      ((HttpServletResponse)s).sendRedirect(req.getContextPath()+"/login");
      return;
    }
    chain.doFilter(r, s);
  }
}
