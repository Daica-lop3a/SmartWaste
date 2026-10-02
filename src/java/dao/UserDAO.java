package dao;

import model.AppUser;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // =========================
    // FIND BY EMAIL - LOGIN
    // =========================

    public AppUser findByUsername(String username) {

        String sql = "SELECT userID, fullName, email, phoneNumber, "
                + "roleID, password, status "
                + "FROM tblUsers "
                + "WHERE email = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);

            ps.setString(1, username);

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
    // FIND BY ID
    // =========================

    public AppUser findById(String userId) {

        String sql = "SELECT userID, fullName, email, phoneNumber, "
                + "roleID, password, status "
                + "FROM tblUsers "
                + "WHERE userID = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);

            ps.setString(1, userId);

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
    // SEARCH USERS
    // =========================

    public List<AppUser> search(String keyword, String roleId) {

        List<AppUser> list = new ArrayList<>();

        String sql = "SELECT userID, fullName, email, phoneNumber, "
                + "roleID, password, status "
                + "FROM tblUsers "
                + "WHERE (userID LIKE ? "
                + "OR fullName LIKE ? "
                + "OR email LIKE ? "
                + "OR phoneNumber LIKE ?) ";

        if (roleId != null && !roleId.trim().isEmpty()) {
            sql += "AND roleID = ? ";
        }

        sql += "ORDER BY userID";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);

            String key = "%" + keyword + "%";

            ps.setString(1, key);
            ps.setString(2, key);
            ps.setString(3, key);
            ps.setString(4, key);

            if (roleId != null && !roleId.trim().isEmpty()) {
                ps.setString(5, roleId);
            }

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
    // INSERT USER
    // =========================

    public boolean insert(AppUser user) {

        String sql = "INSERT INTO tblUsers "
                + "(userID, fullName, email, phoneNumber, "
                + "roleID, password, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement ps = null;

        try {

            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);

            ps.setString(1, user.getUserId());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhoneNumber());
            ps.setString(5, user.getRoleId());
            ps.setString(6, user.getPassword());
            ps.setBoolean(7, user.isStatus());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(ps, conn);
        }

        return false;
    }

    // =========================
    // UPDATE USER
    // =========================

    public boolean update(AppUser user) {

        String sql = "UPDATE tblUsers "
                + "SET fullName = ?, "
                + "email = ?, "
                + "phoneNumber = ?, "
                + "roleID = ? "
                + "WHERE userID = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {

            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhoneNumber());
            ps.setString(4, user.getRoleId());
            ps.setString(5, user.getUserId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(ps, conn);
        }

        return false;
    }

    // =========================
    // DELETE USER
    // =========================

    public boolean delete(String userId) {

        String sql = "DELETE FROM tblUsers "
                + "WHERE userID = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {

            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);

            ps.setString(1, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(ps, conn);
        }

        return false;
    }

    // =========================
    // LOCK / UNLOCK
    // =========================

    public boolean setStatus(String userId, boolean status) {

        String sql = "UPDATE tblUsers "
                + "SET status = ? "
                + "WHERE userID = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {

            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);

            ps.setBoolean(1, status);
            ps.setString(2, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(ps, conn);
        }

        return false;
    }

    // =========================
    // RESET PASSWORD
    // =========================

    public boolean resetPassword(String userId,
            String password) {

        String sql = "UPDATE tblUsers "
                + "SET password = ? "
                + "WHERE userID = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {

            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);

            ps.setString(1, password);
            ps.setString(2, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            DBContext.close(ps, conn);
        }

        return false;
    }

    // =========================
    // MAP RESULTSET → APPUSER
    // =========================

    private AppUser map(ResultSet rs) throws Exception {

        AppUser user = new AppUser();

        user.setUserId(rs.getString("userID"));
        user.setFullName(rs.getString("fullName"));
        user.setEmail(rs.getString("email"));
        user.setPhoneNumber(rs.getString("phoneNumber"));
        user.setRoleId(rs.getString("roleID"));
        user.setPassword(rs.getString("password"));
        user.setStatus(rs.getBoolean("status"));

        return user;
    }
}