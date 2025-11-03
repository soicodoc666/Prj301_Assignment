<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đơn xin nghỉ phép</title>
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background-color: #f8f9fb;
            margin: 0;
            padding: 0;
        }
        header {
            background-color: #e1251b;
            color: white;
            padding: 15px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .container {
            max-width: 600px;
            margin: 60px auto;
            background: white;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 5px 10px rgba(0,0,0,0.1);
        }
        h2 { text-align: center; color: #333; }
        input, textarea {
            width: 100%;
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 15px;
        }
        button {
            background-color: #e1251b;
            color: white;
            border: none;
            padding: 10px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
        }
        button:hover { background-color: #c51d15; }
        .msg { text-align: center; margin-bottom: 10px; font-weight: bold; }
        .error { color: red; }
        .success { color: green; }
        .info-box {
            background-color: #f0f0f0;
            border-left: 4px solid #e1251b;
            padding: 10px 15px;
            margin-bottom: 15px;
            border-radius: 6px;
        }
    </style>
</head>
<body>
<header>
    <h2>📝 Tạo đơn xin nghỉ phép</h2>
    <a href="../home" style="color:white;text-decoration:none;">⬅ Quay về trang chủ</a>
</header>

<div class="container">
    <div class="msg">
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="success">${success}</div>
        </c:if>
    </div>

    <!-- Form nhập tên nhân viên để hiển thị thông tin -->
    <form method="get" action="create" style="margin-bottom:20px;">
        <label>👤 Nhập tên nhân viên:</label>
        <input type="text" name="ename"  value="${param.ename}" required>
        <button type="submit">Kiểm tra</button>
    </form>

    <!-- Hiển thị thông tin nhân viên -->
    <c:if test="${not empty foundEmployee}">
        <div class="info-box">
            👤 <b>Tên:</b> ${foundEmployee.name} <br>
            🏢 <b>Phòng ban:</b> ${foundEmployee.dept.name} <br>
            🏷 <b>Vai trò:</b> ${foundEmployee.role}
        </div>
    </c:if>

    <!-- Form tạo đơn -->
    <form action="create" method="post">
        <input type="hidden" name="ename" value="${foundEmployee.name}">
        <label>📅 Từ ngày:</label>
        <input type="date" name="from" required>

        <label>📅 Đến ngày:</label>
        <input type="date" name="to" required>

        <label>📝 Lý do nghỉ phép:</label>
        <textarea name="reason" rows="4" placeholder="Nhập lý do nghỉ..." required></textarea>

        <button type="submit">Gửi đơn</button>
    </form>
</div>
</body>
</html>
