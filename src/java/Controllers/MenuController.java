package Controllers;

import DAO.MenuDAO;
import Models.MenuItem;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/menu")
public class MenuController extends HttpServlet {

    private final MenuDAO dao = new MenuDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list"; // mặc định: xem danh sách

        switch (action) {
            case "list":
                showMenuList(request, response);
                break;
            case "detail":
                showMenuDetail(request, response);
                break;
            default:
                showMenuList(request, response);
                break;
        }
    }

    private void showMenuList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<MenuItem> menuList = dao.getAllMenuItems();
        request.setAttribute("menuList", menuList);
        RequestDispatcher rd = request.getRequestDispatcher("/Views/guest/menu.jsp");
        rd.forward(request, response);
    }

    private void showMenuDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        MenuItem item = dao.getMenuItemById(id);
        request.setAttribute("menuItem", item);
        RequestDispatcher rd = request.getRequestDispatcher("/Views/guest/menu-detail.jsp");
        rd.forward(request, response);
    }
}
