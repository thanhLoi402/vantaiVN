package tdt.db.adm;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class AdminLink implements Serializable {

	private BigDecimal id;
	private String uri;
	private String name;
	private BigDecimal parent_id;
	private int status;
	private int position;
	private Timestamp gen_date;
	private int level;
	private int display_top;
	
	private int is_select;
	private int is_insert;
	private int is_update;
	private int is_delete;	
	
	private int link_level;
	
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
	public int getDisplay_top() {
		return display_top;
	}
	public void setDisplay_top(int display_top) {
		this.display_top = display_top;
	}
	public int getLevel() {
		return level;
	}
	public void setLevel(int level) {
		this.level = level;
	}
	public BigDecimal getId() {
		return id;
	}
	public void setId(BigDecimal id) {
		this.id = id;
	}
	public String getUri() {
		return uri;
	}
	public void setUri(String uri) {
		this.uri = uri;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public BigDecimal getParent_id() {
		return parent_id;
	}
	public void setParent_id(BigDecimal parent_id) {
		this.parent_id = parent_id;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public int getPosition() {
		return position;
	}
	public void setPosition(int position) {
		this.position = position;
	}
	public Timestamp getGen_date() {
		return gen_date;
	}
	public void setGen_date(Timestamp gen_date) {
		this.gen_date = gen_date;
	}
	public int getLink_level() {
		return link_level;
	}
	public void setLink_level(int link_level) {
		this.link_level = link_level;
	}
}
