package com.Driver;


import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

import com.pom.BrowserSetup1;
import com.pom.OrangehrmLogin;
import com.pom.login;
import com.testng.SonnetTestNGBase;


	public class Driver extends SonnetTestNGBase {

		OrangehrmLogin sam = new OrangehrmLogin();
		BrowserSetup1 bs = new BrowserSetup1();
		login log = new login();
		
			
		
	@BeforeMethod
	public void openBrowser() throws Exception{
		bs.setup();
		
	}

	@AfterMethod(groups={"Smoke","Regression","Functional"})
	 
	public void exit(){
		bs.closeBrowser();
	}



	@Test(priority=1,enabled=true)
	public void TC_01() throws Exception{
	   // _properties.setValue("test_case_id_service", "283");
	    log.login();	
	    sam.SignIn();
	}

	@Test(priority=2,enabled=true)
	public void TC_02() throws Exception{
	 //   _properties.setValue("test_case_id_service", "284");
	    log.login();	
	    sam.AssertFail();
	}
	
	@Test(priority=2,enabled=true)
	public void TC_03() throws Exception{
	 //   _properties.setValue("test_case_id_service", "284");
	    log.login();	
	    sam.InvalidPassword();
	}
	}


