/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ASUS
 */
public class WasteBin {
     private String binID;
    private String binCode;
    private String location;
    private double capacity;
    private double currentFill;
    private String status;
    private String areaID;

    public WasteBin() {
    }

    public WasteBin(String binID, String binCode, String location,
                    double capacity, double currentFill,
                    String status, String areaID) {

        this.binID = binID;
        this.binCode = binCode;
        this.location = location;
        this.capacity = capacity;
        this.currentFill = currentFill;
        this.status = status;
        this.areaID = areaID;
    }

    public String getBinID() {
        return binID;
    }

    public void setBinID(String binID) {
        this.binID = binID;
    }

    public String getBinCode() {
        return binCode;
    }

    public void setBinCode(String binCode) {
        this.binCode = binCode;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public double getCapacity() {
        return capacity;
    }

    public void setCapacity(double capacity) {
        this.capacity = capacity;
    }

    public double getCurrentFill() {
        return currentFill;
    }

    public void setCurrentFill(double currentFill) {
        this.currentFill = currentFill;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAreaID() {
        return areaID;
    }

    public void setAreaID(String areaID) {
        this.areaID = areaID;
    }
}
