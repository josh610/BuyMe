<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<title>New Question</title>
</head>
<body>
	<%
	try {
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		String question = request.getParameter("ask");
		if(question.length() > 200){
			out.print("Question cannot exceed 200 characters. Please try again.");
		}
		else{
			Statement stmt = con.createStatement();
			ResultSet result = stmt.executeQuery("SELECT max(qID) qid FROM question;");
			result.next();
			int qID = result.getInt("qid") + 1;
			
			if(session.getAttribute("usern") == null) {
				out.print("There was an error with your account. Please log back in.");
				%>
				<%--Return to home button--%>
				<form method="post" action="home.jsp">
		  		<input type="submit" value="Return to Home Page" />
				</form>
				<%
			}
			
			else{
				String username = session.getAttribute("usern").toString();
				
				String query =
					"INSERT INTO question VALUES(" +
					qID + ", '" + question + "', NULL, '" + username + "', NULL" +
					");";
				PreparedStatement ps = con.prepareStatement(query);
				int r = ps.executeUpdate(); 
				
				//check if the account was added or not. 
				if(r > 0) {
					out.print("Your question has been submitted.");	
				}
				
				else{
					out.print("Your question could not be submitted, please try again.");
				}
			}
		}
	//close the connection.
	db.closeConnection(con);
	} catch (Exception e) {
		out.print("Question failed. Please try again.");
		
		if(session.getAttribute("usert") == null){
			%>
			<form method="post" action="UserQuestion">
	  		<input type="submit" value="Back" />
			</form>
			<%
		}
				
	}
	%>
	
	<br><br>
	<%--back button--%>
	<form method="post" action="EndUserCustomer.jsp">
 		<input type="submit" value="Back" />
	</form>

</body>
</html>