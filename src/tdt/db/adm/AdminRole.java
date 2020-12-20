package tdt.db.adm;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class AdminRole implements Serializable{
	private BigDecimal id;
	private String admin;
	private BigDecimal link_id;
	private int is_select;
	private int is_insert;
	private int is_update;
	private int is_delete;
	private Timestamp gen_date;
	private String created_by;
	private Timestamp last_updated;
	private String link_name;
	private String link_uri;
	public String getLink_uri() {
		return link_uri;
	}
	public void setLink_uri(String link_uri) {
		this.link_uri = link_uri;
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
	public BigDecimal getLink_id() {
		return link_id;
	}
	public void setLink_id(BigDecimal link_id) {
		this.link_id = link_id;
	}
	public int getIs_select() {
		return is_select;
	}
	public void setIs_select(int is_select) {
		this.is_select = is_select;
	}
	public int getIs_insert() {
		return is_insert;
	}
	public void setIs_insert(int is_insert) {
		this.is_insert = is_insert;
	}
	public int getIs_update() {
		return is_update;
	}
	public void setIs_update(int is_update) {
		this.is_update = is_update;
	}
	public int getIs_delete() {
		return is_delete;
	}
	public void setIs_delete(int is_delete) {
		this.is_delete = is_delete;
	}
	public Timestamp getGen_date() {
		return gen_date;
	}
	public void setGen_date(Timestamp gen_date) {
		this.gen_date = gen_date;
	}
	public String getCreated_by() {
		return created_by;
	}
	public void setCreated_by(String created_by) {
		this.created_by = created_by;
	}
	public Timestamp getLast_updated() {
		return last_updated;
	}
	public void setLast_updated(Timestamp last_updated) {
		this.last_updated = last_updated;
	}
	public String getLink_name() {
		return link_name;
	}
	public void setLink_name(String link_name) {
		this.link_name = link_name;
	}	
}
