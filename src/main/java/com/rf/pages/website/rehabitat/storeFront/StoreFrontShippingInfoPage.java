package com.rf.pages.website.rehabitat.storeFront;

import org.openqa.selenium.By;

import com.rf.core.driver.website.RFWebsiteDriver;
import com.rf.pages.website.rehabitat.storeFront.basePage.StoreFrontWebsiteBasePage;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class StoreFrontShippingInfoPage extends StoreFrontWebsiteBasePage{

	public StoreFrontShippingInfoPage(RFWebsiteDriver driver) {
		super(driver);  
	}

	private static final Logger logger = LogManager
			.getLogger(StoreFrontShippingInfoPage.class.getName());

	private final By ADD_NEW_SHIPPING_ADDRESS_LOC = By.xpath("//a[contains(text(),'Add new shipping address')]");
	private final By CANCEL_BUTTON_OF_SHIPPING_ADDRESS_LOC = By.xpath("//div[@class='accountActions']//a");
	private final By DEFAULT_SHIPPING_ADDRESS_NAME_LOC = By.xpath("//strong[contains(text(),'Default')]");
	private final By EDIT_LINK_OF_DEFAULT_SHIPPING_ADDRESS_LOC = By.xpath("//strong[contains(text(),'Default')]/following::a[1]");
	 private final By ADDRESS_UPDATE_SUCCESS_MSG_LOC = By.xpath("//div[contains(@class,'alert-info') and contains(@class,'alert-dismissable')]");
	private String shippingProfileNameLoc  = "//div[contains(@class,'account-addressbook')]/descendant::strong[contains(text(),'%s')][1]";

	/***
	 * This method clicked on add a new shipping address link 
	 * 
	 * @param
	 * @return store front shipping info page object
	 * 
	 */
	public StoreFrontShippingInfoPage clickAddANewShippingAddressLink(){
		driver.click(ADD_NEW_SHIPPING_ADDRESS_LOC);
		logger.info("Add new shipping address link clicked");
		return this;
	}


	/***
	 * This method validates that shipping profile is present or not
	 * at shipping info page 
	 * 
	 * @param profile name
	 * @return boolean value
	 * 
	 */
	public boolean isShippingProfilePresent(String profileName){
		return driver.isElementPresent(By.xpath(String.format(shippingProfileNameLoc, profileName)));
	}

	/***
	 * This method validates that shipping address details field is present or not
	 * 
	 * @param
	 * @return boolean value
	 * 
	 */
	public boolean isShippingAddressDetailFieldsPresent(String name){
		try{
			driver.pauseExecutionFor(1000);
			driver.type(FIRST_LAST_NAME_FOR_SHIPPING_DETAILS_LOC, name);
			return true;
		}catch(Exception e){
			return false;
		}
	}


	/***
	 * This method click the cancel button of shipping address
	 * 
	 * @param
	 * @return store front shipping info page object
	 * 
	 */
	public StoreFrontShippingInfoPage clickCancelButtonOfShippingAddress(){
		driver.click(CANCEL_BUTTON_OF_SHIPPING_ADDRESS_LOC);
		logger.info("Cancel button clicked");
		return this;
	}



	/***
	 * This method get the default shipping profile name
	 * 
	 * @param
	 * @return profile name
	 * 
	 */
	public String getDefaultShippingAddressName(){
		driver.pauseExecutionFor(2000);
		String profileName = driver.findElement(DEFAULT_SHIPPING_ADDRESS_NAME_LOC).getText();
		logger.info("default profile name is "+profileName);
		return profileName;
	}

	/***
	 * This method clicked on edit link of default shipping address 
	 * 
	 * @param
	 * @return store front shipping info page object
	 * 
	 */
	public StoreFrontShippingInfoPage clickEditLinkOfDefaultShippingAddress(){
		driver.click(EDIT_LINK_OF_DEFAULT_SHIPPING_ADDRESS_LOC);
		logger.info("Edit link clicked of default shipping address");
		return this;
	}

	/***
	 * This method fetch the address update success message  
	 * 
	 * @param
	 * @return String
	 * 
	 */
	public String getAddressUpdateSuccessMsg(){
		return driver.getText(ADDRESS_UPDATE_SUCCESS_MSG_LOC);
	}

}

