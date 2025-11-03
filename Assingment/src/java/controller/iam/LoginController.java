/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.iam;

import dal.UserDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.iam.User;


@WebServlet(urlPatterns = "/login")
public class LoginController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // ✅ Validation cơ bản
        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập đầy đủ thông tin đăng nhập!");
            req.getRequestDispatcher("view/auth/login.jsp").forward(req, resp);
            return;
        }

        // ✅ Kiểm tra trong database
        UserDBContext db = new UserDBContext();
        User u = db.get(username, password);

        if (u != null) {
            // ✅ Đăng nhập thành công
            HttpSession session = req.getSession();
            session.setAttribute("auth", u);

            // ✅ Dùng context path để chuyển hướng an toàn (tránh lỗi Access Denied do sai path)
            resp.sendRedirect(req.getContextPath() + "/home");
        } else {
            // ❌ Sai tài khoản hoặc mật khẩu
            req.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng!");
            req.getRequestDispatcher("view/auth/login.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Nếu người dùng đã đăng nhập thì chuyển sang home luôn
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            resp.sendRedirect(req.getContextPath() + "/home");
        } else {
            req.getRequestDispatcher("view/auth/login.jsp").forward(req, resp);
        }
    }
}
