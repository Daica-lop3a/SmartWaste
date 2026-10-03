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
import model.WasteBin;

/**
 *
 * @author ASUS
 */
public class WasteBinDAO {

    public List<WasteBin> getAll() {

        List<WasteBin> list = new ArrayList<>();

        String sql = "SELECT binID, binCode, location, capacity, "
                + "currentFill, status, areaID "
                + "FROM tblWasteBins "
                + "ORDER BY binID";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {

                WasteBin bin = new WasteBin();

                bin.setBinID(rs.getString("binID"));
                bin.setBinCode(rs.getString("binCode"));
                bin.setLocation(rs.getString("location"));
                bin.setCapacity(rs.getDouble("capacity"));
                bin.setCurrentFill(rs.getDouble("currentFill"));
                bin.setStatus(rs.getString("status"));
                bin.setAreaID(rs.getString("areaID"));

                list.add(bin);
            }

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(rs, ps, conn);
        }

        return list;
    }

    public int countAll() {

        String sql = "SELECT COUNT(*) FROM tblWasteBins";

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

        String sql = "SELECT COUNT(*) "
                + "FROM tblWasteBins "
                + "WHERE status = ?";

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

    public WasteBin findByID(String binID) {

        String sql = "SELECT binID, binCode, location, capacity, "
                + "currentFill, status, areaID "
                + "FROM tblWasteBins "
                + "WHERE binID = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, binID);

            rs = ps.executeQuery();

            if (rs.next()) {

                WasteBin bin = new WasteBin();

                bin.setBinID(rs.getString("binID"));
                bin.setBinCode(rs.getString("binCode"));
                bin.setLocation(rs.getString("location"));
                bin.setCapacity(rs.getDouble("capacity"));
                bin.setCurrentFill(rs.getDouble("currentFill"));
                bin.setStatus(rs.getString("status"));
                bin.setAreaID(rs.getString("areaID"));

                return bin;
            }

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(rs, ps, conn);
        }

        return null;
    }

    public boolean insert(WasteBin bin) {

        String sql = "INSERT INTO tblWasteBins "
                + "(binID, binCode, location, capacity, "
                + "currentFill, status, areaID) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);

            ps.setString(1, bin.getBinID());
            ps.setString(2, bin.getBinCode());
            ps.setString(3, bin.getLocation());
            ps.setDouble(4, bin.getCapacity());
            ps.setDouble(5, bin.getCurrentFill());
            ps.setString(6, bin.getStatus());
            ps.setString(7, bin.getAreaID());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(ps, conn);
        }

        return false;
    }

    public boolean update(WasteBin bin) {

        String sql = "UPDATE tblWasteBins "
                + "SET binCode = ?, "
                + "location = ?, "
                + "capacity = ?, "
                + "currentFill = ?, "
                + "status = ?, "
                + "areaID = ? "
                + "WHERE binID = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);

            ps.setString(1, bin.getBinCode());
            ps.setString(2, bin.getLocation());
            ps.setDouble(3, bin.getCapacity());
            ps.setDouble(4, bin.getCurrentFill());
            ps.setString(5, bin.getStatus());
            ps.setString(6, bin.getAreaID());
            ps.setString(7, bin.getBinID());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(ps, conn);
        }

        return false;
    }

    public boolean delete(String binID) {

        String sql = "DELETE FROM tblWasteBins "
                + "WHERE binID = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);

            ps.setString(1, binID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(ps, conn);
        }

        return false;
    }

    public boolean updateCurrentFill(String binID, int currentFill) {

        String sql = "UPDATE tblWasteBins "
                + "SET currentFill = ? "
                + "WHERE binID = ?";

        Connection cn = null;
        PreparedStatement ps = null;

        try {
            cn = DBContext.getConnection();

            ps = cn.prepareStatement(sql);

            ps.setInt(1, currentFill);
            ps.setString(2, binID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;

        } finally {
            DBContext.close(ps, cn);
        }
    }

    public boolean updateFillAndStatus(String binID, int fillPercent) {

        String status;

        if (fillPercent >= 80) {
            status = "Full";
        } else {
            status = "Active";
        }

        String sql
                = "UPDATE tblWasteBins "
                + "SET currentFill = ?, status = ? "
                + "WHERE binID = ?";

        Connection cn = null;
        PreparedStatement ps = null;

        try {

            cn = DBContext.getConnection();

            ps = cn.prepareStatement(sql);

            ps.setInt(1, fillPercent);
            ps.setString(2, status);
            ps.setString(3, binID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();

            return false;

        } finally {

            DBContext.close(ps, cn);
        }
    }

    public List<WasteBin> getFiltered(
            String search,
            String areaID,
            String status,
            String fillLevel,
            String sort,
            String order) {

        List<WasteBin> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder();

        sql.append("SELECT binID, binCode, location, capacity, ");
        sql.append("currentFill, status, areaID ");
        sql.append("FROM tblWasteBins ");
        sql.append("WHERE 1 = 1 ");

        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {

            sql.append("AND (binCode LIKE ? OR location LIKE ?) ");

            String keyword = "%" + search.trim() + "%";

            params.add(keyword);
            params.add(keyword);
        }

        if (areaID != null && !areaID.trim().isEmpty()) {

            sql.append("AND areaID = ? ");

            params.add(areaID.trim());
        }

        if (status != null && !status.trim().isEmpty()) {

            sql.append("AND status = ? ");

            params.add(status.trim());
        }

        if ("Low".equals(fillLevel)) {

            sql.append("AND currentFill < 50 ");

        } else if ("Medium".equals(fillLevel)) {

            sql.append("AND currentFill >= 50 ");
            sql.append("AND currentFill < 80 ");

        } else if ("High".equals(fillLevel)) {

            sql.append("AND currentFill >= 80 ");
        }

        String orderBy;

        if ("binCode".equals(sort)) {

            orderBy = "binCode";

        } else if ("capacity".equals(sort)) {

            orderBy = "capacity";

        } else if ("currentFill".equals(sort)) {

            orderBy = "currentFill";

        } else {

            orderBy = "binID";
        }

        String sortOrder;

        if ("DESC".equalsIgnoreCase(order)) {

            sortOrder = "DESC";

        } else {

            sortOrder = "ASC";
        }

        sql.append("ORDER BY ")
                .append(orderBy)
                .append(" ")
                .append(sortOrder);

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            conn = DBContext.getConnection();

            ps = conn.prepareStatement(sql.toString());

            for (int i = 0; i < params.size(); i++) {

                ps.setObject(i + 1, params.get(i));
            }

            rs = ps.executeQuery();

            while (rs.next()) {

                WasteBin bin = new WasteBin();

                bin.setBinID(
                        rs.getString("binID"));

                bin.setBinCode(
                        rs.getString("binCode"));

                bin.setLocation(
                        rs.getString("location"));

                bin.setCapacity(
                        rs.getDouble("capacity"));

                bin.setCurrentFill(
                        rs.getDouble("currentFill"));

                bin.setStatus(
                        rs.getString("status"));

                bin.setAreaID(
                        rs.getString("areaID"));

                list.add(bin);
            }

        } catch (Exception e) {

            e.printStackTrace();

        } finally {

            DBContext.close(rs, ps, conn);
        }

        return list;
    }
}
