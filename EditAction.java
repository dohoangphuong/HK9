package net.viralpatel.struts2.action;

import java.util.Arrays;
import java.util.List;

import net.viralpatel.struts2.logic.AuthenticateLogic;
import net.viralpatel.struts2.model.manz_h10f;
import net.viralpatel.struts2.model.manz_h10fEdit;
import net.viralpatel.struts2.model.manz_z10f;
import net.viralpatel.struts2.model.manz_z10fEdit;

import com.google.gson.Gson;
import com.opensymphony.xwork2.ActionSupport;

import org.json.simple.parser.ParseException;

public class EditAction extends ActionSupport {
	private static final long serialVersionUID = 1L;
	private String username;
	private String resultTable;
	private String listResult;
	private String tableMain;
	private String row;
	private List<manz_h10f> listManz_h;
	private List<manz_h10fEdit> listManz_h10fEdit;
	private List<manz_z10f> listManz_z;
	private List<manz_z10fEdit> listManz_z10fEdit;
	private String msgError;

	/**
	 * Check value of string a and string b have equal a == null &&
	 * b.equals(""): 'b' get to Json of web, so it always have value ""
	 * @param a: The value 1
	 * @param b: The value 2
	 * @return true: a == b, 
	 * @return false: a!= b
	 */
	public boolean checkEqualString(String a, String b) {
		if ((a == null && b == null) || (a != null && b != null && a.equals(b))
				|| (a == null && b.equals("")))
			return true;
		return false;
	}

	/**
	 * Check value of manz_h10f a and manz_h10f b have equal
	 * @param a: The value 1
	 * @param b: The value 2
	 * @return true: a == b 
	 * @return false: a!= b
	 */
	public boolean checkEqualOjectManz_h10f(manz_h10f a, manz_h10f b) {
		if (checkEqualString(a.getUsername(), b.getUsername())
				&& checkEqualString(a.get備考(), b.get備考())
				&& checkEqualString(a.get単価(), b.get単価())
				&& checkEqualString(a.get品番(), b.get品番())
				&& checkEqualString(a.get品目k(), b.get品目k())
				&& checkEqualString(a.get完納(), b.get完納())
				&& checkEqualString(a.get数量(), b.get数量())
				&& checkEqualString(a.get発注no(), b.get発注no())
				&& checkEqualString(a.get納入先(), b.get納入先())
				&& checkEqualString(a.get金額(), b.get金額())) {
			return true;
		}

		return false;
	}

	/**
	 * Check value of manz_h10fEdit a and manz_h10fEdit b have equal
	 * @param a: The value 1
	 * @param b: The value 2
	 * @return true: a == b 
	 * @return false: a!= b
	 */
	public boolean checkEqualOjectManz_h10fEdit(manz_h10fEdit a, manz_h10fEdit b) {
		if (checkEqualString(a.get備考(), b.get備考())
				&& checkEqualString(a.get単価(), b.get単価())
				&& checkEqualString(a.get品番(), b.get品番())
				&& checkEqualString(a.get品目名(), b.get品目名())
				&& checkEqualString(a.get完納(), b.get完納())
				&& checkEqualString(a.get数量(), b.get数量())
				&& checkEqualString(a.get発注no(), b.get発注no())
				&& checkEqualString(a.get納入先(), b.get納入先())
				&& checkEqualString(a.get金額(), b.get金額())) {
			return true;
		}

		return false;
	}

	/**
	 * Check value of manz_z10fEdit a and manz_z10fEdit b have equal
	 * @param a: The value 1
	 * @param b: The value 2
	 * @return true: a == b 
	 * @return false: a!= b
	 */
	public boolean checkEqualOjectManz_z10fEdit(manz_z10fEdit a, manz_z10fEdit b) {
		if (checkEqualString(a.get品目c(), b.get品目c())
				&& checkEqualString(a.get品目名(), b.get品目名())
				&& checkEqualString(a.get品番(), b.get品番())
				&& checkEqualString(a.get新在庫数量(), b.get新在庫数量())
				&& checkEqualString(a.get在庫日(), b.get在庫日())
				&& checkEqualString(a.get得意先名(), b.get得意先名())
				&& checkEqualString(a.getメーカーロット(), b.getメーカーロット())
				&& checkEqualString(a.get品名(), b.get品名())) {
			return true;
		}

		return false;
	}

	/**
	 * Run action of editH in struts
	 * @return SUCCESS: function done
	 */
	public String executeManH() throws ParseException {
		boolean updateChange = false;
		msgError = null;
		AuthenticateLogic authLogic = new AuthenticateLogic();
		this.username = new LoginAction().getUsername();
		// If the DB is null
		if (resultTable != null && !resultTable.trim().equals("[]")) {
			Gson gson = new Gson();
			manz_h10fEdit[] listData = gson.fromJson(resultTable,
					manz_h10fEdit[].class);
			List<manz_h10fEdit> listNewManz_h = Arrays.asList(listData);
			List<manz_h10fEdit> listOldManz_h = authLogic
					.setManz_h10fEditToTable(authLogic
							.getTableManzh10f(username));
			listManz_h = authLogic.getTableManzh10f(username);

			// If the DB has changed from other user.
			if (listOldManz_h.size() == listNewManz_h.size()) {
				for (int i = 0; i < listOldManz_h.size(); i++) {
					// If the two object is different
					if (!checkEqualOjectManz_h10fEdit(listOldManz_h.get(i),
							listNewManz_h.get(i))) {
						// If the value of 発注no is different
						if (!checkEqualString(listOldManz_h.get(i).get発注no(),
								listNewManz_h.get(i).get発注no())) {
							// If the value of 発注no is null
							if (listNewManz_h.get(i).get発注no() == null
									|| listNewManz_h.get(i).get発注no().trim()
											.equals("")) {
								msgError = "発注noは空白しています";
								row = String.valueOf(i + 1);
								return SUCCESS;
								// return "error1";
							}

							// If 発注no had existed to two value in Edit.jsp
							for (int j = 0; j < listOldManz_h.size(); j++) {
								// If the Id of 2 object are equal
								if (i != j
										&& checkEqualString(listNewManz_h
												.get(i).get発注no(),
												listNewManz_h.get(j).get発注no())) {
									row = String.valueOf(i + 1);
									msgError = "発注noは重複しています";
									return SUCCESS;
								}
							}
						}
						updateChange = true;
					}
				}
				if (updateChange == true) {
					// Delete the object was changed
					for (int i = 0; i < listNewManz_h.size(); i++)
						if (!checkEqualOjectManz_h10fEdit(listOldManz_h.get(i),
								listNewManz_h.get(i))) {
							authLogic.deleteManz_h10f(listManz_h.get(i));
						}
					// Add the object was changed
					for (int i = 0; i < listNewManz_h.size(); i++)
						if (!checkEqualOjectManz_h10fEdit(listOldManz_h.get(i),
								listNewManz_h.get(i))) {
							authLogic.addManz_h10fEditNotCondition(
									listManz_h.get(i), listNewManz_h.get(i));
							authLogic.updateManz_h10fEditNotCondition(
									listManz_h.get(i), listNewManz_h.get(i));
						}
					row = String.valueOf(0);
					msgError = "success";
					return SUCCESS;
					// return "success";
				} else {
					row = String.valueOf(0);
					msgError = "object diffirent";
					return SUCCESS;
					// return "error3";
				}
			} else {
				row = String.valueOf(0);
				msgError = "size diffirent";
				return SUCCESS;
				// return "error3";
			}
		} else {
			row = String.valueOf(0);
			msgError = "Data null";
			return SUCCESS;
			// return "error4";
		}
	}

	/**
	 * Run action of editZ in struts
	 * @return SUCCESS: function done
	 */
	public String executeManZ() throws ParseException {
		boolean updateChange = false;
		msgError = null;
		AuthenticateLogic authLogic = new AuthenticateLogic();
		this.username = new LoginAction().getUsername();
		// If the DB is null
		if (resultTable != null && !resultTable.trim().equals("[]")) {
			Gson gson = new Gson();
			manz_z10fEdit[] listData = gson.fromJson(resultTable,
					manz_z10fEdit[].class);
			List<manz_z10fEdit> listNewManz_z = Arrays.asList(listData);
			List<manz_z10fEdit> listOldManz_z = authLogic
					.setManz_z10fEditToTable(authLogic
							.getTableManzz10f(username));
			listManz_z = authLogic.getTableManzz10f(username);

			// If the DB has changed from other user.
			if (listOldManz_z.size() == listNewManz_z.size()) {
				for (int i = 0; i < listOldManz_z.size(); i++) {
					// If the two object is different
					if (!checkEqualOjectManz_z10fEdit(listOldManz_z.get(i),
							listNewManz_z.get(i))) {
						// If the value of 発注no is different
						if (!checkEqualString(listOldManz_z.get(i).get品目c(),
								listNewManz_z.get(i).get品目c())) {
							// If the value of 発注no is null
							if (listNewManz_z.get(i).get品目c() == null
									|| listNewManz_z.get(i).get品目c().trim()
											.equals("")) {
								msgError = "品目Cは空白しています";
								row = String.valueOf(i + 1);
								return SUCCESS;
								// return "error1";
							}

							// If 発注no had existed to two value in Edit.jsp
							for (int j = 0; j < listOldManz_z.size(); j++) {
								// If the Id of 2 object are equal
								if (i != j
										&& checkEqualString(listNewManz_z
												.get(i).get品目c(), listNewManz_z
												.get(j).get品目c())) {
									row = String.valueOf(i + 1);
									msgError = "品目Cは重複しています";
									return SUCCESS;
								}
							}
						}
						updateChange = true;
					}
				}
				if (updateChange == true) {
					// Delete the object was changed
					for (int i = 0; i < listNewManz_z.size(); i++)
						if (!checkEqualOjectManz_z10fEdit(listOldManz_z.get(i),
								listNewManz_z.get(i))) {
							authLogic.deleteManz_z10f(listManz_z.get(i)
									.get品目c());
						}
					// Add the object was changed
					for (int i = 0; i < listNewManz_z.size(); i++)
						if (!checkEqualOjectManz_z10fEdit(listOldManz_z.get(i),
								listNewManz_z.get(i))) {
							authLogic.addManz_z10fEditNotCondition(
									listManz_z.get(i), listNewManz_z.get(i));
							authLogic.updateManz_z10fEditNotCondition(
									listManz_z.get(i), listNewManz_z.get(i));
						}
					row = String.valueOf(0);
					msgError = "success";
					return SUCCESS;
					// return "success";
				} else {
					row = String.valueOf(0);
					msgError = "object diffirent";
					return SUCCESS;
					// return "error3";
				}
			} else {
				row = String.valueOf(0);
				msgError = "size diffirent";
				return SUCCESS;
				// return "error3";
			}
		} else {
			row = String.valueOf(0);
			msgError = "Data null";
			return SUCCESS;
			// return "error4";
		}
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public List<manz_h10f> getListManz_h() {
		return listManz_h;
	}

	public void setListManz_h(List<manz_h10f> listManz_h) {
		this.listManz_h = listManz_h;
	}

	public String getResultTable() {
		return resultTable;
	}

	public void setResultTable(String resultTable) {
		this.resultTable = resultTable;
	}

	public String getTableMain() {
		return tableMain;
	}

	public void setTableMain(String tableMain) {
		this.tableMain = tableMain;
	}

	public String getListResult() {
		return listResult;
	}

	public void setListResult(String listResult) {
		this.listResult = listResult;
	}

	public String getRow() {
		return row;
	}

	public void setRow(String row) {
		this.row = row;
	}

	public String getMsgError() {
		return msgError;
	}

	public void setMsgError(String msgError) {
		this.msgError = msgError;
	}

	public List<manz_h10fEdit> getListManz_h10fEdit() {
		return listManz_h10fEdit;
	}

	public void setListManz_h10fEdit(List<manz_h10fEdit> listManz_h10fEdit) {
		this.listManz_h10fEdit = listManz_h10fEdit;
	}

	public List<manz_z10f> getListManz_z() {
		return listManz_z;
	}

	public void setListManz_z(List<manz_z10f> listManz_z) {
		this.listManz_z = listManz_z;
	}

	public List<manz_z10fEdit> getListManz_z10fEdit() {
		return listManz_z10fEdit;
	}

	public void setListManz_z10fEdit(List<manz_z10fEdit> listManz_z10fEdit) {
		this.listManz_z10fEdit = listManz_z10fEdit;
	}
}
