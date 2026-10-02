package controller;

import dao.AlertDAO;
import dao.BinReadingDAO;
import dao.WasteBinDAO;
import model.Alert;
import model.BinReading;
import model.WasteBin;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/api/bin/update-fill")
public class SensorServlet extends HttpServlet {

    private final WasteBinDAO binDAO
            = new WasteBinDAO();

    private final BinReadingDAO readingDAO
            = new BinReadingDAO();

    private final AlertDAO alertDAO
            = new AlertDAO();

    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        resp.setContentType("text/plain");
        resp.setCharacterEncoding("UTF-8");

        // =========================
        // GET PARAMETERS
        // =========================
        String binID
                = req.getParameter("binID");

        String fillValue
                = req.getParameter("fillPercent");

        // =========================
        // VALIDATE BIN ID
        // =========================
        if (binID == null
                || binID.trim().isEmpty()) {

            resp.getWriter().print(
                    "Bin ID is required."
            );

            return;
        }

        // =========================
        // VALIDATE FILL
        // =========================
        if (fillValue == null
                || fillValue.trim().isEmpty()) {

            resp.getWriter().print(
                    "Fill percent is required."
            );

            return;
        }

        int fillPercent;

        try {

            fillPercent
                    = Integer.parseInt(
                            fillValue.trim()
                    );

        } catch (NumberFormatException e) {

            resp.getWriter().print(
                    "Fill percent must be a number."
            );

            return;
        }

        if (fillPercent < 0
                || fillPercent > 100) {

            resp.getWriter().print(
                    "Fill percent must be between 0 and 100."
            );

            return;
        }

        // =========================
        // CHECK BIN
        // =========================
        WasteBin bin
                = binDAO.findByID(binID);

        if (bin == null) {

            resp.getWriter().print(
                    "Waste bin does not exist."
            );

            return;
        }

        // =========================
        // UPDATE FILL + STATUS
        // =========================
        boolean updated
                = binDAO.updateFillAndStatus(
                        binID,
                        fillPercent
                );

        if (!updated) {

            resp.getWriter().print(
                    "Cannot update waste bin."
            );

            return;
        }

        // =========================
        // SAVE SENSOR READING
        // =========================
        BinReading reading
                = new BinReading();

        reading.setBinID(binID);

        reading.setFillPercent(
                fillPercent
        );

        reading.setMeasuredAt(
                new Timestamp(
                        System.currentTimeMillis()
                )
        );

        readingDAO.insert(reading);

        // =========================
        // HIGH FILL ALERT
        // =========================
        if (fillPercent >= 80) {

            if (!alertDAO
                    .hasUnresolvedHighFillAlert(binID)) {

                Alert alert
                        = new Alert();

                alert.setAlertID(
                        "AL"
                        + System.currentTimeMillis()
                );

                alert.setBinID(binID);

                alert.setAlertType(
                        "High_Fill"
                );

                alert.setMessage(
                        "Waste bin fill level has reached "
                        + fillPercent
                        + "%."
                );

                alert.setCreatedDate(
                        new Timestamp(
                                System.currentTimeMillis()
                        )
                );

                alert.setResolved(false);

                alertDAO.insert(alert);
            }

        } else {

            /*
             * Nếu mức rác giảm xuống dưới 80%
             * thì High_Fill Alert cũ được resolve.
             */
            alertDAO
                    .resolveUnresolvedHighFillAlerts(
                            binID
                    );
        }

        // =========================
        // RESPONSE
        // =========================
        resp.getWriter().print(
                "OK - Da luu du lieu sensor cho "
                + bin.getBinCode()
                + " | Fill: "
                + fillPercent
                + "%"
        );
    }
}
