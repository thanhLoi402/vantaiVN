package tdt.db.adm;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class Admin {
	private BigDecimal id;
	private String fullName;
	private String userName;
	private String passwd;
	private int status;
	//status = 0: active
	//status = 1: lock
	private int rightRole;
	//right = 0: member
	//right = 1: admin
	//right = 2: partner
	//right = 3: telco
	private Timestamp genDate;
	
	private String mobile;
	private String email;
	private String ip;
	
	public static int RIGHT_MEMBER = 0;
	public static int RIGHT_ADMIN = 1;
	public static int RIGHT_PARTNER = 2;
	public static int RIGHT_TELCO = 3;
	
	public String getPasswd() {
		return passwd;
	}
	public void setPasswd(String passwd) {
		this.passwd = passwd;
	}
	public BigDecimal getId() {
		return id;
	}
	public void setId(BigDecimal id) {
		this.id = id;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getPassword() {
		return passwd;
	}
	public void setPassword(String password) {
		this.passwd = password;
	}
	
	public Timestamp getGenDate() {
		return genDate;
	}
	public void setGenDate(Timestamp genDate) {
		this.genDate = genDate;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public int getRightRole() {
		return rightRole;
	}
	public void setRightRole(int rightRole) {
		this.rightRole = rightRole;
	}
	public String getFullName() {
		return fullName;
	}
	public void setFullName(String fullName) {
		this.fullName = fullName;
	}
	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getIp() {
		return ip;
	}
	public void setIp(String ip) {
		this.ip = ip;
	}
	
}
