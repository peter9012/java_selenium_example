package com.rf.pages.website.rehabitat.storeFront;

import org.openqa.selenium.By;
import org.openqa.selenium.Keys;

import com.rf.core.driver.website.RFWebsiteDriver;
import com.rf.pages.website.rehabitat.storeFront.basePage.StoreFrontWebsiteBasePage;
import com.rf.test.website.rehabitat.storeFront.baseTest.StoreFrontWebsiteBaseTest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class StoreFrontAccountInfoPage extends StoreFrontWebsiteBasePage{

	public StoreFrontAccountInfoPage(RFWebsiteDriver driver) {
		super(driver);  
	}

	private static final Logger logger = LogManager
			.getLogger(StoreFrontAccountInfoPage.class.getName());

	private final By FIRST_NAME_LOC = By.id("profile.firstName");
	private final By LAST_NAME_LOC = By.id("profile.lastName");
	private final By ADDRESS_LINE_LOC = By.id("profile.line1");
	private final By CITY_LOC = By.id("profile.townCity");
	private final By POSTAL_CODE_LOC = By.id("profile.postcode");
	private final By MAIN_PHONE_NUMBER_LOC = By.id("profile.phone1");
	private final By EMAIL_LOC = By.id("profile.email");
	private final By OLD_PASSWORD_LOC = By.id("profile.currentPassword");
	private final By NEW_PASSWORD_LOC = By.id("profile.newPassword");
	private final By CONFIRM_PASSWORD_LOC = By.id("profile.checkNewPassword");
	private final By USERNAME_FIELD_LOC = By.xpath("//input[@class='text-input valid']");
	private final By SAVE_BUTTON_ACCOUNT_INFO_PAGE_LOC = By.id("accountFormBtn");
	private final By SPOUSE_CHECKBOX_ALREADY_CHECKED_LOC = By.xpath("//input[@id='agree-spouse' and @checked='checked']/following-sibling::label");
	private final By SPOUSE_CHECKBOX_LOC = By.xpath("//input[@id='agree-spouse']/following-sibling::label");
	private final By ACCEPT_BTN_SPOUSE_POPUP_LOC = By.id("accept-spouse");
	private final By SPOUSE_FIRST_NAME_LOC = By.id("profile.spouseFirstname");
	private final By SPOUSE_LAST_NAME_LOC = By.id("profile.spouseLastname");
	private final By SPOUSE_DETAIL_POPUP_YES_BTN_LOC = By.xpath("//div[@id='cboxLoadedContent']/descendant::button[@id='suggestedAddress']");
	private final By SPOUSE_DETAIL_POPUP_USE_AS_ENTERED_BTN_LOC = By.xpath("//div[@id='cboxLoadedContent']/descendant::button[@id='oldAddress']");
	private final By PROFILE_UPDATION_MESSAGE_LOC = By.xpath("//div[@class='global-alerts']/div");
	private final By STATE_DD_LOC = By.id("profile.region");

	private String spouseFirstNameValidationErrorLoc = " //*[@id='profile.spouseFirstname']/following::label[contains(text(),'%s')][1]";
	private String spouseLastNameValidationErrorLoc = " //*[@id='profile.spouseLastname']/following::label[contains(text(),'%s')][1]";
	private String stateForAccountDetails = "//select[@id='profile.region']//option[text()='%s']";
	private String emailValidationErrorLoc ="//*[@id='profile.email']/following::label[contains(text(),'%s')]";
	private String newPasswordValidationErrorLoc ="//*[@id='profile.newPassword']/following::label[contains(text(),'%s')]";
	private String confirmPasswordValidationErrorLoc ="//*[@id='profile.checkNewPassword']/following::label[contains(text(),'%s')]";
	private String firstNameValidationErrorLoc ="//*[@id='profile.firstName']/following::label[contains(text(),'%s')][1]";
	private String lastNameValidationErrorLoc = "//*[@id='profile.lastName']/following::label[contains(text(),'%s')][1]";
	private String addressLineValidationErrorLoc = "//*[@id='profile.line1']/following::label[contains(text(),'%s')][1]";
	private String cityValidationErrorLoc = "//*[@id='profile.townCity']/following::label[contains(text(),'%s')][1]";
	private String postalValidationErrorLoc = "//*[@id='profile.postcode']/following::label[contains(text(),'%s')][1]";
	private String phoneNumberValidationErrorLoc = "//*[@id='profile.phone1']/following::label[contains(text(),'%s')][1]";

	/***
	 * This method verify first Name field on account info page. 
	 * 
	 * @param
	 * @return boolean value
	 * 
	 */
	public boolean isFirstNameFieldPresent(){
		return driver.findElement(FIRST_NAME_LOC).isDisplayed();
	}

	/***
	 * This method verify Last Name field on account info page. 
	 * 
	 * @param
	 * @return boolean value
	 * 
	 */
	public boolean isLastNameFieldPresent(){
		return driver.findElement(LAST_NAME_LOC).isDisplayed();
	}

	/***
	 * This method verify Address field on account info page. 
	 * 
	 * @param
	 * @return boolean value
	 * 
	 */
	public boolean isAddressFieldPresent(){
		return driver.findElement(ADDRESS_LINE_LOC).isDisplayed();
	}

	/***
	 * This method verify city field on account info page. 
	 * 
	 * @param
	 * @return boolean value
	 * 
	 */
	public boolean isCityFieldPresent(){
		return driver.findElement(CITY_LOC).isDisplayed();
	}

	/***
	 * This method verify Postal field on account info page. 
	 * 
	 * @param
	 * @return boolean value
	 * 
	 */
	public boolean isPostalFieldPresent(){
		return driver.findElement(POSTAL_CODE_LOC).isDisplayed();
	}

	/***
	 * This method verify main phone number field on account info page. 
	 * 
	 * @param
	 * @return boolean value
	 * 
	 */
	public boolean isMainPhoneNumberFieldPresent(){
		return driver.findElement(MAIN_PHONE_NUMBER_LOC).isDisplayed();
	}

	/***
	 * This method enter Updated Username on account info page. 
	 * 
	 * @param
	 * @return account info page object
	 * 
	 */
	public StoreFrontAccountInfoPage enterUserName(String userName){
		driver.type(USERNAME_FIELD_LOC, userName);
		logger.info("Entered username is "+userName);
		return this;
	}

	/***
	 * This method click save button on account info page. 
	 * 
	 * @param
	 * @return account Info Page object
	 * 
	 */
	public StoreFrontAccountInfoPage saveAccountInfo(){
		driver.click(SAVE_BUTTON_ACCOUNT_INFO_PAGE_LOC);
		logger.info("Save button clicked on account info page.");
		return this;
	}

	/***
	 * This method enter email address in the email field on account info page 
	 * 
	 * @param
	 * @return account Info Page object
	 * 
	 */
	public StoreFrontAccountInfoPage enterEmail(String email){
		driver.type(EMAIL_LOC,email);
		logger.info("entered email as "+email);
		return this;
	}

	/***
	 * This method enter password in the old password field on account info page 
	 * 
	 * @param
	 * @return account Info Page object
	 * 
	 */
	public StoreFrontAccountInfoPage enterOldPassword(String password){
		driver.type(OLD_PASSWORD_LOC,password);
		logger.info("entered old password as "+password);
		return this;
	}

	/***
	 * This method enter password in the new password field on account info page 
	 * 
	 * @param
	 * @return account Info Page object
	 * 
	 */
	public StoreFrontAccountInfoPage enterNewPassword(String password){
		driver.type(NEW_PASSWORD_LOC,password);
		logger.info("entered new password as "+password);
		return this;
	}

	/***
	 * This method enter password in the confirm password field on account info page 
	 * 
	 * @param
	 * @return account Info Page object
	 * 
	 */
	public StoreFrontAccountInfoPage enterConfirmPassword(String password){
		driver.type(CONFIRM_PASSWORD_LOC,password);
		logger.info("entered confirm password as "+password);
		return this;
	}

	/***
	 * This method verifies the presence of error message for a particular field on account info page 
	 * 
	 * @param
	 * @return Boolean
	 * 
	 */
	public Boolean isValidationMsgPresentForParticularField(String field,String errorMsg){
		Boolean isValidationMsgPresentForParticularField = null;
		if(field.equalsIgnoreCase("email"))
			isValidationMsgPresentForParticularField = driver.isElementPresent(By.xpath(String.format(emailValidationErrorLoc,errorMsg))); 
		else if(field.equalsIgnoreCase("new password"))
			isValidationMsgPresentForParticularField = driver.isElementPresent(By.xpath(String.format(newPasswordValidationErrorLoc,errorMsg)));
		else if(field.equalsIgnoreCase("confirm password"))
			isValidationMsgPresentForParticularField = driver.isElementPresent(By.xpath(String.format(confirmPasswordValidationErrorLoc,errorMsg)));
		else if(field.equalsIgnoreCase("First Name"))
			isValidationMsgPresentForParticularField = driver.isElementPresent(By.xpath(String.format(firstNameValidationErrorLoc,errorMsg)));
		else if(field.equalsIgnoreCase("Last Name"))
			isValidationMsgPresentForParticularField = driver.isElementPresent(By.xpath(String.format(lastNameValidationErrorLoc,errorMsg)));
		else if(field.equalsIgnoreCase("address1"))
			isValidationMsgPresentForParticularField = driver.isElementPresent(By.xpath(String.format(addressLineValidationErrorLoc,errorMsg)));
		else if(field.equalsIgnoreCase("city"))
			isValidationMsgPresentForParticularField = driver.isElementPresent(By.xpath(String.format(cityValidationErrorLoc,errorMsg)));
		else if(field.equalsIgnoreCase("postal"))
			isValidationMsgPresentForParticularField = driver.isElementPresent(By.xpath(String.format(postalValidationErrorLoc,errorMsg)));
		else if(field.equalsIgnoreCase("phone"))
			isValidationMsgPresentForParticularField = driver.isElementPresent(By.xpath(String.format(phoneNumberValidationErrorLoc,errorMsg)));
		else if(field.equalsIgnoreCase("spouseFirstName"))
			isValidationMsgPresentForParticularField = driver.isElementPresent(By.xpath(String.format(spouseFirstNameValidationErrorLoc,errorMsg)));
		else if(field.equalsIgnoreCase("spouseLastName"))
			isValidationMsgPresentForParticularField = driver.isElementPresent(By.xpath(String.format(spouseLastNameValidationErrorLoc,errorMsg)));
		return isValidationMsgPresentForParticularField;
	}

	/***
	 * This method clear all fields on account info page 
	 * 
	 * @param
	 * @return account Info Page object
	 * 
	 */
	public StoreFrontAccountInfoPage clearAllFields(){
		driver.findElement(FIRST_NAME_LOC).clear();
		logger.info("First name field clear");
		driver.findElement(LAST_NAME_LOC).clear();
		logger.info("Last name field clear");
		driver.findElement(ADDRESS_LINE_LOC).clear();
		logger.info("Address line field clear");
		driver.findElement(CITY_LOC).clear();
		logger.info("City field clear");
		driver.findElement(POSTAL_CODE_LOC).clear();
		logger.info("Postal code field clear");
		driver.findElement(MAIN_PHONE_NUMBER_LOC).clear();
		logger.info("Main phone number field clear");
		driver.findElement(EMAIL_LOC).clear();
		logger.info("Email field clear");
		driver.pauseExecutionFor(2000);
		return this;
	}

	/***
	 * This method click checkbox for spouse details on account info page. 
	 * 
	 * @param
	 * @return account Info Page object
	 * 
	 */
	public StoreFrontAccountInfoPage checkSpouseCheckbox(){
		if(driver.isElementPresent(SPOUSE_CHECKBOX_ALREADY_CHECKED_LOC)==false){
			driver.click(SPOUSE_CHECKBOX_LOC);
			logger.info("'Spouse' checkbox clicked on account info page.");
			driver.pauseExecutionFor(2000);
			driver.click(ACCEPT_BTN_SPOUSE_POPUP_LOC);
			logger.info("'ACCEPT' button clicked on spouse account access detail popup");
		}else{
			logger.info("'Spouse' checkbox already checked on account info page");
		}
		return this;
	}
	/***
	 * This method enter Spouse first name field on account info page 
	 * 
	 * @param
	 * @return account Info Page object
	 * 
	 */
	public StoreFrontAccountInfoPage enterSpouseFirstName(String firstName){
		driver.type(SPOUSE_FIRST_NAME_LOC,firstName);
		logger.info("entered Spouse first Name as "+"'"+firstName+"'");
		return this;
	}
	/***
	 * This method enter Spouse last name field on account info page 
	 * 
	 * @param
	 * @return account Info Page object
	 * 
	 */
	public StoreFrontAccountInfoPage enterSpouseLastName(String lastName){
		driver.type(SPOUSE_LAST_NAME_LOC,lastName);
		logger.info("entered Spouse last Name as "+"'"+lastName+"'");
		return this;
	}
	/***
	 * This method validates Spouse details popup when entered spouse details and click save button on account info page.
	 * 
	 * @param
	 * @return boolean value
	 * 
	 */
	public boolean isSpouseDetailsConfirmationPopUpPresent(){
		if(driver.findElement(SPOUSE_DETAIL_POPUP_YES_BTN_LOC).isDisplayed() && driver.findElement(SPOUSE_DETAIL_POPUP_USE_AS_ENTERED_BTN_LOC).isDisplayed()){
			return true;
		}else{
			return false;
		}
	}
	/***
	 * This method click use as entered on spouse details popup on account info page. 
	 * 
	 * @param
	 * @return account Info Page object
	 * 
	 */
	public StoreFrontAccountInfoPage useEnteredDetailsOnSpouseDetailsPopUp(){
		driver.click(SPOUSE_DETAIL_POPUP_USE_AS_ENTERED_BTN_LOC);
		logger.info("'USE AS ENTERED' Btn clicked on Spouse Detail popup at account info page.");
		driver.waitForPageLoad();
		driver.waitForLoadingImageToDisappear();
		return this;
	}
	/***
	 * This method get profile Updation message on account info page.
	 * 
	 * @param
	 * @return profile updation message
	 * 
	 */
	public String getProfileUpdationMessage(){
		String []profileUpdationMessage = driver.findElement(PROFILE_UPDATION_MESSAGE_LOC).getText().split("�"); 
		logger.info("profile updation message is: "+profileUpdationMessage[1]);
		return profileUpdationMessage[1].trim();
	}
	/***
	 * This method enter main Account info on Account Info Page
	 * 
	 * @param First name,Last name, address line1, city, state, postal code, phone number
	 * @return store front Account Info page object
	 * 
	 */
	public StoreFrontWebsiteBasePage enterMainAccountInfo(String firstName, String lastName, String addressLine1, String city, String state, String postal, String phoneNumber){
		driver.type(FIRST_NAME_LOC, firstName);
		logger.info("Entered first name as "+firstName);
		driver.type(LAST_NAME_LOC, lastName);
		logger.info("Entered last name as "+lastName);
		driver.type(ADDRESS_LINE_LOC, addressLine1);
		logger.info("Entered address line 1 as "+addressLine1);
		driver.type(CITY_LOC, city);
		logger.info("Entered city as "+city);
		driver.click(STATE_DD_LOC);
		logger.info("State dropdown clicked");
		driver.click(By.xpath(String.format(stateForAccountDetails, state)));
		logger.info("State selected as "+state);
		driver.type(POSTAL_CODE_LOC, postal);
		logger.info("Entered postal code as "+postal);
		driver.type(MAIN_PHONE_NUMBER_LOC, phoneNumber);
		logger.info("Entered Phone number  as "+phoneNumber);
		return this;
	}
	/***
	 * This method clear field mention in argument on account info page 
	 * 
	 * @param fieldName
	 * @return account Info Page object
	 * 
	 */
	public StoreFrontAccountInfoPage clearFields(String fieldName){
		if(fieldName.equalsIgnoreCase("firstName")){
			driver.findElement(FIRST_NAME_LOC).clear();
			logger.info("First name field clear");
		}
		else if(fieldName.equalsIgnoreCase("lastName")){
			driver.findElement(LAST_NAME_LOC).clear();
			logger.info("Last name field clear");
		}
		else if(fieldName.equalsIgnoreCase("addressLine")){
			driver.findElement(ADDRESS_LINE_LOC).clear();
			logger.info("Address line field clear");
		}
		else if(fieldName.equalsIgnoreCase("city")){
			driver.findElement(CITY_LOC).clear();
			logger.info("City field clear");
		}
		else if(fieldName.equalsIgnoreCase("postalCode")){
			driver.findElement(POSTAL_CODE_LOC).clear();
			logger.info("Postal code field clear");
		}
		else if(fieldName.equalsIgnoreCase("phone")){
			driver.findElement(MAIN_PHONE_NUMBER_LOC).clear();
			logger.info("Main phone number field clear");
		}
		else if(fieldName.equalsIgnoreCase("email")){
			driver.findElement(EMAIL_LOC).clear();
			logger.info("Email field clear");
		}
		driver.pauseExecutionFor(2000);
		return this;
	}
	/***
	 * This method enter value in field mention in argument on account info page 
	 * 
	 * @param fieldName
	 * @return account Info Page object
	 * 
	 */
	public StoreFrontAccountInfoPage enterFields(String fieldName,String value){
		if(fieldName.equalsIgnoreCase("firstName")){
			driver.type(FIRST_NAME_LOC, value);
			logger.info("First name entered "+value);
		}
		else if(fieldName.equalsIgnoreCase("lastName")){
			driver.type(LAST_NAME_LOC, value);
			logger.info("Last name entered "+value);
		}
		else if(fieldName.equalsIgnoreCase("addressLine")){
			driver.type(ADDRESS_LINE_LOC, value);
			logger.info("Address line entered "+value);
		}
		else if(fieldName.equalsIgnoreCase("city")){
			driver.type(CITY_LOC, value);
			logger.info("City entered "+value);
		}
		else if(fieldName.equalsIgnoreCase("postalCode")){
			driver.type(POSTAL_CODE_LOC, value);
			logger.info("Postal code entered "+value);
		}
		else if(fieldName.equalsIgnoreCase("phone")){
			driver.type(MAIN_PHONE_NUMBER_LOC, value);
			logger.info("Main phone number entered "+value);
		}
		else if(fieldName.equalsIgnoreCase("email")){
			driver.type(EMAIL_LOC, value);
			logger.info("Email entered as "+value);
		}
		driver.pauseExecutionFor(2000);
		return this;
	}

}