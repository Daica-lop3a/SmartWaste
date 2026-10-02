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
import model.Area;

/**
 *
 * @author ASUS
 */
public class AreaDAO {
      public List<Area> getAll() {

        List<Area> list = new ArrayList<>();

        String sql = "SELECT areaID, areaName, description "
                + "FROM tblAreas "
                + "ORDER BY areaID";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Area area = new Area();

                area.setAreaId(rs.getString("areaID"));
                area.setAreaName(rs.getString("areaName"));
                area.setDescription(rs.getString("description"));

                list.add(area);
            }

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(rs, ps, conn);
        }

        return list;
    }

    public Area findById(String areaId) {

        String sql = "SELECT areaID, areaName, description "
                + "FROM tblAreas "
                + "WHERE areaID = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();

            ps = conn.prepareStatement(sql);
            ps.setString(1, areaId);

            rs = ps.executeQuery();

            if (rs.next()) {
                Area area = new Area();

                area.setAreaId(rs.getString("areaID"));
                area.setAreaName(rs.getString("areaName"));
                area.setDescription(rs.getString("description"));

                return area;
            }

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(rs, ps, conn);
        }

        return null;
    }

    public boolean insert(Area area) {

        String sql = "INSERT INTO tblAreas "
                + "(areaID, areaName, description) "
                + "VALUES (?, ?, ?)";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();

            ps = conn.prepareStatement(sql);

            ps.setString(1, area.getAreaId());
            ps.setString(2, area.getAreaName());
            ps.setString(3, area.getDescription());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(ps, conn);
        }

        return false;
    }

    public boolean update(Area area) {

        String sql = "UPDATE tblAreas "
                + "SET areaName = ?, description = ? "
                + "WHERE areaID = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();

            ps = conn.prepareStatement(sql);

            ps.setString(1, area.getAreaName());
            ps.setString(2, area.getDescription());
            ps.setString(3, area.getAreaId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(ps, conn);
        }

        return false;
    }

    public boolean delete(String areaId) {

        String sql = "DELETE FROM tblAreas WHERE areaID = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();

            ps = conn.prepareStatement(sql);
            ps.setString(1, areaId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(ps, conn);
        }

        return false;
    }
    public List<Area> getByManager(String managerID) {

    List<Area> list = new ArrayList<>();

    String sql = "SELECT a.areaID, a.areaName, a.description "
            + "FROM tblAreas a "
            + "INNER JOIN tblAreaAssignments aa "
            + "ON a.areaID = aa.areaID "
            + "WHERE aa.userID = ? "
            + "AND aa.assignmentRole = 'MANAGER' "
            + "ORDER BY a.areaID";

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DBContext.getConnection();

        ps = conn.prepareStatement(sql);
        ps.setString(1, managerID);

        rs = ps.executeQuery();

        while (rs.next()) {

            Area area = new Area();

            area.setAreaId(rs.getString("areaID"));
            area.setAreaName(rs.getString("areaName"));
            area.setDescription(rs.getString("description"));

            list.add(area);
        }

    } catch (Exception e) {
        e.printStackTrace();

    } finally {
        DBContext.close(rs, ps, conn);
    }

    return list;
}
}
