package tdt.listener;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class SessionContextListener implements ServletContextListener {

	public void contextDestroyed(ServletContextEvent arg0) {
		// TODO Auto-generated method stub
		System.out.println("contextDestroyed");
		System.out.println(arg0.getSource().toString());
	}

	public void contextInitialized(ServletContextEvent arg0) {
		// TODO Auto-generated method stub
		
	}

}
