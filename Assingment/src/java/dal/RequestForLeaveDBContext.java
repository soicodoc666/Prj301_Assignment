package dal;

import java.util.ArrayList;
import model.RequestForLeave;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Employee;

public class RequestForLeaveDBContext extends DBContext<RequestForLeave> {

    // Lấy tất cả đơn nghỉ phép của nhân viên và cấp dưới
    public ArrayList<RequestForLeave> getByEmployeeAndSubodiaries(int eid) {
        ArrayList<RequestForLeave> rfls = new ArrayList<>();
        String sql = """
            WITH Org AS (
                SELECT *, 0 AS lvl FROM Employee e WHERE e.eid = ?
                UNION ALL
                SELECT c.*, o.lvl + 1 AS lvl 
                FROM Employee c 
                JOIN Org o ON c.supervisorid = o.eid
            )
            SELECT
                r.rid,
                r.created_by,
                e.ename AS created_name,
                r.title,
                r.created_time,
                r.[from],
                r.[to],
                r.reason,
                r.status,
                r.processed_by,
                p.ename AS processed_name
            FROM Org e 
            INNER JOIN RequestForLeave r ON e.eid = r.created_by
            LEFT JOIN Employee p ON p.eid = r.processed_by
            ORDER BY r.created_time ASC
        """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, eid);
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                RequestForLeave rfl = new RequestForLeave();
                rfl.setId(rs.getInt("rid"));
                rfl.setTitle(rs.getString("title"));
                rfl.setCreated_time(rs.getTimestamp("created_time"));
                rfl.setFrom(rs.getDate("from"));
                rfl.setTo(rs.getDate("to"));
                rfl.setReason(rs.getString("reason"));
                rfl.setStatus(rs.getInt("status"));

                Employee created_by = new Employee();
                created_by.setId(rs.getInt("created_by"));
                created_by.setName(rs.getString("created_name"));
                rfl.setCreated_by(created_by);

                int processed_by_id = rs.getInt("processed_by");
                if (processed_by_id != 0) {
                    Employee processed_by = new Employee();
                    processed_by.setId(rs.getInt("processed_by"));
                    processed_by.setName(rs.getString("processed_name"));
                    rfl.setProcessed_by(processed_by);
                }

                rfls.add(rfl);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return rfls;
    }

    // Thêm đơn nghỉ phép mới
    @Override
    public void insert(RequestForLeave model) {
        String sql = """
            INSERT INTO RequestForLeave 
            (created_by, created_time, title, [from], [to], reason, status)
            VALUES (?, GETDATE(), ?, ?, ?, ?, ?)
        """;
        try {
            connection.setAutoCommit(false);
            PreparedStatement stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stm.setInt(1, model.getCreated_by().getId());
            stm.setString(2, model.getTitle());
            stm.setDate(3, model.getFrom());
            stm.setDate(4, model.getTo());
            stm.setString(5, model.getReason());
            stm.setInt(6, model.getStatus());
            stm.executeUpdate();
            connection.commit();
            ResultSet rs = stm.getGeneratedKeys();
            if (rs.next()) {
                model.setId(rs.getInt(1));
            }
        } catch (SQLException ex) {
            try {
                connection.rollback();
            } catch (SQLException e) {
            }
            Logger.getLogger(RequestForLeaveDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
            }
            closeConnection();
        }
    }


    // Xóa đơn nghỉ phép
    public void delete(int rid) {
        String sql = "DELETE FROM RequestForLeave WHERE rid = ?";
        try {
            connection.setAutoCommit(false);
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, rid);
            int rows = stm.executeUpdate();
            System.out.println("🗑 DELETE rows = " + rows); // Log debug
            connection.commit();
        } catch (SQLException ex) {
            try {
                connection.rollback();
            } catch (SQLException e) {
            }
            Logger.getLogger(RequestForLeaveDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
            }
            closeConnection();
        }
    }

    // Duyệt / Từ chối
    public void updateStatus(int rid, int status, int processedBy) {
        String sql = "UPDATE RequestForLeave SET status = ?, processed_by = ? WHERE rid = ?";
        try {
            connection.setAutoCommit(false);
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, status);
            stm.setInt(2, processedBy);
            stm.setInt(3, rid);
            int rows = stm.executeUpdate();
            System.out.println("⚙️ updateStatus rows = " + rows); // Log debug
            connection.commit();
        } catch (SQLException ex) {
            try {
                connection.rollback();
            } catch (SQLException e) {
            }
            Logger.getLogger(RequestForLeaveDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
            }
            closeConnection();
        }
    }

    // Lấy chi tiết 1 đơn
    @Override
    public RequestForLeave get(int id) {
        RequestForLeave rfl = null;
        String sql = """
            SELECT 
                r.rid, r.title, r.created_time, r.[from], r.[to],
                r.reason, r.status,
                e.eid AS created_by_id, e.ename AS created_by_name,
                p.eid AS processed_by_id, p.ename AS processed_by_name
            FROM RequestForLeave r
            JOIN Employee e ON e.eid = r.created_by
            LEFT JOIN Employee p ON p.eid = r.processed_by
            WHERE r.rid = ?
        """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                rfl = new RequestForLeave();
                rfl.setId(rs.getInt("rid"));
                rfl.setTitle(rs.getString("title"));
                rfl.setCreated_time(rs.getTimestamp("created_time"));
                rfl.setFrom(rs.getDate("from"));
                rfl.setTo(rs.getDate("to"));
                rfl.setReason(rs.getString("reason"));
                rfl.setStatus(rs.getInt("status"));

                Employee creator = new Employee();
                creator.setId(rs.getInt("created_by_id"));
                creator.setName(rs.getString("created_by_name"));
                rfl.setCreated_by(creator);

                int pid = rs.getInt("processed_by_id");
                if (!rs.wasNull()) {
                    Employee processed = new Employee();
                    processed.setId(pid);
                    processed.setName(rs.getString("processed_by_name"));
                    rfl.setProcessed_by(processed);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return rfl;
    }

    public ArrayList<RequestForLeave> getLeavesInRangeByDivision(int eid, java.sql.Date from, java.sql.Date to) {
        ArrayList<RequestForLeave> list = new ArrayList<>();
        try {
            String sql = """
            WITH Org AS (
                SELECT eid FROM Employee WHERE eid = ?
                UNION ALL
                SELECT e.eid FROM Employee e 
                JOIN Org o ON e.supervisorid = o.eid
            )
            SELECT 
                r.rid,
                r.created_by,
                e.ename AS created_name,
                r.title,
                r.[from],
                r.[to],
                r.reason,
                r.status
            FROM RequestForLeave r
            JOIN Org o ON o.eid = r.created_by
            JOIN Employee e ON e.eid = r.created_by
            WHERE r.[to] >= ? 
              AND r.[from] <= ? 
              AND r.status = 1
            ORDER BY e.ename
        """;

            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, eid);
            stm.setDate(2, from);
            stm.setDate(3, to);

            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                RequestForLeave rfl = new RequestForLeave();
                rfl.setId(rs.getInt("rid"));
                rfl.setTitle(rs.getString("title"));
                rfl.setFrom(rs.getDate("from"));
                rfl.setTo(rs.getDate("to"));
                rfl.setReason(rs.getString("reason"));
                rfl.setStatus(rs.getInt("status"));

                Employee emp = new Employee();
                emp.setId(rs.getInt("created_by"));
                emp.setName(rs.getString("created_name"));
                rfl.setCreated_by(emp);

                list.add(rfl);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return list;
    }

    @Override
    public void delete(RequestForLeave model) {
        throw new UnsupportedOperationException("Not supported.");
    }

    @Override
    public ArrayList<RequestForLeave> list() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void update(RequestForLeave model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}
