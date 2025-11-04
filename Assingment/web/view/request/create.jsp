<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tạo đơn xin nghỉ phép</title>
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
        h2 {
            text-align: center;
            color: #333;
        }
        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        input, textarea {
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
        button:hover {
            background-color: #c51d15;
        }
        .msg {
            text-align: center;
            margin-bottom: 10px;
            font-weight: bold;
        }
        .error { color: red; }
        .success { color: green; }
        .info-box {
            background: #f9f9f9;
            padding: 15px;
            border-left: 4px solid #e1251b;
            border-radius: 8px;
            margin-bottom: 20px;
            line-height: 1.8;
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

    <!-- ✅ Hiển thị thông tin người dùng -->
    <c:if test="${not empty foundEmployee}">
        <div class="info-box">
            👤 <b>Tên:</b> ${foundEmployee.name} <br>
            🏢 <b>Phòng ban:</b> ${foundEmployee.dept.name} <br>
            🏷 <b>Vai trò:</b> 
            <c:out value="${foundEmployee.role != null ? foundEmployee.role : 'Nhân viên'}" />
        </div>
    </c:if>

    <form action="create" method="post">
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
