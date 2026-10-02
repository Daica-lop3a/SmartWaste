package model;

import java.sql.Timestamp;

public class AreaAssignment {

    private String assignmentID;
    private String areaID;
    private String userID;
    private String assignmentRole;
    private Timestamp assignedDate;

    public AreaAssignment() {
    }

    public AreaAssignment(String assignmentID,
            String areaID,
            String userID,
            String assignmentRole,
            Timestamp assignedDate) {

        this.assignmentID = assignmentID;
        this.areaID = areaID;
        this.userID = userID;
        this.assignmentRole = assignmentRole;
        this.assignedDate = assignedDate;
    }

    public String getAssignmentID() {
        return assignmentID;
    }

    public void setAssignmentID(String assignmentID) {
        this.assignmentID = assignmentID;
    }

    public String getAreaID() {
        return areaID;
    }

    public void setAreaID(String areaID) {
        this.areaID = areaID;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getAssignmentRole() {
        return assignmentRole;
    }

    public void setAssignmentRole(String assignmentRole) {
        this.assignmentRole = assignmentRole;
    }

    public Timestamp getAssignedDate() {
        return assignedDate;
    }

    public void setAssignedDate(Timestamp assignedDate) {
        this.assignedDate = assignedDate;
    }
}
