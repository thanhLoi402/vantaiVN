package tdt.listener;

import java.util.Vector;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import tdt.db.adm.AdminAccessLog;
import tdt.db.adm.AdminAccessLogDAO;

public class SessionCounterListener implements HttpSessionListener {

	private static int totalActiveSessions;
	private static Vector<AdminAccessLog> listAdminOnline;
	private static AdminAccessLogDAO adminAccessLogDAO = new AdminAccessLogDAO();
	
	static{
		listAdminOnline = new Vector<AdminAccessLog>();
		totalActiveSessions = 0;
	}
	
	public static Vector<AdminAccessLog> getListAdminOnline(){
		return listAdminOnline;
	}
	
	public static int getTotalActiveSession() {
		return totalActiveSessions;
	}
	
	public void sessionCreated(HttpSessionEvent arg0) {
	}
	
	public static void sessionCreated(AdminAccessLog obj){
		if(obj!=null){
			if(!listAdminOnline.contains(obj)){
				boolean isExisted = false;
				if(listAdminOnline!=null && listAdminOnline.size()>0){
					AdminAccessLog adm = null;
					for(int i=0;i<listAdminOnline.size();i++){
						adm = listAdminOnline.get(i);
						if((adm.getUsrname().equals(obj.getUsrname())
								&& adm.getIp().equals(obj.getIp())
								&& adm.getBrowser().equals(obj.getBrowser())) || adm.getSessionId().equals(obj.getSessionId()) ){
							isExisted = true;
							break;
						}
					}
				}
				
				if(!isExisted){
					if(adminAccessLogDAO.insertRow(obj)){
						totalActiveSessions++;
						listAdminOnline.add(obj);
						System.out.println("sessionCreated - " + obj.getUsrname());
					}
				}
			}
		}
	}

	public void sessionDestroyed(HttpSessionEvent arg0) {
		try{
			String username = arg0.getSession().getAttribute("datavasosp.adm.username").toString();
			String sessionId = arg0.getSession().getId();
			System.out.println("username: " + username + " - sessionId: " + sessionId);
			if(listAdminOnline!=null && listAdminOnline.size()>0){
				AdminAccessLog adminAccessLog = null;
				for(int i=0;i<listAdminOnline.size();i++){
					adminAccessLog = listAdminOnline.get(i);
					if(adminAccessLog!=null && adminAccessLog.getSessionId().equals(sessionId)){
						adminAccessLogDAO.updateTimeLogout(adminAccessLog.getUsrname(), adminAccessLog.getIp(), adminAccessLog.getBrowser());
						listAdminOnline.remove(i);
						totalActiveSessions--;
						System.out.println("session destroyed username - " + username + " - sId: " + sessionId);
						break;
					}
				}
			}
		}catch(Exception ex){
			System.out.println("error:" + ex.getMessage());
			System.out.println(arg0.getSession()==null?"ss-null":"ss-ok");
		}
	}
}
