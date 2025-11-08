package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Notification;

public class NotificationDBContext extends DBContext<Notification> {

    // Lấy tất cả thông báo của 1 nhân viên, sắp xếp theo thời gian giảm dần
    public ArrayList<Notification> getNotificationsByEmployee(int eid) {
        ArrayList<Notification> list = new ArrayList<>();
        String sql = "SELECT nid, eid, message, created_time, is_seen FROM Notification WHERE eid=? ORDER BY created_time DESC";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, eid);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Notification n = new Notification();
                n.setNid(rs.getInt("nid"));
                n.setEid(rs.getInt("eid"));
                n.setMessage(rs.getString("message"));
                n.setCreatedTime(rs.getTimestamp("created_time"));
                n.setIsSeen(rs.getBoolean("is_seen"));
                list.add(n);
            }
        } catch (SQLException ex) {
            Logger.getLogger(NotificationDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // Lấy số lượng thông báo chưa xem
    public int countUnseen(int eid) {
        int count = 0;
        String sql = "SELECT COUNT(*) AS cnt FROM Notification WHERE eid=? AND is_seen=0";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, eid);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                count = rs.getInt("cnt");
            }
        } catch (SQLException ex) {
            Logger.getLogger(NotificationDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return count;
    }

    // Đánh dấu 1 thông báo là đã xem
    public void markAsSeen(int nid) {
        String sql = "UPDATE Notification SET is_seen=1 WHERE nid=?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, nid);
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(NotificationDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // Đánh dấu tất cả thông báo của 1 nhân viên là đã xem
    public void markAllAsSeen(int eid) {
        String sql = "UPDATE Notification SET is_seen=1 WHERE eid=?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, eid);
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(NotificationDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // Thêm 1 thông báo mới
    public void insert(Notification n) {
        String sql = "INSERT INTO Notification(eid, message, created_time, is_seen) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, n.getEid());
            stm.setString(2, n.getMessage());
            stm.setTimestamp(3, n.getCreatedTime());
            stm.setBoolean(4, n.getIsSeen());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(NotificationDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // --- Các phương thức trừu tượng từ DBContext ---
    @Override
    public ArrayList<Notification> list() {
        return new ArrayList<>(); // hoặc throw new UnsupportedOperationException()
    }

    @Override
    public Notification get(int id) {
        Notification n = null;
        String sql = "SELECT nid, eid, message, created_time, is_seen FROM Notification WHERE nid=?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                n = new Notification();
                n.setNid(rs.getInt("nid"));
                n.setEid(rs.getInt("eid"));
                n.setMessage(rs.getString("message"));
                n.setCreatedTime(rs.getTimestamp("created_time"));
                n.setIsSeen(rs.getBoolean("is_seen"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(NotificationDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return n;
    }

    @Override
    public void update(Notification n) {
        String sql = "UPDATE Notification SET message=?, is_seen=? WHERE nid=?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, n.getMessage());
            stm.setBoolean(2, n.getIsSeen());
            stm.setInt(3, n.getNid());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(NotificationDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public void delete(Notification n) {
        String sql = "DELETE FROM Notification WHERE nid=?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, n.getNid());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(NotificationDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
