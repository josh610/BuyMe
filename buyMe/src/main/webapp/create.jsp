<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Account Creation</title>
</head>
<body>
	<%
		try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			//Create a SQL statement
		
			//create the statement	
			String username = request.getParameter("usern");
			String password = request.getParameter("passw");
			String acctType;
			if(session.getAttribute("usert") == null){
				acctType = "user";
			}
			else acctType = "representative";
			String account = "insert into account values('" + username + "','" + password + "', '" + acctType + "')"; 
			//out.println(account);
			
			//get rid of empty accounts
			if(username.isEmpty() || password.isEmpty()) {
				out.print("Must provide all info to create the account");
			}
			
			else {
				PreparedStatement ps = con.prepareStatement(account);
				int r = ps.executeUpdate(); 
				
				//check if the account was added or not. 
				if(r > 0) {
					out.print("Account successfully created");	
				}
				
				else{
					out.print("The account was not created, try again.");
				}
			}
			
			
			if(session.getAttribute("usert") == null){
				%>
				<%--Return to home button for new user account--%>
				<form method="post" action="home.jsp">
		  		<input type="submit" value="Return to Home Page" />
				</form>
				<%
			}
			else{
				%>
				<%--Return to admin page button for new rep account--%>
				<form method="post" action="Admin.jsp">
		  		<input type="submit" value="Return to Admin Page" />
				</form>
				<%
			}
			
			//close the connection.
			con.close();

		} catch (Exception e) {
			out.print("The account could not be created, try a different username.");
			
			if(session.getAttribute("usert") == null){
				%>
				<%--Return to home button for new user account--%>
				<form method="post" action="home.jsp">
		  		<input type="submit" value="Return to Home Page" />
				</form>
				<%
			}
			else{
				%>
				<%--Return to admin page button for new rep account--%>
				<form method="post" action="Admin.jsp">
		  		<input type="submit" value="Return to Admin Page" />
				</form>
				<%
			}
					
		}
	%>

</body>
</html>