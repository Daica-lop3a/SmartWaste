package dao;

import model.Maintenance;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class MaintenanceDAO {

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM tblMaintenance";

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

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM tblMaintenance WHERE status = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);

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

    public List<Maintenance> getAll() {
        List<Maintenance> list = new ArrayList<Maintenance>();

        String sql = "SELECT maintenanceID, binID, technicianID, "
                   + "maintenanceType, status, scheduledDate, "
                   + "completedDate, description "
                   + "FROM tblMaintenance "
                   + "ORDER BY scheduledDate DESC";

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

    public Maintenance findByID(String maintenanceID) {
        String sql = "SELECT maintenanceID, binID, technicianID, "
                   + "maintenanceType, status, scheduledDate, "
                   + "completedDate, description "
                   + "FROM tblMaintenance "
                   + "WHERE maintenanceID = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, maintenanceID);

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

    public List<Maintenance> getByTechnician(String technicianID) {
        List<Maintenance> list = new ArrayList<Maintenance>();

        String sql = "SELECT maintenanceID, binID, technicianID, "
                   + "maintenanceType, status, scheduledDate, "
                   + "completedDate, description "
                   + "FROM tblMaintenance "
                   + "WHERE technicianID = ? "
                   + "ORDER BY scheduledDate DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, technicianID);

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

    public boolean insert(Maintenance maintenance) {
        String sql = "INSERT INTO tblMaintenance "
                   + "(maintenanceID, binID, technicianID, maintenanceType, "
                   + "status, scheduledDate, completedDate, description) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);

            ps.setString(1, maintenance.getMaintenanceID());
            ps.setString(2, maintenance.getBinID());
            ps.setString(3, maintenance.getTechnicianID());
            ps.setString(4, maintenance.getMaintenanceType());
            ps.setString(5, maintenance.getStatus());
            ps.setTimestamp(6, maintenance.getScheduledDate());
            ps.setTimestamp(7, maintenance.getCompletedDate());
            ps.setString(8, maintenance.getDescription());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBContext.close(ps, conn);
        }

        return false;
    }

    public boolean update(Maintenance maintenance) {
        String sql = "UPDATE tblMaintenance SET "
                   + "binID = ?, "
                   + "technicianID = ?, "
                   + "maintenanceType = ?, "
                   + "status = ?, "
                   + "scheduledDate = ?, "
                   + "completedDate = ?, "
                   + "description = ? "
                   + "WHERE maintenanceID = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);

            ps.setString(1, maintenance.getBinID());
            ps.setString(2, maintenance.getTechnicianID());
            ps.setString(3, maintenance.getMaintenanceType());
            ps.setString(4, maintenance.getStatus());
            ps.setTimestamp(5, maintenance.getScheduledDate());
            ps.setTimestamp(6, maintenance.getCompletedDate());
            ps.setString(7, maintenance.getDescription());
            ps.setString(8, maintenance.getMaintenanceID());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBContext.close(ps, conn);
        }

        return false;
    }

    public boolean delete(String maintenanceID) {
        String sql = "DELETE FROM tblMaintenance WHERE maintenanceID = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, maintenanceID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBContext.close(ps, conn);
        }

        return false;
    }

    private Maintenance map(ResultSet rs) throws Exception {
        Maintenance maintenance = new Maintenance();

        maintenance.setMaintenanceID(
                rs.getString("maintenanceID"));

        maintenance.setBinID(
                rs.getString("binID"));

        maintenance.setTechnicianID(
                rs.getString("technicianID"));

        maintenance.setMaintenanceType(
                rs.getString("maintenanceType"));

        maintenance.setStatus(
                rs.getString("status"));

        maintenance.setScheduledDate(
                rs.getTimestamp("scheduledDate"));

        maintenance.setCompletedDate(
                rs.getTimestamp("completedDate"));

        maintenance.setDescription(
                rs.getString("description"));

        return maintenance;
    }
}