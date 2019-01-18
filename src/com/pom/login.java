package com.pom;

import test.webdriver.SonnetElementBase;

public class login extends SonnetElementBase{
	
	public void login() throws Exception{
		navigateTo(_properties.getValue("url"));
	}

}
