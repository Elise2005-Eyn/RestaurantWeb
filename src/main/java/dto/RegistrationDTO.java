package dto;

import jakarta.servlet.http.HttpServletRequest;

public record RegistrationDTO(
        String username,
        String email,
        String password,
        String firstName,
        String lastName,
        String phone,
        boolean acceptTerms
) {
    public String fullName() {
        String f = firstName == null ? "" : firstName.trim();
        String l = lastName  == null ? "" : lastName.trim();
        return (f + " " + l).trim();
    }

    public static RegistrationDTO from(HttpServletRequest req) {
        String username  = trim(req.getParameter("username"));
        String email     = trim(req.getParameter("email"));
        String password  = req.getParameter("password");
        String firstName = trim(req.getParameter("firstName"));
        String lastName  = trim(req.getParameter("lastName"));
        String phone     = trim(req.getParameter("phone"));
        boolean terms    = "on".equalsIgnoreCase(req.getParameter("acceptTerms"))
                        || "true".equalsIgnoreCase(req.getParameter("acceptTerms"));
        return new RegistrationDTO(username, email, password, firstName, lastName, phone, terms);
    }

    public void backfill(HttpServletRequest req) {
        req.setAttribute("v_username", username);
        req.setAttribute("v_email", email);
        req.setAttribute("v_first", firstName);
        req.setAttribute("v_last", lastName);
        req.setAttribute("v_phone", phone);
        req.setAttribute("v_terms", acceptTerms);
    }

    private static String trim(String s){ return s == null ? null : s.trim(); }
}
