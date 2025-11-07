package model.iam;

import java.util.ArrayList;
import model.BaseModel;
import model.Employee;

public class User extends BaseModel {
    private String username;
    private String password;
    private String displayname;
    private Employee employee;
    private ArrayList<Role> roles = new ArrayList<>();

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getDisplayname() { return displayname; }
    public void setDisplayname(String displayname) { this.displayname = displayname; }

    public Employee getEmployee() { return employee; }
    public void setEmployee(Employee employee) { this.employee = employee; }

    public ArrayList<Role> getRoles() { return roles; }
    public void setRoles(ArrayList<Role> roles) { this.roles = roles; }

    /**
     * Lấy role chính của user
     * Ưu tiên: Head > PM > Employee
     */
    public Role getRole() {
        if (roles == null || roles.isEmpty()) return null;

        // ưu tiên Head
        for (Role r : roles) {
            if ("Trưởng Bộ phận (IT Head)".equals(r.getName())) return r;
        }
        // ưu tiên PM
        for (Role r : roles) {
            if ("Quản lý Dự án/Trưởng phòng".equals(r.getName())) return r;
        }
        // mặc định role đầu tiên
        return roles.get(0);
    }
}
