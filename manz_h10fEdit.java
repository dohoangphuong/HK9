package net.viralpatel.struts2.model;

import java.io.Serializable;

public class manz_h10fEdit implements Serializable {
	private static final long serialVersionUID = 1L;
	private String 発注no;
	private String 品番;
	private String 完納;
	private String 品目名;
	private String 単価;
	private String 数量;
	private String 金額;
	private String 納入先;
	private String 備考;

	public manz_h10fEdit(String 発注no, String 品番, String 完納, String 品目名, String 単価,
			String 金額, String 納入先, String 備考, String 数量) {
		this.発注no = 発注no;
		this.品番 = 品番;
		this.完納 = 完納;
		this.品目名 = 品目名;
		this.単価 = 単価;
		this.金額 = 金額;
		this.納入先 = 納入先;
		this.備考 = 備考;
		this.数量 = 数量;
	}

	public manz_h10fEdit() {

	}

	public String get発注no() {
		return 発注no;
	}

	public void set発注no(String 発注no) {
		this.発注no = 発注no;
	}

	public String get品番() {
		return 品番;
	}

	public void set品番(String 品番) {
		this.品番 = 品番;
	}

	public String get完納() {
		return 完納;
	}

	public void set完納(String 完納) {
		this.完納 = 完納;
	}

	public String get単価() {
		return 単価;
	}

	public void set単価(String 単価) {
		this.単価 = 単価;
	}

	public String get金額() {
		return 金額;
	}

	public void set金額(String 金額) {
		this.金額 = 金額;
	}

	public String get納入先() {
		return 納入先;
	}

	public void set納入先(String 納入先) {
		this.納入先 = 納入先;
	}

	public String get備考() {
		return 備考;
	}

	public void set備考(String 備考) {
		this.備考 = 備考;
	}

	public String get数量() {
		return 数量;
	}

	public void set数量(String 数量) {
		this.数量 = 数量;
	}

	public String get品目名() {
		return 品目名;
	}

	public void set品目名(String 品目名) {
		this.品目名 = 品目名;
	}
}
