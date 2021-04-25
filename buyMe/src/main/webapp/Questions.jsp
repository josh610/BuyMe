<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<title>Insert title here</title>
</head>
<body>
	<%
	try {
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		Statement stmt = con.createStatement();
		String searchPhrase = request.getParameter("search");
		String query =
			"SELECT question, answer FROM question " +
			"WHERE question LIKE '%" + searchPhrase + "%' " +
			"OR answer LIKE '%" + searchPhrase + "%';";
		ResultSet result = stmt.executeQuery(query);
		%>
		<div>
		<table><tr>
			<th
			style="width:400px;font:16px/26px Georgia, Garamond, Serif;">
			Question</th>
			<th
			style="width:400px;font:16px/26px Georgia, Garamond, Serif;">
			Answer</th>
		</tr></table>
		</div>
		
		<table>
		<%
		while(result.next()){ %>
			<tr>
				<th
				style="height:80px;width:400px;border:1px solid #ccc;overflow:auto;">
				<%= result.getString("question") %>
				</th>
				<th
				style="height:80px;width:400px;border:1px solid #ccc;overflow:auto;">
				<%
				String answer = result.getString("answer");
				if(answer == null) out.print("This question has not been answered yet.");
				else out.print(answer);
				%>
				</th>
			</tr>
	<% }
	//close the connection.
	db.closeConnection(con);
	%>
	</table>
	
	<br><br>
	<%--back button--%>
	<form method="post" action="UserQuestions.jsp">
 		<input type="submit" value="Back" />
	</form>
	<%
	} catch(Exception e){
		out.print("Search failed. Please try again.");
		
		if(session.getAttribute("usert") == null){
			%>
			<form method="post" action="UserQuestions.jsp">
	  		<input type="submit" value="Back" />
			</form>
			<%
		}
				
	}
%>
</body>
</html>