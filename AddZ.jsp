<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<title>Add</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" type="text/css"
	href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.2/themes/smoothness/jquery-ui.css" />
<link rel="stylesheet" type="text/css"
	href="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css" />
<script
	src="http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
<script
	src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.2/jquery-ui.min.js"></script>
<script
	src="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
<script
	src="http://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.6.0/underscore.js"></script>
<style>
.main_layout {
	position: relative;
	width: 700px;
	height: 400px;
	margin: 0 auto;
	border: solid 4px #00B0F0;
}

.header {
	width: 698PX;
	float: left;
	height: 60px;
	text-align: center;
}

.main {
	padding-left: 40px;
	padding-top: 80px;
}

.footer {
	padding-right: 10px;
	padding-left: 100px;
	text-align: right;
}

.button {
	background-color: #426EB4;
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
	background-color: #426EB4;
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
	color: #184785;
	background-color: #184785;
}
table.borderless td,table.borderless th {
	border: none !important;
}
</style>
</head>
<body>
	<div class="main_layout">
		<div class="header">
			<s:form action="logout" method="post">
				<h2 style="text-align: center; margin-bottom: -5px;">
					<s:property value="tableName" />
				</h2>
				<button class="btn btn-primary buttonLogout" type="submit"
					value="logout" name="buttonName">ログアウト</button>
				<label class="lbName">ようこそ <s:property value="username" />
					&nbsp&nbsp
				</label>
			</s:form>
			<hr />
		</div>
		<div class="main">
			<div>
				<table class="table table-condensed borderless">
					<thead>
					</thead>
					<tbody>
						<tr>
							<td>品目K</td>
							<td><div class="col-xs-10">
									<input type="text" name="txt1" class="form-control" value=""
										id="txt品目K">
								</div></td>
							<td>得意先C</td>
							<td><div class="col-xs-10">
									<input type="text" name="txt7" class="form-control"
										value="" id="txt得意先C">
								</div></td>
						</tr>
						<tr>
							<td>品目C</td>
							<td><div class="col-xs-10">
									<input type="text" name="txt2" class="form-control"
										value="" id="txt品目C">
								</div></td>
							<td>得意先名</td>
							<td><div class="col-xs-10">
									<input type="text" name="txt8" class="form-control"
										value="" id="txt得意先名">
								</div></td>
						</tr>
						<tr>
							<td>品目名</td>
							<td><div class="col-xs-10">
									<input type="text" name="txt3" class="form-control"
										value="" id="txt品目名">
								</div></td>
							<td width="15%">ﾒｰｶｰロット</td>
							<td><div class="col-xs-10">
									<input type="text" name="txt9" class="form-control"
										value="" id="txtﾒｰｶｰロット">
								</div></td>
						</tr>
						<tr>
							<td>発注No</td>
							<td><div class="col-xs-10">
									<input type="text" name="txt4" class="form-control"
										value="" id="txt発注No">
								</div></td>
							<td>品名</td>
							<td><div class="col-xs-10">
									<input type="text" name="txt10" class="form-control"
										value="" id="txt品名">
								</div></td>
						</tr>
						<tr>
							<td width="14%">新在庫数量</td>
							<td><div class="col-xs-10">
									<input type="text" name="txt5" class="form-control"
										value="" id="txt新在庫数量">
								</div></td>
						</tr>
						<tr>
							<td>在庫日</td>
							<td><div class="col-xs-10">
									<input type="text" name="txt6" class="form-control"
										value="" id="txt在庫日">
								</div></td>
						</tr>
					</tbody>
				</table>
				<div class="footer">
					<button id="submit" class="btn btn-primary button" type="submit"
						value="submit" name="buttonName"
						style="float: right; margin-top: -15px; margin-right: 30px; width: 100px">更新</button>
					<button id="reset" class="btn btn-primary button" type="button"
						value="reset" name="buttonName"
						style="float: right; margin-top: -15px; margin-right: 5px; width: 100px">取り消し</button>
				</div>
			</div>
		</div>
	</div>
	<script>
		$(document).ready(function() {
			$("#submit").click(function() {
				var result = new Object();
				
				result["品目k"] = document.getElementById("txt品目K").value;
				result["得意先c"] = document.getElementById("txt得意先C").value;
				result["品目名"] = document.getElementById("txt品目名").value;
				result["発注no"] = document.getElementById("txt発注No").value;
				result["新在庫数量"] = document.getElementById("txt新在庫数量").value;
				result["在庫日"] = document.getElementById("txt在庫日").value;
				result["品目c"] = document.getElementById("txt品目C").value;
				result["得意先名"] = document.getElementById("txt得意先名").value;
				result["メーカーロット"] = document.getElementById("txtﾒｰｶｰロット").value;
				result["品名"] = document.getElementById("txt品名").value;
				result["username"] = "admin";
				
				$.ajax({
					type : "post",
					url : 'addZ',
					dataType : 'json',
					data : {
						'listResult' : JSON.stringify(result)
					},
					success : function(data) {
						if (data.msgError == "success") {
							alert(data.msgError);
							$("#reset").click();
						} else {
							alert(data.msgError);
						}
					},
					error : function(data, textStatus, req) {
						alert("error");
					},
				});
			});
		});

		$('#reset').click(function() {
			$("#txt品目K").val('');
			$("#txt得意先C").val('');
			$("#txt品目名").val('');	
			$("#txt発注No").val('');
			$("#txt新在庫数量").val('');
			$("#txt在庫日").val('');
			$("#txt品目C").val('');
			$("#txt得意先名").val('');
			$("#txtﾒｰｶｰロット").val('');
			$("#txt品名").val('');
		});
	</script>
</body>
</html>
