package controller.home;

import controller.iam.BaseRequiredAuthenticationController;
import dal.EnrollmentDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Employee;
import model.iam.User;

@WebServlet(urlPatterns = "/home")
public class HomeController extends BaseRequiredAuthenticationController {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        doGet(req, resp, user); // xử lý chung
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        // --- Thông tin người dùng đang đăng nhập
        req.setAttribute("user", user);

        // --- Xử lý tìm kiếm nhân sự
        String ename = req.getParameter("ename");
        if (ename != null && !ename.trim().isEmpty()) {
            EnrollmentDBContext enrollDB = new EnrollmentDBContext();
            Employee emp = enrollDB.getByName(ename.trim());

            if (emp != null) {
                req.setAttribute("foundEmployee", emp);
            } else {
                req.setAttribute("error", "❌ Không tìm thấy nhân viên '" + ename + "' trong công ty!");
            }
        }

        // --- Trả về trang home.jsp
        req.getRequestDispatcher("view/auth/home.jsp").forward(req, resp);
    }
}
