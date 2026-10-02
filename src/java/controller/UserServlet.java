package controller;

import dao.UserDAO;
import model.AppUser;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {
    "/user",
    "/user/create",
    "/user/view",
    "/user/edit",
    "/user/save",
    "/user/delete",
    "/user/lock",
    "/user/reset"
})
public class UserServlet extends HttpServlet {

    private static final String USER_LIST
            = "/WEB-INF/views/userList.jsp";

    private static final String USER_FORM
            = "/WEB-INF/views/userForm.jsp";

    private static final String DEFAULT_PASSWORD = "123456";

    private final UserDAO users = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        String action = action(req);

        if ("/create".equals(action)) {
            showForm(req, resp, null);
            return;
        }
        if ("/view".equals(action)) {

            String id = req.getParameter("id");

            if (id == null || id.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/user");
                return;
            }

            AppUser user = users.findById(id);

            if (user == null) {
                req.setAttribute(
                        "ERROR",
                        "Khong tim thay nguoi dung"
                );

                showList(req, resp);
                return;
            }

            req.setAttribute("USER", user);

            req.getRequestDispatcher(
                    "/WEB-INF/views/userDetail.jsp"
            ).forward(req, resp);

            return;
        }

        if ("/edit".equals(action)) {

            String id = req.getParameter("id");

            if (id == null || id.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/user");
                return;
            }

            AppUser user = users.findById(id);

            if (user == null) {
                req.setAttribute("ERROR",
                        "Khong tim thay nguoi dung");

                showList(req, resp);
                return;
            }

            showForm(req, resp, user);
            return;
        }

        showList(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        String action = action(req);

        if ("/save".equals(action)) {
            save(req, resp);
            return;
        }

        if ("/delete".equals(action)) {
            delete(req, resp);
            return;
        }

        if ("/lock".equals(action)) {
            lock(req, resp);
            return;
        }

        if ("/reset".equals(action)) {
            reset(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/user");
    }

    private String action(HttpServletRequest req) {

        String path = req.getRequestURI()
                .substring(req.getContextPath().length());

        return path.substring("/user".length());
    }

    // =========================
    // LIST
    // =========================
    private void showList(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        try {

            String keyword = req.getParameter("keyword");
            String roleId = req.getParameter("roleId");

            if (keyword == null) {
                keyword = "";
            }

            if (roleId == null) {
                roleId = "";
            }

            req.setAttribute("LIST_USER",
                    users.search(keyword, roleId));

            req.setAttribute("KEYWORD", keyword);
            req.setAttribute("ROLE_ID", roleId);

            req.getRequestDispatcher(USER_LIST)
                    .forward(req, resp);

        } catch (Exception e) {

            log("Error at showList: " + e.toString());

            req.setAttribute("ERROR",
                    "System error");

            req.getRequestDispatcher(USER_LIST)
                    .forward(req, resp);
        }
    }

    // =========================
    // FORM
    // =========================
    private void showForm(HttpServletRequest req,
            HttpServletResponse resp,
            AppUser user)
            throws ServletException, IOException {

        req.setAttribute("USER", user);

        req.getRequestDispatcher(USER_FORM)
                .forward(req, resp);
    }

    // =========================
    // SAVE
    // =========================
    private void save(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        String userId = req.getParameter("userId");

        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phoneNumber = req.getParameter("phoneNumber");
        String roleId = req.getParameter("roleId");

        if (fullName == null) {
            fullName = "";
        }

        if (email == null) {
            email = "";
        }

        if (phoneNumber == null) {
            phoneNumber = "";
        }

        if (roleId == null) {
            roleId = "";
        }

        fullName = fullName.trim();
        email = email.trim();
        phoneNumber = phoneNumber.trim();
        roleId = roleId.trim();

        // =========================
        // VALIDATE
        // =========================
        if (userId == null || userId.trim().isEmpty()) {

            req.setAttribute("ERROR",
                    "User ID khong duoc de trong");

            showFormWithValues(req, resp);
            return;
        }

        if (fullName.length() < 2) {

            req.setAttribute("ERROR",
                    "Ho ten phai tu 2 ky tu");

            showFormWithValues(req, resp);
            return;
        }

        if (email.length() == 0
                || !email.contains("@")) {

            req.setAttribute("ERROR",
                    "Email khong hop le");

            showFormWithValues(req, resp);
            return;
        }

        if (phoneNumber.length() == 0) {

            req.setAttribute("ERROR",
                    "So dien thoai khong duoc de trong");

            showFormWithValues(req, resp);
            return;
        }

        if (!roleId.equals("ADM")
                && !roleId.equals("MGR")
                && !roleId.equals("STF")
                && !roleId.equals("TEC")) {

            req.setAttribute("ERROR",
                    "Role khong hop le");

            showFormWithValues(req, resp);
            return;
        }

        try {

            AppUser user = new AppUser();

            user.setUserId(userId);
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhoneNumber(phoneNumber);
            user.setRoleId(roleId);

            String oldId = req.getParameter("oldId");

            if (oldId == null || oldId.trim().isEmpty()) {

                // CREATE
                user.setPassword(DEFAULT_PASSWORD);
                user.setStatus(true);

                boolean result = users.insert(user);

                if (!result) {

                    req.setAttribute("ERROR",
                            "Khong tao duoc tai khoan");

                    showFormWithValues(req, resp);
                    return;
                }

            } else {

                // UPDATE
                boolean result = users.update(user);

                if (!result) {

                    req.setAttribute("ERROR",
                            "Khong cap nhat duoc tai khoan");

                    showFormWithValues(req, resp);
                    return;
                }
            }

            resp.sendRedirect(req.getContextPath()
                    + "/user");

        } catch (Exception e) {

            log("Error at save: " + e.toString());

            req.setAttribute("ERROR",
                    "System error");

            showFormWithValues(req, resp);
        }
    }

    // =========================
    // DELETE
    // =========================
    private void delete(HttpServletRequest req,
            HttpServletResponse resp)
            throws IOException {

        String userId = req.getParameter("id");

        if (userId == null || userId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/user");
            return;
        }

        try {

            boolean result = users.delete(userId);

            if (!result) {
                req.getSession().setAttribute(
                        "ERROR",
                        "Khong xoa duoc tai khoan");
            }

        } catch (Exception e) {

            log("Error at delete: " + e.toString());

        }

        resp.sendRedirect(req.getContextPath()
                + "/user");
    }

    // =========================
    // LOCK / UNLOCK
    // =========================
    private void lock(HttpServletRequest req,
            HttpServletResponse resp)
            throws IOException {

        String userId = req.getParameter("id");

        if (userId == null || userId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/user");
            return;
        }

        try {

            AppUser user = users.findById(userId);

            if (user != null) {

                boolean newStatus = !user.isStatus();

                users.setStatus(userId, newStatus);
            }

        } catch (Exception e) {

            log("Error at lock: " + e.toString());
        }

        resp.sendRedirect(req.getContextPath()
                + "/user");
    }

    // =========================
    // RESET PASSWORD
    // =========================
    private void reset(HttpServletRequest req,
            HttpServletResponse resp)
            throws IOException {

        String userId = req.getParameter("id");

        if (userId == null || userId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/user");
            return;
        }

        try {

            users.resetPassword(
                    userId,
                    DEFAULT_PASSWORD
            );

        } catch (Exception e) {

            log("Error at reset: " + e.toString());
        }

        resp.sendRedirect(req.getContextPath()
                + "/user");
    }

    // =========================
    // FORM VALUES
    // =========================
    private void showFormWithValues(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        AppUser user = new AppUser();

        user.setUserId(req.getParameter("userId"));
        user.setFullName(req.getParameter("fullName"));
        user.setEmail(req.getParameter("email"));
        user.setPhoneNumber(req.getParameter("phoneNumber"));
        user.setRoleId(req.getParameter("roleId"));

        req.setAttribute("USER", user);

        req.getRequestDispatcher(USER_FORM)
                .forward(req, resp);
    }
}
