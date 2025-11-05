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
        // ❌ KHÔNG closeConnection() ở đây — để các hàm khác còn dùng
        return eid;
    }

    /**
     * Lấy thông tin đầy đủ của Employee (tên, phòng ban, vai trò)
     */
    @Override
    public Employee get(int id) {
        Employee e = null;
        String sql = """
            SELECT e.eid, e.ename, d.did, d.dname, r.rname
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

                Department dept = new Department();
                dept.setId(rs.getInt("did"));
                dept.setName(rs.getString("dname"));
                e.setDept(dept);

                e.setRole(rs.getString("rname"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(EnrollmentDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection(); // ✅ chỉ đóng 1 lần tại đây
        }
        return e;
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

    public Employee getByName(String name) {
        Employee e = null;
        String sql = """
            SELECT e.eid, e.ename, d.did, d.dname, r.rname
            FROM Employee e
            JOIN Division d ON e.did = d.did
            JOIN Enrollment en ON e.eid = en.eid
            JOIN UserRole ur ON en.uid = ur.uid
            JOIN Role r ON ur.rid = r.rid
            WHERE LOWER(LTRIM(RTRIM(e.ename))) = LOWER(LTRIM(RTRIM(?)))
        """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, name);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                e = new Employee();
                e.setId(rs.getInt("eid"));
                e.setName(rs.getString("ename"));

                Department dept = new Department();
                dept.setId(rs.getInt("did"));
                dept.setName(rs.getString("dname"));
                e.setDept(dept);

                e.setRole(rs.getString("rname"));
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
