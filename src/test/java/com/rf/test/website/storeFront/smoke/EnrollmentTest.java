package com.rf.test.website.storeFront.smoke;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.testng.annotations.Test;

import com.rf.core.utils.CommonUtils;
import com.rf.core.utils.DBUtil;
import com.rf.core.website.constants.TestConstants;
import com.rf.core.website.constants.dbQueries.DBQueries_RFO;
import com.rf.pages.website.StoreFrontAccountInfoPage;
import com.rf.pages.website.StoreFrontAccountTerminationPage;
import com.rf.pages.website.StoreFrontBillingInfoPage;
import com.rf.pages.website.StoreFrontCartAutoShipPage;
import com.rf.pages.website.StoreFrontConsultantPage;
import com.rf.pages.website.StoreFrontHomePage;
import com.rf.pages.website.StoreFrontOrdersPage;
import com.rf.pages.website.StoreFrontPCUserPage;
import com.rf.pages.website.StoreFrontUpdateCartPage;
import com.rf.test.website.RFWebsiteBaseTest;


public class EnrollmentTest extends RFWebsiteBaseTest{
	private static final Logger logger = LogManager
			.getLogger(EnrollmentTest.class.getName());

	private StoreFrontHomePage storeFrontHomePage;
	private StoreFrontConsultantPage storeFrontConsultantPage;
	private StoreFrontAccountInfoPage storeFrontAccountInfoPage;
	private StoreFrontUpdateCartPage storeFrontUpdateCartPage;
	private StoreFrontPCUserPage storeFrontPCUserPage;
	private StoreFrontOrdersPage storeFrontOrdersPage;
	private StoreFrontAccountTerminationPage storeFrontAccountTerminationPage;
	private StoreFrontBillingInfoPage storeFrontBillingInfoPage;
	private StoreFrontCartAutoShipPage storeFrontCartAutoShipPage;
	private String RFO_DB = null;
	private String kitName = null;
	private String regimenName = null;
	private String enrollmentType = null;
	private String addressLine1 = null;
	private String city = null;
	private String postalCode = null;
	private String phoneNumber = null;
	private String country = null;
	private String env = null;

	// Test Case Hybris Project-1307 :: Version : 1 :: 2. RC EnrollmentTest 
	@Test
	public void testRCEnrollment_1307() throws InterruptedException{
		int randomNum = CommonUtils.getRandomNum(10000, 1000000);
		String newBillingProfileName = TestConstants.NEW_BILLING_PROFILE_NAME+randomNum;
		String firstName=TestConstants.FIRST_NAME+randomNum;
		String lastName = "lN";
		storeFrontHomePage = new StoreFrontHomePage(driver);
		// Click on our product link that is located at the top of the page and then click in on quick shop
		/*storeFrontHomePage.clickOnShopLink();
			storeFrontHomePage.clickOnAllProductsLink();*/
		storeFrontHomePage.hoverOnShopLinkAndClickAllProductsLinks();

		// Products are displayed?
		s_assert.assertTrue(storeFrontHomePage.areProductsDisplayed(), "quickshop products not displayed");
		logger.info("Quick shop products are displayed");

		//Select a product and proceed to buy it
		storeFrontHomePage.selectProductAndProceedToBuy();

		//Cart page is displayed?
		s_assert.assertTrue(storeFrontHomePage.isCartPageDisplayed(), "Cart page is not displayed");
		logger.info("Cart page is displayed");

		//In the Cart page add one more product
		storeFrontHomePage.addAnotherProduct();

		//Two products are in the Shopping Cart?
		s_assert.assertTrue(storeFrontHomePage.verifyNumberOfProductsInCart("2"), "number of products in the cart is NOT 2");
		logger.info("2 products are successfully added to the cart");

		//Click on Check out
		storeFrontHomePage.clickOnCheckoutButton();

		//Log in or create an account page is displayed?
		s_assert.assertTrue(storeFrontHomePage.isLoginOrCreateAccountPageDisplayed(), "Login or Create Account page is NOT displayed");
		logger.info("Login or Create Account page is displayed");

		//Enter the User information and DO NOT check the "Become a Preferred Customer" checkbox and click the create account button
		storeFrontHomePage.enterNewRCDetails(firstName, TestConstants.LAST_NAME+randomNum, password);

		/*//CheckoutPage is displayed?
			s_assert.assertTrue(storeFrontHomePage.isCheckoutPageDisplayed(), "Checkout page has NOT displayed");
			logger.info("Checkout page has displayed");*/

		//Enter the Main account info and DO NOT check the "Become a Preferred Customer" and click next
		storeFrontHomePage.enterMainAccountInfo();
		logger.info("Main account details entered");

		storeFrontHomePage.clickOnContinueWithoutSponsorLink();
		storeFrontHomePage.clickOnNextButtonAfterSelectingSponsor();

		storeFrontHomePage.clickOnShippingAddressNextStepBtn();
		//Enter Billing Profile
		storeFrontHomePage.enterNewBillingCardNumber(TestConstants.CARD_NUMBER);
		storeFrontHomePage.enterNewBillingNameOnCard(newBillingProfileName+" "+lastName);
		storeFrontHomePage.selectNewBillingCardExpirationDate();
		storeFrontHomePage.enterNewBillingSecurityCode(TestConstants.SECURITY_CODE);
		storeFrontHomePage.selectNewBillingCardAddress();
		storeFrontHomePage.clickOnSaveBillingProfile();
		storeFrontHomePage.clickOnBillingNextStepBtn();
		storeFrontHomePage.clickPlaceOrderBtn();
		s_assert.assertTrue(storeFrontHomePage.isOrderPlacedSuccessfully(), "Order Not placed successfully");
		s_assert.assertTrue(storeFrontHomePage.verifyWelcomeDropdownToCheckUserRegistered(), "User NOT registered successfully");
		//s_assert.assertTrue(storeFrontHomePage.getUserNameAForVerifyLogin(firstName).contains(firstName),"Profile Name After Login"+firstName+" and on UI is "+storeFrontHomePage.getUserNameAForVerifyLogin(firstName));
		s_assert.assertAll();	

	}

	// Test Case Hybris Project-1308 :: Version : 1 :: 1. PC EnrollmentTest  
	@Test
	public void testPCEnrollment_1308() throws InterruptedException{
		int randomNum = CommonUtils.getRandomNum(10000, 1000000);		
		String newBillingProfileName = TestConstants.NEW_BILLING_PROFILE_NAME+randomNum;
		String lastName = "lN";
		country = driver.getCountry();
		storeFrontHomePage = new StoreFrontHomePage(driver);
		String firstName=TestConstants.FIRST_NAME+randomNum;
		// Click on our product link that is located at the top of the page and then click in on quick shop
		/*storeFrontHomePage.clickOnShopLink();
			storeFrontHomePage.clickOnAllProductsLink();*/
		storeFrontHomePage.hoverOnShopLinkAndClickAllProductsLinks();

		// Products are displayed?
		s_assert.assertTrue(storeFrontHomePage.areProductsDisplayed(), "quickshop products not displayed");
		logger.info("Quick shop products are displayed");

		//Select a product with the price less than $80 and proceed to buy it
		storeFrontHomePage.applyPriceFilterLowToHigh();
		storeFrontHomePage.selectProductAndProceedToBuy();

		//Cart page is displayed?
		s_assert.assertTrue(storeFrontHomePage.isCartPageDisplayed(), "Cart page is not displayed");
		logger.info("Cart page is displayed");

		//1 product is in the Shopping Cart?
		s_assert.assertTrue(storeFrontHomePage.verifyNumberOfProductsInCart("1"), "number of products in the cart is NOT 1");
		logger.info("1 product is successfully added to the cart");

		//Click on Check out
		storeFrontHomePage.clickOnCheckoutButton();

		//Log in or create an account page is displayed?
		s_assert.assertTrue(storeFrontHomePage.isLoginOrCreateAccountPageDisplayed(), "Login or Create Account page is NOT displayed");
		logger.info("Login or Create Account page is displayed");

		//Enter the User information and DO NOT check the "Become a Preferred Customer" checkbox and click the create account button
		storeFrontHomePage.enterNewPCDetails(firstName, TestConstants.LAST_NAME+randomNum, password);

		//Pop for PC threshold validation
		s_assert.assertTrue(storeFrontHomePage.isPopUpForPCThresholdPresent(),"Threshold poup for PC validation NOT present");

		//In the Cart page add one more product
		storeFrontHomePage.addAnotherProduct();

		//Click on Check out
		storeFrontHomePage.clickOnCheckoutButton();

		//Enter the Main account info and DO NOT check the "Become a Preferred Customer" and click next
		storeFrontHomePage.enterMainAccountInfo();
		logger.info("Main account details entered");

		storeFrontHomePage.clickOnContinueWithoutSponsorLink();
		storeFrontHomePage.clickOnNextButtonAfterSelectingSponsor();

		storeFrontHomePage.clickOnShippingAddressNextStepBtn();
		//Enter Billing Profile
		storeFrontHomePage.enterNewBillingCardNumber(TestConstants.CARD_NUMBER);
		storeFrontHomePage.enterNewBillingNameOnCard(newBillingProfileName+" "+lastName);
		storeFrontHomePage.selectNewBillingCardExpirationDate();
		storeFrontHomePage.enterNewBillingSecurityCode(TestConstants.SECURITY_CODE);
		storeFrontHomePage.selectNewBillingCardAddress();
		storeFrontHomePage.clickOnSaveBillingProfile();
		storeFrontHomePage.clickOnBillingNextStepBtn();
		/*storeFrontHomePage.clickPlaceOrderBtn();
		s_assert.assertTrue(storeFrontHomePage.verifyPCPerksTermsAndConditionsPopup(),"PC Perks terms and conditions popup not visible when checkboxes for t&c not selected and place order button clicked");
		logger.info("PC Perks terms and conditions popup is visible when checkboxes for t&c not selected and place order button clicked");*/
		storeFrontHomePage.clickOnPCPerksTermsAndConditionsCheckBoxes();
		storeFrontHomePage.clickPlaceOrderBtn();
		//storeFrontHomePage.switchToPreviousTab();
		if(country.equalsIgnoreCase("CA"))
		{storeFrontHomePage.switchToPreviousTab();}
		//storeFrontHomePage.switchToPreviousTab(); 
		storeFrontHomePage.clickOnRodanAndFieldsLogo();
		s_assert.assertTrue(storeFrontHomePage.verifyWelcomeDropdownToCheckUserRegistered(), "User NOT registered successfully");
		//s_assert.assertTrue(storeFrontHomePage.getUserNameAForVerifyLogin(firstName).contains(firstName),"Profile Name After Login"+firstName+" and on UI is "+storeFrontHomePage.getUserNameAForVerifyLogin(firstName));
		s_assert.assertAll();	

	}

	//Hybris Project-1288 :: Version : 1 :: 2. Terms and Conditions - Standard EnrollmentTest with both CRP and Pulse
	@Test
	public void testStandardEnrollmentTermsAndConditions_1288() throws InterruptedException{
		int randomNum = CommonUtils.getRandomNum(10000, 1000000);
		String socialInsuranceNumber = String.valueOf(CommonUtils.getRandomNum(100000000, 999999999));
		country = driver.getCountry();
		enrollmentType = TestConstants.STANDARD_ENROLLMENT;
		regimenName = TestConstants.REGIMEN_NAME_UNBLEMISH;
		String firstName=TestConstants.FIRST_NAME+randomNum;

		if(country.equalsIgnoreCase("CA")){
			kitName = TestConstants.KIT_NAME_EXPRESS;			 
			addressLine1 = TestConstants.ADDRESS_LINE_1_CA;
			city = TestConstants.CITY_CA;
			postalCode = TestConstants.POSTAL_CODE_CA;
			phoneNumber = TestConstants.PHONE_NUMBER_CA;
		}else{
			kitName = TestConstants.KIT_NAME_EXPRESS;
			addressLine1 = TestConstants.ADDRESS_LINE_1_US;
			city = TestConstants.CITY_US;
			postalCode = TestConstants.POSTAL_CODE_US;
			phoneNumber = TestConstants.PHONE_NUMBER_US;
		}

		storeFrontHomePage = new StoreFrontHomePage(driver);
		/*storeFrontHomePage.clickOnOurBusinessLink();
			storeFrontHomePage.clickOnOurEnrollNowLink();*/
		storeFrontHomePage.hoverOnBecomeAConsultantAndClickEnrollNowLink();
		storeFrontHomePage.searchCID();
		storeFrontHomePage.mouseHoverSponsorDataAndClickContinue();
		storeFrontHomePage.enterUserInformationForEnrollment(kitName, regimenName, enrollmentType, firstName, TestConstants.LAST_NAME+randomNum, password, addressLine1, city, postalCode, phoneNumber);
		storeFrontHomePage.clickNextButton();
		storeFrontHomePage.enterCardNumber(TestConstants.CARD_NUMBER);
		storeFrontHomePage.enterNameOnCard(TestConstants.FIRST_NAME+randomNum);
		storeFrontHomePage.selectNewBillingCardExpirationDate();
		storeFrontHomePage.enterSecurityCode(TestConstants.SECURITY_CODE);
		storeFrontHomePage.enterSocialInsuranceNumber(socialInsuranceNumber);
		storeFrontHomePage.enterNameAsItAppearsOnCard(TestConstants.FIRST_NAME);
		storeFrontHomePage.clickEnrollmentNextBtn();
		//		s_assert.assertTrue(storeFrontHomePage.verifySubsribeToPulseCheckBoxIsSelected(), "Subscribe to pulse checkbox not selected");
		//		s_assert.assertTrue(storeFrontHomePage.verifyEnrollToCRPCheckBoxIsSelected(), "Enroll to CRP checkbox not selected");
		storeFrontHomePage.clickEnrollmentNextBtn();
		storeFrontHomePage.selectProductAndProceedToAddToCRP();
		storeFrontHomePage.addQuantityOfProduct("5");
		storeFrontHomePage.clickOnNextBtnAfterAddingProductAndQty();
		s_assert.assertTrue(storeFrontHomePage.isTheTermsAndConditionsCheckBoxDisplayed(), "Terms and Conditions checkbox is not visible");
		storeFrontHomePage.checkThePoliciesAndProceduresCheckBox();
		storeFrontHomePage.checkTheIAcknowledgeCheckBox();		
		storeFrontHomePage.checkTheIAgreeCheckBox();
		storeFrontHomePage.clickOnChargeMyCardAndEnrollMeBtn();
		s_assert.assertTrue(storeFrontHomePage.verifyPopUpForPoliciesAndProcedures(), "PopUp for policies and procedures is not visible");
		storeFrontHomePage.checkTheTermsAndConditionsCheckBox();
		storeFrontHomePage.clickOnChargeMyCardAndEnrollMeBtn();
		storeFrontHomePage.clickOnConfirmAutomaticPayment();
		s_assert.assertTrue(storeFrontHomePage.verifyCongratsMessage(), "Congrats Message is not visible");
		storeFrontHomePage.clickOnRodanAndFieldsLogo();
		s_assert.assertTrue(storeFrontHomePage.verifyWelcomeDropdownToCheckUserRegistered(), "User NOT registered successfully");
		s_assert.assertAll();

	}

	//Test Case Hybris Project-3255 :: Version : 1 :: Standard EnrollmentTest without CRP and Pulse
	@Test
	public void testStandardEnrollmentWithoutCRPAndPulse_3255() throws InterruptedException{
		int randomNum = CommonUtils.getRandomNum(10000, 1000000);
		String socialInsuranceNumber = String.valueOf(CommonUtils.getRandomNum(100000000, 999999999));
		country = driver.getCountry();
		enrollmentType = TestConstants.STANDARD_ENROLLMENT;
		regimenName = TestConstants.REGIMEN_NAME_UNBLEMISH;
		String firstName = TestConstants.FIRST_NAME+randomNum;
		if(country.equalsIgnoreCase("CA")){
			kitName = TestConstants.KIT_NAME_EXPRESS;			 
			addressLine1 = TestConstants.ADDRESS_LINE_1_CA;
			city = TestConstants.CITY_CA;
			postalCode = TestConstants.POSTAL_CODE_CA;
			phoneNumber = TestConstants.PHONE_NUMBER_CA;
		}else{
			kitName = TestConstants.KIT_NAME_EXPRESS;
			addressLine1 = TestConstants.ADDRESS_LINE_1_US;
			city = TestConstants.CITY_US;
			postalCode = TestConstants.POSTAL_CODE_US;
			phoneNumber = TestConstants.PHONE_NUMBER_US;
		}

		storeFrontHomePage = new StoreFrontHomePage(driver);
		/*storeFrontHomePage.clickOnOurBusinessLink();
			storeFrontHomePage.clickOnOurEnrollNowLink();*/
		storeFrontHomePage.hoverOnBecomeAConsultantAndClickEnrollNowLink();
		storeFrontHomePage.searchCID();
		storeFrontHomePage.mouseHoverSponsorDataAndClickContinue();
		storeFrontHomePage.enterUserInformationForEnrollment(kitName, regimenName, enrollmentType, firstName, TestConstants.LAST_NAME+randomNum, password, addressLine1, city, postalCode, phoneNumber);
		storeFrontHomePage.clickNextButton();

		storeFrontHomePage.enterCardNumber(TestConstants.CARD_NUMBER);
		storeFrontHomePage.enterNameOnCard(TestConstants.FIRST_NAME+randomNum);
		storeFrontHomePage.selectNewBillingCardExpirationDate();
		storeFrontHomePage.enterSecurityCode(TestConstants.SECURITY_CODE);
		storeFrontHomePage.enterSocialInsuranceNumber(socialInsuranceNumber);
		storeFrontHomePage.enterNameAsItAppearsOnCard(TestConstants.FIRST_NAME);
		storeFrontHomePage.clickEnrollmentNextBtn();
		storeFrontHomePage.uncheckPulseAndCRPEnrollment();
		s_assert.assertTrue(storeFrontHomePage.verifySubsribeToPulseCheckBoxIsNotSelected(), "Subscribe to pulse checkbox selected after uncheck");
		s_assert.assertTrue(storeFrontHomePage.verifyEnrollToCRPCheckBoxIsNotSelected(), "Enroll to CRP checkbox selected after uncheck");
		storeFrontHomePage.clickEnrollmentNextBtn();
		s_assert.assertTrue(storeFrontHomePage.isTheTermsAndConditionsCheckBoxDisplayed(), "Terms and Conditions checkbox is not visible");
		storeFrontHomePage.checkThePoliciesAndProceduresCheckBox();
		storeFrontHomePage.checkTheIAcknowledgeCheckBox();		
		storeFrontHomePage.checkTheIAgreeCheckBox();
		storeFrontHomePage.checkTheTermsAndConditionsCheckBox();
		storeFrontHomePage.clickOnEnrollMeBtn();
		s_assert.assertTrue(storeFrontHomePage.verifyCongratsMessage(), "Congrats Message is not visible");
		storeFrontHomePage.clickOnRodanAndFieldsLogo();
		s_assert.assertTrue(storeFrontHomePage.verifyWelcomeDropdownToCheckUserRegistered(), "User NOT registered successfully");
		//		s_assert.assertTrue(storeFrontHomePage.getUserNameAForVerifyLogin(firstName).contains(firstName),"Profile Name After Login"+firstName+" and on UI is "+storeFrontHomePage.getUserNameAForVerifyLogin(firstName));
		s_assert.assertAll();
	}

	// Hybris Project-2230 :: Version : 1 :: Verify that user can enroll in CRP through my account.
	@Test
	public void testUserEnrollCRPThroughMyAccount_2230() throws InterruptedException{  
		int randomNum = CommonUtils.getRandomNum(10000, 1000000);
		String socialInsuranceNumber = String.valueOf(CommonUtils.getRandomNum(100000000, 999999999));
		country = driver.getCountry();
		enrollmentType = TestConstants.STANDARD_ENROLLMENT;
		regimenName = TestConstants.REGIMEN_NAME_UNBLEMISH;

		if(country.equalsIgnoreCase("CA")){
			kitName = TestConstants.KIT_NAME_EXPRESS;			 
			addressLine1 = TestConstants.ADDRESS_LINE_1_CA;
			city = TestConstants.CITY_CA;
			postalCode = TestConstants.POSTAL_CODE_CA;
			phoneNumber = TestConstants.PHONE_NUMBER_CA;
		}else{
			kitName = TestConstants.KIT_NAME_EXPRESS;
			addressLine1 = TestConstants.ADDRESS_LINE_1_US;
			city = TestConstants.CITY_US;
			postalCode = TestConstants.POSTAL_CODE_US;
			phoneNumber = TestConstants.PHONE_NUMBER_US;
		}

		storeFrontHomePage = new StoreFrontHomePage(driver);
		storeFrontConsultantPage = new StoreFrontConsultantPage(driver);
		storeFrontHomePage.hoverOnBecomeAConsultantAndClickEnrollNowLink();		
		storeFrontHomePage.searchCID();
		storeFrontHomePage.mouseHoverSponsorDataAndClickContinue();
		storeFrontHomePage.enterUserInformationForEnrollment(kitName, regimenName, enrollmentType, TestConstants.FIRST_NAME+randomNum, TestConstants.LAST_NAME+randomNum, password, addressLine1, city, postalCode, phoneNumber);
		storeFrontHomePage.clickNextButton();
		storeFrontHomePage.enterCardNumber(TestConstants.CARD_NUMBER);
		storeFrontHomePage.enterNameOnCard(TestConstants.FIRST_NAME+randomNum);
		storeFrontHomePage.selectNewBillingCardExpirationDate();
		storeFrontHomePage.enterSecurityCode(TestConstants.SECURITY_CODE);
		storeFrontHomePage.enterSocialInsuranceNumber(socialInsuranceNumber);
		storeFrontHomePage.enterNameAsItAppearsOnCard(TestConstants.FIRST_NAME);
		storeFrontHomePage.clickEnrollmentNextBtn();
		storeFrontHomePage.uncheckPulseAndCRPEnrollment();
		s_assert.assertTrue(storeFrontHomePage.verifySubsribeToPulseCheckBoxIsNotSelected(), "Subscribe to pulse checkbox selected after uncheck");
		s_assert.assertTrue(storeFrontHomePage.verifyEnrollToCRPCheckBoxIsNotSelected(), "Enroll to CRP checkbox selected after uncheck");
		storeFrontHomePage.clickEnrollmentNextBtn();
		storeFrontHomePage.checkThePoliciesAndProceduresCheckBox();
		storeFrontHomePage.checkTheIAcknowledgeCheckBox();  
		storeFrontHomePage.checkTheIAgreeCheckBox();
		storeFrontHomePage.checkTheTermsAndConditionsCheckBox();
		storeFrontHomePage.clickOnEnrollMeBtn();
		s_assert.assertTrue(storeFrontHomePage.verifyCongratsMessage(), "Congrats Message is not visible");
		storeFrontHomePage.clickOnRodanAndFieldsLogo();
		s_assert.assertTrue(storeFrontHomePage.verifyWelcomeDropdownToCheckUserRegistered(), "User NOT registered successfully");

		storeFrontConsultantPage.clickOnWelcomeDropDown();
		storeFrontAccountInfoPage = storeFrontConsultantPage.clickAccountInfoLinkPresentOnWelcomeDropDown();
		s_assert.assertTrue(storeFrontAccountInfoPage.verifyAccountInfoPageIsDisplayed(),"shipping info page has not been displayed");
		storeFrontAccountInfoPage.clickOnYourAccountDropdown();//added
		storeFrontAccountInfoPage.clickOnAutoShipStatus();
		storeFrontAccountInfoPage.clickOnEnrollInCRP();
		storeFrontHomePage.clickOnAddToCRPButtonCreatingCRPUnderBizSite();
		storeFrontHomePage.clickOnCRPCheckout();
		storeFrontHomePage.clickOnUpdateCartShippingNextStepBtnDuringEnrollment();
		storeFrontHomePage.clickOnBillingNextStepBtn();
		storeFrontHomePage.clickOnSetupCRPAccountBtn();
		s_assert.assertTrue(storeFrontHomePage.verifyOrderConfirmation(), "Order Confirmation Message has not been displayed");
		storeFrontHomePage.clickOnGoToMyAccountToCheckStatusOfCRP();
		storeFrontHomePage.clickOnYourAccountDropdown();
		storeFrontAccountInfoPage.clickOnAutoShipStatus();
		s_assert.assertTrue(storeFrontAccountInfoPage.verifyCurrentCRPStatus(), "Current CRP Status has not been Enrolled");
		s_assert.assertAll();
	}

	//Hybris Project-3921 :: Version : 1 :: Verify subscribing to Pulse from My Account under .biz site 
	@Test
	public void testSubscribingPulseMyAccount_3921() throws InterruptedException{
		int randomNum = CommonUtils.getRandomNum(10000, 1000000);
		String socialInsuranceNumber = String.valueOf(CommonUtils.getRandomNum(100000000, 999999999));
		country = driver.getCountry();
		enrollmentType = TestConstants.STANDARD_ENROLLMENT;
		regimenName = TestConstants.REGIMEN_NAME_UNBLEMISH;
		env = driver.getEnvironment();  
		storeFrontHomePage = new StoreFrontHomePage(driver);
		storeFrontHomePage.openPWSSite(country, env);

		if(country.equalsIgnoreCase("CA")){
			kitName = TestConstants.KIT_NAME_BIG_BUSINESS;			 
			addressLine1 = TestConstants.ADDRESS_LINE_1_CA;
			city = TestConstants.CITY_CA;
			postalCode = TestConstants.POSTAL_CODE_CA;
			phoneNumber = TestConstants.PHONE_NUMBER_CA;
		}else{
			kitName = TestConstants.KIT_NAME_BIG_BUSINESS;
			addressLine1 = TestConstants.ADDRESS_LINE_1_US;
			city = TestConstants.CITY_US;
			postalCode = TestConstants.POSTAL_CODE_US;
			phoneNumber = TestConstants.PHONE_NUMBER_US;
		}

		storeFrontHomePage = new StoreFrontHomePage(driver);
		storeFrontConsultantPage = new StoreFrontConsultantPage(driver);
		storeFrontUpdateCartPage = new StoreFrontUpdateCartPage(driver);
		storeFrontHomePage.hoverOnBecomeAConsultantAndClickEnrollNowLink();		
		storeFrontHomePage.enterUserInformationForEnrollment(kitName, regimenName, enrollmentType, TestConstants.FIRST_NAME+randomNum, TestConstants.LAST_NAME+randomNum, password, addressLine1, city, postalCode, phoneNumber);
		storeFrontHomePage.clickNextButton();

		storeFrontHomePage.enterCardNumber(TestConstants.CARD_NUMBER);
		storeFrontHomePage.enterNameOnCard(TestConstants.FIRST_NAME+randomNum);
		storeFrontHomePage.selectNewBillingCardExpirationDate();
		storeFrontHomePage.enterSecurityCode(TestConstants.SECURITY_CODE);
		storeFrontHomePage.enterSocialInsuranceNumber(socialInsuranceNumber);
		storeFrontHomePage.enterNameAsItAppearsOnCard(TestConstants.FIRST_NAME);
		storeFrontHomePage.clickEnrollmentNextBtn();
		storeFrontHomePage.uncheckPulseAndCRPEnrollment();
		s_assert.assertTrue(storeFrontHomePage.verifySubsribeToPulseCheckBoxIsNotSelected(), "Subscribe to pulse checkbox selected after uncheck");
		s_assert.assertTrue(storeFrontHomePage.verifyEnrollToCRPCheckBoxIsNotSelected(), "Enroll to CRP checkbox selected after uncheck");
		storeFrontHomePage.clickEnrollmentNextBtn();
		s_assert.assertTrue(storeFrontHomePage.isTheTermsAndConditionsCheckBoxDisplayed(), "Terms and Conditions checkbox is not visible");
		storeFrontHomePage.checkThePoliciesAndProceduresCheckBox();
		storeFrontHomePage.checkTheIAcknowledgeCheckBox();  
		storeFrontHomePage.checkTheIAgreeCheckBox();
		storeFrontHomePage.checkTheTermsAndConditionsCheckBox();
		storeFrontHomePage.clickOnEnrollMeBtn();
		s_assert.assertTrue(storeFrontHomePage.verifyCongratsMessage(), "Congrats Message is not visible");
		storeFrontHomePage.clickOnRodanAndFieldsLogo();
		s_assert.assertTrue(storeFrontHomePage.verifyWelcomeDropdownToCheckUserRegistered(), "User NOT registered successfully");
		storeFrontHomePage.clickOnWelcomeDropDown();
		storeFrontConsultantPage = new StoreFrontConsultantPage(driver);
		storeFrontAccountInfoPage = storeFrontConsultantPage.clickAccountInfoLinkPresentOnWelcomeDropDown();
		s_assert.assertTrue(storeFrontAccountInfoPage.verifyAccountInfoPageIsDisplayed(),"shipping info page has not been displayed");
		storeFrontAccountInfoPage.clickOnYourAccountDropdown();
		storeFrontAccountInfoPage.clickOnAutoShipStatus();
		storeFrontAccountInfoPage.clickOnSubscribeToPulseBtn();
		storeFrontUpdateCartPage.clickOnBillingNextStepBtn();
		storeFrontUpdateCartPage.clickOnSubscribePulseTermsAndConditionsChkbox();
		storeFrontUpdateCartPage.clickOnSubscribeBtn();
		s_assert.assertTrue(storeFrontUpdateCartPage.verifyPulseOrderCreatedMsg(), "Pulse order created msg is NOT present,Pulse might NOT be subscribed successfully");
		s_assert.assertAll();
	}


	//Hybris Project-52 :: Version : 1 :: BIZ:Standard Enroll Kit USD $45 Business Portfolio (CRP:Y P:Y) 
	@Test
	public void testStandardEnrollmentBusinessPortfolio_52() throws InterruptedException{
		int randomNum = CommonUtils.getRandomNum(10000, 1000000);
		String socialInsuranceNumber = String.valueOf(CommonUtils.getRandomNum(100000000, 999999999));
		country = driver.getCountry();
		enrollmentType = TestConstants.STANDARD_ENROLLMENT;
		regimenName = TestConstants.REGIMEN_NAME_UNBLEMISH;

		if(country.equalsIgnoreCase("CA")){
			kitName = TestConstants.KIT_NAME_EXPRESS;;    
			addressLine1 = TestConstants.ADDRESS_LINE_1_CA;
			city = TestConstants.CITY_CA;
			postalCode = TestConstants.POSTAL_CODE_CA;
			phoneNumber = TestConstants.PHONE_NUMBER_CA;
		}else{
			kitName = TestConstants.KIT_NAME_EXPRESS;
			addressLine1 = TestConstants.ADDRESS_LINE_1_US;
			city = TestConstants.CITY_US;
			postalCode = TestConstants.POSTAL_CODE_US;
			phoneNumber = TestConstants.PHONE_NUMBER_US;
		}

		storeFrontHomePage = new StoreFrontHomePage(driver);
		storeFrontHomePage.hoverOnBecomeAConsultantAndClickEnrollNowLink();
		storeFrontHomePage.searchCID();
		storeFrontHomePage.mouseHoverSponsorDataAndClickContinue();
		storeFrontHomePage.enterUserInformationForEnrollment(kitName, regimenName, enrollmentType, TestConstants.FIRST_NAME+randomNum, TestConstants.LAST_NAME+randomNum, password, addressLine1, city, postalCode, phoneNumber);
		//storeFrontHomePage.enterUserInformationForEnrollment(kitName, regimenName, TestConstants.FIRST_NAME+randomNum, TestConstants.LAST_NAME+randomNum, password, addressLine1, city, postalCode, phoneNumber);
		storeFrontHomePage.clickEnrollmentNextBtn();
		//storeFrontHomePage.acceptTheVerifyYourShippingAddressPop();  
		storeFrontHomePage.enterCardNumber(TestConstants.CARD_NUMBER);
		storeFrontHomePage.enterNameOnCard(TestConstants.FIRST_NAME+randomNum);
		storeFrontHomePage.selectNewBillingCardExpirationDate();
		storeFrontHomePage.enterSecurityCode(TestConstants.SECURITY_CODE);
		storeFrontHomePage.enterSocialInsuranceNumber(socialInsuranceNumber);
		storeFrontHomePage.enterNameAsItAppearsOnCard(TestConstants.FIRST_NAME);
		storeFrontHomePage.clickEnrollmentNextBtn();
		s_assert.assertTrue(storeFrontHomePage.verifySubsribeToPulseCheckBoxIsSelected(), "Subscribe to pulse checkbox not selected");
		s_assert.assertTrue(storeFrontHomePage.verifyEnrollToCRPCheckBoxIsSelected(), "Enroll to CRP checkbox not selected");
		storeFrontHomePage.clickEnrollmentNextBtn();
		storeFrontHomePage.selectProductAndProceedToAddToCRP();
		storeFrontHomePage.addQuantityOfProduct("5");
		storeFrontHomePage.clickOnNextBtnAfterAddingProductAndQty();
		s_assert.assertTrue(storeFrontHomePage.isTheTermsAndConditionsCheckBoxDisplayed(), "Terms and Conditions checkbox is not visible");
		storeFrontHomePage.checkThePoliciesAndProceduresCheckBox();
		storeFrontHomePage.checkTheIAcknowledgeCheckBox();  
		storeFrontHomePage.checkTheIAgreeCheckBox();
		storeFrontHomePage.clickOnEnrollMeBtn();
		s_assert.assertTrue(storeFrontHomePage.verifyPopUpForPoliciesAndProcedures(), "PopUp for policies and procedures is not visible");
		storeFrontHomePage.checkTheTermsAndConditionsCheckBox();
		storeFrontHomePage.clickOnChargeMyCardAndEnrollMeBtn();
		storeFrontHomePage.clickOnConfirmAutomaticPayment();
		s_assert.assertTrue(storeFrontHomePage.verifyCongratsMessage(), "Congrats Message is not visible");
		storeFrontHomePage.clickOnRodanAndFieldsLogo();
		s_assert.assertTrue(storeFrontHomePage.verifyWelcomeDropdownToCheckUserRegistered(), "User NOT registered successfully");
		s_assert.assertAll();
	}

	// Hybris Project-3009 :: Version : 1 :: Reset the password from the storefront and check login with new password
	@Test(enabled=false) //enabled false for now as it will reset the password
	public void testResetPasswordFromStorefrontAndRecheckLogin_3009() throws InterruptedException {
		RFO_DB = driver.getDBNameRFO(); 
		List<Map<String, Object>> randomConsultantList =  null;
		String consultantEmailID = null;
		String accountID = null;
		storeFrontHomePage = new StoreFrontHomePage(driver);

		while(true){
			//			randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.GET_RANDOM_ACTIVE_CONSULTANT_WITH_ORDERS_AND_AUTOSHIPS_RFO,RFO_DB);
			//			consultantEmailID = (String) getValueFromQueryResult(randomConsultantList, "UserName");  
			//			accountID = String.valueOf(getValueFromQueryResult(randomConsultantList, "AccountID"));
			//			logger.info("Account Id of the user is "+accountID);

			storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(TestConstants.CONSULTANT_USERNAME, password);
			boolean isSiteNotFoundPresent = driver.getCurrentUrl().contains("sitenotfound");
			if(isSiteNotFoundPresent){
				logger.info("SITE NOT FOUND for the user "+consultantEmailID);
				driver.get(driver.getURL());
			}
			else
				break;
		}

		s_assert.assertTrue(storeFrontConsultantPage.verifyConsultantPage(),"Consultant Page doesn't contain Welcome User Message");
		logger.info("login is successful");
		storeFrontConsultantPage.clickOnWelcomeDropDown();
		storeFrontAccountInfoPage = storeFrontConsultantPage.clickAccountInfoLinkPresentOnWelcomeDropDown();
		s_assert.assertTrue(storeFrontAccountInfoPage.verifyAccountInfoPageIsDisplayed(),"Account Info page has not been displayed");
		//Reset New Password from the store front
		storeFrontAccountInfoPage.enterOldPassword(password);
		storeFrontAccountInfoPage.enterNewPassword(TestConstants.CONSULTANT_NEW_PASSWORD);
		storeFrontAccountInfoPage.enterConfirmedPassword(TestConstants.CONSULTANT_NEW_PASSWORD);
		storeFrontAccountInfoPage.clickSaveAccountPageInfo();
		logout();
		//validate login with new password
		storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(TestConstants.CONSULTANT_USERNAME,TestConstants.CONSULTANT_NEW_PASSWORD);   
		s_assert.assertTrue(storeFrontConsultantPage.verifyConsultantPage(),"Consultant Page doesn't contain Welcome User Message");
		logger.info("login is successful");
		//Reset old password
		storeFrontConsultantPage.clickOnWelcomeDropDown();
		storeFrontAccountInfoPage = storeFrontConsultantPage.clickAccountInfoLinkPresentOnWelcomeDropDown();
		s_assert.assertTrue(storeFrontAccountInfoPage.verifyAccountInfoPageIsDisplayed(),"Account Info page has not been displayed");
		storeFrontAccountInfoPage.enterOldPassword(TestConstants.CONSULTANT_NEW_PASSWORD);
		storeFrontAccountInfoPage.enterNewPassword(password);
		storeFrontAccountInfoPage.enterConfirmedPassword(password);
		storeFrontAccountInfoPage.clickSaveAccountPageInfo();
		s_assert.assertAll(); 
	}

	// Hybris Project-4260 :: Version : 1 :: UserName Field: Edit & Login 
	@Test
	public void testUserNameFieldEditAndLogin_4260() throws InterruptedException{
		RFO_DB = driver.getDBNameRFO(); 
		List<Map<String, Object>> randomConsultantList =  null;
		String consultantEmailID = null;
		String accountID = null;
		storeFrontHomePage = new StoreFrontHomePage(driver);

		while(true){
			//			randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.GET_RANDOM_ACTIVE_CONSULTANT_WITH_ORDERS_AND_AUTOSHIPS_RFO,RFO_DB);
			//			consultantEmailID = (String) getValueFromQueryResult(randomConsultantList, "UserName");  
			//			accountID = String.valueOf(getValueFromQueryResult(randomConsultantList, "AccountID"));
			//			logger.info("Account Id of the user is "+accountID);

			storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(TestConstants.CONSULTANT_USERNAME, password);
			boolean isSiteNotFoundPresent = driver.getCurrentUrl().contains("sitenotfound");
			if(isSiteNotFoundPresent){
				logger.info("SITE NOT FOUND for the user "+consultantEmailID);
				driver.get(driver.getURL());
			}
			else
				break;
		}

		s_assert.assertTrue(storeFrontConsultantPage.verifyConsultantPage(),"Consultant Page doesn't contain Welcome User Message");
		logger.info("login is successful");
		storeFrontConsultantPage.clickOnWelcomeDropDown();
		storeFrontAccountInfoPage = storeFrontConsultantPage.clickAccountInfoLinkPresentOnWelcomeDropDown();
		s_assert.assertTrue(storeFrontAccountInfoPage.verifyAccountInfoPageIsDisplayed(),"Account Info page has not been displayed");
		//Enter new user name logout and validate the new user
		storeFrontAccountInfoPage.enterUserName(TestConstants.CONSULTANT_EMAIL_ID_FOR_ACCOUNTINFO);
		storeFrontAccountInfoPage.clickSaveAccountPageInfo();
		logout();
		//login with the same user
		//storeFrontHomePage = new StoreFrontHomePage(driver);
		storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(TestConstants.CONSULTANT_EMAIL_ID_FOR_ACCOUNTINFO,password);   
		s_assert.assertTrue(storeFrontConsultantPage.verifyConsultantPage(),"Consultant Page doesn't contain Welcome User Message");
		logger.info("login is successful");
		storeFrontConsultantPage.clickOnWelcomeDropDown();
		storeFrontAccountInfoPage = storeFrontConsultantPage.clickAccountInfoLinkPresentOnWelcomeDropDown();
		s_assert.assertTrue(storeFrontAccountInfoPage.verifyAccountInfoPageIsDisplayed(),"Account Info page has not been displayed");
		//validate the new user
		s_assert.assertTrue(TestConstants.CONSULTANT_EMAIL_ID_FOR_ACCOUNTINFO.equalsIgnoreCase(storeFrontAccountInfoPage.getUserName()),"Username didn't match");
		logout();
		//reset username
		storeFrontHomePage.clickOnRodanAndFieldsLogo();
		storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(TestConstants.CONSULTANT_EMAIL_ID_FOR_ACCOUNTINFO,password);   
		s_assert.assertTrue(storeFrontConsultantPage.verifyConsultantPage(),"Consultant Page doesn't contain Welcome User Message");
		logger.info("login is successful");
		storeFrontConsultantPage.clickOnWelcomeDropDown();
		storeFrontAccountInfoPage = storeFrontConsultantPage.clickAccountInfoLinkPresentOnWelcomeDropDown();
		s_assert.assertTrue(storeFrontAccountInfoPage.verifyAccountInfoPageIsDisplayed(),"Account Info page has not been displayed");
		storeFrontAccountInfoPage.enterUserName(TestConstants.CONSULTANT_USERNAME);
		storeFrontAccountInfoPage.clickSaveAccountPageInfo();
		s_assert.assertAll();
	}

	//Hybris Project-86 :: Version : 1 :: Edit Allow my spouse in My Account  
	@Test
	public void testEditAllowMySpouseInMyAccount() throws InterruptedException	{
		RFO_DB = driver.getDBNameRFO();	
		List<Map<String, Object>> randomConsultantList =  null;
		String consultantEmailID = null;
		String accountID = null;
		storeFrontHomePage = new StoreFrontHomePage(driver);

		while(true){
			//			randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.GET_RANDOM_ACTIVE_CONSULTANT_WITH_ORDERS_AND_AUTOSHIPS_RFO,RFO_DB);
			//			consultantEmailID = (String) getValueFromQueryResult(randomConsultantList, "UserName");		
			//			accountID = String.valueOf(getValueFromQueryResult(randomConsultantList, "AccountID"));
			//			logger.info("Account Id of the user is "+accountID);

			storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(TestConstants.CONSULTANT_USERNAME, password);
			boolean isSiteNotFoundPresent = driver.getCurrentUrl().contains("sitenotfound");
			if(isSiteNotFoundPresent){
				logger.info("SITE NOT FOUND for the user "+consultantEmailID);
				driver.get(driver.getURL());
			}
			else
				break;
		}

		s_assert.assertTrue(storeFrontConsultantPage.verifyConsultantPage(),"Consultant Page doesn't contain Welcome User Message");
		logger.info("login is successful");
		storeFrontConsultantPage.clickOnWelcomeDropDown();
		storeFrontAccountInfoPage = storeFrontConsultantPage.clickAccountInfoLinkPresentOnWelcomeDropDown();
		s_assert.assertTrue(storeFrontAccountInfoPage.verifyAccountInfoPageIsDisplayed(),"Account Info page has not been displayed");
		//click on Allow my Spouse to manage my account
		storeFrontAccountInfoPage.checkAllowMySpouseCheckBox();
		//Enter first,last name and click accept on the popup and validate
		s_assert.assertTrue(storeFrontAccountInfoPage.validateEnterSpouseDetailsAndAccept());
		//click cancel on the 'Allow my spouse' popup and validate
		s_assert.assertFalse(storeFrontAccountInfoPage.validateClickCancelOnProvideAccessToSpousePopup());
		s_assert.assertAll();
	}

	//Hybris Project-2304 :: Version : 1 :: check Cart from Mini cart after adding product
	@Test
	public void testCheckCartFromMiniCartAfterAddingProduct_2304() throws InterruptedException {
		//Navigate to the website
		storeFrontHomePage = new StoreFrontHomePage(driver);

		//Add a item to the cart and validate the mini cart in the header section
		storeFrontHomePage.hoverOnShopLinkAndClickAllProductsLinks();

		// Products are displayed?
		s_assert.assertTrue(storeFrontHomePage.areProductsDisplayed(), "quickshop products not displayed");
		logger.info("Quick shop products are displayed");
		storeFrontHomePage.selectProductAndProceedToBuy();

		//Cart page is displayed?
		s_assert.assertTrue(storeFrontHomePage.isCartPageDisplayed(), "Cart page is not displayed");
		logger.info("Cart page is displayed");

		s_assert.assertTrue(storeFrontHomePage.validateMiniCart(), "mini cart is not being displayed");

		//click on mini cart and validate the cart page with pre-added products
		s_assert.assertTrue(storeFrontHomePage.clickMiniCartAndValidatePreaddedProductsOnCartPage(), "preadded products on cart page is not displayed");  
		s_assert.assertAll();
	}

	//Hybris Project-2327 :: Version : 1 :: check Mini Cart - Not Logged In user
	@Test
	public void testCheckMiniCartForNotLoggedInUser_2327() throws InterruptedException {
		//Navigate to the website
		storeFrontHomePage = new StoreFrontHomePage(driver);
		//validate no mini cart is shown for not logged in user
		s_assert.assertFalse(storeFrontHomePage.validateMiniCart(), "mini cart is displayed for not registered user");
		//Add a item to the cart and validate the mini cart in the header section
		storeFrontHomePage.hoverOnShopLinkAndClickAllProductsLinks();

		// Products are displayed?
		s_assert.assertTrue(storeFrontHomePage.areProductsDisplayed(), "quickshop products not displayed");
		logger.info("Quick shop products are displayed");
		storeFrontHomePage.selectProductAndProceedToBuy();

		//Cart page is displayed?
		s_assert.assertTrue(storeFrontHomePage.isCartPageDisplayed(), "Cart page is not displayed");
		logger.info("Cart page is displayed");

		s_assert.assertTrue(storeFrontHomePage.validateMiniCart(), "mini cart is not being displayed");
		s_assert.assertAll();
	}


	//Hybris Project-2329 :: Version : 1 :: check Mini Cart - Consultant 
	@Test
	public void testCheckMiniCartForConsultant_2329() throws InterruptedException  {
		//Login as consultant and validate the 'Next CRP' mini cart in the header section
		RFO_DB = driver.getDBNameRFO(); 
		List<Map<String, Object>> randomConsultantList =  null;
		String consultantEmailID = null;
		String accountID = null;
		storeFrontHomePage = new StoreFrontHomePage(driver);

		while(true){
			//			randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.GET_RANDOM_ACTIVE_CONSULTANT_WITH_ORDERS_AND_AUTOSHIPS_RFO,RFO_DB);
			//			consultantEmailID = (String) getValueFromQueryResult(randomConsultantList, "UserName");  
			//			accountID = String.valueOf(getValueFromQueryResult(randomConsultantList, "AccountID"));
			//			logger.info("Account Id of the user is "+accountID);

			storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(TestConstants.CONSULTANT_USERNAME, password);
			boolean isSiteNotFoundPresent = driver.getCurrentUrl().contains("sitenotfound");
			if(isSiteNotFoundPresent){
				logger.info("SITE NOT FOUND for the user "+consultantEmailID);
				driver.get(driver.getURL());
			}
			else
				break;
		}

		s_assert.assertTrue(storeFrontConsultantPage.verifyConsultantPage(),"Consultant Page doesn't contain Welcome User Message");
		logger.info("login is successful");
		s_assert.assertTrue(storeFrontConsultantPage.validateNextCRPMiniCart(), "next CRP Mini cart is not displayed");
		//Add a item to the cart and validate the mini cart in the header section
		/* storeFrontHomePage.clickOnShopLink();
	  storeFrontHomePage.clickOnAllProductsLink();*/
		storeFrontHomePage.hoverOnShopLinkAndClickAllProductsLinksAfterLogin();  

		// Products are displayed?
		s_assert.assertTrue(storeFrontHomePage.areProductsDisplayed(), "quickshop products not displayed");
		logger.info("Quick shop products are displayed");
		storeFrontHomePage.selectProductAndProceedToBuy();

		//Cart page is displayed?
		s_assert.assertTrue(storeFrontHomePage.isCartPageDisplayed(), "Cart page is not displayed");
		logger.info("Cart page is displayed");

		s_assert.assertTrue(storeFrontHomePage.validateMiniCart(), "mini cart is not being displayed");
		s_assert.assertAll();
	}

	//Hybris Project-2328 :: Version : 1 :: check Mini Cart - PC 
	@Test
	public void testCheckMiniCartForPC_2328() throws InterruptedException {
		//Login as consultant and validate the 'Next PC PERKS' mini cart in the header section
		RFO_DB = driver.getDBNameRFO();
		List<Map<String, Object>> randomPCUserList =  null;
		String pcUserEmailID = null;
		String accountID = null;
		storeFrontHomePage = new StoreFrontHomePage(driver);

		while(true){
			//			randomPCUserList = DBUtil.performDatabaseQuery(DBQueries_RFO.GET_RANDOM_ACTIVE_PC_WITH_ORDERS_AND_AUTOSHIPS_RFO,RFO_DB);
			//			pcUserEmailID = (String) getValueFromQueryResult(randomPCUserList, "UserName");
			//			accountID = String.valueOf(getValueFromQueryResult(randomPCUserList, "AccountID"));
			//			logger.info("Account Id of the user is "+accountID);  

			storeFrontPCUserPage = storeFrontHomePage.loginAsPCUser("autorfpc@xyz.com", password);
			boolean isSiteNotFoundPresent = driver.getCurrentUrl().contains("sitenotfound");
			if(isSiteNotFoundPresent){
				logger.info("SITE NOT FOUND for the user "+pcUserEmailID);
				driver.get(driver.getURL());
			}
			else
				break;
		}

		logger.info("login is successful");

		s_assert.assertTrue(storeFrontPCUserPage.validateNextPCPerksMiniCart(), "next PC Perks  Mini cart is not displayed");
		//Add a item to the cart and validate the mini cart in the header section
		/* storeFrontHomePage.clickOnShopLink();
	  storeFrontHomePage.clickOnAllProductsLink();*/
		storeFrontHomePage.hoverOnShopLinkAndClickAllProductsLinksAfterLogin();
		// Products are displayed?
		s_assert.assertTrue(storeFrontHomePage.areProductsDisplayed(), "quickshop products not displayed");
		logger.info("Quick shop products are displayed");
		storeFrontHomePage.selectProductAndProceedToBuy();

		//Cart page is displayed?
		s_assert.assertTrue(storeFrontHomePage.isCartPageDisplayed(), "Cart page is not displayed");
		logger.info("Cart page is displayed");

		s_assert.assertTrue(storeFrontHomePage.validateMiniCart(), "mini cart is not being displayed");
		s_assert.assertAll();
	}


	// Hybris Project-87 :: Version : 1 :: Standard Enrollment Billing Profile Edit Shipping Info 
	@Test
	public void testStandardEnrollmentExpressBusinessKitRedefineRegimenEdit_87() throws InterruptedException{
		int randomNum = CommonUtils.getRandomNum(10000, 1000000);
		String socialInsuranceNumber = String.valueOf(CommonUtils.getRandomNum(100000000, 999999999));
		String newAddressLine1=null;
		country = driver.getCountry();
		enrollmentType = TestConstants.STANDARD_ENROLLMENT;
		regimenName = TestConstants.REGIMEN_NAME_REDEFINE;

		if(country.equalsIgnoreCase("CA")){
			kitName = TestConstants.KIT_NAME_EXPRESS;    
			addressLine1 = TestConstants.ADDRESS_LINE_1_CA;
			newAddressLine1 = TestConstants.NEW_ADDRESS_LINE_1_CA;
			city = TestConstants.CITY_CA;
			postalCode = TestConstants.POSTAL_CODE_CA;
			phoneNumber = TestConstants.PHONE_NUMBER_CA;
		}else{
			kitName = TestConstants.KIT_NAME_EXPRESS;
			addressLine1 = TestConstants.ADDRESS_LINE_1_US;
			newAddressLine1 = TestConstants.NEW_ADDRESS_LINE_1_US;
			city = TestConstants.CITY_US;
			postalCode = TestConstants.POSTAL_CODE_US;
			phoneNumber = TestConstants.PHONE_NUMBER_US;
		}

		storeFrontHomePage = new StoreFrontHomePage(driver);
		storeFrontHomePage.hoverOnBecomeAConsultantAndClickEnrollNowLink();
		storeFrontHomePage.searchCID();
		storeFrontHomePage.mouseHoverSponsorDataAndClickContinue();
		storeFrontHomePage.enterUserInformationForEnrollment(kitName, regimenName, enrollmentType, TestConstants.FIRST_NAME+randomNum, TestConstants.LAST_NAME+randomNum, password, addressLine1, city, postalCode, phoneNumber);
		storeFrontHomePage.clickEnrollmentNextBtn();
		//storeFrontHomePage.acceptTheVerifyYourShippingAddressPop();  
		storeFrontHomePage.enterCardNumber(TestConstants.CARD_NUMBER);
		storeFrontHomePage.enterNameOnCard(TestConstants.FIRST_NAME+randomNum);
		storeFrontHomePage.selectNewBillingCardExpirationDate();
		storeFrontHomePage.enterSecurityCode(TestConstants.SECURITY_CODE);
		storeFrontHomePage.enterSocialInsuranceNumber(socialInsuranceNumber);
		storeFrontHomePage.enterNameAsItAppearsOnCard(TestConstants.FIRST_NAME);
		storeFrontHomePage.clickEnrollmentNextBtn();
		s_assert.assertTrue(storeFrontHomePage.verifySubsribeToPulseCheckBoxIsSelected(), "Subscribe to pulse checkbox not selected");
		s_assert.assertTrue(storeFrontHomePage.verifyEnrollToCRPCheckBoxIsSelected(), "Enroll to CRP checkbox not selected");
		storeFrontHomePage.clickEnrollmentNextBtn();
		storeFrontHomePage.selectProductAndProceedToAddToCRP();
		storeFrontHomePage.addQuantityOfProduct("5");
		storeFrontHomePage.clickOnNextBtnAfterAddingProductAndQty();
		s_assert.assertTrue(storeFrontHomePage.isTheTermsAndConditionsCheckBoxDisplayed(), "Terms and Conditions checkbox is not visible");
		storeFrontHomePage.clickOnReviewAndConfirmShippingEditBtn();
		String newFirstName = TestConstants.FIRST_NAME+randomNum;
		String newLastName = TestConstants.LAST_NAME+randomNum;
		storeFrontHomePage.enterUserInformationForEnrollment(newFirstName, newLastName, password, newAddressLine1, city, postalCode, phoneNumber);
		storeFrontHomePage.clickNextButton();
		s_assert.assertTrue(storeFrontHomePage.isReviewAndConfirmPageContainsShippingAddress(newAddressLine1), "Shiiping address is not updated on Review and Confirm page after EDIT");
		s_assert.assertTrue(storeFrontHomePage.isReviewAndConfirmPageContainsFirstAndLastName(newFirstName+" "+newLastName), "First and last Name is not updated on Review and Confirm page after EDIT");
		storeFrontHomePage.checkThePoliciesAndProceduresCheckBox();
		storeFrontHomePage.checkTheIAcknowledgeCheckBox();  
		storeFrontHomePage.checkTheIAgreeCheckBox();
		storeFrontHomePage.clickOnEnrollMeBtn();
		s_assert.assertTrue(storeFrontHomePage.verifyPopUpForPoliciesAndProcedures(), "PopUp for policies and procedures is not visible");
		storeFrontHomePage.checkTheTermsAndConditionsCheckBox();
		storeFrontHomePage.clickOnChargeMyCardAndEnrollMeBtn();
		storeFrontHomePage.clickOnConfirmAutomaticPayment();
		s_assert.assertTrue(storeFrontHomePage.verifyCongratsMessage(), "Congrats Message is not visible");
		storeFrontHomePage.clickOnRodanAndFieldsLogo();
		s_assert.assertTrue(storeFrontHomePage.verifyWelcomeDropdownToCheckUserRegistered(), "User NOT registered successfully");
		s_assert.assertAll();
	}


	//Hybris Project-4281 :: Version : 1 :: Terminate User and Login with User Name
	@Test(enabled=false) //enabled false because it will terminate the user being used
	public void terminateUserAndLoginWithSameUsername_4281() throws InterruptedException{
		RFO_DB = driver.getDBNameRFO();	
		List<Map<String, Object>> randomConsultantList =  null;
		String consultantEmailID = TestConstants.CONSULTANT_USERNAME;
		String accountID = null;
		storeFrontHomePage = new StoreFrontHomePage(driver);

		/*while(true){
				randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.GET_RANDOM_ACTIVE_CONSULTANT_WITH_ORDERS_AND_AUTOSHIPS_RFO,RFO_DB);
				consultantEmailID = (String) getValueFromQueryResult(randomConsultantList, "UserName");		
				accountID = String.valueOf(getValueFromQueryResult(randomConsultantList, "AccountID"));
				logger.info("Account Id of the user is "+accountID);

				storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailID, password);
				boolean isSiteNotFoundPresent = driver.getCurrentUrl().contains("sitenotfound");
				if(isSiteNotFoundPresent){
					logger.info("SITE NOT FOUND for the user "+consultantEmailID);
					driver.get(driver.getURL());
				}
				else
					break;
			}

			s_assert.assertTrue(storeFrontConsultantPage.verifyConsultantPage(),"Consultant Page doesn't contain Welcome User Message");*/
		storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailID, password);
		logger.info("login is successful");
		storeFrontConsultantPage.clickOnWelcomeDropDown();
		storeFrontAccountInfoPage = storeFrontConsultantPage.clickAccountInfoLinkPresentOnWelcomeDropDown();
		storeFrontAccountTerminationPage = storeFrontAccountInfoPage.clickTerminateMyAccount();
		storeFrontAccountTerminationPage.fillTheEntriesAndClickOnSubmitDuringTermination();
		s_assert.assertTrue(storeFrontAccountTerminationPage.verifyAccountTerminationIsConfirmedPopup(), "Account still exist");
		storeFrontAccountTerminationPage.clickOnCloseWindowAfterTermination();
		storeFrontHomePage.clickOnCountryAtWelcomePage();
		storeFrontHomePage.loginAsConsultant(consultantEmailID, password);
		s_assert.assertTrue(storeFrontHomePage.isCurrentURLShowsError(),"Terminated User doesn't get Login failed");  
		s_assert.assertAll();
	}

	//Hybris Project-1976 :: Version : 1 :: Autoship Module. Check My Pulse UI 
	@Test
	public void testAutoshipModuleCheckMyPulseUI_1976() throws InterruptedException	 {
		RFO_DB = driver.getDBNameRFO();	
		List<Map<String, Object>> randomConsultantList =  null;
		String consultantEmailID = TestConstants.CONSULTANT_USERNAME;
		String accountID = null;
		storeFrontHomePage = new StoreFrontHomePage(driver);

		/*while(true){
				randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.GET_RANDOM_ACTIVE_CONSULTANT_WITH_ORDERS_AND_AUTOSHIPS_RFO,RFO_DB);
				consultantEmailID = (String) getValueFromQueryResult(randomConsultantList, "UserName");		
				accountID = String.valueOf(getValueFromQueryResult(randomConsultantList, "AccountID"));
				logger.info("Account Id of the user is "+accountID);

				storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailID, password);
				boolean isSiteNotFoundPresent = driver.getCurrentUrl().contains("sitenotfound");
				if(isSiteNotFoundPresent){
					logger.info("SITE NOT FOUND for the user "+consultantEmailID);
					driver.get(driver.getURL());
				}
				else
					break;
			}*/
		storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailID, password);
		//s_assert.assertTrue(storeFrontConsultantPage.verifyConsultantPage(),"Consultant Page doesn't contain Welcome User Message");
		logger.info("login is successful");
		//goto check my pulse
		storeFrontConsultantPage.clickOnWelcomeDropDown();
		storeFrontConsultantPage.clickCheckMyPulseLinkPresentOnWelcomeDropDown();
		//pass driver control to child window
		storeFrontConsultantPage.switchToChildWindow();
		//validate home page for pulse
		s_assert.assertTrue(storeFrontConsultantPage.validatePulseHomePage(),"Home Page for pulse is not displayed");
		storeFrontConsultantPage.switchToPreviousTab();
		s_assert.assertAll();
	}

	//Hybris Project-4161 :: Version : 1 :: During enrollment customer not opt for pulse but they still able to access the pws as a trial version 
	@Test
	public void testCustomerEnrollWithoutPulseCanAccessPws_4161() throws InterruptedException{
		int randomNum = CommonUtils.getRandomNum(10000, 1000000);
		String socialInsuranceNumber = String.valueOf(CommonUtils.getRandomNum(100000000, 999999999));
		country = driver.getCountry();
		enrollmentType = TestConstants.EXPRESS_ENROLLMENT;
		regimenName = TestConstants.REGIMEN_NAME_UNBLEMISH;
		String firstName = TestConstants.FIRST_NAME+randomNum;

		if(country.equalsIgnoreCase("CA")){
			kitName = TestConstants.KIT_NAME_EXPRESS;    
			addressLine1 = TestConstants.ADDRESS_LINE_1_CA;
			city = TestConstants.CITY_CA;
			postalCode = TestConstants.POSTAL_CODE_CA;
			phoneNumber = TestConstants.PHONE_NUMBER_CA;
		}else{
			kitName = TestConstants.KIT_NAME_EXPRESS;
			addressLine1 = TestConstants.ADDRESS_LINE_1_US;
			city = TestConstants.CITY_US;
			postalCode = TestConstants.POSTAL_CODE_US;
			phoneNumber = TestConstants.PHONE_NUMBER_US;
		}

		storeFrontHomePage = new StoreFrontHomePage(driver);
		//storeFrontConsultantPage=new StoreFrontConsultantPage(driver);
		storeFrontHomePage.hoverOnBecomeAConsultantAndClickEnrollNowLink();
		storeFrontHomePage.searchCID();
		storeFrontHomePage.mouseHoverSponsorDataAndClickContinue();
		storeFrontHomePage.enterUserInformationForEnrollment(kitName, regimenName, enrollmentType, firstName, TestConstants.LAST_NAME+randomNum, password, addressLine1, city, postalCode, phoneNumber);
		storeFrontHomePage.clickNextButton();
		storeFrontHomePage.enterCardNumber(TestConstants.CARD_NUMBER);
		storeFrontHomePage.enterNameOnCard(TestConstants.FIRST_NAME+randomNum);
		storeFrontHomePage.selectNewBillingCardExpirationDate();
		storeFrontHomePage.enterSecurityCode(TestConstants.SECURITY_CODE);
		storeFrontHomePage.enterSocialInsuranceNumber(socialInsuranceNumber);
		storeFrontHomePage.enterNameAsItAppearsOnCard(TestConstants.FIRST_NAME);
		storeFrontHomePage.clickEnrollmentNextBtn();
		storeFrontHomePage.checkThePoliciesAndProceduresCheckBox();
		storeFrontHomePage.checkTheIAcknowledgeCheckBox();  
		storeFrontHomePage.checkTheIAgreeCheckBox();
		storeFrontHomePage.checkTheTermsAndConditionsCheckBox();
		storeFrontHomePage.clickOnChargeMyCardAndEnrollMeBtn();
		storeFrontHomePage.clickOnConfirmAutomaticPayment();
		s_assert.assertTrue(storeFrontHomePage.verifyCongratsMessage(), "Congrats Message is not visible");
		//validate on the confirmation page user lands on .biz site
		s_assert.assertTrue(storeFrontHomePage.validateUserLandsOnPWSbizSite(), "user didn't land on PWS .biz site");
		storeFrontHomePage.clickOnRodanAndFieldsLogo();
		//Fetch the PWS url
		String currentPWSUrl=driver.getCurrentUrl();
		s_assert.assertTrue(storeFrontHomePage.verifyWelcomeDropdownToCheckUserRegistered(), "User NOT registered successfully");
		//s_assert.assertTrue(storeFrontHomePage.getUserNameAForVerifyLogin(firstName).contains(firstName),"Profile Name After Login"+firstName+" and on UI is "+storeFrontHomePage.getUserNameAForVerifyLogin(firstName));
		logout();
		//validate with the current PWSUrl on .com site
		driver.get(storeFrontHomePage.navigateToCommercialWebsite(currentPWSUrl));
		s_assert.assertTrue(storeFrontHomePage.validatePWS(), "PWS is not active");  
		s_assert.assertAll();
	}

	// Hybris Project-1306 :: Version : 1 :: Biz: PC Enroll- Not my sponsor link 
	@Test(enabled=true) //WIP
	public void testPCEnrollNotMySponsorLink_1306() throws InterruptedException	 {
		int randomNum = CommonUtils.getRandomNum(10000, 1000000);  
		String newBillingProfileName = TestConstants.NEW_BILLING_PROFILE_NAME+randomNum;
		String lastName = "lN";
		String firstName = TestConstants.FIRST_NAME+randomNum;
		storeFrontHomePage = new StoreFrontHomePage(driver);
		// Click on our product link that is located at the top of the page and then click in on quick shop
		/*storeFrontHomePage.clickOnShopLink();
			storeFrontHomePage.clickOnAllProductsLink();*/
		storeFrontHomePage.hoverOnShopLinkAndClickAllProductsLinksAfterLogin();
		// Products are displayed?
		s_assert.assertTrue(storeFrontHomePage.areProductsDisplayed(), "quickshop products not displayed");
		logger.info("Quick shop products are displayed");
		storeFrontHomePage.selectProductAndProceedToBuy();
		//Cart page is displayed?
		s_assert.assertTrue(storeFrontHomePage.isCartPageDisplayed(), "Cart page is not displayed");
		logger.info("Cart page is displayed");

		//Click on Check out
		storeFrontHomePage.clickOnCheckoutButton();
		//Log in or create an account page is displayed?
		s_assert.assertTrue(storeFrontHomePage.isLoginOrCreateAccountPageDisplayed(), "Login or Create Account page is NOT displayed");
		logger.info("Login or Create Account page is displayed");
		//Enter the User information and DO check the "Become a Preferred Customer" checkbox and click the create account button
		storeFrontHomePage.enterNewPCDetails(firstName, TestConstants.LAST_NAME+randomNum, password);
		storeFrontHomePage.enterMainAccountInfo();
		storeFrontHomePage.clickOnRequestASponsorBtn();
		storeFrontHomePage.clickOnNotYourSponsorLink();
		storeFrontHomePage.clickOKOnSponsorInformationPopup();
		storeFrontHomePage.searchCIDForPCAndRC();
		storeFrontHomePage.mouseHoverSponsorDataAndClickContinueForPCAndRC();

		storeFrontHomePage.clickOnNextButtonAfterSelectingSponsor();
		storeFrontHomePage.clickOnShippingAddressNextStepBtn();
		//Enter Billing Profile
		storeFrontHomePage.enterNewBillingCardNumber(TestConstants.CARD_NUMBER);
		storeFrontHomePage.enterNewBillingNameOnCard(newBillingProfileName+" "+lastName);
		storeFrontHomePage.selectNewBillingCardExpirationDate();
		storeFrontHomePage.enterNewBillingSecurityCode(TestConstants.SECURITY_CODE);
		storeFrontHomePage.selectNewBillingCardAddress();
		storeFrontHomePage.clickOnSaveBillingProfile();
		storeFrontHomePage.clickOnBillingNextStepBtn();
		s_assert.assertTrue(storeFrontHomePage.validatePCPerksCheckBoxIsDisplayed());
		storeFrontHomePage.clickPlaceOrderBtn();
		s_assert.assertTrue(storeFrontHomePage.verifyPCPerksTermsAndConditionsPopup(),"PC Perks terms and conditions popup not visible when checkboxes for t&c not selected and place order button clicked");
		logger.info("PC Perks terms and conditions popup is visible when checkboxes for t&c not selected and place order button clicked");
		storeFrontHomePage.clickOnPCPerksTermsAndConditionsCheckBoxes();
		storeFrontHomePage.clickPlaceOrderBtn();
		storeFrontHomePage.switchToPreviousTab();
		storeFrontHomePage.switchToPreviousTab();
		storeFrontHomePage.clickOnRodanAndFieldsLogo();
		s_assert.assertTrue(storeFrontHomePage.verifyWelcomeDropdownToCheckUserRegistered(), "User NOT registered successfully");
		//s_assert.assertTrue(storeFrontHomePage.getUserNameAForVerifyLogin(firstName).contains(firstName),"Profile Name After Login"+firstName+" and on UI is "+storeFrontHomePage.getUserNameAForVerifyLogin(firstName));
		s_assert.assertAll(); 
	}

	// Hybris Project-2153 :: Version : 1 :: Check the shipping method disclaimers for " UPS Standard Overnight/FedEx Standard Overnight" 
	@Test(enabled=true) //WIP
	public void testCheckShippingMethodDisclaimersForUPSStandardOvernight_2153() throws InterruptedException	 {
		int randomNum = CommonUtils.getRandomNum(10000, 1000000);
		String socialInsuranceNumber = String.valueOf(CommonUtils.getRandomNum(100000000, 999999999));
		country = driver.getCountry();
		enrollmentType = TestConstants.EXPRESS_ENROLLMENT;
		regimenName = TestConstants.REGIMEN_NAME_UNBLEMISH;

		if(country.equalsIgnoreCase("CA")){
			kitName = TestConstants.KIT_NAME_EXPRESS;    
			addressLine1 = TestConstants.ADDRESS_LINE_1_CA;
			city = TestConstants.CITY_CA;
			postalCode = TestConstants.POSTAL_CODE_CA;
			phoneNumber = TestConstants.PHONE_NUMBER_CA;
		}else{
			kitName = TestConstants.KIT_NAME_EXPRESS;
			addressLine1 = TestConstants.ADDRESS_LINE_1_US;
			city = TestConstants.CITY_US;
			postalCode = TestConstants.POSTAL_CODE_US;
			phoneNumber = TestConstants.PHONE_NUMBER_US;
		}

		storeFrontHomePage = new StoreFrontHomePage(driver);
		//storeFrontConsultantPage=new StoreFrontConsultantPage(driver);
		storeFrontHomePage.hoverOnBecomeAConsultantAndClickEnrollNowLink();
		storeFrontHomePage.searchCID();
		storeFrontHomePage.mouseHoverSponsorDataAndClickContinue();
		storeFrontHomePage.enterUserInformationForEnrollment(kitName, regimenName, enrollmentType, TestConstants.FIRST_NAME+randomNum, TestConstants.LAST_NAME+randomNum, password, addressLine1, city, postalCode, phoneNumber);
		storeFrontHomePage.clickNextButton();
		storeFrontHomePage.enterCardNumber(TestConstants.CARD_NUMBER);
		storeFrontHomePage.enterNameOnCard(TestConstants.FIRST_NAME+randomNum);
		storeFrontHomePage.selectNewBillingCardExpirationDate();
		storeFrontHomePage.enterSecurityCode(TestConstants.SECURITY_CODE);
		storeFrontHomePage.enterSocialInsuranceNumber(socialInsuranceNumber);
		storeFrontHomePage.enterNameAsItAppearsOnCard(TestConstants.FIRST_NAME);
		storeFrontHomePage.clickEnrollmentNextBtn(); 
		// Check the shipping method disclaimers for " UPS Ground (HD)/FedEx Standard Overnight" as Consultant on Checkout screen>>Shipment section
		s_assert.assertTrue(storeFrontHomePage.validateShippingMethodDisclaimersForUPSGroundHD());
		s_assert.assertAll(); 
	}

	// Hybris Project-1305:From Corporate user should able to change sponsor RC
	@Test
	public void testCorporateUserShouldAbleToChangeSponsorRC_1305() throws InterruptedException	 {
		int randomNum = CommonUtils.getRandomNum(10000, 1000000);  
		String newBillingProfileName = TestConstants.NEW_BILLING_PROFILE_NAME+randomNum;
		String firstName=TestConstants.FIRST_NAME+randomNum;
		String lastName = "lN";
		storeFrontHomePage = new StoreFrontHomePage(driver);
		// Click on our product link that is located at the top of the page and then click in on quick shop
		/*storeFrontHomePage.clickOnShopLink();
			storeFrontHomePage.clickOnAllProductsLink();*/
		storeFrontHomePage.hoverOnShopLinkAndClickAllProductsLinksAfterLogin();
		// Products are displayed?
		s_assert.assertTrue(storeFrontHomePage.areProductsDisplayed(), "quickshop products not displayed");
		logger.info("Quick shop products are displayed");
		storeFrontHomePage.selectProductAndProceedToBuy();
		//Cart page is displayed?
		s_assert.assertTrue(storeFrontHomePage.isCartPageDisplayed(), "Cart page is not displayed");
		logger.info("Cart page is displayed");

		//Click on Check out
		storeFrontHomePage.clickOnCheckoutButton();
		//Log in or create an account page is displayed?
		s_assert.assertTrue(storeFrontHomePage.isLoginOrCreateAccountPageDisplayed(), "Login or Create Account page is NOT displayed");
		logger.info("Login or Create Account page is displayed");
		//Enter the User information and DO NOT check the "Become a Preferred Customer" checkbox and click the create account button
		storeFrontHomePage.enterNewRCDetails(firstName, TestConstants.LAST_NAME+randomNum, password);
		storeFrontHomePage.enterMainAccountInfo();
		//Enter Invalid sponsor id & name and validate error message
		storeFrontHomePage.enterSponsorIdDuringCreationOfPC(TestConstants.INVALID_SPONSOR_ID);
		s_assert.assertTrue(storeFrontHomePage.validateInvalidSponsor(), "Invalid sponsor ID accepted");
		storeFrontHomePage.clickSearchAgain();

		storeFrontHomePage.enterSponsorIdDuringCreationOfPC(TestConstants.INVALID_SPONSOR_NAME);
		s_assert.assertTrue(storeFrontHomePage.validateInvalidSponsor(), "Invalid sponsor Name accepted");
		storeFrontHomePage.clickSearchAgain();

		storeFrontHomePage.searchCIDForPCAndRC();
		storeFrontHomePage.mouseHoverSponsorDataAndClickContinueForPCAndRC();

		storeFrontHomePage.clickOnNextButtonAfterSelectingSponsor();
		storeFrontHomePage.clickOnShippingAddressNextStepBtn();
		//Enter Billing Profile
		storeFrontHomePage.enterNewBillingCardNumber(TestConstants.CARD_NUMBER);
		storeFrontHomePage.enterNewBillingNameOnCard(newBillingProfileName+" "+lastName);
		storeFrontHomePage.selectNewBillingCardExpirationDate();
		storeFrontHomePage.enterNewBillingSecurityCode(TestConstants.SECURITY_CODE);
		storeFrontHomePage.selectNewBillingCardAddress();
		storeFrontHomePage.clickOnSaveBillingProfile();
		storeFrontHomePage.clickOnBillingNextStepBtn();
		//validate pc perks terms and condition check box is displayed
		s_assert.assertTrue(storeFrontHomePage.validatePCPerksCheckBoxIsDisplayed());
		//check the check box
		storeFrontHomePage.checkPCPerksCheckBox();
		storeFrontHomePage.clickOnShippingAddressNextStepBtn();
		storeFrontHomePage.clickOnBillingNextStepBtn();
		storeFrontHomePage.clickPlaceOrderBtn();
		s_assert.assertTrue(storeFrontHomePage.verifyPCPerksTermsAndConditionsPopup(),"PC Perks terms and conditions popup not visible when checkboxes for t&c not selected and place order button clicked");
		logger.info("PC Perks terms and conditions popup is visible when checkboxes for t&c not selected and place order button clicked");
		storeFrontHomePage.clickOnPCPerksTermsAndConditionsCheckBoxes();
		storeFrontHomePage.clickPlaceOrderBtn();
		storeFrontHomePage.switchToPreviousTab();
		storeFrontHomePage.switchToPreviousTab();
		storeFrontHomePage.clickOnRodanAndFieldsLogo();
		s_assert.assertTrue(storeFrontHomePage.verifyWelcomeDropdownToCheckUserRegistered(), "User NOT registered successfully");
		//s_assert.assertTrue(storeFrontHomePage.getUserNameAForVerifyLogin(firstName).contains(firstName),"Profile Name After Login"+firstName+" and on UI is "+storeFrontHomePage.getUserNameAForVerifyLogin(firstName));
		s_assert.assertAll(); 
	}

	//Hybris Project-2489:Verify if Consultant can use same prefix, when he is subscribing to pulse. ( Consultant's trial version)
	@Test
	public void testVerifyConsultantCanUseSamePrefixWhenSubscribingToPulse_2489() throws InterruptedException	  {
		int randomNum = CommonUtils.getRandomNum(10000, 1000000);
		String socialInsuranceNumber = String.valueOf(CommonUtils.getRandomNum(100000000, 999999999));
		country = driver.getCountry();
		String firstName=TestConstants.FIRST_NAME+randomNum;
		enrollmentType = TestConstants.STANDARD_ENROLLMENT;
		regimenName = TestConstants.REGIMEN_NAME_UNBLEMISH;

		if(country.equalsIgnoreCase("CA")){
			kitName = TestConstants.KIT_NAME_EXPRESS;    
			addressLine1 = TestConstants.ADDRESS_LINE_1_CA;
			city = TestConstants.CITY_CA;
			postalCode = TestConstants.POSTAL_CODE_CA;
			phoneNumber = TestConstants.PHONE_NUMBER_CA;
		}else{
			kitName = TestConstants.KIT_NAME_EXPRESS;
			addressLine1 = TestConstants.NEW_ADDRESS_LINE_1_US;
			city = TestConstants.CITY_US;
			postalCode = TestConstants.POSTAL_CODE_US;
			phoneNumber = TestConstants.PHONE_NUMBER_US;
		}

		storeFrontHomePage = new StoreFrontHomePage(driver);
		storeFrontConsultantPage=new StoreFrontConsultantPage(driver);
		storeFrontHomePage.hoverOnBecomeAConsultantAndClickEnrollNowLink();
		storeFrontHomePage.searchCID();
		storeFrontHomePage.mouseHoverSponsorDataAndClickContinue();
		storeFrontHomePage.enterUserInformationForEnrollment(kitName, regimenName, enrollmentType, firstName, TestConstants.LAST_NAME+randomNum, password, addressLine1, city, postalCode, phoneNumber);
		storeFrontHomePage.clickNextButton();
		storeFrontHomePage.enterCardNumber(TestConstants.CARD_NUMBER);
		storeFrontHomePage.enterNameOnCard(TestConstants.FIRST_NAME+randomNum);
		storeFrontHomePage.selectNewBillingCardExpirationDate();
		storeFrontHomePage.enterSecurityCode(TestConstants.SECURITY_CODE);
		storeFrontHomePage.enterSocialInsuranceNumber(socialInsuranceNumber);
		storeFrontHomePage.enterNameAsItAppearsOnCard(TestConstants.FIRST_NAME);
		storeFrontHomePage.clickEnrollmentNextBtn();
		storeFrontHomePage.uncheckPulseAndCRPEnrollment();
		storeFrontHomePage.clickEnrollmentNextBtn();
		storeFrontHomePage.checkThePoliciesAndProceduresCheckBox();
		storeFrontHomePage.checkTheIAcknowledgeCheckBox();  
		storeFrontHomePage.checkTheIAgreeCheckBox();
		storeFrontHomePage.checkTheTermsAndConditionsCheckBox();
		storeFrontHomePage.clickOnChargeMyCardAndEnrollMeBtn();
		// storeFrontHomePage.clickOnConfirmAutomaticPayment();
		s_assert.assertTrue(storeFrontHomePage.verifyCongratsMessage(), "Congrats Message is not visible");
		//validate on the confirmation page user lands on .biz site
		//s_assert.assertTrue(storeFrontHomePage.validateUserLandsOnPWSbizSite(), "user didn't land on PWS .biz site");
		storeFrontHomePage.clickOnRodanAndFieldsLogo();
		//Fetch the PWS url
		//String currentPWSUrl=driver.getCurrentUrl();
		s_assert.assertTrue(storeFrontHomePage.verifyWelcomeDropdownToCheckUserRegistered(), "User NOT registered successfully");
		//s_assert.assertTrue(storeFrontHomePage.getUserNameAForVerifyLogin(firstName).contains(firstName),"Profile Name After Login"+firstName+" and on UI is "+storeFrontHomePage.getUserNameAForVerifyLogin(firstName));
		//goto .com site and navigate to Account Info->Autoship tatus->Cancel pulse subscription
		storeFrontConsultantPage.clickOnWelcomeDropDown();
		storeFrontConsultantPage.clickAccountInfoLinkPresentOnWelcomeDropDown();
		storeFrontHomePage.clickOnYourAccountDropdown();
		storeFrontConsultantPage.clickOnAutoshipStatusLink();
		storeFrontConsultantPage.subscribeToPulse();
		//verify default pulse prefix suggestions
		s_assert.assertTrue(storeFrontConsultantPage.validatePulsePrefixSuggestionsAvailable(), "pulse prefix suggestions are not available");
		s_assert.assertAll(); 
	}

	// Hybris Phase 2-2047 :: Version : 1 :: Edit billing profile on 'Billing Profile' page 
	@Test(enabled=true) //WIP
	public void testEditBillingProfileOnBillingProfilePage_2047() throws InterruptedException, SQLException{
		int randomNum = CommonUtils.getRandomNum(10000, 1000000);
		RFO_DB = driver.getDBNameRFO(); 

		List<Map<String, Object>> randomConsultantList =  null;
		String consultantEmailID = TestConstants.CONSULTANT_USERNAME;
		String accountID = null;

		String newBillingProfileName = TestConstants.NEW_BILLING_PROFILE_NAME_US+randomNum;
		String lastName = "lN";
		/*while(true){
		   randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.GET_RANDOM_ACTIVE_CONSULTANT_WITH_ORDERS_AND_AUTOSHIPS_RFO,RFO_DB);
		   consultantEmailID = (String) getValueFromQueryResult(randomConsultantList, "UserName");  
		   accountID = String.valueOf(getValueFromQueryResult(randomConsultantList, "AccountID"));
		   logger.info("Account Id of the user is "+accountID);

		   storeFrontHomePage = new StoreFrontHomePage(driver);
		   storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailID, password);
		   boolean isSiteNotFoundPresent = driver.getCurrentUrl().contains("sitenotfound");
		   if(isSiteNotFoundPresent){
		    logger.info("SITE NOT FOUND for the user "+consultantEmailID);
		    driver.get(driver.getURL());
		   }
		   else
		    break;
		  }*/
		storeFrontHomePage = new StoreFrontHomePage(driver);
		storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailID, password);
		//s_assert.assertTrue(storeFrontConsultantPage.verifyConsultantPage(),"Consultant Page doesn't contain Welcome User Message");
		logger.info("login is successful");

		storeFrontConsultantPage.clickOnWelcomeDropDown();
		storeFrontBillingInfoPage = storeFrontConsultantPage.clickBillingInfoLinkPresentOnWelcomeDropDown();
		s_assert.assertTrue(storeFrontBillingInfoPage.verifyBillingInfoPageIsDisplayed(),"Billing Info page has not been displayed");

		storeFrontBillingInfoPage.clickOnEditBillingProfile();
		storeFrontBillingInfoPage.enterNewBillingNameOnCard(newBillingProfileName+" "+lastName);
		storeFrontBillingInfoPage.enterNewBillingCardNumber(TestConstants.CARD_NUMBER);
		storeFrontBillingInfoPage.selectNewBillingCardExpirationDate();
		storeFrontBillingInfoPage.enterNewBillingSecurityCode(TestConstants.SECURITY_CODE);
		storeFrontBillingInfoPage.selectNewBillingCardAddress();
		storeFrontBillingInfoPage.selectUseThisBillingProfileFutureAutoshipChkbox();
		storeFrontBillingInfoPage.clickOnSaveBillingProfile();

		//--------------- Verify that Newly edited Billing profile is listed in the Billing profiles section-----------------------------------------------------------------------------------------------------

		s_assert.assertTrue(storeFrontBillingInfoPage.isTheBillingAddressPresentOnPage(newBillingProfileName),"Newly edited Billing profile is NOT listed on the page");

		//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		storeFrontConsultantPage.clickOnWelcomeDropDown();
		storeFrontOrdersPage = storeFrontConsultantPage.clickOrdersLinkPresentOnWelcomeDropDown();
		storeFrontOrdersPage.clickAutoshipOrderNumber();

		//------------------ Verify that autoship template contains the newly edited billing profile------------------------------------------------------------		

		s_assert.assertTrue(storeFrontOrdersPage.isPaymentMethodContainsName(newBillingProfileName),"Autoship Template Payment Method doesn't contains the newly edited billing profile when future autoship checkbox is selected");

		//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


		storeFrontConsultantPage.clickOnWelcomeDropDown();
		storeFrontOrdersPage = storeFrontConsultantPage.clickOrdersLinkPresentOnWelcomeDropDown();
		storeFrontOrdersPage.clickOnFirstAdHocOrder();

		//------------------ Verify that adhoc orders template doesn't contains the newly edited billing profile ------------------------------------------------------------

		s_assert.assertFalse(storeFrontOrdersPage.isPaymentMethodContainsName(newBillingProfileName),"AdHoc Orders Template Payment Method contains the newly edited billing profile when future autoship checkbox is selected");

		//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		storeFrontConsultantPage.clickOnWelcomeDropDown();
		storeFrontCartAutoShipPage = storeFrontConsultantPage.clickEditCrpLinkPresentOnWelcomeDropDown();
		storeFrontUpdateCartPage = storeFrontCartAutoShipPage.clickUpdateMoreInfoLink();
		storeFrontUpdateCartPage.clickOnEditPaymentBillingProfile();
		s_assert.assertTrue(storeFrontUpdateCartPage.isNewBillingProfileIsSelectedByDefault(newBillingProfileName),"New Billing Profile is not selected by default on CRP cart page");
		storeFrontConsultantPage = storeFrontUpdateCartPage.clickRodanAndFieldsLogo();
		s_assert.assertAll();
	}


	//Hybris Project-93 :: Version : 1 :: Express Enrollment Billing Profile Main Account Info - Edit 
	@Test
	public void testExpressEnrollmentBillingProfileMainAccountInfoEdit_93() throws InterruptedException	{
		int randomNum = CommonUtils.getRandomNum(10000, 1000000);
		String socialInsuranceNumber = String.valueOf(CommonUtils.getRandomNum(100000000, 999999999));
		country = driver.getCountry();
		enrollmentType = TestConstants.EXPRESS_ENROLLMENT;
		regimenName = TestConstants.REGIMEN_NAME_REDEFINE;

		if(country.equalsIgnoreCase("CA")){
			kitName = TestConstants.KIT_NAME_EXPRESS;    
			addressLine1 = TestConstants.ADDRESS_LINE_1_CA;
			city = TestConstants.CITY_CA;
			postalCode = TestConstants.POSTAL_CODE_CA;
			phoneNumber = TestConstants.PHONE_NUMBER_CA;
		}else{
			kitName = TestConstants.KIT_NAME_EXPRESS;
			addressLine1 = TestConstants.NEW_ADDRESS_LINE_1_US;
			city = TestConstants.CITY_US;
			postalCode = TestConstants.POSTAL_CODE_US;
			phoneNumber = TestConstants.PHONE_NUMBER_US;
		}

		storeFrontHomePage = new StoreFrontHomePage(driver);
		storeFrontHomePage.hoverOnBecomeAConsultantAndClickEnrollNowLink();
		storeFrontHomePage.searchCID();
		storeFrontHomePage.mouseHoverSponsorDataAndClickContinue();
		storeFrontHomePage.enterUserInformationForEnrollment(kitName, regimenName, enrollmentType, TestConstants.FIRST_NAME+randomNum, TestConstants.LAST_NAME+randomNum, password, addressLine1, city, postalCode, phoneNumber);
		storeFrontHomePage.clickNextButton();
		storeFrontHomePage.enterCardNumber(TestConstants.CARD_NUMBER);
		storeFrontHomePage.enterNameOnCard(TestConstants.FIRST_NAME+randomNum);
		storeFrontHomePage.selectNewBillingCardExpirationDate();
		storeFrontHomePage.enterSecurityCode(TestConstants.SECURITY_CODE);
		storeFrontHomePage.enterSocialInsuranceNumber(socialInsuranceNumber);
		storeFrontHomePage.enterNameAsItAppearsOnCard(TestConstants.FIRST_NAME);
		storeFrontHomePage.clickEnrollmentNextBtn();
		//click edit next to main account info and validate setup account page is displayed
		storeFrontHomePage.clickOnReviewAndConfirmShippingEditBtn();
		s_assert.assertTrue(storeFrontHomePage.validateSetUpAccountPageIsDisplayed(), "SetUp account page is not displayed");
		//Edit contact Info and re-enter password
		storeFrontHomePage.reEnterContactInfoAndPassword();
		//validate updated Account Info Details on review and confirmation page
		s_assert.assertTrue(storeFrontHomePage.validateUpdatedMainAccountInfo());
		storeFrontHomePage.checkThePoliciesAndProceduresCheckBox();
		storeFrontHomePage.checkTheIAcknowledgeCheckBox();  
		storeFrontHomePage.checkTheIAgreeCheckBox();
		storeFrontHomePage.checkTheTermsAndConditionsCheckBox();
		storeFrontHomePage.clickOnChargeMyCardAndEnrollMeBtn();
		storeFrontHomePage.clickOnConfirmAutomaticPayment();
		s_assert.assertTrue(storeFrontHomePage.verifyCongratsMessage(), "Congrats Message is not visible");
		s_assert.assertAll(); 
	}

	// Hybris Project-143:CRP Template - Check Threshold by Add/remove products and increase/decrease qty
	@Test(enabled=false) //WIP 
	public void testCheckThresholdByAddRemoveProductsAndIncreaseDecreaseQty_143() throws InterruptedException	{
		String QtyOfProducts="10";
		RFO_DB = driver.getDBNameRFO(); 
		List<Map<String, Object>> randomConsultantList =  null;
		String consultantEmailID = TestConstants.CONSULTANT_USERNAME;
		String accountID = null;
		storeFrontHomePage = new StoreFrontHomePage(driver);

		/*while(true){
	      randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.GET_RANDOM_ACTIVE_CONSULTANT_WITH_ORDERS_AND_AUTOSHIPS_RFO,RFO_DB);
	      consultantEmailID = (String) getValueFromQueryResult(randomConsultantList, "UserName");  
	      accountID = String.valueOf(getValueFromQueryResult(randomConsultantList, "AccountID"));
	      logger.info("Account Id of the user is "+accountID);

	      storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailID, password);
	      boolean isSiteNotFoundPresent = driver.getCurrentUrl().contains("sitenotfound");
	      if(isSiteNotFoundPresent){
	       logger.info("SITE NOT FOUND for the user "+consultantEmailID);
	       driver.get(driver.getURL());
	      }
	      else
	       break;
	     }*/
		storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailID, password);
		//s_assert.assertTrue(storeFrontConsultantPage.verifyConsultantPage(),"Consultant Page doesn't contain Welcome User Message");
		logger.info("login is successful"); 
		//click on auto ship cart
		storeFrontHomePage.clickOnAutoshipCart();
		//validate update Cart page is displayed
		s_assert.assertTrue(storeFrontHomePage.validateUpdateCartPageIsDisplayed(),"update cart page is not displayed");
		//click on continue shopping link
		storeFrontHomePage.clickOnContinueShoppingLink();
		//add a product and add it to crp
		storeFrontHomePage.selectAProductAndAddItToCRP();
		//validate auto ship update cart message
		s_assert.assertTrue(storeFrontHomePage.validateAutoshipTemplateUpdatedMsg(),"auto ship update cart message is not displayed");
		//click on continue shopping link
		storeFrontHomePage.clickOnContinueShoppingLink();
		//add a product and add it to crp
		storeFrontHomePage.selectAProductAndAddItToCRP();
		//validate auto ship update cart message
		s_assert.assertTrue(storeFrontHomePage.validateAutoshipTemplateUpdatedMsg(),"auto ship update cart message is not displayed");
		//Remove product(s) until SV is less than threshold (100 SV) and validate the error mesaage
		s_assert.assertTrue(storeFrontHomePage.validateRemoveProductsTillErrorMsgIsDisplayed(),"Error message is not being displayed");
		//update the product Qty by Increasing it and validate the  auto ship update cart message
		storeFrontHomePage.addQuantityOfProduct(QtyOfProducts);
		s_assert.assertTrue(storeFrontHomePage.validateAutoshipTemplateUpdatedMsg(),"auto ship update cart message is not displayed");
		//update the product Qty Decreasing it and validate the  Error message
		s_assert.assertTrue(storeFrontHomePage.validateRemoveProductsTillErrorMsgIsDisplayed(),"Error message is not being displayed");
		s_assert.assertAll(); 
	}

	// Hybris Project-142 Autoship template - manage products in cart - PC perk 
	@Test(enabled=false) //WIP
	public void testAutoshipTemplateManagePoductsInCartPCPerk_142() throws InterruptedException	{
		String QtyOfProducts="10";
		RFO_DB = driver.getDBNameRFO();
		List<Map<String, Object>> randomPCUserList =  null;
		String pcUserEmailID = TestConstants.PC_USERNAME;
		String accountID = null;
		storeFrontHomePage = new StoreFrontHomePage(driver);
		/*   while(true){
	    randomPCUserList = DBUtil.performDatabaseQuery(DBQueries_RFL.GET_RANDOM_ACTIVE_PC_WITH_ORDERS_AND_AUTOSHIPS_RFL,RFL_DB);
	    pcUserEmailID = (String) getValueFromQueryResult(randomPCUserList, "UserName");
	    accountID = String.valueOf(getValueFromQueryResult(randomPCUserList, "AccountID"));
	    logger.info("Account Id of the user is "+accountID);  

	    storeFrontHomePage = new StoreFrontHomePage(driver);
	    storeFrontPCUserPage = storeFrontHomePage.loginAsPCUser(pcUserEmailID, password);
	    boolean isSiteNotFoundPresent = driver.getCurrentUrl().contains("sitenotfound");
	    if(isSiteNotFoundPresent){
	     logger.info("SITE NOT FOUND for the user "+pcUserEmailID);
	     driver.get(driver.getURL());
	    }
	    else
	     break;*/
		storeFrontPCUserPage=storeFrontHomePage.loginAsPCUser(pcUserEmailID, password);
		logger.info("login is successful"); 
		//click on auto ship cart
		storeFrontHomePage.clickOnAutoshipCart();
		//validate update pc perks cart page is displayed
		s_assert.assertTrue(storeFrontHomePage.validateUpdateCartPageIsDisplayed(),"pc perks update cart page is not displayed");
		//click on continue shopping link
		storeFrontHomePage.clickOnContinueShoppingLink();
		//add a product and add it to pc perks
		storeFrontHomePage.selectAProductAndAddItToPCPerks();
		//validate pc perks update cart message
		s_assert.assertTrue(storeFrontHomePage.validateAutoshipTemplateUpdatedMsg(),"pc perks update cart message is not displayed");
		//click on continue shopping link
		storeFrontHomePage.clickOnContinueShoppingLink();
		//add a product and add it to pc perks
		storeFrontHomePage.selectAProductAndAddItToPCPerks();
		//validate pc perks update cart message
		s_assert.assertTrue(storeFrontHomePage.validateAutoshipTemplateUpdatedMsg(),"pc perks update cart message is not displayed");
		//Remove products until SV is less than threshold US - SV is less than $80 CA - SV is less than CAD $90
		s_assert.assertTrue(storeFrontHomePage.validateErrorMsgAfterRemovingProductsFromPcCart(),"Error message is not being displayed");
		//update the product Qty by Increasing it and validate the  pc perks update cart message
		storeFrontHomePage.addQuantityOfProduct(QtyOfProducts);
		s_assert.assertTrue(storeFrontHomePage.validateAutoshipTemplateUpdatedMsgAfterIncreasingQtyOfProducts(),"pc perks update cart message is not displayed");
		//update the product Qty Decreasing it and validate the  Error message
		s_assert.assertTrue(storeFrontHomePage.validateErrorMsgAfterRemovingProductsFromPcCart(),"Error message is not being displayed");
		s_assert.assertAll(); 
	}

	//Hybris Project-4350:Verify "Join my team" button on the .com and .biz site
	@Test
	public void testJoinMyTeamButtonPresentOnTheComAndBizSite_4350(){
		country = driver.getCountry();
		env = driver.getEnvironment();		
		storeFrontHomePage = new StoreFrontHomePage(driver);
		String bizPws = storeFrontHomePage.getBizPWS(country, env);
		String comPws = storeFrontHomePage.convertBizToComPWS(bizPws);
		storeFrontHomePage.openPWS(comPws);
		storeFrontHomePage.clickOnUserName();
		s_assert.assertFalse(storeFrontHomePage.verifyJoinMyTeamLinkPresent(), "Join My Team Link present on the Com page");
		storeFrontHomePage.openPWS(bizPws);
		storeFrontHomePage.clickOnUserName();
		s_assert.assertTrue(storeFrontHomePage.verifyJoinMyTeamLinkPresent(), "Join My Team Link is not present on the Biz page");
		s_assert.assertAll(); 
	}

	//Hybris Project-4332:Verify Meet Your Consultant Page from .biz site after clicking on Personalize My Profile link
	@Test(enabled=false)
	public void testMeetyourConsultantPageFromBizSiteAfterClickOnPersonalizeMyProfileLink_4332(){
		RFO_DB = driver.getDBNameRFO();		
		List<Map<String, Object>> randomConsultantList =  null;
		String consultantWithPWSEmailID = TestConstants.CONSULTANT_USERNAME;
		String consultantPWSURL = TestConstants.CONSULTANT_BIZ_URL;
		storeFrontHomePage = new StoreFrontHomePage(driver);
		/*randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.GET_RANDOM_CONSULTANT_WITH_PWS_RFO,RFO_DB);
			consultantWithPWSEmailID = (String) getValueFromQueryResult(randomConsultantList, "UserName");
			consultantPWSURL = (String) getValueFromQueryResult(randomConsultantList, "URL");*/

		storeFrontHomePage.openPWS(consultantPWSURL);
		storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantWithPWSEmailID, password);
		storeFrontHomePage.clickOnUserName();
		storeFrontHomePage.clickOnPersonalizeMyProfileLink();
		s_assert.assertTrue(storeFrontConsultantPage.getHomtownNamePresentOnAfterClickonPersinalizeLink().length()>0, "HomeTown text is not present on meet your consultant page");
		s_assert.assertTrue(storeFrontConsultantPage.getConsultantSinceTextPresentAfterClickonPersinalizeLink().length()>0, "Consultant since text is not present on meet your consultant page");
		s_assert.assertTrue(storeFrontConsultantPage.getFavoriteProductNameIsPresentAfterClickonPersinalizeLink().length()>0, "Favorite product text is not present on meet your consultant page");
		s_assert.assertAll(); 
	}

	//Hybris Project-4333:Verify Meet Your Consultant Page from .com site after clicking on Personalize My Profile link.
	@Test
	public void testMeetyourConsultantPageFromComSiteAfterClickOnPersonalizeMyProfileLink_4333(){
		RFO_DB = driver.getDBNameRFO();		
		List<Map<String, Object>> randomConsultantList =  null;
		String consultantWithPWSEmailID = TestConstants.CONSULTANT_USERNAME;
		String consultantPWSURL = TestConstants.CONSULTANT_COM_URL;
		storeFrontHomePage = new StoreFrontHomePage(driver);
		/*randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.GET_RANDOM_CONSULTANT_WITH_PWS_RFO,RFO_DB);
			consultantWithPWSEmailID = (String) getValueFromQueryResult(randomConsultantList, "UserName");
			consultantPWSURL = (String) getValueFromQueryResult(randomConsultantList, "URL");
			consultantPWSURL = storeFrontHomePage.convertBizToComPWS(consultantPWSURL);
		 */

		storeFrontHomePage.openPWS(consultantPWSURL);
		storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantWithPWSEmailID, password);
		storeFrontHomePage.clickOnUserName();
		storeFrontHomePage.clickOnPersonalizeMyProfileLink();
		s_assert.assertTrue(storeFrontConsultantPage.getHomtownNamePresentOnAfterClickonPersinalizeLink().length()>0, "HomeTown text is not present on meet your consultant page");
		s_assert.assertTrue(storeFrontConsultantPage.getConsultantSinceTextPresentAfterClickonPersinalizeLink().length()>0, "Consultant since text is not present on meet your consultant page");
		s_assert.assertTrue(storeFrontConsultantPage.getFavoriteProductNameIsPresentAfterClickonPersinalizeLink().length()>0, "Favorite product text is not present on meet your consultant page");
		s_assert.assertAll();
	}

	//Hybris Project-3832:Verify ABOUT SECTION of Meet Your Consultant Page
	@Test(enabled=false)
	public void testAboutSectionOfMeetYourConsultantPage_3832(){
		RFO_DB = driver.getDBNameRFO();		
		List<Map<String, Object>> randomConsultantList =  null;
		String consultantWithPWSEmailID = TestConstants.CONSULTANT_USERNAME;
		String consultantPWSURL = TestConstants.CONSULTANT_COM_URL;
		String pwsUrlForBiz = TestConstants.CONSULTANT_BIZ_URL;
		storeFrontHomePage = new StoreFrontHomePage(driver);
		/*randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.GET_RANDOM_CONSULTANT_WITH_PWS_RFO,RFO_DB);
			consultantWithPWSEmailID = (String) getValueFromQueryResult(randomConsultantList, "UserName");
			consultantPWSURL = (String) getValueFromQueryResult(randomConsultantList, "URL");
			consultantPWSURL = storeFrontHomePage.convertBizToComPWS(consultantPWSURL);
		 */
		// For .com site
		storeFrontHomePage.openPWS(consultantPWSURL);
		storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantWithPWSEmailID, password);
		storeFrontHomePage.clickOnUserName();
		storeFrontHomePage.clickOnPersonalizeMyProfileLink();
		s_assert.assertTrue(storeFrontConsultantPage.getHomtownNamePresentOnAfterClickonPersinalizeLink().length()>0, "HomeTown text is not present on meet your consultant page");
		s_assert.assertTrue(storeFrontConsultantPage.getConsultantSinceTextPresentAfterClickonPersinalizeLink().length()>0, "Consultant since text is not present on meet your consultant page");
		s_assert.assertTrue(storeFrontConsultantPage.getFavoriteProductNameIsPresentAfterClickonPersinalizeLink().length()>0, "Favorite product text is not present on meet your consultant page");

		// For .biz site
		storeFrontHomePage.openPWS(pwsUrlForBiz);
		storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantWithPWSEmailID, password);
		storeFrontHomePage.clickOnUserName();
		storeFrontHomePage.clickOnPersonalizeMyProfileLink();
		s_assert.assertTrue(storeFrontConsultantPage.getHomtownNamePresentOnAfterClickonPersinalizeLink().length()>0, "HomeTown text is not present on meet your consultant page");
		s_assert.assertTrue(storeFrontConsultantPage.getConsultantSinceTextPresentAfterClickonPersinalizeLink().length()>0, "Consultant since text is not present on meet your consultant page");
		s_assert.assertTrue(storeFrontConsultantPage.getFavoriteProductNameIsPresentAfterClickonPersinalizeLink().length()>0, "Favorite product text is not present on meet your consultant page");
		s_assert.assertAll();
	}


	//Hybris Project-3836:Verify 3 Content Block SECTION of Meet Your Consultant Page
	@Test
	public void testContentBlockSectionOfMeetYourConsultantPage_3836(){
		RFO_DB = driver.getDBNameRFO();		
		List<Map<String, Object>> randomConsultantList =  null;
		String consultantWithPWSEmailID = TestConstants.CONSULTANT_USERNAME;
		String consultantPWSURL = TestConstants.CONSULTANT_COM_URL;
		String pwsUrlForBiz = TestConstants.CONSULTANT_BIZ_URL;
		storeFrontHomePage = new StoreFrontHomePage(driver);
		/*randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.GET_RANDOM_CONSULTANT_WITH_PWS_RFO,RFO_DB);
			consultantWithPWSEmailID = (String) getValueFromQueryResult(randomConsultantList, "UserName");
			consultantPWSURL = (String) getValueFromQueryResult(randomConsultantList, "URL");
			consultantPWSURL = storeFrontHomePage.convertBizToComPWS(consultantPWSURL);
		 */

		storeFrontHomePage.openPWS(consultantPWSURL);
		storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantWithPWSEmailID, password);
		storeFrontHomePage.clickOnUserName();
		storeFrontHomePage.clickOnPersonalizeMyProfileLink();
		s_assert.assertTrue(storeFrontConsultantPage.verifyBlockOfWhyIJoinedOnMeetYourConsultantPage(), "Why I joined Rodan + Fields block is not Present on meet your consultant page ");
		s_assert.assertTrue(storeFrontConsultantPage.verifyBlockOfProductsOnMeetYourConsultantPage(), "What I love most about R+F products block is not Present on meet your consultant page ");
		s_assert.assertTrue(storeFrontConsultantPage.verifyBlockOfBusinessOnMeetYourConsultantPage(), "What I love most about my R+F Business block is not Present on meet your consultant page ");

		// For .biz site
		storeFrontHomePage.openPWS(pwsUrlForBiz);
		storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantWithPWSEmailID, password);
		storeFrontHomePage.clickOnUserName();
		storeFrontHomePage.clickOnPersonalizeMyProfileLink();
		s_assert.assertTrue(storeFrontConsultantPage.verifyBlockOfWhyIJoinedOnMeetYourConsultantPage(), "Why I joined Rodan + Fields block is not Present on meet your consultant page ");
		s_assert.assertTrue(storeFrontConsultantPage.verifyBlockOfProductsOnMeetYourConsultantPage(), "What I love most about R+F products block is not Present on meet your consultant page ");
		s_assert.assertTrue(storeFrontConsultantPage.verifyBlockOfBusinessOnMeetYourConsultantPage(), "What I love most about my R+F Business block is not Present on meet your consultant page ");
		s_assert.assertAll();
	}

	// Hybris Project-3854:Register as RC with Different CA Sponsor WITH Pulse
	@Test(enabled=false)
	public void testRegisterAsRCWithDifferentCASponserWithPulse_3854() throws InterruptedException {
		int randomNum = CommonUtils.getRandomNum(10000, 1000000);
		String socialInsuranceNumber = String.valueOf(CommonUtils.getRandomNum(100000000, 999999999));
		String newBillingProfileName = TestConstants.NEW_BILLING_PROFILE_NAME+randomNum;
		String lastName = "lN";
		List<Map<String, Object>> canadianSponserList =  null;
		String canadianSponserHavingPulse=null;
		country = driver.getCountry();
		String firstName=TestConstants.FIRST_NAME+randomNum;
		enrollmentType = TestConstants.STANDARD_ENROLLMENT;
		regimenName = TestConstants.REGIMEN_NAME_UNBLEMISH;

		storeFrontHomePage = new StoreFrontHomePage(driver);
		// Get Canadian sponser with PWS from database
		//   canadianSponserList = DBUtil.performDatabaseQuery(DBQueries_RFO.GET_RANDOM_CONSULTANT_WITH_PWS_RFO,RFO_DB);
		//   canadianSponserHavingPulse = (String) getValueFromQueryResult(canadianSponserList, "AccountID");
		storeFrontHomePage.openPWS(TestConstants.SPONSER_PWS);

		storeFrontHomePage.hoverOnShopLinkAndClickAllProductsLinks();
		// Products are displayed?
		s_assert.assertTrue(storeFrontHomePage.areProductsDisplayed(), "quickshop products not displayed");
		logger.info("Quick shop products are displayed");

		//Select a product and proceed to buy it
		storeFrontHomePage.selectProductAndProceedToBuy();

		//Cart page is displayed?
		s_assert.assertTrue(storeFrontHomePage.isCartPageDisplayed(), "Cart page is not displayed");
		logger.info("Cart page is displayed");

		//Click on Check out
		storeFrontHomePage.clickOnCheckoutButton();

		//Log in or create an account page is displayed?
		s_assert.assertTrue(storeFrontHomePage.isLoginOrCreateAccountPageDisplayed(), "Login or Create Account page is NOT displayed");
		logger.info("Login or Create Account page is displayed");

		//Enter the User information and DO NOT check the "Become a Preferred Customer" checkbox and click the create account button
		storeFrontHomePage.enterNewRCDetails(firstName, TestConstants.LAST_NAME+randomNum, password);

		//Enter the Main account info and DO NOT check the "Become a Preferred Customer" and click next
		storeFrontHomePage.enterMainAccountInfo();
		logger.info("Main account details entered");
		storeFrontHomePage.clickOnNotYourSponsorLink();
		//assert continue without sponser link is not present and request your sponser button
		s_assert.assertFalse(storeFrontHomePage.verifyContinueWithoutSponserLinkPresent(),"continue without sponser link present");
		s_assert.assertFalse(storeFrontHomePage.verifyRequestASponsorBtn(),"Request a sponser button is present");
		//storeFrontHomePage.clickOKOnSponsorInformationPopup();
		storeFrontHomePage.searchCIDForSponserHavingPulseSubscribed(TestConstants.CANADIAN_SPONSER_HAVING_PULSE);
		storeFrontHomePage.mouseHoverSponsorDataAndClickContinueForPCAndRC();
		storeFrontHomePage.clickOnNextButtonAfterSelectingSponsor();
		storeFrontHomePage.clickOnShippingAddressNextStepBtn();
		//Enter Billing Profile
		storeFrontHomePage.enterNewBillingCardNumber(TestConstants.CARD_NUMBER);
		storeFrontHomePage.enterNewBillingNameOnCard(newBillingProfileName+" "+lastName);
		storeFrontHomePage.selectNewBillingCardExpirationDate();
		storeFrontHomePage.enterNewBillingSecurityCode(TestConstants.SECURITY_CODE);
		storeFrontHomePage.selectNewBillingCardAddress();
		storeFrontHomePage.clickOnSaveBillingProfile();
		storeFrontHomePage.clickOnBillingNextStepBtn();
		storeFrontHomePage.clickPlaceOrderBtn();
		storeFrontHomePage.clickOnRodanAndFieldsLogo();
		//Fetch the PWS url and assert
		String currentPWSUrl=driver.getCurrentUrl();
		s_assert.assertFalse(storeFrontHomePage.verifyPWSAfterSuccessfulEnrollment(TestConstants.SPONSER_PWS,currentPWSUrl),"PWS after enrollment are same");
		s_assert.assertTrue(storeFrontHomePage.verifyWelcomeDropdownToCheckUserRegistered(), "User NOT registered successfully");
		s_assert.assertAll(); 
	}

	//Hybris Project-2250:Corporate Sponsor: PC and RC can create an account without a Sponsor -- will be set to Corporate
	@Test
	public void testPCAndRCAccountCreationWithoutASponsor() throws InterruptedException	{
		int randomNum = CommonUtils.getRandomNum(10000, 1000000);
		String newBillingProfileName = TestConstants.NEW_BILLING_PROFILE_NAME+randomNum;
		String firstName=TestConstants.FIRST_NAME+randomNum;
		String lastName = "lN";
		//RC-Enrollment
		storeFrontHomePage = new StoreFrontHomePage(driver);
		// Click on our product link that is located at the top of the page and then click in on quick shop
		storeFrontHomePage.hoverOnShopLinkAndClickAllProductsLinks();

		// Products are displayed?
		s_assert.assertTrue(storeFrontHomePage.areProductsDisplayed(), "quickshop products not displayed");
		logger.info("Quick shop products are displayed");

		//Select a product and proceed to buy it
		storeFrontHomePage.selectProductAndProceedToBuy();

		//Cart page is displayed?
		s_assert.assertTrue(storeFrontHomePage.isCartPageDisplayed(), "Cart page is not displayed");
		logger.info("Cart page is displayed");

		//In the Cart page add one more product
		storeFrontHomePage.addAnotherProduct();

		//Two products are in the Shopping Cart?
		s_assert.assertTrue(storeFrontHomePage.verifyNumberOfProductsInCart("2"), "number of products in the cart is NOT 2");
		logger.info("2 products are successfully added to the cart");

		//Click on Check out
		storeFrontHomePage.clickOnCheckoutButton();

		//Log in or create an account page is displayed?
		s_assert.assertTrue(storeFrontHomePage.isLoginOrCreateAccountPageDisplayed(), "Login or Create Account page is NOT displayed");
		logger.info("Login or Create Account page is displayed");

		//Enter the User information and DO NOT check the "Become a Preferred Customer" checkbox and click the create account button
		storeFrontHomePage.enterNewRCDetails(firstName, TestConstants.LAST_NAME+randomNum, password);

		//Enter the Main account info  and click next
		storeFrontHomePage.enterMainAccountInfo();
		logger.info("Main account details entered");

		storeFrontHomePage.clickOnContinueWithoutSponsorLink();
		storeFrontHomePage.clickOnNextButtonAfterSelectingSponsor();

		storeFrontHomePage.clickOnShippingAddressNextStepBtn();
		//Enter Billing Profile
		storeFrontHomePage.enterNewBillingCardNumber(TestConstants.CARD_NUMBER);
		storeFrontHomePage.enterNewBillingNameOnCard(newBillingProfileName+" "+lastName);
		storeFrontHomePage.selectNewBillingCardExpirationDate();
		storeFrontHomePage.enterNewBillingSecurityCode(TestConstants.SECURITY_CODE);
		storeFrontHomePage.selectNewBillingCardAddress();
		storeFrontHomePage.clickOnSaveBillingProfile();
		storeFrontHomePage.clickOnBillingNextStepBtn();
		storeFrontHomePage.clickPlaceOrderBtn();
		s_assert.assertTrue(storeFrontHomePage.isOrderPlacedSuccessfully(), "Order Not placed successfully");
		s_assert.assertTrue(storeFrontHomePage.verifyWelcomeDropdownToCheckUserRegistered(), "User NOT registered successfully");
		logout();
		//click on the rodanfields Logo
		storeFrontHomePage.clickOnRodanAndFieldsLogo();
		//PC-Enrollment
		storeFrontHomePage.hoverOnShopLinkAndClickAllProductsLinks();

		// Products are displayed?
		s_assert.assertTrue(storeFrontHomePage.areProductsDisplayed(), "quickshop products not displayed");
		logger.info("Quick shop products are displayed");

		//Select a product with the price less than $80 and proceed to buy it
		storeFrontHomePage.applyPriceFilterLowToHigh();
		storeFrontHomePage.selectProductAndProceedToBuy();

		//Cart page is displayed?
		s_assert.assertTrue(storeFrontHomePage.isCartPageDisplayed(), "Cart page is not displayed");
		logger.info("Cart page is displayed");

		//1 product is in the Shopping Cart?
		s_assert.assertTrue(storeFrontHomePage.verifyNumberOfProductsInCart("1"), "number of products in the cart is NOT 1");
		logger.info("1 product is successfully added to the cart");

		//Click on Check out
		storeFrontHomePage.clickOnCheckoutButton();

		//Log in or create an account page is displayed?
		s_assert.assertTrue(storeFrontHomePage.isLoginOrCreateAccountPageDisplayed(), "Login or Create Account page is NOT displayed");
		logger.info("Login or Create Account page is displayed");

		//Enter the User information and DO  check the "Become a Preferred Customer" checkbox and click the create account button
		storeFrontHomePage.enterNewPCDetails(firstName, TestConstants.LAST_NAME+randomNum, password);

		//Pop for PC threshold validation
		s_assert.assertTrue(storeFrontHomePage.isPopUpForPCThresholdPresent(),"Threshold poup for PC validation NOT present");

		//In the Cart page add one more product
		storeFrontHomePage.addAnotherProduct();

		//Click on Check out
		storeFrontHomePage.clickOnCheckoutButton();

		//Enter the Main account info and click next
		storeFrontHomePage.enterMainAccountInfo();
		logger.info("Main account details entered");

		storeFrontHomePage.clickOnContinueWithoutSponsorLink();
		storeFrontHomePage.clickOnNextButtonAfterSelectingSponsor();

		storeFrontHomePage.clickOnShippingAddressNextStepBtn();
		//Enter Billing Profile
		storeFrontHomePage.enterNewBillingCardNumber(TestConstants.CARD_NUMBER);
		storeFrontHomePage.enterNewBillingNameOnCard(newBillingProfileName+" "+lastName);
		storeFrontHomePage.selectNewBillingCardExpirationDate();
		storeFrontHomePage.enterNewBillingSecurityCode(TestConstants.SECURITY_CODE);
		storeFrontHomePage.selectNewBillingCardAddress();
		storeFrontHomePage.clickOnSaveBillingProfile();
		storeFrontHomePage.clickOnBillingNextStepBtn();
		/*storeFrontHomePage.clickPlaceOrderBtn();
	   s_assert.assertTrue(storeFrontHomePage.verifyPCPerksTermsAndConditionsPopup(),"PC Perks terms and conditions popup not visible when checkboxes for t&c not selected and place order button clicked");
	   logger.info("PC Perks terms and conditions popup is visible when checkboxes for t&c not selected and place order button clicked");*/
		storeFrontHomePage.clickOnPCPerksTermsAndConditionsCheckBoxes();
		storeFrontHomePage.clickPlaceOrderBtn();
		storeFrontHomePage.switchToPreviousTab(); 
		storeFrontHomePage.clickOnRodanAndFieldsLogo();
		s_assert.assertTrue(storeFrontHomePage.verifyWelcomeDropdownToCheckUserRegistered(), "User NOT registered successfully");
		s_assert.assertAll(); 
	}

	// Hybris Project-3774:Register as RC with Different CA Sponsor WITH Pulse
	@Test(enabled=false)
	public void testRegisterAsRCWithDifferentCASponserWithPulse_3774() throws InterruptedException {
		int randomNum = CommonUtils.getRandomNum(10000, 1000000);
		String socialInsuranceNumber = String.valueOf(CommonUtils.getRandomNum(100000000, 999999999));
		String newBillingProfileName = TestConstants.NEW_BILLING_PROFILE_NAME+randomNum;
		String lastName = "lN";
		List<Map<String, Object>> canadianSponserList =  null;
		String canadianSponserHavingPulse=null;
		country = driver.getCountry();
		String firstName=TestConstants.FIRST_NAME+randomNum;
		enrollmentType = TestConstants.STANDARD_ENROLLMENT;
		regimenName = TestConstants.REGIMEN_NAME_UNBLEMISH;

		storeFrontHomePage = new StoreFrontHomePage(driver);
		// Get Canadian sponser with PWS from database
		//   canadianSponserList = DBUtil.performDatabaseQuery(DBQueries_RFO.GET_RANDOM_CONSULTANT_WITH_PWS_RFO,RFO_DB);
		//   canadianSponserHavingPulse = (String) getValueFromQueryResult(canadianSponserList, "AccountID");
		storeFrontHomePage.openPWS(TestConstants.SPONSER_PWS);

		storeFrontHomePage.hoverOnShopLinkAndClickAllProductsLinks();
		// Products are displayed?
		s_assert.assertTrue(storeFrontHomePage.areProductsDisplayed(), "quickshop products not displayed");
		logger.info("Quick shop products are displayed");

		//Select a product and proceed to buy it
		storeFrontHomePage.selectProductAndProceedToBuy();

		//Cart page is displayed?
		s_assert.assertTrue(storeFrontHomePage.isCartPageDisplayed(), "Cart page is not displayed");
		logger.info("Cart page is displayed");

		//Click on Check out
		storeFrontHomePage.clickOnCheckoutButton();

		//Log in or create an account page is displayed?
		s_assert.assertTrue(storeFrontHomePage.isLoginOrCreateAccountPageDisplayed(), "Login or Create Account page is NOT displayed");
		logger.info("Login or Create Account page is displayed");

		//Enter the User information and DO NOT check the "Become a Preferred Customer" checkbox and click the create account button
		storeFrontHomePage.enterNewRCDetails(firstName, TestConstants.LAST_NAME+randomNum, password);

		//Enter the Main account info and DO NOT check the "Become a Preferred Customer" and click next
		storeFrontHomePage.enterMainAccountInfo();
		logger.info("Main account details entered");
		storeFrontHomePage.clickOnNotYourSponsorLink();
		//assert continue without sponser link is not present and request your sponser button
		s_assert.assertFalse(storeFrontHomePage.verifyContinueWithoutSponserLinkPresent(),"continue without sponser link present");
		s_assert.assertFalse(storeFrontHomePage.verifyRequestASponsorBtn(),"Request a sponser button is present");
		//storeFrontHomePage.clickOKOnSponsorInformationPopup();
		storeFrontHomePage.searchCIDForSponserHavingPulseSubscribed(TestConstants.CANADIAN_SPONSER_HAVING_PULSE);
		storeFrontHomePage.mouseHoverSponsorDataAndClickContinueForPCAndRC();
		storeFrontHomePage.clickOnNextButtonAfterSelectingSponsor();
		storeFrontHomePage.clickOnShippingAddressNextStepBtn();
		//Enter Billing Profile
		storeFrontHomePage.enterNewBillingCardNumber(TestConstants.CARD_NUMBER);
		storeFrontHomePage.enterNewBillingNameOnCard(newBillingProfileName+" "+lastName);
		storeFrontHomePage.selectNewBillingCardExpirationDate();
		storeFrontHomePage.enterNewBillingSecurityCode(TestConstants.SECURITY_CODE);
		storeFrontHomePage.selectNewBillingCardAddress();
		storeFrontHomePage.clickOnSaveBillingProfile();
		storeFrontHomePage.clickOnBillingNextStepBtn();
		storeFrontHomePage.clickPlaceOrderBtn();
		storeFrontHomePage.clickOnRodanAndFieldsLogo();
		//Fetch the PWS url and assert
		String currentPWSUrl=driver.getCurrentUrl();
		s_assert.assertFalse(storeFrontHomePage.verifyPWSAfterSuccessfulEnrollment(TestConstants.SPONSER_PWS,currentPWSUrl),"PWS after enrollment are same");
		s_assert.assertTrue(storeFrontHomePage.verifyWelcomeDropdownToCheckUserRegistered(), "User NOT registered successfully");
		s_assert.assertAll(); 
	}

	//Hybris Project-3881:CORP:Join PCPerk in the Order Summary section - CA Spsonor with Pulse
	@Test
	public void testJoinPCPerkWhileEnrollingWithCASponserWithPulse_3881() throws InterruptedException {
		int randomNum = CommonUtils.getRandomNum(10000, 1000000);
		String socialInsuranceNumber = String.valueOf(CommonUtils.getRandomNum(100000000, 999999999));
		String newBillingProfileName = TestConstants.NEW_BILLING_PROFILE_NAME+randomNum;
		String firstName=TestConstants.FIRST_NAME+randomNum;
		String lastName = "lN";
		country = driver.getCountry();
		enrollmentType = TestConstants.STANDARD_ENROLLMENT;
		regimenName = TestConstants.REGIMEN_NAME_UNBLEMISH;
		env = driver.getEnvironment();  
		storeFrontHomePage = new StoreFrontHomePage(driver);
		storeFrontHomePage.openPWSSite(country, env);

		if(country.equalsIgnoreCase("CA")){
			kitName = TestConstants.KIT_NAME_BIG_BUSINESS;			 
			addressLine1 = TestConstants.ADDRESS_LINE_1_CA;
			city = TestConstants.CITY_CA;
			postalCode = TestConstants.POSTAL_CODE_CA;
			phoneNumber = TestConstants.PHONE_NUMBER_CA;
		}else{
			kitName = TestConstants.KIT_NAME_BIG_BUSINESS;
			addressLine1 = TestConstants.ADDRESS_LINE_1_US;
			city = TestConstants.CITY_US;
			postalCode = TestConstants.POSTAL_CODE_US;
			phoneNumber = TestConstants.PHONE_NUMBER_US;
		}
		// Click on Shop link and select All product link  
		storeFrontHomePage.hoverOnShopLinkAndClickAllProductsLinks();
		// Products are displayed?
		s_assert.assertTrue(storeFrontHomePage.areProductsDisplayed(), "quickshop products not displayed");
		logger.info("Quick shop products are displayed");

		//Select a product and proceed to buy it
		storeFrontHomePage.selectProductAndProceedToBuy();
		//Click on Check out
		storeFrontHomePage.clickOnCheckoutButton();

		//Log in or create an account page is displayed?
		s_assert.assertTrue(storeFrontHomePage.isLoginOrCreateAccountPageDisplayed(), "Login or Create Account page is NOT displayed");
		logger.info("Login or Create Account page is displayed");

		//Enter the User information and DO NOT check the "Become a Preferred Customer" checkbox and click the create account button
		storeFrontHomePage.enterNewRCDetails(firstName, TestConstants.LAST_NAME+randomNum, password);
		//select checkbox for join pc perks in order summary section
		storeFrontHomePage.checkPCPerksCheckBox();
		//Enter the Main account info and DO NOT check the "Become a Preferred Customer" and click next
		storeFrontHomePage.enterMainAccountInfo();
		logger.info("Main account details entered");
		storeFrontHomePage.clickOnNotYourSponsorLink();
		//assert continue without sponser link is not present and request your sponser button
		s_assert.assertFalse(storeFrontHomePage.verifyContinueWithoutSponserLinkPresent(),"continue without sponser link present");
		s_assert.assertFalse(storeFrontHomePage.verifyRequestASponsorBtn(),"Request a sponser button is present");
		//storeFrontHomePage.clickOKOnSponsorInformationPopup();
		storeFrontHomePage.searchCIDForSponserHavingPulseSubscribed(TestConstants.CANADIAN_SPONSER_HAVING_PULSE_CA);
		storeFrontHomePage.mouseHoverSponsorDataAndClickContinueForPCAndRC();
		storeFrontHomePage.clickOnNextButtonAfterSelectingSponsor();
		storeFrontHomePage.clickOnShippingAddressNextStepBtn();
		//Enter Billing Profile
		storeFrontHomePage.enterNewBillingCardNumber(TestConstants.CARD_NUMBER);
		storeFrontHomePage.enterNewBillingNameOnCard(newBillingProfileName+" "+lastName);
		storeFrontHomePage.selectNewBillingCardExpirationDate();
		storeFrontHomePage.enterNewBillingSecurityCode(TestConstants.SECURITY_CODE);
		storeFrontHomePage.selectNewBillingCardAddress();
		storeFrontHomePage.clickOnSaveBillingProfile();
		storeFrontHomePage.clickOnBillingNextStepBtn();
		storeFrontHomePage.checkIAcknowledgePCAccountCheckBox();
		storeFrontHomePage.checkPCPerksTermsAndConditionsCheckBox();
		storeFrontHomePage.clickPlaceOrderBtn();
		storeFrontHomePage.switchToPreviousTab();
		storeFrontHomePage.clickOnRodanAndFieldsLogo();
		//Fetch the PWS url and assert
		String currentPWSUrl=driver.getCurrentUrl();
		logger.info("Fetched Pws After enrollment is "+currentPWSUrl);
		s_assert.assertTrue(storeFrontHomePage.verifyPCUserIsOnSponserPWSAfterSuccessfulEnrollment(TestConstants.SPONSER_PWS_HAVING_PULSE_DOT_COM_CA,currentPWSUrl),"PC User is not on sponser pws after enrollment");
		s_assert.assertTrue(storeFrontHomePage.verifyWelcomeDropdownToCheckUserRegistered(), "User NOT registered successfully");
		s_assert.assertAll(); 
	}
	//Hybris Project-3878 :: Version : 1 :: CORP:Join PCPerk in the shipment -CA Sposnor WITHOUT Pulse
	@Test(enabled=false) //WIP
	public void testJoinPCPerkWhileEnrollingWithCASponserWithoutPulse_3878() throws InterruptedException {
		int randomNum = CommonUtils.getRandomNum(10000, 1000000);
		String socialInsuranceNumber = String.valueOf(CommonUtils.getRandomNum(100000000, 999999999));
		String newBillingProfileName = TestConstants.NEW_BILLING_PROFILE_NAME+randomNum;
		String firstName=TestConstants.FIRST_NAME+randomNum;
		String lastName = "lN";
		String corpUrl = driver.getURL();
		country = driver.getCountry();
		enrollmentType = TestConstants.STANDARD_ENROLLMENT;
		regimenName = TestConstants.REGIMEN_NAME_UNBLEMISH;
		env = driver.getEnvironment();  
		storeFrontHomePage = new StoreFrontHomePage(driver);
		String bizPws = storeFrontHomePage.getBizPWS(country, env);
		String comPws = storeFrontHomePage.convertBizToComPWS(bizPws);

		if(country.equalsIgnoreCase("CA")){
			kitName = TestConstants.KIT_NAME_BIG_BUSINESS;			 
			addressLine1 = TestConstants.ADDRESS_LINE_1_CA;
			city = TestConstants.CITY_CA;
			postalCode = TestConstants.POSTAL_CODE_CA;
			phoneNumber = TestConstants.PHONE_NUMBER_CA;
		}else{
			kitName = TestConstants.KIT_NAME_BIG_BUSINESS;
			addressLine1 = TestConstants.ADDRESS_LINE_1_US;
			city = TestConstants.CITY_US;
			postalCode = TestConstants.POSTAL_CODE_US;
			phoneNumber = TestConstants.PHONE_NUMBER_US;
		}
		//Navigate to .com pws 
		storeFrontHomePage.openPWS(comPws);
		// Click on Shop link and select All product link  
		storeFrontHomePage.hoverOnShopLinkAndClickAllProductsLinks();
		// Products are displayed?
		s_assert.assertTrue(storeFrontHomePage.areProductsDisplayed(), "quickshop products not displayed");
		logger.info("Quick shop products are displayed");

		//Select a product and proceed to buy it
		storeFrontHomePage.selectProductAndProceedToBuy();
		//Click on Check out
		storeFrontHomePage.clickOnCheckoutButton();

		//Log in or create an account page is displayed?
		s_assert.assertTrue(storeFrontHomePage.isLoginOrCreateAccountPageDisplayed(), "Login or Create Account page is NOT displayed");
		logger.info("Login or Create Account page is displayed");
		//Enter the User information and DO NOT check the "Become a Preferred Customer" checkbox and click the create account button
		storeFrontHomePage.enterNewRCDetails(firstName, TestConstants.LAST_NAME+randomNum, password);
		//select checkbox for join pc perks in order summary section
		storeFrontHomePage.checkPCPerksCheckBox();
		//Enter the Main account info and DO NOT check the "Become a Preferred Customer" and click next
		storeFrontHomePage.enterMainAccountInfo();
		logger.info("Main account details entered");
		storeFrontHomePage.clickOnNotYourSponsorLink();
		//assert continue without sponser link is not present and request your sponser button
		s_assert.assertFalse(storeFrontHomePage.verifyContinueWithoutSponserLinkPresent(),"continue without sponser link present");
		s_assert.assertFalse(storeFrontHomePage.verifyRequestASponsorBtn(),"Request a sponser button is present");
		//storeFrontHomePage.clickOKOnSponsorInformationPopup();
		storeFrontHomePage.searchCID(TestConstants.CANADIAN_SPONSER_WITHOUT_PULSE_CA);
		storeFrontHomePage.mouseHoverSponsorDataAndClickContinueForPCAndRC();
		storeFrontHomePage.clickOnNextButtonAfterSelectingSponsor();
		storeFrontHomePage.clickOnShippingAddressNextStepBtn();
		//Enter Billing Profile
		storeFrontHomePage.enterNewBillingCardNumber(TestConstants.CARD_NUMBER);
		storeFrontHomePage.enterNewBillingNameOnCard(newBillingProfileName+" "+lastName);
		storeFrontHomePage.selectNewBillingCardExpirationDate();
		storeFrontHomePage.enterNewBillingSecurityCode(TestConstants.SECURITY_CODE);
		storeFrontHomePage.selectNewBillingCardAddress();
		storeFrontHomePage.clickOnSaveBillingProfile();
		storeFrontHomePage.clickOnBillingNextStepBtn();
		storeFrontHomePage.checkIAcknowledgePCAccountCheckBox();
		storeFrontHomePage.checkPCPerksTermsAndConditionsCheckBox();
		storeFrontHomePage.clickPlaceOrderBtn();
		storeFrontHomePage.clickOnRodanAndFieldsLogo();
		//Fetch the PWS url and assert
		String currentPWSUrl=driver.getCurrentUrl();
		logger.info("Fetched Pws After enrollment is "+currentPWSUrl);
		s_assert.assertFalse(storeFrontHomePage.verifyPCUserIsOnCorpSiteAfterSuccessfulEnrollment(corpUrl,currentPWSUrl),"After RC to PC enrollment the PC user is not on  corp site");
		s_assert.assertTrue(storeFrontHomePage.verifyWelcomeDropdownToCheckUserRegistered(), "User NOT registered successfully");
		s_assert.assertAll(); 
	}

	//Hybris Project-3757 :: Version : 1 :: Join PCPerk in the shipment section - CA Spsonor with Pulse
	@Test(enabled=false)//WIP
	public void testJoinPCPerkWhileEnrollingWithCASponserWithPulse_3757() throws InterruptedException {
		int randomNum = CommonUtils.getRandomNum(10000, 1000000);
		String socialInsuranceNumber = String.valueOf(CommonUtils.getRandomNum(100000000, 999999999));
		String newBillingProfileName = TestConstants.NEW_BILLING_PROFILE_NAME+randomNum;
		String firstName=TestConstants.FIRST_NAME+randomNum;
		String lastName = "lN";
		country = driver.getCountry();
		enrollmentType = TestConstants.STANDARD_ENROLLMENT;
		regimenName = TestConstants.REGIMEN_NAME_UNBLEMISH;
		env = driver.getEnvironment();  
		storeFrontHomePage = new StoreFrontHomePage(driver);
		storeFrontHomePage.openPWSSite(country, env);

		if(country.equalsIgnoreCase("CA")){
			kitName = TestConstants.KIT_NAME_BIG_BUSINESS;			 
			addressLine1 = TestConstants.ADDRESS_LINE_1_CA;
			city = TestConstants.CITY_CA;
			postalCode = TestConstants.POSTAL_CODE_CA;
			phoneNumber = TestConstants.PHONE_NUMBER_CA;
		}else{
			kitName = TestConstants.KIT_NAME_BIG_BUSINESS;
			addressLine1 = TestConstants.ADDRESS_LINE_1_US;
			city = TestConstants.CITY_US;
			postalCode = TestConstants.POSTAL_CODE_US;
			phoneNumber = TestConstants.PHONE_NUMBER_US;
		}
		// Click on Shop link and select All product link  
		storeFrontHomePage.hoverOnShopLinkAndClickAllProductsLinks();
		// Products are displayed?
		s_assert.assertTrue(storeFrontHomePage.areProductsDisplayed(), "quickshop products not displayed");
		logger.info("Quick shop products are displayed");

		//Select a product and proceed to buy it
		storeFrontHomePage.selectProductAndProceedToBuy();
		//Click on Check out
		storeFrontHomePage.clickOnCheckoutButton();

		//Log in or create an account page is displayed?
		s_assert.assertTrue(storeFrontHomePage.isLoginOrCreateAccountPageDisplayed(), "Login or Create Account page is NOT displayed");
		logger.info("Login or Create Account page is displayed");
		//Enter the User information and DO NOT check the "Become a Preferred Customer" checkbox and click the create account button
		storeFrontHomePage.enterNewRCDetails(firstName, TestConstants.LAST_NAME+randomNum, password);
		//select checkbox for join pc perks in order summary section
		storeFrontHomePage.checkPCPerksCheckBox();
		//Enter the Main account info and DO NOT check the "Become a Preferred Customer" and click next
		storeFrontHomePage.enterMainAccountInfo();
		logger.info("Main account details entered");
		storeFrontHomePage.clickOnNotYourSponsorLink();
		//assert continue without sponser link is not present and request your sponser button
		s_assert.assertFalse(storeFrontHomePage.verifyContinueWithoutSponserLinkPresent(),"continue without sponser link present");
		s_assert.assertFalse(storeFrontHomePage.verifyRequestASponsorBtn(),"Request a sponser button is present");
		//storeFrontHomePage.clickOKOnSponsorInformationPopup();
		storeFrontHomePage.searchCIDForSponserHavingPulseSubscribed(TestConstants.CANADIAN_SPONSER_HAVING_PULSE_CA);
		storeFrontHomePage.mouseHoverSponsorDataAndClickContinueForPCAndRC();
		storeFrontHomePage.clickOnNextButtonAfterSelectingSponsor();
		storeFrontHomePage.clickOnShippingAddressNextStepBtn();
		//Enter Billing Profile
		storeFrontHomePage.enterNewBillingCardNumber(TestConstants.CARD_NUMBER);
		storeFrontHomePage.enterNewBillingNameOnCard(newBillingProfileName+" "+lastName);
		storeFrontHomePage.selectNewBillingCardExpirationDate();
		storeFrontHomePage.enterNewBillingSecurityCode(TestConstants.SECURITY_CODE);
		storeFrontHomePage.selectNewBillingCardAddress();
		storeFrontHomePage.clickOnSaveBillingProfile();
		storeFrontHomePage.clickOnBillingNextStepBtn();
		storeFrontHomePage.checkIAcknowledgePCAccountCheckBox();
		storeFrontHomePage.checkPCPerksTermsAndConditionsCheckBox();
		storeFrontHomePage.clickPlaceOrderBtn();
		storeFrontHomePage.switchToPreviousTab();
		storeFrontHomePage.clickOnRodanAndFieldsLogo();
		//Fetch the PWS url and assert
		String currentPWSUrl=driver.getCurrentUrl();
		logger.info("Fetched Pws After enrollment is "+currentPWSUrl);
		s_assert.assertTrue(storeFrontHomePage.verifyPCUserIsOnSponserPWSAfterSuccessfulEnrollment(TestConstants.SPONSER_PWS_HAVING_PULSE_DOT_COM_CA,currentPWSUrl),"PC User is not on sponser pws after enrollment");
		s_assert.assertTrue(storeFrontHomePage.verifyWelcomeDropdownToCheckUserRegistered(), "User NOT registered successfully");
		s_assert.assertAll(); 
	}
}



