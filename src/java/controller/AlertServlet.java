package controller;

import dao.AlertDAO;
import dao.WasteBinDAO;
import model.Alert;
import model.AppUser;
import model.WasteBin;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet("/alert/*")
public class AlertServlet extends HttpServlet {

    private final AlertDAO alertDAO = new AlertDAO();
    private final WasteBinDAO binDAO = new WasteBinDAO();

    @Override
    protected void doGet(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        AppUser user = (AppUser) session.getAttribute("user");
        String path = req.getPathInfo();

        // =========================
        // ALERT LIST
        // =========================
        if (path == null || "/".equals(path)) {
            showList(req, resp);
            return;
        }

        // =========================
        // VIEW DETAIL
        // ADM / MGR / STF / TEC
        // =========================
        if ("/view".equals(path)) {

            String alertID = req.getParameter("id");

            if (alertID == null || alertID.trim().isEmpty()) {
                showList(req, resp);
                return;
            }

            Alert alert = alertDAO.findByID(alertID);

            if (alert == null) {
                req.setAttribute(
                        "ERROR",
                        "Alert không tồn tại."
                );

                showList(req, resp);
                return;
            }

            req.setAttribute("ALERT", alert);

            req.getRequestDispatcher(
                    "/WEB-INF/views/alertDetail.jsp")
                    .forward(req, resp);

            return;
        }

        // =========================
        // CREATE
        // ADM / MGR ONLY
        // =========================
        if ("/create".equals(path)) {

            if (!canManage(user)) {
                showDenied(req, resp);
                return;
            }

            loadFormData(req);

            req.getRequestDispatcher(
                    "/WEB-INF/views/alertForm.jsp")
                    .forward(req, resp);

            return;
        }

        // =========================
        // EDIT
        // ADM / MGR ONLY
        // =========================
        if ("/edit".equals(path)) {

            if (!canManage(user)) {
                showDenied(req, resp);
                return;
            }

            String alertID = req.getParameter("id");

            Alert alert = alertDAO.findByID(alertID);

            if (alert == null) {

                req.setAttribute(
                        "ERROR",
                        "Alert không tồn tại."
                );

                showList(req, resp);
                return;
            }

            loadFormData(req);

            req.setAttribute("ALERT", alert);

            req.getRequestDispatcher(
                    "/WEB-INF/views/alertForm.jsp")
                    .forward(req, resp);

            return;
        }

        showDenied(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        AppUser user = (AppUser) session.getAttribute("user");
        String path = req.getPathInfo();

        // =========================
        // SAVE
        // =========================
        if ("/save".equals(path)) {

            if (!canManage(user)) {
                showDenied(req, resp);
                return;
            }

            save(req, resp);
            return;
        }

        // =========================
        // DELETE
        // =========================
        if ("/delete".equals(path)) {

            if (!canManage(user)) {
                showDenied(req, resp);
                return;
            }

            delete(req, resp);
            return;
        }

        // =========================
        // RESOLVE / UNRESOLVE
        // =========================
        if ("/resolve".equals(path)) {

            if (!canManage(user)) {
                showDenied(req, resp);
                return;
            }

            resolve(req, resp);
            return;
        }

        showDenied(req, resp);
    }

    // =====================================================
    // SHOW LIST
    // =====================================================
    private void showList(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        List<Alert> list = alertDAO.getAll();

        req.setAttribute("LIST_ALERT", list);

        req.getRequestDispatcher(
                "/WEB-INF/views/alertList.jsp")
                .forward(req, resp);
    }

    // =====================================================
    // LOAD FORM DATA
    // =====================================================
    private void loadFormData(HttpServletRequest req) {

        List<WasteBin> bins = binDAO.getAll();

        req.setAttribute("LIST_BIN", bins);
    }

    // =====================================================
    // SAVE
    // =====================================================
    private void save(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        String alertID = req.getParameter("alertID");
        String binID = req.getParameter("binID");
        String alertType = req.getParameter("alertType");
        String message = req.getParameter("message");

        String error = validate(
                alertID,
                binID,
                alertType,
                message
        );

        // =========================
        // VALIDATION ERROR
        // =========================
        if (error != null) {

            Alert alert = new Alert();

            alert.setAlertID(alertID);
            alert.setBinID(binID);
            alert.setAlertType(alertType);
            alert.setMessage(message);

            req.setAttribute("ERROR", error);
            req.setAttribute("ALERT", alert);

            loadFormData(req);

            req.getRequestDispatcher(
                    "/WEB-INF/views/alertForm.jsp")
                    .forward(req, resp);

            return;
        }

        // =========================
        // CHECK OLD ALERT
        // =========================
        Alert oldAlert = alertDAO.findByID(alertID);

        Alert alert = new Alert();

        alert.setAlertID(alertID);
        alert.setBinID(binID);
        alert.setAlertType(alertType);
        alert.setMessage(message);

        // =========================
        // CREATE
        // =========================
        if (oldAlert == null) {

            alert.setCreatedDate(
                    new Timestamp(
                            System.currentTimeMillis()
                    )
            );

            alert.setResolved(false);

            alertDAO.insert(alert);

        } else {

            // =========================
            // UPDATE
            // =========================
            alert.setCreatedDate(
                    oldAlert.getCreatedDate()
            );

            alert.setResolved(
                    oldAlert.isResolved()
            );

            alertDAO.update(alert);
        }

        resp.sendRedirect(
                req.getContextPath() + "/alert"
        );
    }

    // =====================================================
    // DELETE
    // =====================================================
    private void delete(HttpServletRequest req,
            HttpServletResponse resp)
            throws IOException {

        String alertID = req.getParameter("id");

        if (alertID != null
                && !alertID.trim().isEmpty()) {

            alertDAO.delete(alertID);
        }

        resp.sendRedirect(
                req.getContextPath() + "/alert"
        );
    }

    // =====================================================
    // RESOLVE / UNRESOLVE
    // =====================================================
    private void resolve(HttpServletRequest req,
            HttpServletResponse resp)
            throws IOException {

        String alertID = req.getParameter("id");
        String value = req.getParameter("value");

        if (alertID != null
                && !alertID.trim().isEmpty()) {

            boolean resolved
                    = "true".equalsIgnoreCase(value);

            alertDAO.setResolved(
                    alertID,
                    resolved
            );
        }

        resp.sendRedirect(
                req.getContextPath() + "/alert"
        );
    }

    // =====================================================
    // VALIDATE
    // =====================================================
    private String validate(String alertID,
            String binID,
            String alertType,
            String message) {

        if (alertID == null
                || alertID.trim().isEmpty()) {

            return "Alert ID không được để trống.";
        }

        if (binID == null
                || binID.trim().isEmpty()) {

            return "Bin ID không được để trống.";
        }

        if (alertType == null
                || alertType.trim().isEmpty()) {

            return "Alert Type không được để trống.";
        }

        if (message == null
                || message.trim().isEmpty()) {

            return "Message không được để trống.";
        }

        return null;
    }

    // =====================================================
    // CHECK ROLE
    // =====================================================
    private boolean canManage(AppUser user) {

        return "ADM".equals(user.getRoleId())
                || "MGR".equals(user.getRoleId());
    }

    // =====================================================
    // DENIED
    // =====================================================
    private void showDenied(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher(
                "/WEB-INF/views/denied.jsp")
                .forward(req, resp);
    }
}
