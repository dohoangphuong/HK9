<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>
<style>
.menu {
	width: 294PX;
	float: left;
	border: 2px solid #00B0F0;
	height: 196px;
}

.main {
	width: 294PX;
	float: left;
	border: 2px solid #00B0F0;
	height: 196px;
	text-align: center;
}

.center {
	margin: auto;
	width: 596px;
	height: 200px;
	border: 2px solid #00B0F0;
}

.btnAction {
	margin: auto;
	margin-top: 10%;
}

.inform {
	margin: auto;
	margin-top: 10%;
}
</style>
<title>Login</title>
</head>
<body>
	<div class="center">
		<div class="menu">
			<span id="simulationInfos" style="display: none"><s:property
					value="mssError" /></span>

			<s:if test="hasActionErrors()">
				<script type="text/javascript">
					alert(simulationInfos.innerHTML);
					 window.location.href = "Login.jsp";
				</script>
			</s:if>
			<s:form action="login" method="post">
				<div class="inform">
					<s:textfield name="username" key="label.username" size="20"
						value="" align="center" maxlength="254" />
					<s:password name="password" key="label.password" size="20" value=""
						align="center" maxlength="254" />
				</div>
				<div class="btnAction">
					<s:submit
						style=" margin-top:50px; margin-bottom:10px; margin-left:50px; text-color: white; background: #426EB4; color: white; border: 2px solid #184785;"
						name="buttons" method="execute" key="label.login" value="ログイン"
						align="center" />
				</div>
			</s:form>
		</div>

		<div id="main" class="main">
			<div style="margin-top: 70px; font-size: 200%;">WELCOME TO FJS
			</div>
		</div>
	</div>
</body>
</html>
