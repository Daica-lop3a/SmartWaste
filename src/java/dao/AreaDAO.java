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

    public List<Area> getFiltered(
            String search,
            String sort,
            String order) {

        List<Area> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder();

        sql.append("SELECT areaID, areaName, description ");
        sql.append("FROM tblAreas ");
        sql.append("WHERE 1 = 1 ");

        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {

            sql.append("AND (areaID LIKE ? OR areaName LIKE ?) ");

            String keyword = "%" + search.trim() + "%";

            params.add(keyword);
            params.add(keyword);
        }

        String orderBy;

        if ("areaName".equals(sort)) {

            orderBy = "areaName";

        } else {

            orderBy = "areaID";
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

                Area area = new Area();

                area.setAreaId(
                        rs.getString("areaID"));

                area.setAreaName(
                        rs.getString("areaName"));

                area.setDescription(
                        rs.getString("description"));

                list.add(area);
            }

        } catch (Exception e) {

            e.printStackTrace();

        } finally {

            DBContext.close(rs, ps, conn);
        }

        return list;
    }

    public List<Area> getFilteredByManager(
            String managerID,
            String search,
            String sort,
            String order) {

        List<Area> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder();

        sql.append("SELECT a.areaID, a.areaName, a.description ");
        sql.append("FROM tblAreas a ");
        sql.append("INNER JOIN tblAreaAssignments aa ");
        sql.append("ON a.areaID = aa.areaID ");
        sql.append("WHERE aa.userID = ? ");
        sql.append("AND aa.assignmentRole = 'MANAGER' ");

        List<Object> params = new ArrayList<>();

        params.add(managerID);

        if (search != null && !search.trim().isEmpty()) {

            sql.append("AND (a.areaID LIKE ? OR a.areaName LIKE ?) ");

            String keyword = "%" + search.trim() + "%";

            params.add(keyword);
            params.add(keyword);
        }

        String orderBy;

        if ("areaName".equals(sort)) {

            orderBy = "a.areaName";

        } else {

            orderBy = "a.areaID";
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

                Area area = new Area();

                area.setAreaId(
                        rs.getString("areaID"));

                area.setAreaName(
                        rs.getString("areaName"));

                area.setDescription(
                        rs.getString("description"));

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
