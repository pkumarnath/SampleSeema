package testScriptsPkg;


import pageObjectPkg.uniliverPageObj;
//import test.webdriver.SonnetElementBase;

public class uniliverTestCases {
	
	 uniliverPageObj un= new uniliverPageObj();	
	
	 public void accessApplication() throws Exception {
		 un.setup();
	 }
	
	public void login() throws Exception {		
		un.login("hemalatha.s1@sonata-software.com", "S0nata@007");
	} 
	
	public void searchItems() throws Exception {		
		un.searchItems();
	}

}
