<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Delete</title>
</head>
<body>
	<%
		try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			//Create a SQL statement
			Statement stmt = con.createStatement();
		
			//create the statement	
			String newData = request.getParameter("newData");
			String oldData = request.getParameter("oldData");
			String action = request.getParameter("action");
			String condition = request.getParameter("condition");
			
			String query =
					action + newData + condition + oldData;
			//out.println(query);
			
			stmt.executeUpdate(query);
			
			out.print("Success");
			
		} catch (Exception e) {
			out.print("Action could not be performed. Please try again.");		
		}
	%>
	
	<%--Back button--%>
	<form method="post" action="CustomerRep.jsp">
 		<input type="submit" value="Back" />
	</form>

</body>
</html>