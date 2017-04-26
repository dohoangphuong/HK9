<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<title>Select Mode</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<style>
.header {
	width: 698PX;
	float: left;
	/* border: 1px solid red; */
	height: 60px;
	text-align: center;
}

.menu {
	width: 344PX;
	float: left;
	/* border: 2px solid red; */
	height: 335px;
	text-align: center;
}

.main {
	width: 344PX;
	float: left;
	/* border: 2px solid red; */
	height: 335px;
	text-align: center;
}

.center {
	margin: auto;
	width: 700px;
	height: 400px;
	border: 4px solid #00B0F0;
}

.centerMenu {
	align-self: center;
	-webkit-align-self: center;
}

.centerScreen {
	margin: auto;
	margin-top: 30%;
}

.button {
	background-color: #4F81BD;
	border: none;
	color: white;
	text-align: center;
	text-decoration: none;
	display: inline-block;
	font-size: 16px;
	margin: 4px 2px;
	cursor: pointer;
	width: 100px;
	border: 2px solid #184785;
}

.buttonLogout {
	background-color: #4F81BD; /* Green */
	border: none;
	text-align: center;
	text-decoration: none;
	display: inline-block;
	cursor: pointer;
	float: right;
	margin-top: -25px;
	margin-right: 15px;
	text-color: white;
	color: white;
	border: 2px solid #184785;
}

.lbName {
	font-size: 13px;
	float: right;
	margin-top: -15px;
}

.lbUser {
	font-size: 15px;
	float: right;
	margin-top: -15px;
}

hr {
	height: 1px;
	width: 95%;
	color: #4CAF50;
	background-color: #4A7EBB;
}

hr.vertical {
	width: 1px;
	height: 75%;
	float: left;
	text-align: center;
	background-color: #4A7EBB;
	/* background-color: #4CAF50; */ /* Green */
}
</style>
</head>

<body>
	<div class="center">
		<div class="header">
			<s:actionerror />
			<div>
				<s:form action="selecth" method="post">
					<h2 style="text-align: center; margin-bottom: -5px;">SELECT
						MODE</h2>
					<button class="btn btn-primary buttonLogout" type="submit"
						value="logout" name="buttonName">ログアウト</button>
					<label class="lbName">ようこそ <s:property value="username" />
						&nbsp&nbsp
					</label>
				</s:form>
				<hr />
			</div>
		</div>
		<div class="menu">
			<s:form action="selecth" method="post">
				<div class="centerMenu">
					<h3>MANZ_H10F</h3>
					<div class="centerScreen">
						<button class="btn btn-primary button" type="submit" value="add"
							name="buttonName">ADD</button>
					</div>
					<button class="btn btn-primary button" type="submit" value="edit"
						name="buttonName">EDIT</button>
				</div>
			</s:form>
		</div>
		<hr class="vertical" />
		<div class="main">
			<s:form action="selectz" method="post">
				<div class="centerMenu">
					<h3>MANZ_Z10F</h3>
					<div class="centerScreen">
						<button class="btn btn-primary button" type="submit" value="addZ"
							name="buttonName">ADD</button>
					</div>
					<button class="btn btn-primary button" type="submit" value="editZ"
						name="buttonName">EDIT</button>
				</div>
			</s:form>
		</div>
	</div>
</body>
</html>
