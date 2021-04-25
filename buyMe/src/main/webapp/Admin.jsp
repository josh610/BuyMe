<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Admin</title>
</head>
<body>
	<%
	if(session.getAttribute("usern") == null) {
		out.print("No Account Found.");
		%>
		<%--Return to home button--%>
		<form method="post" action="home.jsp">
  		<input type="submit" value="Return to Home Page" />
		</form>
		<%
	}
	else{
		
		%>
		<br>
		<br>
		Create Customer Representative Account
		<%--Create customer rep account--%>
		<form method="get" action="create.jsp">
			username <input type ="text" name="usern">
			password <input type ="text" name="passw">
			<input type="submit" value="Create Account">
		<br>
		<br>
		<br>
		</form>
		
		<form  method="post" action="SalesReport.jsp"> 
  		<input  type="submit" value="Create a Sales Report" />
  		</form>
	<%
	}
	%>
	<br><br>
	<%--Log Out button--%>
	<form method="post" action="logOut.jsp">
 		<input type="submit" value="Log Out and Return Home" />
	</form>
</body>
</html>