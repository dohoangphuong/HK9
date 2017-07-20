package net.viralpatel.struts2.action;

import java.util.List;

import net.viralpatel.struts2.logic.AuthenticateLogic;
import net.viralpatel.struts2.model.manz_h10f;
import net.viralpatel.struts2.model.manz_h10fEdit;
import net.viralpatel.struts2.model.manz_z10f;
import net.viralpatel.struts2.model.manz_z10fEdit;

import com.opensymphony.xwork2.ActionSupport;

@SuppressWarnings("serial")
public class SelectModeAction extends ActionSupport {
	private String buttonName;
	private String tableName;
	private String username;
	private List<manz_h10f> listManz_h;
	private List<manz_z10f> listManz_z;
	private List<manz_h10fEdit> listManz_h10fEdit;
	private List<manz_z10fEdit> listManz_z10fEdit;

	/**
	 * Run action of selecth in struts
	 * @return logout: Client click button logout
	 * @return add: Client click button add
	 * @return edit: Client click button edit or reset
	 * @return error: Undefined error
	 */
	public String execute() {
		AuthenticateLogic authLogic = new AuthenticateLogic();
		this.username = new LoginAction().getUsername();

		if ("logout".equals(buttonName)) {
			return "logout";
		}

		if ("add".equals(buttonName)) {
			tableName = "MAN_H10F";
			return "add";
		}

		if ("edit".equals(buttonName)) {
			tableName = "MANZ_H10F";
			listManz_h = authLogic.getTableManzh10f(username);
			listManz_h10fEdit = authLogic.setManz_h10fEditToTable(listManz_h);
			return "edit";
		}

		if ("reset".equals(buttonName)) {
			tableName = "MANZ_H10F";
			listManz_h = authLogic.getTableManzh10f(username);
			listManz_h10fEdit = authLogic.setManz_h10fEditToTable(listManz_h);
			return "edit";
		}

		return "error";
	}

	/**
	 * Run action of selectz in struts
	 * @return add: Client click button add
	 * @return edit: Client click button edit or reset
	 * @return error: Undefined error
	 */
	public String executeManz_z() throws Exception {
		AuthenticateLogic authLogic = new AuthenticateLogic();
		this.username = new LoginAction().getUsername();
		if ("addZ".equals(buttonName)) {
			tableName = "MAN_Z10F";
			return "add";
		}

		if ("editZ".equals(buttonName)) {
			tableName = "MANZ_Z10F";
			listManz_z = authLogic.getTableManzz10f(username);
			listManz_z10fEdit = authLogic.setManz_z10fEditToTable(listManz_z);
			return "edit";
		}

		if ("reset".equals(buttonName)) {
			tableName = "MANZ_Z10F";
			listManz_z = authLogic.getTableManzz10f(username);
			listManz_z10fEdit = authLogic.setManz_z10fEditToTable(listManz_z);
			return "edit";
		}
		return "error";
	}

	public String gettButtonName() {
		return this.buttonName;
	}

	public void setButtonName(String buttonName) {
		this.buttonName = buttonName;
	}

	public List<manz_h10f> getListManz_h() {
		return listManz_h;
	}

	public void setListManz_h(List<manz_h10f> listManz_h) {
		this.listManz_h = listManz_h;
	}

	public String getTableName() {
		return tableName;
	}

	public void setTableName(String tableName) {
		this.tableName = tableName;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public List<manz_z10f> getListManz_z() {
		return listManz_z;
	}

	public void setListManz_z(List<manz_z10f> listManz_z) {
		this.listManz_z = listManz_z;
	}

	public List<manz_h10fEdit> getListManz_h10fEdit() {
		return listManz_h10fEdit;
	}

	public void setListManz_h10fEdit(List<manz_h10fEdit> listManz_h10fEdit) {
		this.listManz_h10fEdit = listManz_h10fEdit;
	}

	public List<manz_z10fEdit> getListManz_z10fEdit() {
		return listManz_z10fEdit;
	}

	public void setListManz_z10fEdit(List<manz_z10fEdit> listManz_z10fEdit) {
		this.listManz_z10fEdit = listManz_z10fEdit;
	}

}
