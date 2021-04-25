<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Checking Credentials</title>
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
					
					//If its a user, go to EndUserCostumer page. 
					if(accountType.equals("user")) {
						//Now that the account has been logged into, the password is no longer needed. 
						session.setAttribute("usern", givenUser);
						session.setAttribute("usert", "user");
		    	        response.sendRedirect("EndUserCustomer.jsp"); //redirect to customer jsp with the username
						
					}
					//If it's an admin
					else if(accountType.equals("admin")) {
						session.setAttribute("usern", givenUser); 
						session.setAttribute("usert", "admin");
		    	        response.sendRedirect("Admin.jsp"); //redirect to AdminAccount.jsp
					}
					//If it's a customer rep
					else{
						session.setAttribute("usern", givenUser); 
						session.setAttribute("usert", "representative");
		    	        response.sendRedirect("CustomerRep.jsp"); //redirect to CustomerRep.jsp
					}
					
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