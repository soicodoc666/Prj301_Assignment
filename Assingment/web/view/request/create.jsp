    <%@page contentType="text/html" pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <!DOCTYPE html>
    <html lang="vi">
        <head>
            <meta charset="UTF-8">
            <title>Tạo đơn nghỉ phép</title>
            <style>
                body {
                    font-family: "Segoe UI", sans-serif;
                    background-color: #f4f6f8;
                    margin: 0;
                    padding: 0;
                }

                header {
                    background-color: #e1251b;
                    color: white;
                    padding: 15px 30px;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .container {
                    max-width: 700px;
                    margin: 40px auto;
                    background: white;
                    border-radius: 10px;
                    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                    padding: 30px;
                }

                h2 {
                    text-align: center;
                    color: #333;
                    margin-bottom: 20px;
                }

                label {
                    display: block;
                    margin-top: 15px;
                    font-weight: bold;
                }

                input[type="text"],
                input[type="date"],
                textarea {
                    width: 100%;
                    padding: 10px;
                    border-radius: 6px;
                    border: 1px solid #ccc;
                    margin-top: 5px;
                    font-size: 15px;
                }

                textarea {
                    resize: none;
                }

                button {
                    margin-top: 25px;
                    background-color: #e1251b;
                    color: white;
                    border: none;
                    padding: 12px 20px;
                    border-radius: 6px;
                    cursor: pointer;
                    font-size: 15px;
                    font-weight: bold;
                    width: 100%;
                }

                button:hover {
                    background-color: #c51d15;
                }


                .message {
                    margin-top: 20px;
                    font-weight: bold;
                    text-align: center;
                }

                .success {
                    color: #28a745;
                }

                .error {
                    color: #dc3545;
                }

                a.back {
                    color: white;
                    text-decoration: none;
                    font-weight: bold;
                }

                a.back:hover {
                    text-decoration: underline;
                }
            </style>
        </head>
        <body>

            <header>
                <h2>Tạo đơn nghỉ phép</h2>
                <a href="../home" class="back">← Quay lại</a>
            </header>

            <div class="container">
                <form action="create" method="post">
                    <label for="title">📌 Tiêu đề:</label>
                    <input type="text" id="title" name="title" placeholder="Nhập tiêu đề nghỉ phép..." required>

                    <label for="from">📅 Từ ngày:</label>
                    <input type="date" id="from" name="from" required>

                    <label for="to">📅 Đến ngày:</label>
                    <input type="date" id="to" name="to" required>

                    <label for="reason">📝 Lý do:</label>
                    <textarea id="reason" name="reason" rows="4" placeholder="Nhập lý do nghỉ..." required></textarea>

                    <button type="submit">Gửi đơn nghỉ phép</button>
                </form>

                <c:if test="${not empty success}">
                    <div class="message success">${success}</div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="message error">${error}</div>
                </c:if>
            </div>

        </body>
    </html>
