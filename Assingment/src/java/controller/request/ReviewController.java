package controller.request;

import controller.iam.BaseRequiredAuthorizationController;
import dal.EnrollmentDBContext;
import dal.RequestForLeaveDBContext;
import dal.NotificationDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import model.Employee;
import model.RequestForLeave;
import model.Notification;
import model.iam.User;

@WebServlet(urlPatterns = "/request/review")
public class ReviewController extends BaseRequiredAuthorizationController {

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        int rid = Integer.parseInt(req.getParameter("id"));
        HttpSession session = req.getSession();

        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        EnrollmentDBContext enrollDB = new EnrollmentDBContext();
        NotificationDBContext notiDB = new NotificationDBContext();
        int eid = enrollDB.getEmployeeIdByUserId(user.getId());

        try {
            switch (action) {
                case "delete" -> {
                    db.delete(rid);
                    session.setAttribute("success", "Xóa đơn nghỉ phép thành công!");
                }

                case "approve" -> {
                    db.updateStatus(rid, 1, eid);
                    session.setAttribute("success", "Đơn đã được chấp nhận!");

                    // Lấy lại đơn
                    RequestForLeave reqLeave = db.get(rid);
                    if (reqLeave != null && reqLeave.getCreated_by() != null) {
                        Notification n = new Notification();
                        n.setEid(reqLeave.getCreated_by().getId()); // gửi cho người tạo đơn
                        n.setMessage("Đơn nghỉ phép #" + rid + " của bạn đã được chấp nhận!");
                        n.setCreatedTime(new Timestamp(System.currentTimeMillis()));
                        n.setIsSeen(false);
                        notiDB.insert(n);
                    } else {
                        System.out.println("⚠️ Không tìm thấy RequestForLeave #" + rid);
                    }
                }

                case "reject" -> {
                    db.updateStatus(rid, 2, eid);
                    session.setAttribute("success", "Đơn đã bị từ chối!");

                    // Lấy lại đơn
                    RequestForLeave reqLeave = db.get(rid);
                    if (reqLeave != null && reqLeave.getCreated_by() != null) {
                        Notification n = new Notification();
                        n.setEid(reqLeave.getCreated_by().getId());
                        n.setMessage("Đơn nghỉ phép #" + rid + " của bạn đã bị từ chối!");
                        n.setCreatedTime(new Timestamp(System.currentTimeMillis()));
                        n.setIsSeen(false);
                        notiDB.insert(n);
                    } else {
                        System.out.println("⚠️ Không tìm thấy RequestForLeave #" + rid);
                    }
                }

            }
        } catch (Exception ex) {
            session.setAttribute("error", "Đã xảy ra lỗi: " + ex.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/request/list");
    }

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        String idRaw = req.getParameter("id");
        if (idRaw == null) {
            resp.sendRedirect(req.getContextPath() + "/request/list");
            return;
        }

        int rid = Integer.parseInt(idRaw);
        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        RequestForLeave reqLeave = db.get(rid);

        if (reqLeave == null) {
            req.setAttribute("error", "Không tìm thấy đơn nghỉ phép!");
            req.getRequestDispatcher("../view/request/review.jsp").forward(req, resp);
            return;
        }

        EnrollmentDBContext enrollDB = new EnrollmentDBContext();
        int eid = enrollDB.getEmployeeIdByUserId(user.getId());
        Employee emp = enrollDB.get(eid);

        boolean isOwner = (reqLeave.getCreated_by() != null
                && reqLeave.getCreated_by().getId() == emp.getId());

        req.setAttribute("isOwner", isOwner);
        req.setAttribute("reqLeave", reqLeave);
        req.setAttribute("employee", emp);

        req.getRequestDispatcher("../view/request/review.jsp").forward(req, resp);
    }
}
