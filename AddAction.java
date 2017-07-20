package net.viralpatel.struts2.action;

import java.util.List;

import net.viralpatel.struts2.logic.AuthenticateLogic;
import net.viralpatel.struts2.model.manz_h10f;
import net.viralpatel.struts2.model.manz_z10f;

import com.google.gson.Gson;
import com.opensymphony.xwork2.ActionSupport;

public class AddAction extends ActionSupport {
	private static final long serialVersionUID = 1L;
	private String buttonName;
	private String tableName;
	private String username;
	private List<manz_h10f> listManz_h;
	private String msgError;
	private String listResult;

	/**
	 * Run action of addH in struts
	 * @return SUCCESS: function done
	 */
	public String executeManH() {
		AuthenticateLogic authLogic = new AuthenticateLogic();

		if (listResult != null && !listResult.trim().equals("[]")) {
			Gson gson = new Gson();
			manz_h10f dataManz_h = gson.fromJson(listResult, manz_h10f.class);
			try {
				dataManz_h.setUsername(new LoginAction().getUsername());

				tableName = "MANZ_H10F";
				if (dataManz_h != null) {
					int result = authLogic.addManz_h10f(dataManz_h);
					if (result != -1) {
						msgError = getText("AddH.alert"
								+ String.valueOf(result));
						return SUCCESS;
					}
				}
			} catch (Exception e) {
			}
		}

		return SUCCESS;
	}
	
	/**
	 * Run action of addZ in struts
	 * @return SUCCESS: function done
	 */
	public String executeManZ() {
		AuthenticateLogic authLogic = new AuthenticateLogic();

		if (listResult != null && !listResult.trim().equals("[]")) {
			Gson gson = new Gson();
			manz_z10f dataManz_z = gson.fromJson(listResult, manz_z10f.class);
			try {
				dataManz_z.setUsername(new LoginAction().getUsername());

				tableName = "MANZ_H10F";
				if (dataManz_z != null) {
					int result = authLogic.addManz_z10f(dataManz_z);
					if (result != -1) {
						msgError = getText("AddZ.alert"
								+ String.valueOf(result));
						return SUCCESS;
					}
				}
			} catch (Exception e) {
			}
		}

		return SUCCESS;
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

	public String getMsgError() {
		return msgError;
	}

	public void setMsgError(String msgError) {
		this.msgError = msgError;
	}

	public String getListResult() {
		return listResult;
	}

	public void setListResult(String listResult) {
		this.listResult = listResult;
	}

}
