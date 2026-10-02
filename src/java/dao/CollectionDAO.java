package dao;

import model.CollectionRequest;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CollectionDAO {

    // =========================================================
    // GET ALL
    // =========================================================
    public List<CollectionRequest> getAll() {

        List<CollectionRequest> list = new ArrayList<>();

        String sql
                = "SELECT requestID, binID, staffID, status, "
                + "priority, createdDate, notes "
                + "FROM tblCollectionRequests "
                + "ORDER BY createdDate DESC";

        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = DBContext.getConnection();
            ps = cn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(map(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(rs, ps, cn);
        }

        return list;
    }

    // =========================================================
    // GET BY ID
    // =========================================================
    public CollectionRequest findByID(String requestID) {

        String sql
                = "SELECT requestID, binID, staffID, status, "
                + "priority, createdDate, notes "
                + "FROM tblCollectionRequests "
                + "WHERE requestID = ?";

        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = DBContext.getConnection();
            ps = cn.prepareStatement(sql);

            ps.setString(1, requestID);

            rs = ps.executeQuery();

            if (rs.next()) {
                return map(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(rs, ps, cn);
        }

        return null;
    }

    // =========================================================
    // GET BY STAFF
    // =========================================================
    public List<CollectionRequest> getByStaff(String staffID) {

        List<CollectionRequest> list = new ArrayList<>();

        String sql
                = "SELECT requestID, binID, staffID, status, "
                + "priority, createdDate, notes "
                + "FROM tblCollectionRequests "
                + "WHERE staffID = ? "
                + "ORDER BY createdDate DESC";

        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = DBContext.getConnection();
            ps = cn.prepareStatement(sql);

            ps.setString(1, staffID);

            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(map(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(rs, ps, cn);
        }

        return list;
    }

    // =========================================================
    // INSERT
    // =========================================================
    public boolean insert(CollectionRequest request) {

        String sql
                = "INSERT INTO tblCollectionRequests "
                + "(requestID, binID, staffID, status, "
                + "priority, createdDate, notes) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        Connection cn = null;
        PreparedStatement ps = null;

        try {
            cn = DBContext.getConnection();
            ps = cn.prepareStatement(sql);

            ps.setString(1, request.getRequestID());
            ps.setString(2, request.getBinID());
            ps.setString(3, request.getStaffID());
            ps.setString(4, request.getStatus());
            ps.setString(5, request.getPriority());
            ps.setTimestamp(6, request.getCreatedDate());
            ps.setString(7, request.getNotes());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(ps, cn);
        }

        return false;
    }

    // =========================================================
    // UPDATE
    // =========================================================
    public boolean update(CollectionRequest request) {

        String sql
                = "UPDATE tblCollectionRequests "
                + "SET binID = ?, "
                + "staffID = ?, "
                + "status = ?, "
                + "priority = ?, "
                + "notes = ? "
                + "WHERE requestID = ?";

        Connection cn = null;
        PreparedStatement ps = null;

        try {
            cn = DBContext.getConnection();
            ps = cn.prepareStatement(sql);

            ps.setString(1, request.getBinID());
            ps.setString(2, request.getStaffID());
            ps.setString(3, request.getStatus());
            ps.setString(4, request.getPriority());
            ps.setString(5, request.getNotes());
            ps.setString(6, request.getRequestID());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(ps, cn);
        }

        return false;
    }

    // =========================================================
    // DELETE
    // =========================================================
    public boolean delete(String requestID) {

        String sql
                = "DELETE FROM tblCollectionRequests "
                + "WHERE requestID = ?";

        Connection cn = null;
        PreparedStatement ps = null;

        try {
            cn = DBContext.getConnection();
            ps = cn.prepareStatement(sql);

            ps.setString(1, requestID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(ps, cn);
        }

        return false;
    }

    // =========================================================
    // COUNT ALL
    // =========================================================
    public int countAll() {

        String sql
                = "SELECT COUNT(*) "
                + "FROM tblCollectionRequests";

        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = DBContext.getConnection();
            ps = cn.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(rs, ps, cn);
        }

        return 0;
    }

    // =========================================================
    // COUNT BY STATUS
    // =========================================================
    public int countByStatus(String status) {

        String sql
                = "SELECT COUNT(*) "
                + "FROM tblCollectionRequests "
                + "WHERE status = ?";

        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = DBContext.getConnection();
            ps = cn.prepareStatement(sql);

            ps.setString(1, status);

            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(rs, ps, cn);
        }

        return 0;
    }

    // =========================================================
    // MAP RESULTSET -> OBJECT
    // =========================================================
    private CollectionRequest map(ResultSet rs)
            throws Exception {

        CollectionRequest request
                = new CollectionRequest();

        request.setRequestID(
                rs.getString("requestID")
        );

        request.setBinID(
                rs.getString("binID")
        );

        request.setStaffID(
                rs.getString("staffID")
        );

        request.setStatus(
                rs.getString("status")
        );

        request.setPriority(
                rs.getString("priority")
        );

        request.setCreatedDate(
                rs.getTimestamp("createdDate")
        );

        request.setNotes(
                rs.getString("notes")
        );

        return request;
    }
}
