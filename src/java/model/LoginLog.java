package model;

import java.sql.Timestamp;

public class LoginLog {
    private int logId;
    private Integer userId;
    private String username;
    private boolean success;
    private String ipAddress;
    private Timestamp loginAt;

    public int getLogId() { return logId; }
    public void setLogId(int v) { this.logId = v; }
    public Integer getUserId() { return userId; }
    public void setUserId(Integer v) { this.userId = v; }
    public String getUsername() { return username; }
    public void setUsername(String v) { this.username = v; }
    public boolean isSuccess() { return success; }
    public void setSuccess(boolean v) { this.success = v; }
    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String v) { this.ipAddress = v; }
    public Timestamp getLoginAt() { return loginAt; }
    public void setLoginAt(Timestamp v) { this.loginAt = v; }
}
