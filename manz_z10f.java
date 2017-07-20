package net.viralpatel.struts2.model;
import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "manz_z10f")
public class manz_z10f implements Serializable {
	private static final long serialVersionUID = 1L;
	private String 品目k;
	private String 品目c;
	private String 品目名;
	private String 発注no;
	private String 新在庫数量;
	private String 在庫日;
	private String 得意先c;
	private String 得意先名;
	private String メーカーロット;
	private String 品名;
	private String username;

	public manz_z10f() {
	}

	public manz_z10f(String 品目k, String 品目c, String 品目名, String 発注no,
			String 新在庫数量, String 在庫日, String 得意先c, String 得意先名, String メーカーロット,
			String 品名, String username) {
		this.品目k = 品目k;
		this.品目c = 品目c;
		this.品目名 = 品目名;
		this.発注no = 発注no;
		this.新在庫数量 = 新在庫数量;
		this.在庫日 = 在庫日;
		this.得意先c = 得意先c;
		this.得意先名 = 得意先名;
		this.setメーカーロット(メーカーロット);
		this.品名 = 品名;
		this.username = username;
	}

	@Column(name = "品目k")
	public String get品目k() {
		return 品目k;
	}

	public void set品目k(String 品目k) {
		this.品目k = 品目k;
	}

	@Id
	@Column(name = "品目c")
	public String get品目c() {
		return 品目c;
	}

	public void set品目c(String 品目c) {
		this.品目c = 品目c;
	}

	@Column(name = "品目名")
	public String get品目名() {
		return 品目名;
	}

	public void set品目名(String 品目名) {
		this.品目名 = 品目名;
	}

	@Column(name = "発注no")
	public String get発注no() {
		return 発注no;
	}

	public void set発注no(String 発注no) {
		this.発注no = 発注no;
	}

	@Column(name = "新在庫数量")
	public String get新在庫数量() {
		return 新在庫数量;
	}

	public void set新在庫数量(String 新在庫数量) {
		this.新在庫数量 = 新在庫数量;
	}

	@Column(name = "在庫日")
	public String get在庫日() {
		return 在庫日;
	}

	public void set在庫日(String 在庫日) {
		this.在庫日 = 在庫日;
	}

	@Column(name = "得意先c")
	public String get得意先c() {
		return 得意先c;
	}

	public void set得意先c(String 得意先c) {
		this.得意先c = 得意先c;
	}

	@Column(name = "得意先名")
	public String get得意先名() {
		return 得意先名;
	}

	public void set得意先名(String 得意先名) {
		this.得意先名 = 得意先名;
	}

	@Column(name = "品名")
	public String get品名() {
		return 品名;
	}

	public void set品名(String 品名) {
		this.品名 = 品名;
	}

	@Column(name = "username")
	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	@Column(name = "メーカーロット")
	public String getメーカーロット() {
		return メーカーロット;
	}

	public void setメーカーロット(String メーカーロット) {
		this.メーカーロット = メーカーロット;
	}
}
