package controller;

import dao.AlertDAO;
import dao.CollectionDAO;
import dao.MaintenanceDAO;
import dao.WasteBinDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final MaintenanceDAO maintenanceDAO = new MaintenanceDAO();
    private final WasteBinDAO binDAO = new WasteBinDAO();
    private final CollectionDAO collectionDAO = new CollectionDAO();
    private final AlertDAO alertDAO = new AlertDAO();

    @Override
    protected void doGet(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        // Check login
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // =========================
        // WASTE BIN
        // =========================
        int totalBins = binDAO.countAll();
        int activeBins = binDAO.countByStatus("Active");
        int fullBins = binDAO.countByStatus("Full");
        int maintenanceBins = binDAO.countByStatus("Maintenance");

        req.setAttribute("totalBins", totalBins);
        req.setAttribute("activeBins", activeBins);
        req.setAttribute("fullBins", fullBins);
        req.setAttribute("maintenanceBins", maintenanceBins);
        req.setAttribute("LIST_BIN", binDAO.getAll());

        // =========================
        // COLLECTION REQUEST
        // =========================
        int totalRequests = collectionDAO.countAll();
        int pendingRequests = collectionDAO.countByStatus("Pending");
        int inProgressRequests = collectionDAO.countByStatus("In_Progress");
        int completedRequests = collectionDAO.countByStatus("Completed");

        req.setAttribute("totalRequests", totalRequests);
        req.setAttribute("pendingRequests", pendingRequests);
        req.setAttribute("inProgressRequests", inProgressRequests);
        req.setAttribute("completedRequests", completedRequests);

        // =========================
        // MAINTENANCE
        // =========================
        int totalMaintenance = maintenanceDAO.countAll();
        int pendingMaintenance = maintenanceDAO.countByStatus("Pending");
        int inProgressMaintenance = maintenanceDAO.countByStatus("In_Progress");
        int completedMaintenance = maintenanceDAO.countByStatus("Completed");

        req.setAttribute("totalMaintenance", totalMaintenance);
        req.setAttribute("pendingMaintenance", pendingMaintenance);
        req.setAttribute("inProgressMaintenance", inProgressMaintenance);
        req.setAttribute("completedMaintenance", completedMaintenance);

        // =========================
        // ALERT
        // =========================
        int totalAlerts = alertDAO.countAll();
        int unresolvedAlerts = alertDAO.countUnresolved();

        req.setAttribute("totalAlerts", totalAlerts);
        req.setAttribute("unresolvedAlerts", unresolvedAlerts);

        // =========================
        // GO TO DASHBOARD
        // =========================
        req.getRequestDispatcher(
                "/WEB-INF/views/dashboard.jsp"
        ).forward(req, resp);
    }
}
