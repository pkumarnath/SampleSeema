package com.pom;

import org.openqa.selenium.By;

import com.base.Attributes;
import com.base.Wait;
import com.thoughtworks.selenium.webdriven.commands.IsElementPresent;

import test.webdriver.SonnetElement;

public class OrangehrmLogin extends SonnetElement  {

		public void SignIn() throws Exception{
			findElement(By.id("txtUsername")).sendKeys("Admin");
	    	findElement(By.id("txtPassword")).sendKeys("admin123");
	    	findElement(By.id("btnLogin")).click(Wait.Page_Load);
	    	String WelcomeText =  findElement(By.cssSelector(".panelTrigger")).getAttribute(Attributes.TEXT);
	        System.out.println(WelcomeText);
            
		}
		
		public void InvalidPassword() throws Exception{
			findElement(By.id("txtUsername")).sendKeys("Admin");
	    	findElement(By.id("txtPassword")).sendKeys("admin1234");
	    	findElement(By.id("btnLogin")).click(Wait.Page_Load);
	    	String WelcomeText =  findElement(By.cssSelector(".panelTrigger")).getAttribute(Attributes.TEXT);
	        System.out.println(WelcomeText);
		}
		
		
		public void AssertFail() throws Exception{
			findElement(By.id("txtUsername")).sendKeys("Admin");
	    	findElement(By.id("txtPassword")).sendKeys("admin123");
	    	findElement(By.id("btnLogin")).click(Wait.Page_Load);
	    	_assert.equals(false, true, "test assert failure", true);
	    	String WelcomeText =  findElement(By.cssSelector(".panelTrigger")).getAttribute(Attributes.TEXT);
	        System.out.println(WelcomeText);
		}
	
	

}
