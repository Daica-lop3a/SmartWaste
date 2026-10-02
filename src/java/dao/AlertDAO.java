/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Alert;

/**
 *
 * @author ASUS
 */
public class AlertDAO {
      // =========================
    // COUNT ALL ALERTS
    // =========================
    public int countAll() {

        String sql = "SELECT COUNT(*) FROM tblAlerts";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(rs, ps, conn);
        }

        return 0;
    }


    // =========================
    // COUNT UNRESOLVED ALERTS
    // =========================
    public int countUnresolved() {

        String sql = "SELECT COUNT(*) "
                + "FROM tblAlerts "
                + "WHERE isResolved = 0";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(rs, ps, conn);
        }

        return 0;
    }
        // =========================
    // GET ALL ALERTS
    // =========================
    public List<Alert> getAll() {

        List<Alert> list = new ArrayList<Alert>();

        String sql = "SELECT alertID, binID, alertType, message, "
                + "createdDate, isResolved "
                + "FROM tblAlerts "
                + "ORDER BY createdDate DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(map(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(rs, ps, conn);
        }

        return list;
    }


    // =========================
    // FIND ALERT BY ID
    // =========================
    public Alert findByID(String alertID) {

        String sql = "SELECT alertID, binID, alertType, message, "
                + "createdDate, isResolved "
                + "FROM tblAlerts "
                + "WHERE alertID = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, alertID);

            rs = ps.executeQuery();

            if (rs.next()) {
                return map(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(rs, ps, conn);
        }

        return null;
    }


    // =========================
    // INSERT ALERT
    // =========================
    public boolean insert(Alert alert) {

        String sql = "INSERT INTO tblAlerts "
                + "(alertID, binID, alertType, message, "
                + "createdDate, isResolved) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);

            ps.setString(1, alert.getAlertID());
            ps.setString(2, alert.getBinID());
            ps.setString(3, alert.getAlertType());
            ps.setString(4, alert.getMessage());
            ps.setTimestamp(5, alert.getCreatedDate());
            ps.setBoolean(6, alert.isResolved());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(ps, conn);
        }

        return false;
    }


    // =========================
    // UPDATE ALERT
    // =========================
    public boolean update(Alert alert) {

        String sql = "UPDATE tblAlerts SET "
                + "binID = ?, "
                + "alertType = ?, "
                + "message = ?, "
                + "isResolved = ? "
                + "WHERE alertID = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);

            ps.setString(1, alert.getBinID());
            ps.setString(2, alert.getAlertType());
            ps.setString(3, alert.getMessage());
            ps.setBoolean(4, alert.isResolved());
            ps.setString(5, alert.getAlertID());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(ps, conn);
        }

        return false;
    }


    // =========================
    // DELETE ALERT
    // =========================
    public boolean delete(String alertID) {

        String sql = "DELETE FROM tblAlerts WHERE alertID = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, alertID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(ps, conn);
        }

        return false;
    }


    // =========================
    // RESOLVE / UNRESOLVE ALERT
    // =========================
    public boolean setResolved(String alertID, boolean resolved) {

        String sql = "UPDATE tblAlerts "
                + "SET isResolved = ? "
                + "WHERE alertID = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);

            ps.setBoolean(1, resolved);
            ps.setString(2, alertID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(ps, conn);
        }

        return false;
    }


    // =========================
    // MAP RESULTSET -> ALERT
    // =========================
    private Alert map(ResultSet rs) throws Exception {

        Alert alert = new Alert();

        alert.setAlertID(
                rs.getString("alertID"));

        alert.setBinID(
                rs.getString("binID"));

        alert.setAlertType(
                rs.getString("alertType"));

        alert.setMessage(
                rs.getString("message"));

        alert.setCreatedDate(
                rs.getTimestamp("createdDate"));

        alert.setResolved(
                rs.getBoolean("isResolved"));

        return alert;
    }
    public boolean hasUnresolvedHighFillAlert(String binID) {

    String sql = "SELECT COUNT(*) "
            + "FROM tblAlerts "
            + "WHERE binID = ? "
            + "AND alertType = 'High_Fill' "
            + "AND isResolved = 0";

    Connection cn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        cn = DBContext.getConnection();
        ps = cn.prepareStatement(sql);

        ps.setString(1, binID);

        rs = ps.executeQuery();

        if (rs.next()) {
            return rs.getInt(1) > 0;
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBContext.close(rs, ps, cn);
    }

    return false;
}
    // =========================
// RESOLVE ALL HIGH FILL ALERTS OF BIN
// =========================
public boolean resolveUnresolvedHighFillAlerts(String binID) {

    String sql = "UPDATE tblAlerts "
            + "SET isResolved = 1 "
            + "WHERE binID = ? "
            + "AND alertType = 'High_Fill' "
            + "AND isResolved = 0";

    Connection cn = null;
    PreparedStatement ps = null;

    try {
        cn = DBContext.getConnection();
        ps = cn.prepareStatement(sql);

        ps.setString(1, binID);

        return ps.executeUpdate() > 0;

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBContext.close(ps, cn);
    }

    return false;
}
}
