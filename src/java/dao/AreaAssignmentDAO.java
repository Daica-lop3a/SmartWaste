package dao;

import model.AppUser;
import model.AreaAssignment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AreaAssignmentDAO {

    // =========================================================
    // INSERT
    // =========================================================
    public boolean insert(AreaAssignment assignment) {

        String sql = "INSERT INTO tblAreaAssignments "
                + "(assignmentID, areaID, userID, assignmentRole, assignedDate) "
                + "VALUES (?, ?, ?, ?, ?)";

        Connection cn = null;
        PreparedStatement ps = null;

        try {
            cn = DBContext.getConnection();
            ps = cn.prepareStatement(sql);

            ps.setString(1, assignment.getAssignmentID());
            ps.setString(2, assignment.getAreaID());
            ps.setString(3, assignment.getUserID());
            ps.setString(4, assignment.getAssignmentRole());
            ps.setTimestamp(5, assignment.getAssignedDate());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;

        } finally {
            DBContext.close(ps, cn);
        }
    }

    // =========================================================
    // GET BY AREA
    // =========================================================
    public List<AreaAssignment> getByArea(String areaID) {

        List<AreaAssignment> list = new ArrayList<>();

        String sql = "SELECT assignmentID, areaID, userID, "
                + "assignmentRole, assignedDate "
                + "FROM tblAreaAssignments "
                + "WHERE areaID = ? "
                + "ORDER BY assignedDate DESC";

        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = DBContext.getConnection();
            ps = cn.prepareStatement(sql);

            ps.setString(1, areaID);

            rs = ps.executeQuery();

            while (rs.next()) {

                AreaAssignment assignment
                        = new AreaAssignment();

                assignment.setAssignmentID(
                        rs.getString("assignmentID"));

                assignment.setAreaID(
                        rs.getString("areaID"));

                assignment.setUserID(
                        rs.getString("userID"));

                assignment.setAssignmentRole(
                        rs.getString("assignmentRole"));

                assignment.setAssignedDate(
                        rs.getTimestamp("assignedDate"));

                list.add(assignment);
            }

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(rs, ps, cn);
        }

        return list;
    }

    // =========================================================
    // GET BY USER
    // =========================================================
    public List<AreaAssignment> getByUser(String userID) {

        List<AreaAssignment> list = new ArrayList<>();

        String sql = "SELECT assignmentID, areaID, userID, "
                + "assignmentRole, assignedDate "
                + "FROM tblAreaAssignments "
                + "WHERE userID = ? "
                + "ORDER BY assignedDate DESC";

        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = DBContext.getConnection();
            ps = cn.prepareStatement(sql);

            ps.setString(1, userID);

            rs = ps.executeQuery();

            while (rs.next()) {

                AreaAssignment assignment
                        = new AreaAssignment();

                assignment.setAssignmentID(
                        rs.getString("assignmentID"));

                assignment.setAreaID(
                        rs.getString("areaID"));

                assignment.setUserID(
                        rs.getString("userID"));

                assignment.setAssignmentRole(
                        rs.getString("assignmentRole"));

                assignment.setAssignedDate(
                        rs.getTimestamp("assignedDate"));

                list.add(assignment);
            }

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(rs, ps, cn);
        }

        return list;
    }

    // =========================================================
    // CHECK MANAGER OF AREA
    // =========================================================
    public boolean isManagerOfArea(
            String userID,
            String areaID) {

        String sql = "SELECT 1 "
                + "FROM tblAreaAssignments "
                + "WHERE userID = ? "
                + "AND areaID = ? "
                + "AND assignmentRole = 'MANAGER'";

        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = DBContext.getConnection();
            ps = cn.prepareStatement(sql);

            ps.setString(1, userID);
            ps.setString(2, areaID);

            rs = ps.executeQuery();

            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
            return false;

        } finally {
            DBContext.close(rs, ps, cn);
        }
    }

    // =========================================================
    // GET STAFF BY AREA
    // =========================================================
    public List<AppUser> getStaffByArea(String areaID) {

        List<AppUser> list = new ArrayList<>();

        String sql = "SELECT "
                + "u.userID, "
                + "u.fullName, "
                + "u.email, "
                + "u.phoneNumber, "
                + "u.roleID, "
                + "u.password, "
                + "u.status "
                + "FROM tblUsers u "
                + "INNER JOIN tblAreaAssignments aa "
                + "ON u.userID = aa.userID "
                + "WHERE aa.areaID = ? "
                + "AND aa.assignmentRole = 'STAFF' "
                + "AND u.roleID = 'STF' "
                + "AND u.status = 1 "
                + "ORDER BY u.userID";

        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = DBContext.getConnection();
            ps = cn.prepareStatement(sql);

            ps.setString(1, areaID);

            rs = ps.executeQuery();

            while (rs.next()) {

                AppUser user = new AppUser();

                user.setUserId(
                        rs.getString("userID"));

                user.setFullName(
                        rs.getString("fullName"));

                user.setEmail(
                        rs.getString("email"));

                user.setPhoneNumber(
                        rs.getString("phoneNumber"));

                user.setRoleId(
                        rs.getString("roleID"));

                user.setPassword(
                        rs.getString("password"));

                user.setStatus(
                        rs.getBoolean("status"));

                list.add(user);
            }

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(rs, ps, cn);
        }

        return list;
    }

    // =========================================================
    // CHECK STAFF OF AREA
    // =========================================================
    public boolean isStaffOfArea(
            String userID,
            String areaID) {

        String sql = "SELECT 1 "
                + "FROM tblAreaAssignments "
                + "WHERE userID = ? "
                + "AND areaID = ? "
                + "AND assignmentRole = 'STAFF'";

        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = DBContext.getConnection();
            ps = cn.prepareStatement(sql);

            ps.setString(1, userID);
            ps.setString(2, areaID);

            rs = ps.executeQuery();

            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
            return false;

        } finally {
            DBContext.close(rs, ps, cn);
        }
    }
}
