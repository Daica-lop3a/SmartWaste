package controller;

import dao.UserDAO;
import model.AppUser;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final String ERROR = "/WEB-INF/views/login.jsp";
    private static final String SUCCESS = "/dashboard";

    private final UserDAO users = new UserDAO();

    protected void processRequest(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String url = ERROR;

        try {

            if ("GET".equalsIgnoreCase(request.getMethod())) {
                return;
            }

            String username = request.getParameter("username");
            String password = request.getParameter("password");

            if (username != null) {
                username = username.trim();
            }

            UserDAO dao = new UserDAO();
            AppUser user = dao.findByUsername(username);

            if (user == null) {

                request.setAttribute("ERROR",
                        "Sai email hoac mat khau");

                request.setAttribute("OLD_USERNAME", username);

            } else if (!user.isStatus()) {

                request.setAttribute("ERROR",
                        "Tai khoan da bi khoa");

                request.setAttribute("OLD_USERNAME", username);

            } else if (password == null
                    || !password.equals(user.getPassword())) {

                request.setAttribute("ERROR",
                        "Sai email hoac mat khau");

                request.setAttribute("OLD_USERNAME", username);

            } else {

                HttpSession session = request.getSession();

                session.setAttribute("user", user);

                url = SUCCESS;
            }

        } catch (Exception e) {

            log("Error at LoginServlet: " + e.toString());

            request.setAttribute("ERROR",
                    "System error, please try again");

        } finally {

            if (SUCCESS.equals(url)) {

                response.sendRedirect(
                        request.getContextPath() + url);

            } else {

                request.getRequestDispatcher(url)
                        .forward(request, response);
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);
    }
}