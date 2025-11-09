package controller.request;

import controller.iam.BaseRequiredAuthorizationController;
import dal.EnrollmentDBContext;
import dal.RequestForLeaveDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import model.Employee;
import model.RequestForLeave;
import model.iam.User;

@WebServlet(urlPatterns = "/request/list")
public class ListController extends BaseRequiredAuthorizationController {

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        EnrollmentDBContext enrollDB = new EnrollmentDBContext();
        int eid = enrollDB.getEmployeeIdByUserId(user.getId());
        Employee emp = enrollDB.get(eid);

        // --- Phân trang ---
        int pagesize = 10;
        int pageindex = 1;
        String pageParam = req.getParameter("page");
        if (pageParam != null) {
            try {
                pageindex = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                pageindex = 1;
            }
        }

        // --- Lấy từ khóa tìm kiếm ---
        String keyword = req.getParameter("keyword");
        if (keyword == null) {
            keyword = "";
        }

        // --- Lấy dữ liệu ---
        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        ArrayList<RequestForLeave> rfls = db.getByEmployeeAndSubodiaries(eid, pageindex, pagesize, keyword);
        int count = db.countByEmployeeAndSubodiaries(eid, keyword);

        // --- Tính tổng số trang ---
        int totalpage = (count % pagesize == 0) ? (count / pagesize) : (count / pagesize + 1);
        if (totalpage == 0) {
            totalpage = 1;
        }

        // --- Thông báo từ session ---
        String message = (String) req.getSession().getAttribute("message");
        if (message != null) {
            req.setAttribute("message", message);
            req.getSession().removeAttribute("message");
        }

        // --- Gửi dữ liệu cho JSP ---
        req.setAttribute("rfls", rfls);
        req.setAttribute("employee", emp);
        req.setAttribute("pageindex", pageindex);
        req.setAttribute("totalpage", totalpage);
        req.setAttribute("keyword", keyword); // để giữ lại khi search

        System.out.println("[DEBUG] count=" + count + ", totalpage=" + totalpage + ", rfls.size=" + rfls.size());

        req.getRequestDispatcher("../view/request/list.jsp").forward(req, resp);
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet.");
    }
}
