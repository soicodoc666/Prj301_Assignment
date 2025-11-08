package model;

import java.sql.Timestamp;

public class Notification extends BaseModel{

    private int nid;
    private int eid; // nhân viên nhận thông báo
    private String message;
    private Timestamp createdTime;
    private boolean isSeen;

    public Notification() {
    }

    // Getter & Setter
    public int getNid() {
        return nid;
    }

    public void setNid(int nid) {
        this.nid = nid;
    }

    public int getEid() {
        return eid;
    }

    public void setEid(int eid) {
        this.eid = eid;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Timestamp getCreatedTime() {
        return createdTime;
    }

    public void setCreatedTime(Timestamp createdTime) {
        this.createdTime = createdTime;
    }

    public boolean getIsSeen() {
        return isSeen;
    }

    public void setIsSeen(boolean isSeen) {
        this.isSeen = isSeen;
    }
}
