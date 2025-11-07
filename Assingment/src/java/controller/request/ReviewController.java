package controller.request;

import controller.iam.BaseRequiredAuthorizationController;
import dal.EnrollmentDBContext;
import dal.RequestForLeaveDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Employee;
import model.RequestForLeave;
import model.iam.User;

@WebServlet(urlPatterns = "/request/review")
public class ReviewController extends BaseRequiredAuthorizationController {

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        int rid = Integer.parseInt(req.getParameter("id"));

        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        RequestForLeave reqLeave = db.get(rid);

        if (reqLeave == null) {
            req.getSession().setAttribute("error", "Không tìm thấy đơn nghỉ phép để xử lý!");
            resp.sendRedirect(req.getContextPath() + "/request/list");
            return;
        }

        EnrollmentDBContext enrollDB = new EnrollmentDBContext();
        int eid = enrollDB.getEmployeeIdByUserId(user.getId());
        Employee emp = enrollDB.get(eid);

        String message = null;

        switch (action) {
            case "update" -> {
                String title = req.getParameter("title");
                String reason = req.getParameter("reason");
                String fromStr = req.getParameter("from");
                String toStr = req.getParameter("to");

                try {
                    java.sql.Date from = java.sql.Date.valueOf(fromStr);
                    java.sql.Date to = java.sql.Date.valueOf(toStr);

                    reqLeave.setTitle(title);
                    reqLeave.setReason(reason);
                    reqLeave.setFrom(from);
                    reqLeave.setTo(to);

                    db.update(reqLeave);
                    message = "✅ Cập nhật đơn nghỉ phép thành công!";
                } catch (IllegalArgumentException e) {
                    req.getSession().setAttribute("error", "❌ Ngày tháng không hợp lệ (yyyy-MM-dd)!");
                    resp.sendRedirect(req.getContextPath() + "/request/list");
                    return;
                }
            }

            case "delete" -> {
                db.delete(reqLeave);
                message = "🗑️ Đã xóa đơn nghỉ phép thành công!";
            }

            case "approve" -> {
                reqLeave.setStatus(1);
                reqLeave.setProcessed_by(emp);
                db.update(reqLeave);
                message = "✅ Đơn đã được chấp nhận!";
            }

            case "reject" -> {
                reqLeave.setStatus(2);
                reqLeave.setProcessed_by(emp);
                db.update(reqLeave);
                message = "❌ Đơn đã bị từ chối!";
            }
        }

        // ✅ Lưu thông báo vào session
        req.getSession().setAttribute("success", message);

        // ✅ Tránh trình duyệt hiển thị dữ liệu cũ trong cache
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);

        // ✅ Quay về danh sách và load lại dữ liệu mới
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
