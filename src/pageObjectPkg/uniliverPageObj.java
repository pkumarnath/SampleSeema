package pageObjectPkg;

import org.openqa.selenium.By;
import com.base.SonnetBase;
import test.webdriver.SonnetElement;




public class uniliverPageObj extends SonnetElement {
	
	public void setup() throws Exception {
		SonnetBase m = new SonnetBase();
		m.applyDefaults();
		invokeBrowser(_properties.getValue("browser_name"));
		navigateTo(_properties.getValue("url"));
		_wait.waitForPageLoad();
	}
	
	public void browserClose() {
		_Driver.quit();
	}

	public void login(String uname, String upswd) throws Exception {
		System.out.println(getCurrentUrl());
		findElement(By.linkText("Login/register")).click();
		findElement(By.id("dwfrm_login_username")).clear();
		findElement(By.id("dwfrm_login_username")).sendKeys("hemalatha.s1@sonata-software.com");
		findElement(By.id("dwfrm_login_password")).clear();
		findElement(By.id("dwfrm_login_password")).sendKeys("S0nata@007");
		findElement(By.name("dwfrm_login_login")).submit();
	}
	
	public boolean loginSuccessful() throws Exception {
		return _assert.equals(getCurrentUrl(), "https://www.t2tea.com/en/au/up-to-60-off-selected-teawares-gift-packs-3/", false);
	}

	public void searchItems() throws Exception {
		findElement(By.id("icon-search")).click();
		findElement(By.name("simpleSearch")).clear();
		findElement(By.name("simpleSearch")).sendKeys("Tea Cups");
		findElement(By.name("simpleSearchSubMobile")).click();
		wait();
		_assert.equals(getTitle(), "Sites-UNI-T2-APAC-Site | T2 TeaAU", false);
		
	}	

}
