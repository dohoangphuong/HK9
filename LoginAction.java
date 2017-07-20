package net.viralpatel.struts2.action;

import net.viralpatel.struts2.logic.AuthenticateLogic;
import com.opensymphony.xwork2.ActionSupport;

@SuppressWarnings("serial")
public class LoginAction extends ActionSupport {
	static private String username;
	private String password;
	private String mssError;

	/**
	 * Run action of login in struts
	 * @return error1: username null
	 * @return error2: password null
	 * @return error: username or password isn't validate in DB,
	 * @return success:  username and password is validate in DB.
	 */
	public String execute() throws Exception {
		AuthenticateLogic authLogic = new AuthenticateLogic();
		if (LoginAction.username.equals("")) {
			mssError = getText("error1.login");
			addActionError(getText("error1.login"));
			return "error1";
		} else {
			if (this.password.equals("")) {
				mssError = getText("error2.login");
				addActionError(getText("error2.login"));
				return "error2";
			} else {
				if (authLogic.checkLogin(LoginAction.username, this.password)) {			
					this.clearActionErrors();
					return "success";
				}
			}
		}
		mssError = getText("error.login");
		addActionError(getText("error.login"));

		return "error";
	}


	public String getUsername() {
		return LoginAction.username;
	}

	public void setUsername(String username) {
		LoginAction.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getMssError() {
		return mssError;
	}

	public void setMssError(String mssError) {
		this.mssError = mssError;
	}
}
