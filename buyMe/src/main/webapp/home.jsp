<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>336 Login</title>
	</head>
	
	<body>
		<% out.println("Login or create an account."); %> 

	<br>
	<form method="get" action="attemptLogin.jsp">
	<td> username </td><td><input type ="text" name="usern"></td>
	<td> password </td><td><input type ="text" name="passw"></td>
	
	<input type="submit" value="Log in">
	</form>
	

	<%--To creaete an account--%>
	<form method="get" action="create.jsp">
	<td> username </td><td><input type ="text" name="usern"></td>
	<td> password </td><td><input type ="text" name="passw"></td>
			
	<input type="submit" value="Create account">
	</form>
		
	
	<br> 

</body>
</html>