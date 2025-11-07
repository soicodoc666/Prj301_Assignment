package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Employee;
import model.Schedule;

public class ScheduleDBContext extends DBContext<Schedule> {

    public ArrayList<Schedule> getSchedulesInRange(Date from, Date to){
        ArrayList<Schedule> list = new ArrayList<>();
        String sql = "SELECT s.id, s.eid, e.ename, s.schedule_date, s.task " +
                     "FROM Schedule s JOIN Employee e ON s.eid = e.eid " +
                     "WHERE s.schedule_date BETWEEN ? AND ?";

        try(PreparedStatement stm = connection.prepareStatement(sql)){
            stm.setDate(1, from);
            stm.setDate(2, to);
            ResultSet rs = stm.executeQuery();
            while(rs.next()){
                Schedule s = new Schedule();
                s.setId(rs.getInt("id"));
                Employee e = new Employee();
                e.setId(rs.getInt("eid"));
                e.setName(rs.getString("ename"));
                s.setEmployee(e);
                s.setDate(rs.getDate("schedule_date"));
                s.setTask(rs.getString("task"));
                list.add(s);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ScheduleDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return list;
    }

    @Override
    public void insert(Schedule model) { throw new UnsupportedOperationException(); }
    @Override
    public void update(Schedule model) { throw new UnsupportedOperationException(); }
    @Override
    public void delete(Schedule model) { throw new UnsupportedOperationException(); }
    @Override
    public Schedule get(int id) { throw new UnsupportedOperationException(); }
    @Override
    public ArrayList<Schedule> list() { throw new UnsupportedOperationException(); }
}
