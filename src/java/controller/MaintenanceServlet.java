package controller;

import dao.MaintenanceDAO;
import dao.UserDAO;
import dao.WasteBinDAO;
import model.AppUser;
import model.Maintenance;
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

@WebServlet("/maintenance/*")
public class MaintenanceServlet extends HttpServlet {

    private final MaintenanceDAO maintenanceDAO = new MaintenanceDAO();
    private final WasteBinDAO binDAO = new WasteBinDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null
                || session.getAttribute("user") == null) {

            resp.sendRedirect(
                    req.getContextPath() + "/login");
            return;
        }

        AppUser user
                = (AppUser) session.getAttribute("user");

        String role = user.getRoleId();
        String path = req.getPathInfo();

        // =====================================================
        // MAINTENANCE LIST
        // =====================================================
        if (path == null || "/".equals(path)) {

            List<Maintenance> list;

            if ("TEC".equals(role)) {

                list = maintenanceDAO.getByTechnician(
                        user.getUserId());

            } else {

                list = maintenanceDAO.getAll();
            }

            req.setAttribute(
                    "LIST_MAINTENANCE",
                    list);

            req.getRequestDispatcher(
                    "/WEB-INF/views/maintenanceList.jsp")
                    .forward(req, resp);

            return;
        }

        // =====================================================
        // VIEW DETAIL
        // =====================================================
        if ("/view".equals(path)) {

            String id = req.getParameter("id");

            if (id == null || id.trim().isEmpty()) {

                resp.sendRedirect(
                        req.getContextPath()
                        + "/maintenance");

                return;
            }

            Maintenance maintenance
                    = maintenanceDAO.findByID(id);

            if (maintenance == null) {

                resp.sendRedirect(
                        req.getContextPath()
                        + "/maintenance");

                return;
            }

            // TEC chỉ được xem maintenance của chính mình
            if ("TEC".equals(role)
                    && !user.getUserId().equals(
                            maintenance.getTechnicianID())) {

                showDenied(req, resp);
                return;
            }

            req.setAttribute(
                    "MAINTENANCE",
                    maintenance);

            req.getRequestDispatcher(
                    "/WEB-INF/views/maintenanceDetail.jsp")
                    .forward(req, resp);

            return;
        }

        // =====================================================
        // CREATE
        // ADM / MGR ONLY
        // =====================================================
        if ("/create".equals(path)) {

            if (!"ADM".equals(role)
                    && !"MGR".equals(role)) {

                showDenied(req, resp);
                return;
            }

            loadFormData(req);

            req.setAttribute(
                    "MODE",
                    "CREATE");

            req.getRequestDispatcher(
                    "/WEB-INF/views/maintenanceForm.jsp")
                    .forward(req, resp);

            return;
        }

        // =====================================================
        // EDIT
        // =====================================================
        if ("/edit".equals(path)) {

            String id = req.getParameter("id");

            if (id == null || id.trim().isEmpty()) {

                resp.sendRedirect(
                        req.getContextPath()
                        + "/maintenance");

                return;
            }

            Maintenance maintenance
                    = maintenanceDAO.findByID(id);

            if (maintenance == null) {

                resp.sendRedirect(
                        req.getContextPath()
                        + "/maintenance");

                return;
            }

            // TEC chỉ được sửa maintenance của chính mình
            if ("TEC".equals(role)) {

                if (!user.getUserId().equals(
                        maintenance.getTechnicianID())) {

                    showDenied(req, resp);
                    return;
                }
            }

            // Chỉ ADM / MGR / TEC
            if (!"ADM".equals(role)
                    && !"MGR".equals(role)
                    && !"TEC".equals(role)) {

                showDenied(req, resp);
                return;
            }

            loadFormData(req);

            req.setAttribute(
                    "MAINTENANCE",
                    maintenance);

            req.setAttribute(
                    "MODE",
                    "EDIT");

            req.getRequestDispatcher(
                    "/WEB-INF/views/maintenanceForm.jsp")
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

        if (session == null
                || session.getAttribute("user") == null) {

            resp.sendRedirect(
                    req.getContextPath() + "/login");

            return;
        }

        AppUser user
                = (AppUser) session.getAttribute("user");

        String role = user.getRoleId();
        String path = req.getPathInfo();

        // =====================================================
        // SAVE
        // =====================================================
        if ("/save".equals(path)) {

            save(req, resp, user, role);
            return;
        }

        // =====================================================
        // DELETE
        // =====================================================
        if ("/delete".equals(path)) {

            if (!"ADM".equals(role)
                    && !"MGR".equals(role)) {

                showDenied(req, resp);
                return;
            }

            String id = req.getParameter("id");

            if (id != null && !id.trim().isEmpty()) {

                maintenanceDAO.delete(id);
            }

            resp.sendRedirect(
                    req.getContextPath()
                    + "/maintenance");

            return;
        }

        showDenied(req, resp);
    }

    // =====================================================
    // SAVE
    // =====================================================
    private void save(HttpServletRequest req,
            HttpServletResponse resp,
            AppUser user,
            String role)
            throws ServletException, IOException {

        String maintenanceID
                = req.getParameter("maintenanceID");

        String binID
                = req.getParameter("binID");

        String technicianID
                = req.getParameter("technicianID");

        String maintenanceType
                = req.getParameter("maintenanceType");

        String status
                = req.getParameter("status");

        String scheduledDate
                = req.getParameter("scheduledDate");

        String completedDate
                = req.getParameter("completedDate");

        String description
                = req.getParameter("description");

        // =====================================================
        // CHECK EXISTING
        // =====================================================
        Maintenance old = null;

        if (maintenanceID != null
                && !maintenanceID.trim().isEmpty()) {

            old = maintenanceDAO.findByID(
                    maintenanceID);
        }

        // =====================================================
        // TEC RULE
        // =====================================================
        if ("TEC".equals(role)) {

            // TEC không được tạo mới
            if (old == null) {

                showDenied(req, resp);
                return;
            }

            // TEC chỉ sửa maintenance của mình
            if (!user.getUserId().equals(
                    old.getTechnicianID())) {

                showDenied(req, resp);
                return;
            }

            // TEC không được đổi các thông tin này
            binID = old.getBinID();

            technicianID
                    = old.getTechnicianID();

            maintenanceType
                    = old.getMaintenanceType();
        }

        // =====================================================
        // ROLE CHECK
        // =====================================================
        if (!"ADM".equals(role)
                && !"MGR".equals(role)
                && !"TEC".equals(role)) {

            showDenied(req, resp);
            return;
        }

        // =====================================================
        // VALIDATE REQUIRED FIELDS
        // =====================================================
        if (maintenanceID == null
                || maintenanceID.trim().isEmpty()
                || binID == null
                || binID.trim().isEmpty()
                || technicianID == null
                || technicianID.trim().isEmpty()
                || maintenanceType == null
                || maintenanceType.trim().isEmpty()
                || status == null
                || status.trim().isEmpty()) {

            showFormError(
                    req,
                    resp,
                    "Vui lòng nhập đầy đủ thông tin.");

            return;
        }

        // =====================================================
        // VALIDATE STATUS
        // =====================================================
        if (!isValidStatus(status)) {

            showFormError(
                    req,
                    resp,
                    "Status không hợp lệ.");

            return;
        }

        // =====================================================
        // VALIDATE TYPE
        // =====================================================
        if (!isValidType(maintenanceType)) {

            showFormError(
                    req,
                    resp,
                    "Maintenance Type không hợp lệ.");

            return;
        }

        // =====================================================
        // PARSE DATE
        // =====================================================
        Timestamp scheduledTimestamp
                = parseTimestamp(scheduledDate);

        Timestamp completedTimestamp
                = parseTimestamp(completedDate);

        if (scheduledDate != null
                && !scheduledDate.trim().isEmpty()
                && scheduledTimestamp == null) {

            showFormError(
                    req,
                    resp,
                    "Scheduled Date không hợp lệ.");

            return;
        }

        if (completedDate != null
                && !completedDate.trim().isEmpty()
                && completedTimestamp == null) {

            showFormError(
                    req,
                    resp,
                    "Completed Date không hợp lệ.");

            return;
        }

        // =====================================================
        // COMPLETED => AUTO TIME
        // =====================================================
        if ("Completed".equals(status)
                && completedTimestamp == null) {

            completedTimestamp
                    = new Timestamp(
                            System.currentTimeMillis());
        }

        // =====================================================
        // CREATE MAINTENANCE OBJECT
        // =====================================================
        Maintenance maintenance
                = new Maintenance();

        maintenance.setMaintenanceID(
                maintenanceID);

        maintenance.setBinID(
                binID);

        maintenance.setTechnicianID(
                technicianID);

        maintenance.setMaintenanceType(
                maintenanceType);

        maintenance.setStatus(
                status);

        maintenance.setScheduledDate(
                scheduledTimestamp);

        maintenance.setCompletedDate(
                completedTimestamp);

        maintenance.setDescription(
                description);

        // =====================================================
        // INSERT / UPDATE
        // =====================================================
        boolean success;

        if (old == null) {

            // Chỉ ADM / MGR được tạo
            if (!"ADM".equals(role)
                    && !"MGR".equals(role)) {

                showDenied(req, resp);
                return;
            }

            success
                    = maintenanceDAO.insert(
                            maintenance);

        } else {

            success
                    = maintenanceDAO.update(
                            maintenance);
        }

        if (!success) {

            showFormError(
                    req,
                    resp,
                    "Không thể lưu maintenance.");

            return;
        }

        resp.sendRedirect(
                req.getContextPath()
                + "/maintenance");
    }

    // =====================================================
    // LOAD FORM DATA
    // =====================================================
    private void loadFormData(
            HttpServletRequest req) {

        List<WasteBin> bins
                = binDAO.getAll();

        List<AppUser> technicians
                = userDAO.search("", "TEC");

        req.setAttribute(
                "LIST_BIN",
                bins);

        req.setAttribute(
                "LIST_TECHNICIAN",
                technicians);
    }

    // =====================================================
    // SHOW FORM ERROR
    // =====================================================
    private void showFormError(
            HttpServletRequest req,
            HttpServletResponse resp,
            String message)
            throws ServletException, IOException {

        Maintenance maintenance
                = new Maintenance();

        maintenance.setMaintenanceID(
                req.getParameter("maintenanceID"));

        maintenance.setBinID(
                req.getParameter("binID"));

        maintenance.setTechnicianID(
                req.getParameter("technicianID"));

        maintenance.setMaintenanceType(
                req.getParameter("maintenanceType"));

        maintenance.setStatus(
                req.getParameter("status"));

        maintenance.setScheduledDate(
                parseTimestamp(
                        req.getParameter(
                                "scheduledDate")));

        maintenance.setCompletedDate(
                parseTimestamp(
                        req.getParameter(
                                "completedDate")));

        maintenance.setDescription(
                req.getParameter(
                        "description"));

        req.setAttribute(
                "ERROR",
                message);

        req.setAttribute(
                "MAINTENANCE",
                maintenance);

        req.setAttribute(
                "MODE",
                maintenance.getMaintenanceID() == null
                || maintenance.getMaintenanceID()
                        .trim().isEmpty()
                        ? "CREATE"
                        : "EDIT");

        loadFormData(req);

        req.getRequestDispatcher(
                "/WEB-INF/views/maintenanceForm.jsp")
                .forward(req, resp);
    }

    // =====================================================
    // VALIDATE STATUS
    // =====================================================
    private boolean isValidStatus(
            String status) {

        return "Pending".equals(status)
                || "In_Progress".equals(status)
                || "Completed".equals(status)
                || "Cancelled".equals(status);
    }

    // =====================================================
    // VALIDATE TYPE
    // =====================================================
    private boolean isValidType(
            String type) {

        return "Repair".equals(type)
                || "Inspection".equals(type)
                || "Replacement".equals(type)
                || "Sensor_Check".equals(type);
    }

    // =====================================================
    // PARSE TIMESTAMP
    // =====================================================
    private Timestamp parseTimestamp(
            String value) {

        if (value == null
                || value.trim().isEmpty()) {

            return null;
        }

        try {

            return Timestamp.valueOf(
                    value.replace("T", " "));

        } catch (Exception e) {

            return null;
        }
    }

    // =====================================================
    // DENIED
    // =====================================================
    private void showDenied(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher(
                "/WEB-INF/views/denied.jsp")
                .forward(req, resp);
    }
}
