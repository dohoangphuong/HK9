<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<title>Edit</title>
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
	margin-top: 17px;
	height: 1px;
	width: 95%;
	color: #184785;
	background-color: #184785;
}

table.borderless td,table.borderless th {
	border: none !important;
}

/* Table */
.table-editable {
	position: relative;
	.
	glyphicon
	{
	font-size
	:
	20px;
}

}
.table {
	overflow-y: scroll;
}

.table {
	margin-top: 10px;
	overflow-x: scroll;
}

<!--
tr,td,th {
	border: 1px solid #4A7EBB;
	max-width: 200px;
	min-width: 200px;
}

table {
	border: 3px solid #00B0F0;
	border-collapse: collapse;
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
				<div class="table"
					style="height: 250px; width: 610px; margin: 0 auto; padding-top: 2px;">
					<div id="table" class="table-editable">
						<table class="table" border="1" id="tableMain">
							<tr>
								<th>発注no</th>
								<th>品番</th>
								<th>完納</th>
								<th>品目名</th>
								<th>単価</th>
								<th>数量</th>
								<th>金額</th>
								<th>納入先</th>
								<th>備考</th>
							</tr>
							<s:iterator value="listManz_h10fEdit" var="i">
								<tr>
									<td contenteditable="true"><input class="form-control"
										maxlength="254" type="text" name="text" value="${i.発注no}"></td>
									<td contenteditable="true"><input class="form-control"
										maxlength="254" type="text" name="text" value="${i.品番}"></td>
									<td contenteditable="true"><input class="form-control"
										maxlength="254" type="text" name="text" value="${i.完納}"></td>
									<td contenteditable="true"><input class="form-control"
										maxlength="254" type="text" name="text" value="${i.品目名}"></td>
									<td contenteditable="true"><input class="form-control"
										maxlength="254" type="text" name="text" value="${i.単価}"></td>
									<td contenteditable="true"><input class="form-control"
										maxlength="254" type="text" name="text" value="${i.数量}"></td>
									<td contenteditable="true"><input class="form-control"
										maxlength="254" type="text" name="text" value="${i.金額}"></td>
									<td contenteditable="true"><input class="form-control"
										maxlength="254" type="text" name="text" value="${i.納入先}"></td>
									<td contenteditable="true"><input class="form-control"
										maxlength="254" type="text" name="text" value="${i.備考}"></td>
								</tr>
							</s:iterator>
							<!-- This is our clone able table line -->
							<tr class="hide">
								<td contenteditable="true">Untitled</td>
								<td contenteditable="true">undefined</td>
								<td contenteditable="true">Untitled</td>
								<td contenteditable="true">Untitled</td>
								<td contenteditable="true">Untitled</td>
								<td contenteditable="true">Untitled</td>
								<td contenteditable="true">Untitled</td>
								<td contenteditable="true">Untitled</td>
								<td contenteditable="true">Untitled</td>
							</tr>
						</table>
					</div>
				</div>
				<div class="footer">
					<br />
					<button id="submit" class="btn btn-primary button" type="button"
						value="submit" name="buttonName"
						style="float: right; margin-top: -1px; margin-right: 30px; width: 100px">更新</button>
					<s:form action="selecth" method="post">
						<button id="reset" class="btn btn-primary button" type="submit"
							value="reset" name="buttonName"
							style="float: right; margin-top: -1px; margin-right: 5px; width: 100px">取り消し</button>
					</s:form>
				</div>
			</div>
		</div>
	</div>

	<script>
		$(document).ready(function() {
			$("#submit").click(function() {
				$.ajax({
					type : "post",
					url : 'editH',
					dataType : 'json',
					data : {
						'resultTable' : JSON.stringify(data)
					},
					success : function(data) {
						if (data.row != 0) {
							//tableMain.rows[data.row].cells[0].focus();
							var $rows = $TABLE.find('tr:not(:hidden)');

							// Turn all existing rows into a loopable array

							$rows.each(function(index, element) {
								if (index == data.row) {
									$(this).find('input').eq(0).focus();
									alert(data.msgError);
									return;
								}

							});

						} else {
							/* if (data.msgError == "success") {
								alert(data.msgError);
							} */
							alert(data.msgError);
							$("#reset").click();
						}
					},
					error : function(data, textStatus, req) {
						alert("error");
					},
				});
			});
		});
		/* $(document).ready(function() {
			$("#export-btn").click(function() {
				$.ajax({
					type : "post",
					url : "<s:url action='editH'/>",
					dataType : 'text/javascript',
					data : {
						'resultTable' : JSON.stringify(data)
					},
					success : function(result) {
						alert(result);
					},
					error : function(xhr, errmsg) {
						alert(errmsg);
					}
				});
			});
		}); */
		var $TABLE = $('#table');
		var $BTN = $('#submit');
		var $EXPORT = $('#export');
		var $VALUEDATA = $('#valueData');
		var data = [];

		// A few jQuery helpers for exporting only
		jQuery.fn.pop = [].pop;
		jQuery.fn.shift = [].shift;

		$BTN.click(function() {
			var $rows = $TABLE.find('tr:not(:hidden)');
			var headers = [];
			data = [];

			// Get the headers (add special header logic here)
			$($rows.shift()).find('th:not(:empty)').each(function() {
				headers.push($(this).text().toLowerCase());
			});

			// Turn all existing rows into a loopable array
			$rows.each(function() {
				/* var $td = $(this).find('td'); */
				var val = $(this).find('input');
				var h = {};

				// Use the headers from earlier to name our hash keys
				headers.forEach(function(header, i) {
					/* h[header] = $td.eq(i).text(); */
					h[header] = val.eq(i).val();
				});
				data.push(h);
			});

			// Output the result			
			$EXPORT.text(JSON.stringify(data));
		});
	</script>
</body>
</html>
