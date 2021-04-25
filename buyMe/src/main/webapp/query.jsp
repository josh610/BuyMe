<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Logged In</title>
</head>
<body>

	<%
	
		try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			//Create a SQL statement
			Statement stmt = con.createStatement();
		
			String givenUser = request.getParameter("usern");
			
			//create the query
			String str = "SELECT * FROM account WHERE username = '" + givenUser + "'";
			
			ResultSet result = stmt.executeQuery(str);
			
			//check if there is a username with that name. 
			if(!result.next()) {
				%>
				<br> 
				That login information does not match with an existing account. 
				<br> 
			
				<%--Return to home button--%>
				<form method="post" action="home.jsp">
		  		<input type="submit" value="Return to Home Page" />
				</form>
				<% 
			}
			else{
				
				//the username and password matched. 
				if(result.getString("password").equals(request.getParameter("passw"))) {
				
					String accountType = result.getString("type"); 
					
					%>
					<br> 
					Successfully logged in to a <% out.print(accountType); %> account. 
					<br> 
					
					<%--Return to home button--%>
					<form method="post" action="home.jsp">
	  				<input type="submit" value="Log out and return to Home Page" />
					</form>
					<% 
				
				}
				
				//The username matched but not the password 
				else{
					%>
					<br> 
					That login information does not match with an existing account. 
					<br> 
					
					<%--Return to home button--%>
					<form method="post" action="home.jsp">
	  				<input type="submit" value="Return to Home Page" />
					</form>
					<% 
				}
				
				//Create an auction. 
				//
			
			}
			
			//close the connection.
			con.close();

		} catch (Exception e) {
			out.print(e);
		}
	%>

</body>
</html>