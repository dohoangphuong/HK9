package net.viralpatel.struts2.model;
import java.io.Serializable;

public class manz_z10fEdit implements Serializable {
	private static final long serialVersionUID = 1L;
	private String 品目c;
	private String 品目名;
	private String 品番;
	private String 新在庫数量;
	private String 在庫日;
	private String 得意先名;
	private String メーカーロット;
	private String 品名;

	public manz_z10fEdit() {
	}

	public manz_z10fEdit( String 品目c, String 品目名, String 品番,
			String 新在庫数量, String 在庫日, String 得意先名, String メーカーロット,
			String 品名) {
		this.品目c = 品目c;
		this.品目名 = 品目名;
		this.新在庫数量 = 新在庫数量;
		this.在庫日 = 在庫日;
		this.得意先名 = 得意先名;
		this.setメーカーロット(メーカーロット);
		this.品名 = 品名;
		this.品番 = 品番;
	}

	public String get品目c() {
		return 品目c;
	}

	public void set品目c(String 品目c) {
		this.品目c = 品目c;
	}

	public String get品目名() {
		return 品目名;
	}

	public void set品目名(String 品目名) {
		this.品目名 = 品目名;
	}

	public String get新在庫数量() {
		return 新在庫数量;
	}

	public void set新在庫数量(String 新在庫数量) {
		this.新在庫数量 = 新在庫数量;
	}

	public String get在庫日() {
		return 在庫日;
	}

	public void set在庫日(String 在庫日) {
		this.在庫日 = 在庫日;
	}

	public String get得意先名() {
		return 得意先名;
	}

	public void set得意先名(String 得意先名) {
		this.得意先名 = 得意先名;
	}

	public String get品名() {
		return 品名;
	}

	public void set品名(String 品名) {
		this.品名 = 品名;
	}

	public String getメーカーロット() {
		return メーカーロット;
	}

	public void setメーカーロット(String メーカーロット) {
		this.メーカーロット = メーカーロット;
	}

	public String get品番() {
		return 品番;
	}

	public void set品番(String 品番) {
		this.品番 = 品番;
	}
}
