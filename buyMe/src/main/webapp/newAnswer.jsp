<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<title>New Answer</title>
</head>
<body>
	<%
	try {
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		
		String answer = request.getParameter("answer");
		if(answer.length() > 200){
			out.print("Answer cannot exceed 200 characters. Please try again.");
		}
		else{
			Statement stmt = con.createStatement();
			String qID = request.getParameter("qid");

			String username = session.getAttribute("usern").toString();
			
			String query =
				"UPDATE question " +
				"SET answer='" + answer + "', " +
				"rep='" + username + "' " +
				"WHERE qID='" + qID + "';";
			PreparedStatement ps = con.prepareStatement(query);
			int r = ps.executeUpdate(); 
			
			//check if the account was added or not. 
			if(r > 0) {
				out.print("Your answer has been submitted.");	
			}
			
			else{
				out.print("Your answer could not be submitted, please try again.");
			}
		}
	//close the connection.
	db.closeConnection(con);
	} catch (Exception e) {
		out.print("Failed to answer question. Please try again.");
		
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
	<form method="post" action="CustomerRep.jsp">
 		<input type="submit" value="Back" />
	</form>
</body>
</html>