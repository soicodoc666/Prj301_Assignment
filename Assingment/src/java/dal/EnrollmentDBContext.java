package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Department;
import model.Employee;

public class EnrollmentDBContext extends DBContext<Employee> {

    /**
     * Lấy employee id dựa trên user id (dành cho user đang đăng nhập)
     */
    public int getEmployeeIdByUserId(int uid) {
        int eid = -1;
        String sql = "SELECT eid FROM Enrollment WHERE uid = ? AND active = 1";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, uid);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                eid = rs.getInt("eid");
            }
        } catch (SQLException ex) {
            Logger.getLogger(EnrollmentDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return eid;
    }

    /**
     * Lấy thông tin đầy đủ của Employee (tên, phòng ban, vai trò, supervisor)
     */
    @Override
    public Employee get(int id) {
        Employee e = null;
        String sql = """
            SELECT e.eid, e.ename, e.supervisorid,
                   d.did, d.dname, r.rname
            FROM Employee e
            JOIN Division d ON e.did = d.did
            JOIN Enrollment en ON e.eid = en.eid
            JOIN UserRole ur ON en.uid = ur.uid
            JOIN Role r ON ur.rid = r.rid
            WHERE e.eid = ?
        """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                e = new Employee();
                e.setId(rs.getInt("eid"));
                e.setName(rs.getString("ename"));
                e.setRole(rs.getString("rname"));

                Department dept = new Department();
                dept.setId(rs.getInt("did"));
                dept.setName(rs.getString("dname"));
                e.setDept(dept);

                // ✅ Gắn supervisor nếu có
                int supervisorId = rs.getInt("supervisorid");
                if (supervisorId != 0) {
                    Employee supervisor = getSupervisorByEmployeeId(supervisorId);
                    e.setSupervisor(supervisor);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(EnrollmentDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return e;
    }

    /**
     * Lấy supervisor của một nhân viên
     */
    public Employee getSupervisorByEmployeeId(int supervisorId) {
        Employee supervisor = null;
        String sql = "SELECT eid, ename FROM Employee WHERE eid = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, supervisorId);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                supervisor = new Employee();
                supervisor.setId(rs.getInt("eid"));
                supervisor.setName(rs.getString("ename"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(EnrollmentDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return supervisor;
    }

    @Override
    public ArrayList<Employee> list() {
        ArrayList<Employee> list = new ArrayList<>();
        String sql = "SELECT eid, ename FROM Employee";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
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
public ArrayList<Employee> searchByName(String name) {
    ArrayList<Employee> list = new ArrayList<>();
    String sql = """
        SELECT e.eid, e.ename, d.did, d.dname, r.rname
        FROM Employee e
        JOIN Division d ON e.did = d.did
        JOIN Enrollment en ON e.eid = en.eid
        JOIN UserRole ur ON en.uid = ur.uid
        JOIN Role r ON ur.rid = r.rid
        WHERE LOWER(e.ename) LIKE LOWER(?)
    """;
    try (PreparedStatement stm = connection.prepareStatement(sql)) {
        stm.setString(1, "%" + name.trim() + "%");
        ResultSet rs = stm.executeQuery();
        while (rs.next()) {
            Employee e = new Employee();
            e.setId(rs.getInt("eid"));
            e.setName(rs.getString("ename"));

            Department dept = new Department();
            dept.setId(rs.getInt("did"));
            dept.setName(rs.getString("dname"));
            e.setDept(dept);

            e.setRole(rs.getString("rname"));
            list.add(e);
        }
    } catch (SQLException ex) {
        Logger.getLogger(EnrollmentDBContext.class.getName()).log(Level.SEVERE, null, ex);
    } finally {
        closeConnection();
    }
    return list;
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
