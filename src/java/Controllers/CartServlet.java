package Controllers;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;
import Models.CartItem;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/Views/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }

        String action = req.getParameter("action");

        switch (action) {
            case "add":
                int id = Integer.parseInt(req.getParameter("id"));
                String name = req.getParameter("name");
                double price = Double.parseDouble(req.getParameter("price"));
                String image = req.getParameter("image");

                boolean found = false;
                for (CartItem item : cart) {
                    if (item.getId() == id) {
                        item.setQuantity(item.getQuantity() + 1);
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    cart.add(new CartItem(id, name, price, 1, image));
                }
                break;

            case "remove":
                int removeId = Integer.parseInt(req.getParameter("id"));
                cart.removeIf(item -> item.getId() == removeId);
                break;

            case "clear":
                cart.clear();
                break;
        }

        session.setAttribute("cart", cart);
        resp.sendRedirect("cart");
    }
}
