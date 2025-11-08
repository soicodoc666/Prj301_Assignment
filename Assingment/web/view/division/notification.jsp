<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Thông báo</title>
<style>
body { font-family:"Segoe UI",sans-serif; padding:20px; background:#f4f6f8; }
h2 { color:#333; }
.noti { background:white; border:1px solid #ddd; padding:10px; margin-bottom:5px; border-radius:5px; }
.unseen { background:#ffd6d6; }
.seen { background:#d0e7ff; }
button { padding:5px 10px; margin:5px; cursor:pointer; }
</style>
</head>
<body>
<h2>Thông báo của bạn</h2>

<c:if test="${empty notifications}">
    <p>Chưa có thông báo nào</p>
</c:if>

<c:if test="${not empty notifications}">
    <form action="${pageContext.request.contextPath}/division/notification" method="post">
        <input type="hidden" name="action" value="markAll"/>
        <button type="submit">Đánh dấu tất cả đã xem</button>
    </form>

    <c:forEach var="n" items="${notifications}">
        <div class="noti ${n.isSeen ? 'seen':'unseen'}">
            <p>${n.message}</p>
            <small>${n.createdTime}</small>
            <c:if test="${!n.isSeen}">
                <form style="display:inline" action="${pageContext.request.contextPath}/division/notification" method="post">
                    <input type="hidden" name="action" value="markOne"/>
                    <input type="hidden" name="nid" value="${n.nid}"/>
                    <button type="submit">Đã xem</button>
                </form>
            </c:if>
        </div>
    </c:forEach>
</c:if>

</body>
</html>
