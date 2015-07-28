package com.rf.pages.website;

import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.By;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriverException;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.Select;

import com.rf.core.driver.website.RFWebsiteDriver;
import com.rf.core.website.constants.TestConstants;
import com.rf.test.website.storeFront.autoship.AutoshipTest;

public class StoreFrontShippingInfoPage extends RFWebsiteBasePage{
	private static final Logger logger = LogManager
			.getLogger(StoreFrontShippingInfoPage.class.getName());

	private final By SHIPPING_PAGE_TEMPLATE_HEADER_LOC = By.xpath("//div[@class='gray-container-info-top' and text()='Shipping info']");  
	private final By TOTAL_SHIPPING_ADDRESSES_LOC = By.xpath("//ul[@id='multiple-billing-profiles']/li");
	private final By USE_THIS_SHIPPING_PROFILE_FUTURE_AUTOSHIP_CHKBOX_LOC = By.xpath("//div[@id='use-for-autoship']/div");
	private final By NEW_SHIPPING_PROFILE_SAVE_BTN_LOC = By.id("saveShippingAddress");
	private final By ADD_NEW_SHIPPING_LINK_LOC = By.linkText("Add a new shipping address�");


	public StoreFrontShippingInfoPage(RFWebsiteDriver driver) {
		super(driver);		
	}

	public boolean verifyShippingInfoPageIsDisplayed(){
		driver.waitForElementPresent(SHIPPING_PAGE_TEMPLATE_HEADER_LOC);
		return driver.getCurrentUrl().contains(TestConstants.SHIPPING_PAGE_SUFFIX_URL);
	}

	public boolean isDefaultAddressRadioBtnSelected(String defaultAddressFirstNameDB) throws InterruptedException{
		Thread.sleep(2000);
		return driver.findElement(By.xpath("//span[contains(text(),'"+defaultAddressFirstNameDB+"')]/ancestor::li[1]/form/span/input")).isSelected();
	}

	public boolean isDefaultShippingAddressSelected(String address1) throws InterruptedException{
		Thread.sleep(2000);
		return driver.findElement(By.xpath("//input[@name='addressCode' and @checked='checked']/ancestor::li[1]/p[1]")).getText().contains(address1);
	}	


	public boolean verifyAutoShipAddressTextNextToDefaultRadioBtn(String defaultAddressFirstNameDB){
		return driver.findElement(By.xpath("//span[contains(text(),'"+defaultAddressFirstNameDB+"')]/following::b[@class='AutoshipOrderAddress']")).getText().equals(TestConstants.AUTOSHIP_ADRESS_TEXT);
	}

	public int getTotalShippingAddressesDisplayed(){
		driver.waitForElementPresent(TOTAL_SHIPPING_ADDRESSES_LOC);
		List<WebElement> totalShippingAddressesDisplayed = driver.findElements(TOTAL_SHIPPING_ADDRESSES_LOC);
		return totalShippingAddressesDisplayed.size();
	}

	public void clickOnEditForFirstAddress(){
		driver.waitForElementPresent(By.xpath("//ul[@id='multiple-billing-profiles']//li[1]//a[text()='Edit']"));
		driver.findElement(By.xpath("//ul[@id='multiple-billing-profiles']//li[1]//a[text()='Edit']")).click();
		logger.info("First Address Edit link clicked");
		
	}

	public void clickAddNewShippingProfileLink() throws InterruptedException{
		driver.waitForElementPresent(ADD_NEW_SHIPPING_LINK_LOC);
		driver.click(ADD_NEW_SHIPPING_LINK_LOC);
		Thread.sleep(2000);
		logger.info("Add new shipping profile link clicked");
	}

	public void enterNewShippingAddressName(String name){
		driver.findElement(By.id("new-attention")).sendKeys(name);
		logger.info("New Shipping Address name is "+name);
	}

	public void enterNewShippingAddressLine1(String addressLine1){
		driver.findElement(By.id("new-address-1")).sendKeys(addressLine1);
		logger.info("New Shipping Address is "+addressLine1);
	}

	public void enterNewShippingAddressCity(String city){
		driver.findElement(By.id("townCity")).sendKeys(city);
		logger.info("New Shipping City is "+city);
	}

	public void selectNewShippingAddressState(String state){
		Select stateDD = new Select(driver.findElement(By.id("state")));
		stateDD.selectByValue(state);
	}

	public void enterNewShippingAddressPostalCode(String postalCode){
		driver.findElement(By.id("postcode")).sendKeys(postalCode);
	}

	public void enterNewShippingAddressPhoneNumber(String phoneNumber){
		driver.findElement(By.id("phonenumber")).sendKeys(phoneNumber);
	}

	public void selectFirstCardNumber() throws InterruptedException{
		Thread.sleep(2000);
		try{
			driver.waitForElementPresent(By.xpath("//select[@id='cardDropDowndropdown']"));
			driver.findElement(By.xpath("//select[@id='cardDropDowndropdown']")).click();
			
		}catch(WebDriverException e){
			Actions action = new Actions(RFWebsiteDriver.driver);
			action.moveToElement(driver.findElement(By.xpath("//select[@id='cardDropDowndropdown']"))).click().build().perform();
			
		}
		Thread.sleep(2000);
		driver.findElement(By.xpath("//select[@id='cardDropDowndropdown']/option[2]")).click();
		logger.info("First Card number selected from drop down");
	}

	public void enterNewShippingAddressSecurityCode(String securityCode){
		driver.findElement(By.id("security-code")).sendKeys(securityCode);
	}

	public void selectUseThisShippingProfileFutureAutoshipChkbox(){
		driver.findElement(USE_THIS_SHIPPING_PROFILE_FUTURE_AUTOSHIP_CHKBOX_LOC).click();
	}

	public void clickOnSaveShippingProfile() throws InterruptedException{
		driver.waitForElementPresent(NEW_SHIPPING_PROFILE_SAVE_BTN_LOC);
		driver.click(NEW_SHIPPING_PROFILE_SAVE_BTN_LOC);
		Thread.sleep(5000);
		logger.info("New Shipping prifile save button clicked");
	}

	public boolean isShippingAddressPresentOnShippingPage(String name){
		try{
			driver.findElement(By.xpath("//ul[@id='multiple-billing-profiles']//li//span[@class='font-bold'][contains(text(),'"+name+"')]"));
			return true;
		}catch(NoSuchElementException e){
			try{
				driver.findElement(By.xpath("//ul[@id='multiple-billing-profiles']//li//span[@class='font-bold'][contains(text(),'"+name.toLowerCase()+"')]"));
				return true;
			}
			catch(NoSuchElementException e1){
				return false;
			}			
		}
	}

}


