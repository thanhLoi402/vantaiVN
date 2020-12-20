package tdt.service.servlet;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Random;
import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class CaptcharServlet extends HttpServlet {
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		response.setContentType("image/jpg");
		
		int iTotalChars = 6;
		
		int iHeight = 20;
		int iWidth = 80;
		
		Font fntStyle1 = new Font("Arial", 1, 20);
		Font fntStyle2 = new Font("Verdana", 1, 20);
		
		Random randChars = new Random();
		String sImageCode = Long.toString(Math.abs(randChars.nextLong()), 36).substring(0, iTotalChars);
		
		session.setAttribute("sms-captcha-auth", sImageCode);
		
		BufferedImage biImage = new BufferedImage(iWidth, iHeight, 1);
		Graphics2D g2dImage = (Graphics2D) biImage.getGraphics();
		
		int iCircle = 15;
		g2dImage.fillRect(0, 0, iWidth, iHeight);
		for (int i = 0; i < iCircle; i++) {
			g2dImage.setColor(new Color(randChars.nextInt(255), randChars.nextInt(255), randChars.nextInt(255)));
			
			int iRadius = (int) (Math.random() * iHeight / 2.0D);
			int iX = (int) (Math.random() * iWidth - iRadius);
			//int i = (int) (Math.random() * iHeight - iRadius);
		}
		g2dImage.setFont(fntStyle1);
		for (int i = 0; i < iTotalChars; i++) {
			g2dImage.setColor(new Color(randChars.nextInt(255), randChars.nextInt(255), randChars.nextInt(255)));
			if (i % 2 == 0) {
				g2dImage.drawString(sImageCode.substring(i, i + 1), 13 * i, 15);
			} else {
				g2dImage.drawString(sImageCode.substring(i, i + 1), 13 * i, 15);
			}
		}
		ServletOutputStream osImage = response.getOutputStream();
		ImageIO.write(biImage, "jpeg", osImage);
		osImage.flush();
		osImage.close();
		
		g2dImage.dispose();
		
		session.setAttribute("dns_security_code", sImageCode);
	}
	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
	
	public void init() throws ServletException {
	}
}
