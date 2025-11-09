package dal;

import java.util.ArrayList;
import model.RequestForLeave;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Employee;

public class RequestForLeaveDBContext extends DBContext<RequestForLeave> {

//    // Lấy tất cả đơn nghỉ phép của nhân viên và cấp dưới
//    public ArrayList<RequestForLeave> getByEmployeeAndSubodiaries(int eid) {
//        ArrayList<RequestForLeave> rfls = new ArrayList<>();
//        String sql = """
//            WITH Org AS (
//                SELECT *, 0 AS lvl FROM Employee e WHERE e.eid = ?
//                UNION ALL
//                SELECT c.*, o.lvl + 1 AS lvl 
//                FROM Employee c 
//                JOIN Org o ON c.supervisorid = o.eid
//            )
//           SELECT
//                r.rid,
//                r.created_by,
//                e.ename AS created_name,    -- người tạo
//                r.title,
//                r.created_time,
//                r.[from],
//                r.[to],
//                r.reason,
//                r.status,
//                r.processed_by,
//                p.ename AS processed_name   -- người xử lý
//            FROM Employee e
//            INNER JOIN RequestForLeave r ON e.eid = r.created_by
//            LEFT JOIN Employee p ON p.eid = r.processed_by
//            ORDER BY r.created_time DESC;
//        """;
//
//        try (PreparedStatement stm = connection.prepareStatement(sql)) {
//            stm.setInt(1, eid);
//            ResultSet rs = stm.executeQuery();
//
//            while (rs.next()) {
//                RequestForLeave rfl = new RequestForLeave();
//                rfl.setId(rs.getInt("rid"));
//                rfl.setTitle(rs.getString("title"));
//                rfl.setCreated_time(rs.getTimestamp("created_time"));
//                rfl.setFrom(rs.getDate("from"));
//                rfl.setTo(rs.getDate("to"));
//                rfl.setReason(rs.getString("reason"));
//                rfl.setStatus(rs.getInt("status"));
//
//                Employee created_by = new Employee();
//                created_by.setId(rs.getInt("created_by"));
//                created_by.setName(rs.getString("created_name"));
//                rfl.setCreated_by(created_by);
//
//                int processed_by_id = rs.getInt("processed_by");
//                if (processed_by_id != 0) {
//                    Employee processed_by = new Employee();
//                    processed_by.setId(rs.getInt("processed_by"));
//                    processed_by.setName(rs.getString("processed_name"));
//                    rfl.setProcessed_by(processed_by);
//                }
//
//                rfls.add(rfl);
//            }
//        } catch (SQLException ex) {
//            Logger.getLogger(RequestForLeaveDBContext.class.getName()).log(Level.SEVERE, null, ex);
//        } finally {
//            closeConnection();
//        }
//        return rfls;
//    }

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

            ResultSet rs = stm.getGeneratedKeys();
            if (rs.next()) {
                model.setId(rs.getInt(1));
            }

            // 📨 Gửi thông báo cho cấp trên
            String getSupervisorSQL = "SELECT supervisorid FROM Employee WHERE eid = ?";
            PreparedStatement stm2 = connection.prepareStatement(getSupervisorSQL);
            stm2.setInt(1, model.getCreated_by().getId());
            ResultSet rs2 = stm2.executeQuery();
            if (rs2.next()) {
                int supervisorId = rs2.getInt("supervisorid");
                if (supervisorId != 0) {
                    NotificationDBContext notiDB = new NotificationDBContext();
                    model.Notification n = new model.Notification();
                    n.setEid(supervisorId);
                    n.setMessage("📩 Nhân viên " + model.getCreated_by().getName() + " vừa gửi đơn nghỉ phép mới cần bạn duyệt.");
                    n.setCreatedTime(new java.sql.Timestamp(System.currentTimeMillis()));
                    n.setIsSeen(false);
                    notiDB.insert(n);
                }
            }

            connection.commit();
            System.out.println("✅ insert + notify supervisor OK");

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
// Duyệt / Từ chối + Gửi thông báo tự động

    public void updateStatus(int rid, int status, int processedBy) {
        String sql = "UPDATE RequestForLeave SET status = ?, processed_by = ? WHERE rid = ?";
        try {
            connection.setAutoCommit(false);

            // 1️⃣ Cập nhật trạng thái đơn nghỉ phép
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, status);
            stm.setInt(2, processedBy);
            stm.setInt(3, rid);
            int rows = stm.executeUpdate();

            // 2️⃣ Nếu cập nhật thành công → Lấy thông tin chi tiết để gửi thông báo
            if (rows > 0) {
                String getInfoSQL = """
                SELECT 
                    r.created_by, r.processed_by, r.status,
                    c.ename AS created_name,
                    p.ename AS processed_name
                FROM RequestForLeave r
                JOIN Employee c ON c.eid = r.created_by
                LEFT JOIN Employee p ON p.eid = r.processed_by
                WHERE r.rid = ?
            """;

                PreparedStatement infoStm = connection.prepareStatement(getInfoSQL);
                infoStm.setInt(1, rid);
                ResultSet rs = infoStm.executeQuery();

                if (rs.next()) {
                    int createdBy = rs.getInt("created_by");
                    int processedByEmp = rs.getInt("processed_by");
                    String createdName = rs.getString("created_name");
                    String processedName = rs.getString("processed_name");
                    int st = rs.getInt("status");

                    // 3️⃣ Tạo nội dung thông báo
                    String message;
                    if (processedByEmp == createdBy) {
                        message = "Đơn nghỉ phép của bạn đã được tự động duyệt.";
                    } else if (st == 1) {
                        message = "Đơn nghỉ phép của bạn đã được duyệt bởi " + processedName + ".";
                    } else if (st == 2) {
                        message = "Đơn nghỉ phép của bạn đã bị từ chối bởi " + processedName + ".";
                    } else {
                        message = "Trạng thái đơn nghỉ phép của bạn đã được cập nhật.";
                    }

                    // 4️⃣ Ghi thông báo vào bảng Notification
                    NotificationDBContext notiDB = new NotificationDBContext();
                    model.Notification n = new model.Notification();
                    n.setEid(createdBy);
                    n.setMessage(message);
                    n.setCreatedTime(new java.sql.Timestamp(System.currentTimeMillis()));
                    n.setIsSeen(false);
                    notiDB.insert(n);
                }
            }

            connection.commit();
            System.out.println("✅ updateStatus + notification OK!");

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
    // --- Helper map ResultSet sang RequestForLeave ---

    private RequestForLeave mapResultSetToRequest(ResultSet rs) throws SQLException {
        RequestForLeave rfl = new RequestForLeave();
        rfl.setId(rs.getInt("rid"));
        rfl.setTitle(rs.getString("title"));
        rfl.setReason(rs.getString("reason"));
        rfl.setStatus(rs.getInt("status"));
        rfl.setFrom(rs.getDate("from"));
        rfl.setTo(rs.getDate("to"));
        rfl.setCreated_time(rs.getTimestamp("created_time"));

        // Người tạo
        Employee creator = new Employee();
        creator.setId(rs.getInt("created_by"));
        creator.setName(rs.getString("created_name"));
        rfl.setCreated_by(creator);

        // Người xử lý
        int pid = rs.getInt("processed_by");
        if (!rs.wasNull()) {
            Employee processor = new Employee();
            processor.setId(pid);
            processor.setName(rs.getString("processed_name"));
            rfl.setProcessed_by(processor);
        } else {
            rfl.setProcessed_by(null);
        }

        return rfl;
    }

    // --- Lấy danh sách nhân viên và cấp dưới, phân trang ---
    public ArrayList<RequestForLeave> getByEmployeeAndSubodiaries(int eid, int pageindex, int pagesize) {
        ArrayList<RequestForLeave> list = new ArrayList<>();
        String sql = """
            SELECT r.*, 
                   c.ename AS created_name, 
                   p.ename AS processed_name
            FROM RequestForLeave r
            INNER JOIN Employee c ON r.created_by = c.eid
            LEFT JOIN Employee p ON r.processed_by = p.eid
            WHERE r.created_by = ? OR r.created_by IN (SELECT eid FROM Employee WHERE supervisorid = ?)
            ORDER BY r.created_time DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, eid);
            stm.setInt(2, eid);
            stm.setInt(3, (pageindex - 1) * pagesize);
            stm.setInt(4, pagesize);

            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToRequest(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeConnection();
        }

        return list;
    }

    // --- Đếm tổng số đơn ---
    public int countByEmployeeAndSubodiaries(int eid) {
        int count = 0;
        String sql = """
            SELECT COUNT(*) 
            FROM RequestForLeave r
            WHERE r.created_by = ? OR r.created_by IN (SELECT eid FROM Employee WHERE supervisorid = ?)
        """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, eid);
            stm.setInt(2, eid);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeConnection();
        }

        return count;
    }

    // --- Lấy danh sách theo khoảng thời gian ---
    public ArrayList<RequestForLeave> getLeavesInRange(java.sql.Date from, java.sql.Date to) {
        ArrayList<RequestForLeave> list = new ArrayList<>();
        String sql = """
            SELECT r.*, 
                   c.ename AS created_name, 
                   p.ename AS processed_name
            FROM RequestForLeave r
            JOIN Employee c ON r.created_by = c.eid
            LEFT JOIN Employee p ON r.processed_by = p.eid
            WHERE r.[to] >= ? AND r.[from] <= ? AND r.status = 1
            ORDER BY c.ename
        """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setDate(1, from);
            stm.setDate(2, to);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToRequest(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return list;
    }

   
}
