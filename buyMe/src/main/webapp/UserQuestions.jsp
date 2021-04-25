<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Customer Service</title>
</head>
<body>
	<form method="post" action="Questions.jsp">
		<input type ="text" name="search"/><span>&#60;</span>--Search Questions
		<br>
		<input type="submit" name="search" value=""/><span>&#60;</span>--View All Questions
	</form>
	<br>
	<br>
	<form method="post" action="newQuestion.jsp">
		Ask A New Question<input type="text" name="ask" />
	</form>
	
	<br><br>
	<%--back button--%>
	<form method="post" action="EndUserCustomer.jsp">
 		<input type="submit" value="Back" />
	</form>
</body>
</html>