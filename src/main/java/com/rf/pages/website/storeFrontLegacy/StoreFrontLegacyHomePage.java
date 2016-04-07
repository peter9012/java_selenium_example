package com.rf.pages.website.storeFrontLegacy;

import java.util.Iterator;
import java.util.Set;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.Alert;
import org.openqa.selenium.By;
import org.openqa.selenium.support.ui.Select;
import com.rf.core.driver.website.RFWebsiteDriver;

public class StoreFrontLegacyHomePage extends StoreFrontLegacyRFWebsiteBasePage{

	private static final Logger logger = LogManager
			.getLogger(StoreFrontLegacyHomePage.class.getName());

	private static String regimenLoc= "//cufontext[text()='%s']/following::a[1]/img";
	private static String genderLocForPCAndRC= "//label[text()='%s']/preceding::input[1]";
	private static String expiryMonthLoc= "//select[contains(@id,'uxMonthDropDown')]//option[@value='%s']";
	private static String expiryYearLoc= "//select[contains(@id,'uxYearDropDown')]//option[@value='%s']";
	private static String regimenHeaderLoc = "//div[@id='HeaderCol']//span[text()='%s']";
	private static String regimenNameLoc= "//cufon[@alt='%s']";
	private static String redefineRegimenSubLinks= "//cufontext[text()='REDEFINE']/following::li//span[text()='%s']";

	private static final By PRODUCTS_LIST_LOC = By.xpath("//div[@id='FullPageItemList']");
	private static final By RESULTS_TEXT_LOC = By.xpath("//cufontext[text()='RESULTS']/preceding::canvas[1]");
	private static final By TESTIMONIAL_PAGE_CONTENT_LOC = By.xpath("//div[@id='RFContent']/div/div/blockquote[1]/div[1]");
	private static final By NEWS_TEXT_LOC = By.xpath("//div[@id='RFContent']");
	private static final By FAQS_TEXT_LOC = By.xpath("//div[@id='RFContent']//cufontext[text()='Questions']");
	private static final By ADVICE_PAGE_CONTENT_LOC = By.xpath("//div[@id='RFContent']//td[1]");
	private static final By GLOSSARY_PAGE_CONTENT_LOC = By.xpath("//div[@id='GlossaryAF']");
	private static final By INGREDIENTS_AND_USAGE_LINK_LOC = By.xpath("//a[text()='Ingredients and Usage']");
	private static final By INGREDIENTS_CONTENT_LOC = By.xpath("//span[@id='ProductUsage']");
	private static final By FOOTER_CONTACT_US_LINK_LOC = By.xpath("//div[@id='FooterPane']//span[text()='Contact Us']");
	private static final By CONTACT_US_PAGE_HEADER_LOC = By.xpath("//cufontext[text()='About ']");

	private static final By BUSINESS_SYSTEM_LOC = By.xpath("//span[text()='Business System']");
	private static final By ENROLL_NOW_ON_BUSINESS_PAGE_LOC = By.xpath("//a[text()='ENROLL NOW']");
	private static final By CID_LOC = By.id("NameOrId");
	private static final By CID_SEARCH_LOC = By.id("BtnSearch");
	private static final By SEARCH_RESULTS_LOC = By.xpath("//div[@id='searchResults']//a");
	private static final By BIG_BUSINESS_LAUNCH_KIT_LOC = By.xpath("//cufontext[contains(text(),'Big')]/ancestor::div[@class='KitContent'][1]");
	private static final By BUSINESS_PORTFOLIO_KIT_LOC =By.xpath("//cufontext[contains(text(),'Portfolio')]/ancestor::div[@class='KitContent'][1]");
	private static final By SELECT_ENROLLMENT_KIT_NEXT_BTN_LOC =By.xpath("//a[@id='BtnNext']//canvas");
	private static final By ACCOUNT_INFORMATION_NEXT_BTN = By.xpath("//a[@id='btnNext']//cufon");
	private static final By REDEFINE_REGIMEN_LOC = By.xpath("//cufontext[text()='REDEFINE ']/ancestor::a[1]");
	private static final By REGIMEN_NEXT_BTN_LOC = By.xpath("//a[@id='BtnDone']");
	private static final By EXPRESS_ENROLLMENT_LOC = By.id("btnGoToExpressEnroll");
	private static final By ENROLLMENT_NEXT_BTN_LOC = By.xpath("//a[@id='btnNext']");
	private static final By STANDARD_ENROLLMENT_LOC = By.id("btnGoToStandardEnrollment");

	private static final By ACCOUNT_FIRST_NAME_LOC = By.id("Account_FirstName");
	private static final By ACCOUNT_LAST_NAME_LOC = By.id("Account_LastName");
	private static final By ACCOUNT_EMAIL_ADDRESS_LOC = By.id("Account_EmailAddress");
	private static final By ACCOUNT_PASSWORD_LOC = By.id("Account_Password");
	private static final By ACCOUNT_CONFIRM_PASSWORD_LOC = By.id("txtConfirmPassword");
	private static final By ACCOUNT_MAIN_ADDRESS1_LOC = By.id("MainAddress_Address1");
	private static final By ACCOUNT_POSTAL_CODE_LOC = By.id("MainAddress_PostalCode");
	private static final By ACCOUNT_PHONE_NUMBER1_LOC = By.id("txtPhoneNumber1");
	private static final By ACCOUNT_PHONE_NUMBER2_LOC = By.id("txtPhoneNumber2");
	private static final By ACCOUNT_PHONE_NUMBER3_LOC = By.id("txtPhoneNumber3");

	private static final By SETUP_ACCOUNT_NEXT_BTN_LOC = By.id("btnNext");
	private static final By USE_AS_ENTERED_BTN_LOC = By.xpath(".//*[@id='QAS_AcceptOriginal']");
	private static final By CARD_NUMBER_LOC = By.xpath(".//*[@id='Payment_AccountNumber']");
	private static final By NAME_ON_CARD_LOC = By.xpath(".//*[@id='Payment_NameOnCard']");
	private static final By EXP_MONTH_LOC = By.id("ExpMonth");
	private static final By EXP_YEAR_LOC = By.id("ExpYear");
	private static final By SSN1_LOC = By.xpath(".//*[@id='txtTaxNumber1']");
	private static final By SSN2_LOC = By.xpath(".//*[@id='txtTaxNumber2']");
	private static final By SSN3_LOC = By.xpath(".//*[@id='txtTaxNumber3']");
	private static final By SSN_CARD_NAME_LOC  = By.xpath(".//*[@id='Account_EnrollNameOnCard']");
	private static final By PWS_LOC = By.id("Account_EnrollSubdomain");
	private static final By PWS_AVAILABLE_MSG_LOC = By.xpath("//li[@id='Abailable0' and contains(text(),'is available')]");
	private static final By COMPLETE_ACCOUNT_NEXT_BTN_LOC = By.xpath(".//*[@id='btnNext']");

	private static final By EMAIL_POLICY_AND_PROCEDURE_TOGGLE_BTN_LOC = By.xpath("//input[@id='Account_EnrollPolicyProcedure']/following::div[1]//div[@class='ibutton-handle-middle']") ;
	private static final By ENROLL_SWITCH_POLICY_TOGGLE_BTN_LOC = By.xpath("//input[@id='Account_EnrollSwitchingPolicy']/following::div[1]//div[@class='ibutton-handle-middle']") ;
	private static final By ENROLL_TERMS_CONDITIONS_TOGGLE_BTN_LOC = By.xpath("//input[@id='Account_EnrollTermsAndConditions']/following::div[1]//div[@class='ibutton-handle-middle']") ;
	private static final By ENROLL_E_SIGN_CONSENT_TOGGLE_BTN_LOC = By.xpath("//input[@id='Account_EnrollESignConsent']/following::div[1]//div[@class='ibutton-handle-middle']") ;

	private static final By CHARGE_AND_ENROLL_ME_BTN_LOC = By.id("ChargeAndEnrollMe");
	private static final By CONFIRM_AUTOSHIP_BTN_LOC = By.id("confirmAuthoship");
	private static final By CONGRATS_MSG_LOC = By.id("Congrats");

	private static final By AUTOSHIP_OPTIONS_NEXT_BTN_LOC = By.xpath("//a[@id='btnNext']");
	private static final By ADD_TO_CART_BTN_LOC = By.xpath("//div[@class='productList']/div[1]/div[1]/a[2]"); 
	private static final By YOUR_CRP_ORDER_POPUP_NEXT_BTN_LOC = By.id("PlaceCRPOrder");
	private static final By USERNAME_TEXT_BOX_LOC = By.id("username");
	private static final By PASSWORD_TXTFLD_ONFOCUS_LOC = By.id("passwordWatermarkReplacement");
	private static final By PASSWORD_TEXT_BOX_LOC = By.id("password");
	private static final By ENTER_LOGIN_BTN_LOC = By.id("loginButton");
	private static final By SUBSCRIBE_TO_PULSE_TOGGLE_BTN_LOC = By.xpath("//input[@id='Account_EnrollPulse']/following::div[1]//div[@class='ibutton-handle-middle']");
	private static final By ENROLL_IN_CRP_TOGGLE_BTN_LOC = By.xpath("//input[@id='Account_EnrollCRP']/following::div[1]//div[@class='ibutton-handle-middle']");
	private static final By RODAN_AND_FIELDS_IMG_LOC = By.xpath("//div[@id='logo']//img");
	private static final By LOGOUT_LOC = By.xpath("//a[text()='Log Out']");
	private static final By EXISTING_CONSULTANT_LOC = By.xpath("//div[@id='ExistentConsultant']/p[contains(text(),'already have a Consultant account')]");
	private static final By ENROLL_NOW_ON_BIZ_PWS_PAGE_LOC = By.xpath("//div[@id='mainBanner']/div[1]/a/img");
	private static final By ENROLL_NOW_ON_WHY_RF_PAGE_LOC = By.xpath("//a[text()='Enroll Now']");

	private static final By ADD_TO_CART_BTN = By.xpath("//a[text()='Add to Cart']");
	private static final By CLICK_HERE_LINK_FOR_PC = By.xpath("//a[contains(@id,'PreferredLink')]");
	private static final By ENROLL_NOW_FOR_PC_AND_RC = By.xpath("//a[text()='Enroll Now']");
	private static final By FIRST_NAME_FOR_PC_AND_RC = By.xpath("//input[contains(@id,'uxFirstName')]");
	private static final By LAST_NAME_FOR_PC_AND_RC = By.xpath("//input[contains(@id,'uxLastName')]");
	private static final By EMAIL_ADDRESS_FOR_PC_AND_RC = By.xpath("//input[contains(@id,'uxEmailAddress')]");
	private static final By CREATE_PASSWORD_FOR_PC_AND_RC = By.xpath("//table[@class='FormTable']//input[contains(@id,'uxPassword')]");
	private static final By CONFIRM_PASSWORD_FOR_PC_AND_RC = By.xpath("//input[contains(@id,'uxConfirmPassword')]");
	private static final By PHONE_NUMBER_FOR_PC_AND_RC = By.xpath("//input[contains(@id,'uxPhoneNumber')]");
	private static final By CONTINUE_BTN_PREFERRED_PROFILE_PAGE_LOC = By.xpath("//input[contains(@id,'uxContinue')]");
	private static final By ID_NUMBER_AS_SPONSOR = By.xpath("//input[contains(@id,'uxSponsorID')]");
	private static final By BEGIN_SEARCH_BTN = By.xpath("//a[contains(@id,'uxSearchByName')]");
	private static final By SPONSOR_RADIO_BTN = By.xpath("//div[@class='DashRow']/input");
	private static final By TERMS_AND_CONDITION_CHK_BOX_FOR_PC = By.xpath("//input[contains(@id,'uxAgree1')]");
	private static final By CONTINUE_BTN_PREFERRED_AUTOSHIP_SETUP_PAGE_LOC = By.xpath("//div[@id='MyAutoshipItems']/following::input[contains(@id,'uxContinue')]");

	private static final By ADDRESS_NAME_FOR_SHIPPING_PROFILE = By.xpath("//input[contains(@id,'uxAddressName')]");
	private static final By ATTENTION_FIRST_NAME = By.xpath("//td[@class='tdinput']//input[contains(@id,'uxAttentionFirstName')][1]");
	private static final By ATTENTION_LAST_NAME = By.xpath("//td[@class='tdinput']//input[contains(@id,'uxAttentionLastName')][1]");
	private static final By ADDRESS_LINE_1 = By.xpath("//input[contains(@id,'uxAddressLine1')]");
	private static final By ZIP_CODE = By.xpath("//input[contains(@id,'uxZipCode')]");
	private static final By CITY_DD = By.xpath("//input[contains(@id,'uxCityDropDown_Input')]");
	private static final By FIRST_VALUE_OF_CITY_DD = By.xpath("//div[contains(@id,'uxCityDropDown_DropDown')]//ul[@class='rcbList']/li");
	private static final By COUNTRY_DD = By.xpath("//input[contains(@id,'uxCountyDropDown_Input')]");
	private static final By FIRST_VALUE_OF_COUNTRY_DD = By.xpath("//div[contains(@id,'uxCountyDropDown_DropDown')]//ul[@class='rcbList']/li");
	private static final By PHONE_NUMBER_SHIPPING_PROFILE_PAGE = By.xpath("//input[contains(@id,'uxShippingEditor_AppPhone')]");
	private static final By BILLING_NAME_FOR_BILLING_PROFILE = By.xpath("//input[contains(@id,'uxBillingProfileName')]");
	private static final By NAME_ON_CARD = By.xpath("//input[contains(@id,'uxNameOnCard')]");
	private static final By CREDIT_CARD_NUMBER_INPUT_FIELD = By.xpath("//input[contains(@id,'uxCreditCardNumber')]");
	private static final By EXPIRATION_DATE_MONTH_DD = By.xpath("//select[contains(@id,'uxMonthDropDown')]");
	private static final By EXPIRATION_DATE_YEAR_DD = By.xpath("//select[contains(@id,'uxYearDropDown')]");
	private static final By PHONE_NUMBER_BILLING_PROFILE_PAGE = By.xpath("//input[contains(@id,'uxPhone')]");
	private static final By COMPLETE_ENROLLMENT_BTN = By.xpath("//input[contains(@id,'uxComplete')]");
	private static final By WELCOME_TXT_AFTER_ENROLLMENT = By.xpath("//cufontext[contains(text(),'Welcome')]");
	private static final By USERNAME_TXTFLD_LOC = By.id("username");
	private static final By PASSWORD_TXTFLD_LOC = By.id("password");
	private static final By LOGIN_BTN_LOC = By.xpath("//a[@id='loginButton']");
	private static final By CLICK_HERE_LINK_FOR_RC = By.xpath("//a[contains(@id,'RetailLink')]");
	private static final By LOG_OUT_ON_CORP_BTN = By.xpath("//a[text()='Log-Out']");
	private static final By CARRERS_LINK_LOC = By.xpath("//div[@id='LeftNav']//span[text()='Careers']");
	private static final By PRESS_ROOM_LINK_LOC = By.xpath("//div[@id='LeftNav']//span[text()='Press Room']");
	private static final By CONTACT_US_LINK_LOC = By.xpath("//div[@id='LeftNav']//span[text()='Contact Us']");
	private static final By WHO_WE_ARE_LINK_LOC = By.xpath("//div[@id='LeftNav']//span[text()='Who We Are']");
	private static final By PC_PERKS_LINK_LOC = By.xpath("//div[@id='HeaderCol']//span[text()='PC PERKS']");
	private static final By DIGITAL_PRODUCT_LINK_LOC = By.xpath("//div[@id='HeaderCol']//span[text()='Digital Product Catalog']");
	private static final By PRODUCT_PHILOSOPHY_LOC = By.xpath("//span[text()='Product Philosophy']");
	private static final By DIGITAL_PRODUCT_CATALOG_LOC = By.xpath("//span[text()='Digital Product Catalog']");
	private static final By REAL_RESULTS_LINK_LOC = By.xpath("//div[@id='HeaderCol']//span[text()='Real Results']");
	private static final By EXECUTIVE_TEAM_LINK_LOC = By.xpath("//div[@id='LeftNav']//span[text()='Executive Team']");
	private static final By ABOUT_RF_LOC = By.xpath("//span[text()='About R+F']");
	private static final By SOLUTION_TOOL_LINK_LOC = By.xpath("//div[@id='HeaderCol']//span[text()='Solution Tool']");
	private static final By PRIVACY_POLICY_LINK = By.xpath("//span[text()='Privacy Policy']");
	private static final By PRIVACY_POLICY_TEXT = By.xpath("//u[text()='PRIVACY POLICY']");
	private static final By SATISFACTION_GUARANTEE_LINK = By.xpath("//span[text()='Satisfaction Guarantee']");
	private static final By SATISFACTION_GUARANTEE_TEXT = By.xpath("//cufontext[text()='Guarantee']");
	private static final By TERMS_AND_CONDITIONS_LINK = By.xpath("//span[text()='Terms & Conditions']");
	private static final By SOLUTION_TOOL_LOC = By.xpath("//span[text()='Products']/following::li/a/span[text()='Solution Tool']");
	private static final By SOLUTION_TOOL_PAGE_LOC = By.xpath("//div[@id='RFContent']");
	private static final By FIND_RODAN_FIELD_CONSULTANT_LINK_LOC = By.xpath("//div[@id='RFContent']//a[text()='Find a Rodan + Fields Consultant']");
	private static final By SPONSOR_RADIO_BTN_ON_FIND_CONSULTANT_PAGE = By.xpath("//div[@class='DashRow']//input");
	private static final By PWS_TXT_ON_FIND_CONSULTANT_PAGE = By.xpath("//span[contains(text(),'PWS URL')]/a");
	private static final By CHECKOUT_BTN = By.xpath("//span[text()='Checkout']");
	private static final By CLICK_HERE_LINK = By.xpath("//a[text()='Click here']");
	private static final By DETAILS_LINK = By.xpath("//a[text()='Details']");


	public StoreFrontLegacyHomePage(RFWebsiteDriver driver) {
		super(driver);
		// TODO Auto-generated constructor stub
	}

	public void clickBusinessSystemBtn(){
		driver.quickWaitForElementPresent(BUSINESS_SYSTEM_LOC);
		driver.click(BUSINESS_SYSTEM_LOC);
		logger.info("Business system button clicked");
		driver.waitForPageLoad();
	}

	public void clickEnrollNowBtnOnBusinessPage(){
		driver.quickWaitForElementPresent(ENROLL_NOW_ON_BUSINESS_PAGE_LOC);
		driver.click(ENROLL_NOW_ON_BUSINESS_PAGE_LOC);
		logger.info("Enroll Now button on business page is clicked");
		driver.waitForPageLoad();
	}

	public void enterCID(String cid){
		driver.quickWaitForElementPresent(CID_LOC);
		driver.type(CID_LOC, cid);
		logger.info("CID enterd as: "+cid);
		driver.click(CID_SEARCH_LOC);
		logger.info("search button clicked after entering CID");
	}

	public void clickSearchResults(){
		driver.quickWaitForElementPresent(SEARCH_RESULTS_LOC);
		driver.click(SEARCH_RESULTS_LOC);
		logger.info("Search results clicked");
		driver.waitForPageLoad();
	}

	public void selectEnrollmentKit(String kit){
		if(kit.equalsIgnoreCase("Big Business Launch Kit")){
			driver.quickWaitForElementPresent(BIG_BUSINESS_LAUNCH_KIT_LOC);
			driver.click(BIG_BUSINESS_LAUNCH_KIT_LOC);
			logger.info("Big Business Launch Kit is selected");
		}
	}

	public void selectRegimenAndClickNext(String regimen){
		if(regimen.equalsIgnoreCase("Redefine")){
			driver.quickWaitForElementPresent(REDEFINE_REGIMEN_LOC);
			driver.click(REDEFINE_REGIMEN_LOC);
			logger.info("Redefine regimen is selected");
		}
		driver.click(REGIMEN_NEXT_BTN_LOC);
		logger.info("Regimen Next button clicked");
	}

	public void selectEnrollmentType(String enrollmentType){
		if(enrollmentType.equalsIgnoreCase("Express")){
			driver.quickWaitForElementPresent(EXPRESS_ENROLLMENT_LOC);
			driver.click(EXPRESS_ENROLLMENT_LOC);
			logger.info("express enrollment is selected");
		}
		else if(enrollmentType.equalsIgnoreCase("Standard")){
			driver.quickWaitForElementPresent(STANDARD_ENROLLMENT_LOC);
			driver.click(STANDARD_ENROLLMENT_LOC);
			logger.info("standard enrollment is selected");
		}
		driver.click(ENROLLMENT_NEXT_BTN_LOC);
		logger.info("Next button after selecting enrollment type is clicked");
	}

	public void enterSetUpAccountInformation(String firstName,String lastName,String emailAddress,String password,String addressLine1,String postalCode,String phnNumber1,String phnNumber2,String phnNumber3){
		driver.type(ACCOUNT_FIRST_NAME_LOC, firstName);
		logger.info("first name entered as: "+firstName);
		driver.type(ACCOUNT_LAST_NAME_LOC, lastName);
		logger.info("last name entered as: "+lastName);
		driver.type(ACCOUNT_EMAIL_ADDRESS_LOC, emailAddress);
		logger.info("email address entered as: "+emailAddress);
		driver.type(ACCOUNT_PASSWORD_LOC, password);
		logger.info("password entered as: "+password);
		driver.type(ACCOUNT_CONFIRM_PASSWORD_LOC, password);
		logger.info("confirm password entered as: "+password);
		driver.type(ACCOUNT_MAIN_ADDRESS1_LOC, addressLine1);
		logger.info("Main Address Line1 entered as: "+addressLine1);
		driver.type(ACCOUNT_POSTAL_CODE_LOC, postalCode+"\t");
		logger.info("Postal code entered as: "+postalCode);
		driver.type(ACCOUNT_PHONE_NUMBER1_LOC,phnNumber1);
		logger.info("Phone number 1 entered as: "+phnNumber1);
		driver.type(ACCOUNT_PHONE_NUMBER2_LOC,phnNumber2);
		logger.info("Phone number 2 entered as: "+phnNumber2);
		driver.type(ACCOUNT_PHONE_NUMBER3_LOC,phnNumber3);	
		logger.info("Phone number 3 entered as: "+phnNumber3);
	}

	public void clickSetUpAccountNextBtn(){
		driver.click(SETUP_ACCOUNT_NEXT_BTN_LOC);
		logger.info("set up account next button is clicked");
		driver.quickWaitForElementPresent(USE_AS_ENTERED_BTN_LOC);
		driver.findElement(USE_AS_ENTERED_BTN_LOC).click();
		logger.info("use as entered button clicked");
		driver.waitForPageLoad();
	}

	public void enterBillingInformation(String cardNumber,String nameOnCard,String expMonth,String expYear){
		driver.findElement(CARD_NUMBER_LOC).sendKeys(cardNumber);
		logger.info("card number entered is: "+cardNumber);
		driver.findElement(NAME_ON_CARD_LOC).sendKeys(nameOnCard);
		logger.info("name on card entered is: "+nameOnCard);
		Select dropdown1 = new Select(driver.findElement(EXP_MONTH_LOC));
		dropdown1.selectByVisibleText(expMonth);
		logger.info("Exp Month selected as: "+expMonth);
		Select dropdown2 = new Select(driver.findElement(EXP_YEAR_LOC));
		dropdown2.selectByVisibleText(expYear);
		logger.info("Exp Year selected as: "+expYear);
	}

	public void enterAccountInformation(int randomNum1,int randomNum2,int randomNum3,String SSNCardName){
		driver.findElement(SSN1_LOC).sendKeys(String.valueOf(randomNum1));
		logger.info("SSN1 entered as: "+randomNum1);
		driver.findElement(SSN2_LOC).sendKeys(String.valueOf(randomNum2));
		logger.info("SSN2 entered as: "+randomNum2);
		driver.findElement(SSN3_LOC).sendKeys(String.valueOf(randomNum3));
		logger.info("SSN3 entered as: "+randomNum3);
		driver.findElement(SSN_CARD_NAME_LOC).sendKeys(SSNCardName);
		logger.info("SSN card name entered as: "+SSNCardName);
	}

	public void enterPWS(String pws){
		driver.quickWaitForElementPresent(PWS_LOC);
		driver.type(PWS_LOC, pws);
		logger.info("PWS enterd as: "+pws);

	}

	public void clickCompleteAccountNextBtn(){
		driver.waitForElementToBeVisible(PWS_AVAILABLE_MSG_LOC, 30);
		driver.findElement(COMPLETE_ACCOUNT_NEXT_BTN_LOC).click();
		logger.info("complete account next button clicked");
	}

	public void clickTermsAndConditions(){
		driver.findElement(EMAIL_POLICY_AND_PROCEDURE_TOGGLE_BTN_LOC).click();
		logger.info("Email policy and procedure toggle button clicked");
		driver.findElement(ENROLL_SWITCH_POLICY_TOGGLE_BTN_LOC).click();
		logger.info("Enroll switch policy toggle button clicked");
		driver.findElement(ENROLL_TERMS_CONDITIONS_TOGGLE_BTN_LOC).click();
		logger.info("Enroll terms and conditions toggle button clicked");
		driver.findElement(ENROLL_E_SIGN_CONSENT_TOGGLE_BTN_LOC).click();
		logger.info("Enroll e sign consent toggle button clicked");
	}

	public void chargeMyCardAndEnrollMe(){
		driver.quickWaitForElementPresent(CHARGE_AND_ENROLL_ME_BTN_LOC);
		driver.click(CHARGE_AND_ENROLL_ME_BTN_LOC);
		logger.info("Charge and enroll me button clicked");
		driver.pauseExecutionFor(2000);
		driver.quickWaitForElementPresent(CONFIRM_AUTOSHIP_BTN_LOC);
		driver.click(CONFIRM_AUTOSHIP_BTN_LOC);
		logger.info("Confirm autoship button clicked");
		driver.waitForPageLoad();
	}

	public boolean isCongratulationsMessageAppeared(){
		driver.quickWaitForElementPresent(CONGRATS_MSG_LOC);
		return driver.isElementPresent(CONGRATS_MSG_LOC);
	}

	public void clickYesSubscribeToPulseNow() {
		driver.waitForElementPresent(SUBSCRIBE_TO_PULSE_TOGGLE_BTN_LOC);
		driver.click(SUBSCRIBE_TO_PULSE_TOGGLE_BTN_LOC);
		logger.info("subscribe to pulse now option clicked By yes");

	}

	public void clickYesEnrollInCRPNow() {
		driver.waitForElementPresent(ENROLL_IN_CRP_TOGGLE_BTN_LOC);
		driver.click(ENROLL_IN_CRP_TOGGLE_BTN_LOC);
		logger.info("Enroll in CRP now option clicked By yes");		  
	}

	public void clickAutoShipOptionsNextBtn() {
		driver.waitForElementPresent(AUTOSHIP_OPTIONS_NEXT_BTN_LOC);
		driver.click(AUTOSHIP_OPTIONS_NEXT_BTN_LOC);
		logger.info("Autoships options next step button clicked");		  
	}

	public void selectProductToAddToCart() {
		driver.waitForElementPresent(ADD_TO_CART_BTN_LOC);
		driver.click(ADD_TO_CART_BTN_LOC);
		logger.info("Add to cart button clicked");		  
	}

	public void clickYourCRPOrderPopUpNextBtn() {
		driver.waitForElementPresent(YOUR_CRP_ORDER_POPUP_NEXT_BTN_LOC);
		driver.click(YOUR_CRP_ORDER_POPUP_NEXT_BTN_LOC);
		logger.info("Your crp order popup next btn clicked");		  
	}

	public void clickBillingInfoNextBtn(){
		driver.findElement(COMPLETE_ACCOUNT_NEXT_BTN_LOC).click();
		logger.info("standard enrollment complete account next button clicked");
	}

	public void openBizPWS(String pws){
		driver.get(pws);
		driver.waitForPageLoad();
		logger.info("page redirected to biz PWS");
	}

	public void clickEnrollNowBtnOnbizPWSPage(){
		driver.quickWaitForElementPresent(ENROLL_NOW_ON_BIZ_PWS_PAGE_LOC);
		driver.click(ENROLL_NOW_ON_BIZ_PWS_PAGE_LOC);
		logger.info("Enroll Now button on biz PWS page is clicked");
		driver.waitForPageLoad();
	}

	public void clickEnrollNowBtnOnWhyRFPage(){
		driver.quickWaitForElementPresent(ENROLL_NOW_ON_WHY_RF_PAGE_LOC);
		driver.click(ENROLL_NOW_ON_WHY_RF_PAGE_LOC);
		logger.info("Enroll Now button on Why RF page is clicked");
		driver.waitForPageLoad();
	}

	public void clickOnRodanAndFieldsLogo(){
		driver.quickWaitForElementPresent(RODAN_AND_FIELDS_IMG_LOC);
		driver.click(RODAN_AND_FIELDS_IMG_LOC);
		logger.info("Rodan and Fields logo clicked"); 
		driver.waitForPageLoad();
	}

	public void logOut(){
		driver.quickWaitForElementPresent(LOGOUT_LOC);
		driver.click(LOGOUT_LOC);
		logger.info("Log Out Link clicked"); 
		driver.waitForPageLoad();
	}

	public boolean validateExistingConsultantPopUp(String emailAddress){
		driver.quickWaitForElementPresent(EXISTING_CONSULTANT_LOC);
		driver.type(ACCOUNT_EMAIL_ADDRESS_LOC, emailAddress);
		logger.info("email address entered as: "+emailAddress);
		driver.type(ACCOUNT_PASSWORD_LOC, "");
		logger.info("password entered as: "+"");
		return driver.isElementPresent(EXISTING_CONSULTANT_LOC);
	}

	public StoreFrontLegacyConsultantPage loginAsConsultant(String userName, String password) {
		driver.waitForElementPresent(USERNAME_TEXT_BOX_LOC);
		driver.type(USERNAME_TEXT_BOX_LOC, userName);
		logger.info("Entered Username is: "+userName);
		driver.click(PASSWORD_TXTFLD_ONFOCUS_LOC);
		driver.type(PASSWORD_TEXT_BOX_LOC, password);
		logger.info("Entered Password is: "+password);
		driver.click(ENTER_LOGIN_BTN_LOC);
		logger.info("login  enter button clicked");
		driver.waitForPageLoad();
		return new StoreFrontLegacyConsultantPage(driver);
	}

	public void selectRegimen(String regimen){
		regimen = regimen.toUpperCase();
		driver.quickWaitForElementPresent(By.xpath(String.format(regimenLoc, regimen)));
		driver.click(By.xpath(String.format(regimenLoc, regimen)));
		logger.info("Regimen selected is: "+regimen);
	}

	public void clickAddToCartBtn(){
		driver.quickWaitForElementPresent(ADD_TO_CART_BTN);
		driver.click(ADD_TO_CART_BTN);
		logger.info("Add to cart button clicked");
		driver.waitForPageLoad();
	}

	public void clickClickHereLinkForPC(){
		driver.quickWaitForElementPresent(CLICK_HERE_LINK_FOR_PC);
		driver.click(CLICK_HERE_LINK_FOR_PC);
		logger.info("Click here link clicked for PC enrollment");
		driver.waitForPageLoad();
	}

	public void clickEnrollNowBtnForPCAndRC(){
		driver.quickWaitForElementPresent(ENROLL_NOW_FOR_PC_AND_RC);
		driver.click(ENROLL_NOW_FOR_PC_AND_RC);
		logger.info("Enroll now button clicked");
		driver.waitForPageLoad();
	}

	public void enterProfileDetailsForPCAndRC(String firstName,String lastName,String emailAddress,String password,String phnNumber,String gender){
		driver.type(FIRST_NAME_FOR_PC_AND_RC, firstName);
		logger.info("first name entered as: "+firstName);
		driver.type(LAST_NAME_FOR_PC_AND_RC, lastName);
		logger.info("last name entered as: "+lastName);
		driver.type(EMAIL_ADDRESS_FOR_PC_AND_RC, emailAddress);
		logger.info("email address entered as: "+emailAddress);
		driver.type(CREATE_PASSWORD_FOR_PC_AND_RC, password);
		logger.info("password entered as: "+password);
		driver.type(CONFIRM_PASSWORD_FOR_PC_AND_RC, password);
		logger.info("confirm password entered as: "+password);
		driver.type(PHONE_NUMBER_FOR_PC_AND_RC,phnNumber);
		logger.info("Phone number entered as: "+phnNumber);
		driver.click(By.xpath(String.format(genderLocForPCAndRC, gender)));
		logger.info("Gender selected is: "+gender);
	}

	public void clickContinueBtnForPCAndRC(){
		driver.quickWaitForElementPresent(CONTINUE_BTN_PREFERRED_PROFILE_PAGE_LOC);
		driver.click(CONTINUE_BTN_PREFERRED_PROFILE_PAGE_LOC);
		logger.info("Continue button clicked");
		driver.waitForPageLoad();
	}

	public void enterIDNumberAsSponsorForPCAndRC(String sponsorID){
		driver.quickWaitForElementPresent(ID_NUMBER_AS_SPONSOR);
		driver.type(ID_NUMBER_AS_SPONSOR, sponsorID);
		logger.info("Sponsor ID entered is: "+sponsorID);
	}

	public void clickBeginSearchBtn(){
		driver.quickWaitForElementPresent(BEGIN_SEARCH_BTN);
		driver.click(BEGIN_SEARCH_BTN);
		logger.info("Begin search button clicked");
	}

	public void selectSponsorRadioBtn(){
		driver.quickWaitForElementPresent(SPONSOR_RADIO_BTN);
		driver.click(SPONSOR_RADIO_BTN);
		logger.info("Radio button of sponsor is selected");
	}

	public void clickSelectAndContinueBtnForPCAndRC(){
		driver.quickWaitForElementPresent(CONTINUE_BTN_PREFERRED_PROFILE_PAGE_LOC);
		driver.click(CONTINUE_BTN_PREFERRED_PROFILE_PAGE_LOC);
		logger.info("Select and Continue button clicked");
		driver.waitForPageLoad();
	}

	public void checkTermsAndConditionChkBoxForPCAndRC(){
		driver.quickWaitForElementPresent(TERMS_AND_CONDITION_CHK_BOX_FOR_PC);
		driver.click(TERMS_AND_CONDITION_CHK_BOX_FOR_PC);
		logger.info("Terms & condition checkbox checked");
	}

	public void clickContinueBtnOnAutoshipSetupPageForPC(){
		driver.quickWaitForElementPresent(CONTINUE_BTN_PREFERRED_AUTOSHIP_SETUP_PAGE_LOC);
		driver.click(CONTINUE_BTN_PREFERRED_AUTOSHIP_SETUP_PAGE_LOC);
		logger.info("Continue button clicked on Autoship setup page");
		driver.waitForPageLoad();
	}


	public void enterShippingProfileDetails(String addressName, String firstName,String lastName,String addressLine1,String postalCode,String phnNumber){
		driver.type(ADDRESS_NAME_FOR_SHIPPING_PROFILE, addressName);
		logger.info("Address name entered as: "+addressName);
		driver.type(ATTENTION_FIRST_NAME, firstName);
		logger.info("Attention first name entered as: "+firstName);
		driver.type(ATTENTION_LAST_NAME, lastName);
		logger.info("Attention last name entered as: "+lastName);
		driver.type(ADDRESS_LINE_1, addressLine1);
		logger.info("Address line 1 entered as: "+addressLine1);
		driver.type(ZIP_CODE, postalCode+"\t");
		driver.waitForStorfrontLegacyLoadingImageToDisappear();
		logger.info("Postal code entered as: "+postalCode);
		driver.click(CITY_DD);
		logger.info("City dropdown clicked");
		driver.click(FIRST_VALUE_OF_CITY_DD);
		logger.info("City selected");
		driver.waitForElementPresent(COUNTRY_DD);
		driver.click(COUNTRY_DD);
		logger.info("Country dropdown clicked");
		driver.click(FIRST_VALUE_OF_COUNTRY_DD);
		logger.info("Country selected");
		driver.type(PHONE_NUMBER_SHIPPING_PROFILE_PAGE,phnNumber);
		logger.info("Phone number entered as: "+phnNumber);
	}

	public void enterBillingInfoDetails(String billingName, String firstName,String lastName,String cardName,String cardNumer,String month,String year,String addressLine1,String postalCode,String phnNumber){
		driver.type(BILLING_NAME_FOR_BILLING_PROFILE, billingName);
		logger.info("Billing profile name entered as: "+billingName);
		driver.type(ATTENTION_FIRST_NAME, firstName);
		logger.info("Attention first name entered as: "+firstName);
		driver.type(ATTENTION_LAST_NAME, lastName);
		logger.info("Attention last name entered as: "+lastName);
		driver.type(NAME_ON_CARD, cardName);
		logger.info("Card Name entered as: "+cardName);
		driver.type(CREDIT_CARD_NUMBER_INPUT_FIELD, cardNumer);
		logger.info("Card number entered as: "+cardNumer);
		driver.click(EXPIRATION_DATE_MONTH_DD);
		logger.info("Expiration month dropdown clicked");
		driver.click(By.xpath(String.format(expiryMonthLoc, month)));
		logger.info("Expiry month selected is: "+month);
		driver.click(EXPIRATION_DATE_YEAR_DD);
		logger.info("Expiration year dropdown clicked");
		driver.click(By.xpath(String.format(expiryYearLoc, year)));
		logger.info("Expiry year selected is: "+year);
		driver.type(ADDRESS_LINE_1, addressLine1);
		logger.info("Billing street address entered as: "+addressLine1);
		driver.type(ZIP_CODE, postalCode+"\t");
		logger.info("Postal code entered as: "+postalCode);
		driver.waitForStorfrontLegacyLoadingImageToDisappear();
		driver.click(CITY_DD);
		logger.info("City dropdown clicked");
		driver.click(FIRST_VALUE_OF_CITY_DD);
		logger.info("City selected");
		driver.type(PHONE_NUMBER_BILLING_PROFILE_PAGE,phnNumber);
		logger.info("Phone number entered as: "+phnNumber);
	}

	public void clickCompleteEnrollmentBtn(){
		driver.quickWaitForElementPresent(COMPLETE_ENROLLMENT_BTN);
		driver.click(COMPLETE_ENROLLMENT_BTN);
		logger.info("Complete enrollmet button clicked");
		driver.waitForPageLoad();
	}

	public void clickOKBtnOfJavaScriptPopUp(){
		Alert alert = driver.switchTo().alert();
		alert.accept();
		logger.info("Ok button of java Script popup is clicked.");
		driver.waitForPageLoad();
	}

	public void clickUseAsEnteredBtn(){
		driver.quickWaitForElementPresent(USE_AS_ENTERED_BTN_LOC);
		driver.findElement(USE_AS_ENTERED_BTN_LOC).click();
		logger.info("use as entered button clicked");
		driver.waitForPageLoad();
	}

	public boolean isEnrollmentCompletedSuccessfully(){
		driver.quickWaitForElementPresent(WELCOME_TXT_AFTER_ENROLLMENT);
		return driver.isElementPresent(WELCOME_TXT_AFTER_ENROLLMENT);
	}

	public void loginAsPCUser(String username,String password){
		driver.waitForElementPresent(USERNAME_TXTFLD_LOC);
		driver.type(USERNAME_TXTFLD_LOC, username);
		driver.click(PASSWORD_TXTFLD_ONFOCUS_LOC);
		driver.type(PASSWORD_TXTFLD_LOC,password);  
		logger.info("login username is "+username);
		logger.info("login password is "+password);
		driver.click(LOGIN_BTN_LOC);
		logger.info("login button clicked");
		driver.waitForPageLoad();		
	}

	public void loginAsRCUser(String username,String password){
		driver.waitForElementPresent(USERNAME_TXTFLD_LOC);
		driver.type(USERNAME_TXTFLD_LOC, username);
		driver.click(PASSWORD_TXTFLD_ONFOCUS_LOC);
		driver.type(PASSWORD_TXTFLD_LOC,password);  
		logger.info("login username is "+username);
		logger.info("login password is "+password);
		driver.click(LOGIN_BTN_LOC);
		logger.info("login button clicked");
		driver.waitForPageLoad();
	}

	public void clickClickHereLinkForRC(){
		driver.quickWaitForElementPresent(CLICK_HERE_LINK_FOR_RC);
		driver.click(CLICK_HERE_LINK_FOR_RC);
		logger.info("Click here link for RC User is clicked.");
		driver.waitForPageLoad();
	}

	public void clickCreateMyAccountBtnOnCreateRetailAccountPage(){
		driver.quickWaitForElementPresent(CONTINUE_BTN_PREFERRED_PROFILE_PAGE_LOC);
		driver.click(CONTINUE_BTN_PREFERRED_PROFILE_PAGE_LOC);
		logger.info("Create my account button clicked");
		driver.waitForPageLoad();
	}

	public String getJavaScriptPopUpText(){
		Alert alert = driver.switchTo().alert();
		String alertTxt=alert.getText();
		logger.info("Txt From java Script popup is "+alertTxt);
		return alertTxt;
	}

	public boolean verifyUserSuccessfullyLoggedInOnCorpSite() {
		driver.waitForElementPresent(LOG_OUT_ON_CORP_BTN);
		if(driver.isElementPresent(LOG_OUT_ON_CORP_BTN)){
			logger.info("User Successfully Logged In");
			return true;
		}else return false;
	}

	public void selectBusinessPortfolioEnrollmentKit(){
		driver.quickWaitForElementPresent(BUSINESS_PORTFOLIO_KIT_LOC);
		driver.click(BUSINESS_PORTFOLIO_KIT_LOC);
		logger.info("Business Portfolio Kit is selected");
	}

	public void clickNextBtnOnSelectEnrollmentKitPage(){
		driver.quickWaitForElementPresent(SELECT_ENROLLMENT_KIT_NEXT_BTN_LOC);
		driver.click(SELECT_ENROLLMENT_KIT_NEXT_BTN_LOC);
		logger.info("Business Portfolio Kit is selected");
		driver.waitForPageLoad();
	}

	public void clickAccountInformationNextBtn(){
		driver.quickWaitForElementPresent(ACCOUNT_INFORMATION_NEXT_BTN);
		driver.click(ACCOUNT_INFORMATION_NEXT_BTN);
		logger.info("Account Information Next button clicked");
		driver.waitForPageLoad();
	}

	public void clickChargeMyCardAndEnrollMeWithOutConfirmAutoship(){
		driver.quickWaitForElementPresent(CHARGE_AND_ENROLL_ME_BTN_LOC);
		driver.click(CHARGE_AND_ENROLL_ME_BTN_LOC);
		logger.info("Charge and enroll me button clicked");
		driver.pauseExecutionFor(2000);
		driver.waitForPageLoad();
	}

	public void clickSubSectionUnderRegimen(String regimenHeader){
		driver.quickWaitForElementPresent(By.xpath(String.format(regimenHeaderLoc, regimenHeader)));
		driver.click(By.xpath(String.format(regimenHeaderLoc, regimenHeader)));
		logger.info("Regimen selected is: "+regimenHeader);
	}

	public boolean verifyUserIsRedirectedToProductsPage() {
		driver.waitForElementPresent(PRODUCTS_LIST_LOC);
		return driver.isElementPresent(PRODUCTS_LIST_LOC); 
	}

	public boolean verifyUserIsRedirectedToResultsPage() {
		driver.waitForElementPresent(RESULTS_TEXT_LOC);
		return driver.isElementPresent(RESULTS_TEXT_LOC); 
	}

	public boolean verifyUserIsRedirectedToTestimonialsPage() {
		// TODO Auto-generated method stub
		driver.waitForElementPresent(TESTIMONIAL_PAGE_CONTENT_LOC);
		return driver.isElementPresent(TESTIMONIAL_PAGE_CONTENT_LOC);
	}

	public boolean verifyUserIsRedirectedToNewsPage() {
		driver.waitForElementPresent(NEWS_TEXT_LOC);
		return driver.isElementPresent(NEWS_TEXT_LOC);
	}

	public boolean verifyUserIsRedirectedToFAQsPage() {
		driver.waitForElementPresent(FAQS_TEXT_LOC);
		return driver.isElementPresent(FAQS_TEXT_LOC);
	}

	public boolean verifyUserIsRedirectedToAdvicePage() {
		driver.waitForElementPresent(ADVICE_PAGE_CONTENT_LOC);
		return driver.isElementPresent(ADVICE_PAGE_CONTENT_LOC);
	}

	public boolean verifyUserIsRedirectedToGlossaryPage() {
		driver.waitForElementPresent(GLOSSARY_PAGE_CONTENT_LOC);
		return driver.isElementPresent(GLOSSARY_PAGE_CONTENT_LOC);
	}

	public void clickIngredientsAndUsageLink() {
		driver.waitForElementPresent(INGREDIENTS_AND_USAGE_LINK_LOC);
		driver.click(INGREDIENTS_AND_USAGE_LINK_LOC);
		logger.info("INGREDIENTS AND USAGE LINK CLICKED");
	}

	public boolean verifyIngredientsAndUsageInfoVisible() {
		driver.waitForElementPresent(INGREDIENTS_CONTENT_LOC);
		return driver.IsElementVisible(driver.findElement(INGREDIENTS_CONTENT_LOC));

	}

	public void clickContactUsAtFooter() {
		driver.waitForElementPresent(FOOTER_CONTACT_US_LINK_LOC);
		driver.click(FOOTER_CONTACT_US_LINK_LOC);
		logger.info("contact us link is clicked");
	}

	public boolean verifylinkIsRedirectedToContactUsPage() {
		driver.waitForElementPresent(CONTACT_US_PAGE_HEADER_LOC);
		return driver.isElementPresent(CONTACT_US_PAGE_HEADER_LOC);
	}

	public void clickProductPhilosophyLink(){
		driver.quickWaitForElementPresent(PRODUCT_PHILOSOPHY_LOC);
		driver.click(PRODUCT_PHILOSOPHY_LOC);
		logger.info("Product Philosophy Link clicked");
		driver.waitForPageLoad();
	}

	public void clickDigitalProductCatalogLink(){
		driver.quickWaitForElementPresent(DIGITAL_PRODUCT_CATALOG_LOC);
		driver.click(DIGITAL_PRODUCT_CATALOG_LOC);
		logger.info("Digital Product Catalog Link clicked");
		driver.waitForPageLoad();
	}

	public boolean validateProductPhilosohyPageDisplayed(){
		return driver.getCurrentUrl().contains("Products/Philosophy");
	}

	public boolean validateRealResultsLink(){
		driver.quickWaitForElementPresent(REAL_RESULTS_LINK_LOC);
		driver.click(REAL_RESULTS_LINK_LOC);
		logger.info("Real Results Link clicked");
		driver.waitForPageLoad();
		boolean status= driver.getCurrentUrl().contains("Results");
		driver.navigate().back();
		return status;
	}

	public boolean validateExecutiveTeamLinkPresent(){
		driver.quickWaitForElementPresent(EXECUTIVE_TEAM_LINK_LOC);
		return driver.isElementPresent(EXECUTIVE_TEAM_LINK_LOC);
	}

	public boolean validateExecuteTeamLink(){
		driver.quickWaitForElementPresent(EXECUTIVE_TEAM_LINK_LOC);
		driver.click(EXECUTIVE_TEAM_LINK_LOC);
		logger.info("Execute Team Link clicked");
		driver.waitForPageLoad();
		return driver.getCurrentUrl().contains("Executives");
	}

	public boolean validateCareersLinkPresent(){
		driver.quickWaitForElementPresent(CARRERS_LINK_LOC);
		return driver.isElementPresent(CARRERS_LINK_LOC);
	}

	public boolean validateContactUsLinkPresent(){
		driver.quickWaitForElementPresent(CONTACT_US_LINK_LOC);
		return driver.isElementPresent(CONTACT_US_LINK_LOC);
	}

	public boolean validateWhoWeAreLinkPresent(){
		driver.quickWaitForElementPresent(WHO_WE_ARE_LINK_LOC);
		return driver.isElementPresent(WHO_WE_ARE_LINK_LOC);
	}

	public boolean validatePressRoomLinkPresent(){
		driver.quickWaitForElementPresent(PRESS_ROOM_LINK_LOC);
		return driver.isElementPresent(PRESS_ROOM_LINK_LOC);
	}

	public boolean validateSolutionToolLink(){
		driver.quickWaitForElementPresent(SOLUTION_TOOL_LINK_LOC);
		driver.click(SOLUTION_TOOL_LINK_LOC);
		logger.info("Solution Tool Link clicked");
		driver.waitForPageLoad();
		boolean status= driver.getCurrentUrl().contains("SolutionTool");
		driver.navigate().back();
		return status;
	}

	public boolean validatePCPerksLink(){
		driver.quickWaitForElementPresent(PC_PERKS_LINK_LOC);
		driver.click(PC_PERKS_LINK_LOC);
		logger.info("PC Perks Link clicked");
		driver.waitForPageLoad();
		boolean status= driver.getCurrentUrl().contains("PCPerks");
		driver.navigate().back();
		return status;
	}

	public boolean validateDigitalProductCatalogLink(){
		driver.quickWaitForElementPresent(DIGITAL_PRODUCT_LINK_LOC);
		driver.click(DIGITAL_PRODUCT_LINK_LOC);
		logger.info("Digital Product Link clicked");
		driver.waitForPageLoad();
		boolean status= driver.getCurrentUrl().contains("Digimag");
		driver.navigate().back();
		return status;
	}

	public void clickAboutRFBtn(){
		driver.quickWaitForElementPresent(ABOUT_RF_LOC);
		driver.click(ABOUT_RF_LOC);
		logger.info("About RF button clicked");
		driver.waitForPageLoad();
	}

	public void clickPrivacyPolicyLink(){
		driver.quickWaitForElementPresent(PRIVACY_POLICY_LINK);
		driver.click(PRIVACY_POLICY_LINK);
		logger.info("Privacy policy link clicked");
		driver.waitForPageLoad();
	}

	public boolean isPrivacyPolicyPagePresent(){
		driver.quickWaitForElementPresent(PRIVACY_POLICY_TEXT);
		return driver.isElementPresent(PRIVACY_POLICY_TEXT);
	}

	public void clickSatisfactionGuaranteeLink(){
		driver.quickWaitForElementPresent(SATISFACTION_GUARANTEE_LINK);
		driver.click(SATISFACTION_GUARANTEE_LINK);
		logger.info("Satisfaction guarantee link clicked");
		driver.waitForPageLoad();
	}

	public boolean isSatisfactionGuaranteePagePresent(){
		driver.quickWaitForElementPresent(SATISFACTION_GUARANTEE_TEXT);
		return driver.isElementPresent(SATISFACTION_GUARANTEE_TEXT);
	}

	public void selectPromotionRegimen(){
		String regimen = "Promotions";
		driver.quickWaitForElementPresent(By.xpath(String.format(regimenLoc, regimen)));
		driver.click(By.xpath(String.format(regimenLoc, regimen)));
		logger.info("Regimen selected is: "+regimen);
	}

	public boolean isRegimenNamePresentAfterClickedOnRegimen(String regimen){
		regimen = regimen.toUpperCase();
		driver.quickWaitForElementPresent(By.xpath(String.format(regimenNameLoc, regimen)));
		return driver.isElementPresent(By.xpath(String.format(regimenNameLoc, regimen)));
	}

	public void clickTermsAndConditionsLink(){
		driver.quickWaitForElementPresent(TERMS_AND_CONDITIONS_LINK);
		driver.click(TERMS_AND_CONDITIONS_LINK);
		logger.info("Terms & Conditions link clicked");
		driver.waitForPageLoad();
	}

	public void clickSolutionToolUnderProduct(){
		driver.quickWaitForElementPresent(SOLUTION_TOOL_LOC);
		driver.click(SOLUTION_TOOL_LOC);
		logger.info("Solution tool clicked under product tab button");
		driver.waitForPageLoad();
	}

	public boolean verifySolutionToolPage(){
		driver.quickWaitForElementPresent(SOLUTION_TOOL_PAGE_LOC);
		return driver.isElementPresent(SOLUTION_TOOL_PAGE_LOC);
	}

	public void clickFindRodanFieldConsultantLink(){
		driver.quickWaitForElementPresent(FIND_RODAN_FIELD_CONSULTANT_LINK_LOC);
		driver.click(FIND_RODAN_FIELD_CONSULTANT_LINK_LOC);
		logger.info("Find rodan and fields consultant link is clicked.");
		driver.waitForPageLoad();
	}

	public void selectSponsorRadioBtnOnFindConsultantPage(){
		driver.quickWaitForElementPresent(SPONSOR_RADIO_BTN_ON_FIND_CONSULTANT_PAGE);
		driver.click(SPONSOR_RADIO_BTN_ON_FIND_CONSULTANT_PAGE);
		logger.info("Radio button of sponsor is selected");
	}

	public String getPWSFromFindConsultantPage(){
		driver.quickWaitForElementPresent(PWS_TXT_ON_FIND_CONSULTANT_PAGE);
		String fetchPWS=driver.findElement(PWS_TXT_ON_FIND_CONSULTANT_PAGE).getText();
		logger.info("Fetched PWS from find a consultant page is"+fetchPWS);
		return fetchPWS;
	}

	public boolean verifyRedefineRegimenSections(String sublinkName){
		driver.quickWaitForElementPresent(By.xpath(String.format(redefineRegimenSubLinks, sublinkName)));
		return driver.IsElementVisible(driver.findElement(By.xpath(String.format(redefineRegimenSubLinks, sublinkName))));
	}

	public boolean verifyAddToCartButton() {
		driver.quickWaitForElementPresent(ADD_TO_CART_BTN);
		return driver.isElementPresent(ADD_TO_CART_BTN);
	}

	public boolean verifyCheckoutBtnOnMyShoppingCart() {
		driver.quickWaitForElementPresent(CHECKOUT_BTN);
		return driver.isElementPresent(CHECKOUT_BTN);
	}

	public void clickClickhereLink(){
		driver.quickWaitForElementPresent(CLICK_HERE_LINK);
		driver.click(CLICK_HERE_LINK);
		logger.info("Clicke here link clicked");
		driver.waitForPageLoad();
	}

	public boolean isClickHereLinkRedirectinToAppropriatePage(String redirectedPageLink){
		driver.waitForPageLoad();
		Set<String> set=driver.getWindowHandles();
		Iterator<String> it=set.iterator();
		String parentWindow=it.next();
		String childWindow=it.next();
		driver.switchTo().window(childWindow);
		boolean status= driver.getCurrentUrl().contains(redirectedPageLink);
		driver.close();
		driver.switchTo().window(parentWindow);
		return status;
	}

	public void clickDetailsLink(){
		driver.quickWaitForElementPresent(DETAILS_LINK);
		driver.click(DETAILS_LINK);
		logger.info("Details link clicked");
		driver.waitForPageLoad();
	}
}