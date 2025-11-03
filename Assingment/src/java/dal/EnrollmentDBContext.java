/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Department;
import model.Employee;

/**
 * Dùng để ánh xạ giữa User và Employee Ví dụ: lấy Employee ID từ User ID (đang
 * đăng nhập)
 */
public class EnrollmentDBContext extends DBContext<Employee> {

    /**
     * Lấy employee id dựa trên user id
     *
     * @param uid user id đang đăng nhập
     * @return employee id tương ứng, hoặc -1 nếu không có
     */
    public int getEmployeeIdByUserId(int uid) {
        int eid = -1;
        try {
            String sql = "SELECT eid FROM Enrollment WHERE uid = ? AND active = 1";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, uid);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                eid = rs.getInt("eid");
            }
        } catch (SQLException ex) {
            Logger.getLogger(EnrollmentDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return eid;
    }

    /**
     * Lấy thông tin Employee (bao gồm tên, phòng ban, supervisor)
     */
    @Override
    public Employee get(int id) {
        Employee e = null;
        try {
            String sql = """
                SELECT e.eid, e.ename, e.did, e.supervisorid
                FROM Employee e
                WHERE e.eid = ?
            """;
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                e = new Employee();
                e.setId(rs.getInt("eid"));
                e.setName(rs.getString("ename"));
                // có thể thêm lấy supervisor hoặc department nếu cần
            }
        } catch (SQLException ex) {
            Logger.getLogger(EnrollmentDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return e;
    }

    @Override
    public ArrayList<Employee> list() {
        ArrayList<Employee> list = new ArrayList<>();
        try {
            String sql = "SELECT eid, ename FROM Employee";
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Employee e = new Employee();
                e.setId(rs.getInt("eid"));
                e.setName(rs.getString("ename"));
                list.add(e);
            }
        } catch (SQLException ex) {
            Logger.getLogger(EnrollmentDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return list;
    }

    public Employee getByName(String name) {
    Employee e = null;
    try {
        String sql = """
            SELECT e.eid, e.ename,
                   d.did, d.dname,
                   s.eid AS sid, s.ename AS sname
            FROM Employee e
            LEFT JOIN Department d ON e.did = d.did
            LEFT JOIN Employee s ON e.supervisorid = s.eid
            WHERE e.ename = ?
        """;
        PreparedStatement stm = connection.prepareStatement(sql);
        stm.setString(1, name);
        ResultSet rs = stm.executeQuery();
        if (rs.next()) {
            e = new Employee();
            e.setId(rs.getInt("eid"));
            e.setName(rs.getString("ename"));

            // Gán phòng ban
            Department d = new Department();
            d.setId(rs.getInt("did"));
            d.setName(rs.getString("dname"));
            e.setDept(d);

            // Gán người quản lý
            Employee s = new Employee();
            s.setId(rs.getInt("sid"));
            s.setName(rs.getString("sname"));
            e.setSupervisor(s);
        }
    } catch (SQLException ex) {
        Logger.getLogger(EnrollmentDBContext.class.getName()).log(Level.SEVERE, null, ex);
    } finally {
        closeConnection();
    }
    return e;
}


    @Override
    public void insert(Employee model) {
        throw new UnsupportedOperationException("Insert Employee not supported.");
    }

    @Override
    public void update(Employee model) {
        throw new UnsupportedOperationException("Update Employee not supported.");
    }

    @Override
    public void delete(Employee model) {
        throw new UnsupportedOperationException("Delete Employee not supported.");
    }
}
