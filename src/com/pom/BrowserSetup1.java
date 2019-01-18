package com.pom;

import test.webdriver.SonnetElementBase;

public class BrowserSetup1 extends SonnetElementBase {
	
	public void setup() throws Exception{
		
		invokeBrowser(_properties.getValue("browser_name"));
	}
	
	public void closeBrowser(){
		
		_Driver.quit();

}
}
