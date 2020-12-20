package tdt.db.adm;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class AdminLog {
	private BigDecimal id;
	private String admin;
	private String description;
	private Timestamp gen_date;
	private int type;
	
	public static int TYPE_INSERT = 0;
	public static int TYPE_UPDATE = 1;
	public static int TYPE_DELETE = 2;
	
	
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
	public BigDecimal getId() {
		return id;
	}
	public void setId(BigDecimal id) {
		this.id = id;
	}
	public String getAdmin() {
		return admin;
	}
	public void setAdmin(String admin) {
		this.admin = admin;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public Timestamp getGen_date() {
		return gen_date;
	}
	public void setGen_date(Timestamp gen_date) {
		this.gen_date = gen_date;
	}	
}
