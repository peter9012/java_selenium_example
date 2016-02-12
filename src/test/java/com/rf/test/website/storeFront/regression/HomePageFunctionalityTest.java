package com.rf.test.website.storeFront.regression;

import java.util.List;
import java.util.Map;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.testng.annotations.Test;

import com.rf.core.utils.CommonUtils;
import com.rf.core.utils.DBUtil;
import com.rf.core.website.constants.TestConstants;
import com.rf.core.website.constants.dbQueries.DBQueries_RFO;
import com.rf.pages.website.storeFront.StoreFrontAccountInfoPage;
import com.rf.pages.website.storeFront.StoreFrontAccountTerminationPage;
import com.rf.pages.website.storeFront.StoreFrontConsultantPage;
import com.rf.pages.website.storeFront.StoreFrontHomePage;
import com.rf.pages.website.storeFront.StoreFrontPCUserPage;
import com.rf.pages.website.storeFront.StoreFrontRCUserPage;
import com.rf.test.website.RFWebsiteBaseTest;

public class HomePageFunctionalityTest extends RFWebsiteBaseTest{
	private static final Logger logger = LogManager
			.getLogger(HomePageFunctionalityTest.class.getName());
	public String emailID=null;
	private StoreFrontHomePage storeFrontHomePage;
	private StoreFrontConsultantPage storeFrontConsultantPage;
	private StoreFrontAccountInfoPage storeFrontAccountInfoPage;
	private StoreFrontPCUserPage storeFrontPCUserPage;
	private StoreFrontRCUserPage storeFrontRCUserPage;
	private StoreFrontAccountTerminationPage storeFrontAccountTerminationPage;
	private String phoneNumber = null;
	private String country = null;
	private String RFO_DB = null;
	private String env = null;

	//Hybris Project-4350:Verify "Join my team" button on the .com and .biz site
	@Test 
	public void testJoinMyTeamButtonPresentOnTheComAndBizSite_4350(){
		country = driver.getCountry();
		env = driver.getEnvironment();  
		storeFrontHomePage = new StoreFrontHomePage(driver);
		String PWS = storeFrontHomePage.openPWSSite(country, env);
		storeFrontHomePage.clickOnUserName();
		s_assert.assertTrue(storeFrontHomePage.verifyJoinMyTeamLinkPresent(), "Join My Team Link is not present on the Biz page");
		storeFrontHomePage.clickOnJoinMyTeamBtn();
		s_assert.assertTrue(driver.getCurrentUrl().contains(".biz/"+driver.getCountry()+"/consultant/enrollment/kitproduct"),"user is not on biz enrollment kit page after clicking 'Join My Team' btn");
		String comPWS = storeFrontHomePage.convertBizToComPWS(PWS);
		storeFrontHomePage.openConsultantPWS(comPWS);
		storeFrontHomePage.clickOnUserName();
		s_assert.assertFalse(storeFrontHomePage.verifyJoinMyTeamLinkPresent(), "Join My Team Link present on the Com page");
		s_assert.assertAll(); 
	}

	//Hybris Project-4332:Verify Meet Your Consultant Page from .biz site after clicking on Personalize My Profile link
	@Test 
	public void testMeetyourConsultantPageFromBizSiteAfterClickOnPersonalizeMyProfileLink_4332(){
		RFO_DB = driver.getDBNameRFO();  
		List<Map<String, Object>> randomConsultantList =  null;
		String consultantWithPWSEmailID = null; //TestConstants.CONSULTANT_USERNAME;
		String consultantPWSURL = null; //TestConstants.CONSULTANT_BIZ_URL;
		storeFrontHomePage = new StoreFrontHomePage(driver);
		while(true){
			randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguementPWS(DBQueries_RFO.GET_RANDOM_CONSULTANT_WITH_PWS_RFO,driver.getEnvironment(),driver.getCountry(),countryId),RFO_DB);
			consultantWithPWSEmailID = (String) getValueFromQueryResult(randomConsultantList, "UserName");
			consultantPWSURL = (String) getValueFromQueryResult(randomConsultantList, "URL");
			consultantPWSURL = storeFrontHomePage.convertComSiteToBizSite(consultantPWSURL);
			storeFrontHomePage.openPWS(consultantPWSURL);
			if(driver.getCurrentUrl().contains("sitenotfound"))
				continue;
			else
				break;
		}
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
		String consultantWithPWSEmailID = null; //TestConstants.CONSULTANT_USERNAME;
		String consultantPWSURL = null; //TestConstants.CONSULTANT_COM_URL;
		storeFrontHomePage = new StoreFrontHomePage(driver);
		while(true){
			randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguementPWS(DBQueries_RFO.GET_RANDOM_CONSULTANT_WITH_PWS_RFO,driver.getEnvironment(),driver.getCountry(),countryId),RFO_DB);
			consultantWithPWSEmailID = (String) getValueFromQueryResult(randomConsultantList, "UserName");
			consultantPWSURL = (String) getValueFromQueryResult(randomConsultantList, "URL");
			consultantPWSURL = storeFrontHomePage.convertBizSiteToComSite(consultantPWSURL);
			storeFrontHomePage.openPWS(consultantPWSURL);
			if(driver.getCurrentUrl().contains("sitenotfound"))
				continue;
			else
				break;
		}
		storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantWithPWSEmailID, password);
		storeFrontHomePage.clickOnUserName();
		storeFrontHomePage.clickOnPersonalizeMyProfileLink();
		s_assert.assertTrue(storeFrontConsultantPage.getHomtownNamePresentOnAfterClickonPersinalizeLink().length()>0, "HomeTown text is not present on meet your consultant page");
		s_assert.assertTrue(storeFrontConsultantPage.getConsultantSinceTextPresentAfterClickonPersinalizeLink().length()>0, "Consultant since text is not present on meet your consultant page");
		s_assert.assertTrue(storeFrontConsultantPage.getFavoriteProductNameIsPresentAfterClickonPersinalizeLink().length()>0, "Favorite product text is not present on meet your consultant page");
		s_assert.assertAll();
	}

	//Hybris Project-3832:Verify ABOUT SECTION of Meet Your Consultant Page
	@Test 
	public void testAboutSectionOfMeetYourConsultantPage_3832(){
		RFO_DB = driver.getDBNameRFO();		
		List<Map<String, Object>> randomConsultantList =  null;
		String consultantWithPWSEmailID = null; //TestConstants.CONSULTANT_USERNAME;
		String consultantPWSURL = null; //TestConstants.CONSULTANT_COM_URL;
		storeFrontHomePage = new StoreFrontHomePage(driver);
		randomConsultantList =DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguementPWS(DBQueries_RFO.GET_RANDOM_CONSULTANT_WITH_PWS_RFO,driver.getEnvironment(),driver.getCountry(),countryId),RFO_DB);
		consultantWithPWSEmailID = (String) getValueFromQueryResult(randomConsultantList, "UserName");
		consultantPWSURL = (String) getValueFromQueryResult(randomConsultantList, "URL");

		// For .com site
		consultantPWSURL = storeFrontHomePage.convertBizSiteToComSite(consultantPWSURL);
		storeFrontHomePage.openPWS(consultantPWSURL);
		storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantWithPWSEmailID, password);
		storeFrontHomePage.clickOnUserName();
		storeFrontHomePage.clickOnPersonalizeMyProfileLink();
		s_assert.assertTrue(storeFrontConsultantPage.getHomtownNamePresentOnAfterClickonPersinalizeLink().length()>0, "HomeTown text is not present on meet your consultant page");
		s_assert.assertTrue(storeFrontConsultantPage.getConsultantSinceTextPresentAfterClickonPersinalizeLink().length()>0, "Consultant since text is not present on meet your consultant page");
		s_assert.assertTrue(storeFrontConsultantPage.getFavoriteProductNameIsPresentAfterClickonPersinalizeLink().length()>0, "Favorite product text is not present on meet your consultant page");

		// For .biz site
		consultantPWSURL = storeFrontHomePage.convertComSiteToBizSite(consultantPWSURL);
		storeFrontHomePage.openPWS(consultantPWSURL);
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
		String consultantWithPWSEmailID = null; //TestConstants.CONSULTANT_USERNAME;
		String consultantPWSURL = null; //TestConstants.CONSULTANT_COM_URL;

		storeFrontHomePage = new StoreFrontHomePage(driver);
		randomConsultantList =DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguementPWS(DBQueries_RFO.GET_RANDOM_CONSULTANT_WITH_PWS_RFO,driver.getEnvironment(),driver.getCountry(),countryId),RFO_DB);

		consultantWithPWSEmailID = (String) getValueFromQueryResult(randomConsultantList, "UserName");
		consultantPWSURL = (String) getValueFromQueryResult(randomConsultantList, "URL");
		//consultantPWSURL = storeFrontHomePage.convertBizToComPWS(consultantPWSURL);

		// for .com site
		consultantPWSURL = storeFrontHomePage.convertBizSiteToComSite(consultantPWSURL);
		storeFrontHomePage.openPWS(consultantPWSURL);
		storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantWithPWSEmailID, password);
		storeFrontHomePage.clickOnUserName();
		storeFrontHomePage.clickOnPersonalizeMyProfileLink();
		s_assert.assertTrue(storeFrontConsultantPage.verifyBlockOfWhyIJoinedOnMeetYourConsultantPage(), "Why I joined Rodan + Fields block is not Present on meet your consultant page ");
		s_assert.assertTrue(storeFrontConsultantPage.verifyBlockOfProductsOnMeetYourConsultantPage(), "What I love most about R+F products block is not Present on meet your consultant page ");
		s_assert.assertTrue(storeFrontConsultantPage.verifyBlockOfBusinessOnMeetYourConsultantPage(), "What I love most about my R+F Business block is not Present on meet your consultant page ");

		// For .biz site
		consultantPWSURL = storeFrontHomePage.convertComSiteToBizSite(consultantPWSURL);
		storeFrontHomePage.openPWS(consultantPWSURL);
		storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantWithPWSEmailID, password);
		storeFrontHomePage.clickOnUserName();
		storeFrontHomePage.clickOnPersonalizeMyProfileLink();
		s_assert.assertTrue(storeFrontConsultantPage.verifyBlockOfWhyIJoinedOnMeetYourConsultantPage(), "Why I joined Rodan + Fields block is not Present on meet your consultant page ");
		s_assert.assertTrue(storeFrontConsultantPage.verifyBlockOfProductsOnMeetYourConsultantPage(), "What I love most about R+F products block is not Present on meet your consultant page ");
		s_assert.assertTrue(storeFrontConsultantPage.verifyBlockOfBusinessOnMeetYourConsultantPage(), "What I love most about my R+F Business block is not Present on meet your consultant page ");
		s_assert.assertAll();
	}

	// Hybris Project-3844:Verify links in Meet Your consultant Banner
	@Test 
	public void testVerifyLinksInMeetYourConsultantBanner_3844() {
		RFO_DB = driver.getDBNameRFO();
		List<Map<String, Object>> randomConsultantList =  null;
		String consultantEmailID = null;
		String accountId = null;
		storeFrontHomePage = new StoreFrontHomePage(driver);
		while(true){
			randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguement
					(DBQueries_RFO.GET_RANDOM_ACTIVE_CONSULTANT_WITH_ORDERS_AND_AUTOSHIPS_RFO,countryId),RFO_DB);
			consultantEmailID = (String) getValueFromQueryResult(randomConsultantList, "UserName");  
			accountId = String.valueOf(getValueFromQueryResult(randomConsultantList, "AccountID"));
			logger.info("Account Id of the user is "+accountId);
			storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailID, password);
			boolean isLoginError = driver.getCurrentUrl().contains("error");
			if(isLoginError){
				logger.info("Login error for the user "+consultantEmailID);
				driver.get(driver.getURL());
			}
			else
				break;
		}
		logger.info("login is successful");
		//click meet your consultant banner link
		storeFrontConsultantPage.clickOnMeetYourConsultantLink();
		//validate we are navigated to "Meet your Consultant" page on .COM
		s_assert.assertTrue(storeFrontConsultantPage.validateMeetYourConsultantPage(),"Meet your consultant page is not displayed");
		s_assert.assertAll();
	}

	//Hybris Project-3847:Verify Footer Links on .COM home Page
	@Test 
	public void testVerifyFooterLinksOnHomePage_3847()	 {
		//Navgate to app home page
		storeFrontHomePage = new StoreFrontHomePage(driver);
		//validate RF Connection link
		s_assert.assertTrue(storeFrontHomePage.validateRFConnectionLink(),"RF Connection link is not redirecting to proper screen");
		//validate Carrers link
		s_assert.assertTrue(storeFrontHomePage.validateCareersLink(),"Careers link is not redirecting to proper screen");
		//validtae Contact-Us Link
		s_assert.assertTrue(storeFrontHomePage.validateContactUsLink(),"Contact Us link is not redirecting to proper screen");
		//validate Disclaimer link
		s_assert.assertTrue(storeFrontHomePage.validateDisclaimerLink(),"Disclaimer link is not redirecting to proper screen");
		//validate Privacy-policy link
		s_assert.assertTrue(storeFrontHomePage.validatePrivacyPolicyLink(),"PrivacyPolicy link is not redirecting to proper screen");
		//validate Satisfaction-Guarantee link
		s_assert.assertTrue(storeFrontHomePage.validateSatisfactionGuaranteeLink(),"SatisfactionGuarantee link is not redirecting to proper screen");
		//validate Terms&Conditions link
		s_assert.assertTrue(storeFrontHomePage.validateTermsConditionsLink(),"TermsConditions link is not redirecting to proper screen");
		//validate pressroom link
		s_assert.assertTrue(storeFrontHomePage.validatePressRoomLink(),"PressRoom link is not redirecting to proper screen");
		//validate country flag dropdown
		s_assert.assertTrue(storeFrontHomePage.validateCountryFlagDropDownBtn(),"Country flag Drop down button is not present in UI on homepage");
		//validate Derm RF Link
		s_assert.assertTrue(storeFrontHomePage.validateDermRFLink()," Derm RF link is not redirecting to proper screen");
		s_assert.assertAll();
	}

	//Hybris Project-3845:Verify the Links in the top Navigation on .COM home Page
	@Test 
	public void testVerifyLinksInTheTopNavigationOnHomePage_3845()	 {
		//Navgate to app home page
		storeFrontHomePage = new StoreFrontHomePage(driver);
		//click on logo and validate the homepage
		storeFrontHomePage.clickOnRodanAndFieldsLogo();
		s_assert.assertTrue(storeFrontHomePage.validateHomePage(),"Home page is not displayed ");
		//click login  link and validate username,password,login button & forgot pwd link
		s_assert.assertTrue(storeFrontHomePage.validateLoginFunctionality(),"All the Elements of login functionality are not displayed!");
		//validate 'shop','About' &'Become a Consultant' Menu 
		s_assert.assertTrue(storeFrontHomePage.validateTopNavigationMenuElements(),"Top Menu Navigation Elements are not displayed/present");
		//validate country flag dropdown
		s_assert.assertTrue(storeFrontHomePage.validateCountryFlagDropDownBtn(),"Country flag Drop down button is not present in UI on homepage");
		s_assert.assertAll();
	}

	//Hybris Project-3823:Verify Top Nav as Logged in Consultant(.com)
	@Test 
	public void testVerifyTopNavLoggedInConsultant_3823() throws InterruptedException	 {
		RFO_DB = driver.getDBNameRFO();
		List<Map<String, Object>> randomConsultantList =  null;
		String consultantEmailID = null;
		String accountId = null;
		storeFrontHomePage = new StoreFrontHomePage(driver);
		while(true){
			randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguement(DBQueries_RFO.GET_RANDOM_ACTIVE_CONSULTANT_WITH_ORDERS_AND_AUTOSHIPS_RFO,countryId),RFO_DB);
			consultantEmailID = (String) getValueFromQueryResult(randomConsultantList, "UserName");  
			accountId = String.valueOf(getValueFromQueryResult(randomConsultantList, "AccountID"));
			logger.info("Account Id of the user is "+accountId);
			storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailID, password);
			boolean isLoginError = driver.getCurrentUrl().contains("error");
			if(isLoginError){
				logger.info("Login error for the user "+consultantEmailID);
				driver.get(driver.getURL());
			}
			else
				break;
		}
		logger.info("login is successful");
		//validate(after logging as consultant) on homapage CRP cart is displayed
		s_assert.assertTrue(storeFrontConsultantPage.validateCRPCartDisplayed(), "CRP Cart is not displayed");
		//add product to cart..
		storeFrontHomePage.hoverOnShopLinkAndClickAllProductsLinks(); 
		storeFrontHomePage.selectProductAndProceedToBuy();
		//validate CRP Cart is displayed?
		s_assert.assertTrue(storeFrontConsultantPage.validateCRPCartDisplayed(), "CRP Cart is not displayed");
		//validate adhoc cart is displayed?
		s_assert.assertTrue(storeFrontConsultantPage.validateAdhocCartIsDisplayed(), "Ad-hoc Cart is not displayed");
		//validate 'My Act' dropdown in the top Nav is present
		s_assert.assertTrue(storeFrontConsultantPage.validateMyAccountDDPresentInTopNav(), "My act DD is not displayed in the top Nav");
		s_assert.assertAll(); 
	}

	//Hybris Project-3841:Verify Top Nav as Logged in Consultant(.biz)
	@Test 
	public void testVerifyTopNavLoggedInConsultantbizSite_3841() throws InterruptedException{
		country = driver.getCountry();
		env = driver.getEnvironment(); 
		storeFrontHomePage = new StoreFrontHomePage(driver);
		RFO_DB = driver.getDBNameRFO();
		String PWS = storeFrontHomePage.getBizPWS(country, env);
		PWS = storeFrontHomePage.convertComSiteToBizSite(PWS);
		storeFrontHomePage.openPWS(PWS);
		List<Map<String, Object>> randomConsultantList =  null;
		String consultantEmailID = null;
		String accountId = null;
		while(true){
			randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguement

					(DBQueries_RFO.GET_RANDOM_ACTIVE_CONSULTANT_WITH_ORDERS_AND_AUTOSHIPS_RFO,countryId),RFO_DB);
			consultantEmailID = (String) getValueFromQueryResult(randomConsultantList, "UserName");  
			accountId = String.valueOf(getValueFromQueryResult(randomConsultantList, "AccountID"));
			logger.info("Account Id of the user is "+accountId);
			storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailID, password);
			boolean isLoginError = driver.getCurrentUrl().contains("error");
			if(isLoginError){
				logger.info("Login error for the user "+consultantEmailID);
				driver.get(driver.getURL());
			}
			else
				break;
		}
		logger.info("login is successful");
		//validate(after logging as consultant) on homapage CRP cart is displayed
		s_assert.assertTrue(storeFrontConsultantPage.validateCRPCartDisplayed(), "CRP Cart is not displayed");
		//add product to cart..
		storeFrontHomePage.hoverOnShopLinkAndClickAllProductsLinks(); 
		storeFrontHomePage.selectProductAndProceedToBuy();
		//validate CRP Cart is displayed?
		s_assert.assertTrue(storeFrontConsultantPage.validateCRPCartDisplayed(), "CRP Cart is not displayed");
		//validate adhoc cart is displayed?
		s_assert.assertTrue(storeFrontConsultantPage.validateAdhocCartIsDisplayed(), "Ad-hoc Cart is not displayed");
		//validate 'My Act' dropdown in the top Nav is present
		s_assert.assertTrue(storeFrontConsultantPage.validateMyAccountDDPresentInTopNav(), "My act DD is not displayed in the top Nav");
		s_assert.assertAll(); 
	}

	//Hybris Project-3824:Verify Top Nav as Logged in PC User(.com)
	@Test 
	public void testVerifyTopNavLoggedInPCUser_3824() throws InterruptedException{
		List<Map<String, Object>> randomPCUserList =  null;
		String pcUserEmailID = null;
		String accountIdForPCUser = null;
		storeFrontHomePage = new StoreFrontHomePage(driver);
		while(true){
			randomPCUserList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguement

					(DBQueries_RFO.GET_RANDOM_ACTIVE_PC_WITH_ORDERS_AND_AUTOSHIPS_RFO,countryId),RFO_DB);
			pcUserEmailID = (String) getValueFromQueryResult(randomPCUserList, "UserName");  
			accountIdForPCUser = String.valueOf(getValueFromQueryResult(randomPCUserList, "AccountID"));
			logger.info("Account Id of the user is "+accountIdForPCUser);

			storeFrontPCUserPage = storeFrontHomePage.loginAsPCUser(pcUserEmailID, password);
			boolean isSiteNotFoundPresent = driver.getCurrentUrl().contains("sitenotfound");
			if(isSiteNotFoundPresent){
				logger.info("SITE NOT FOUND for the user "+pcUserEmailID);
				driver.get(driver.getURL());
			}
			else
				break;
		}
		logger.info("login is successful");
		//validate(after logging as PC) on homapage PC Perks cart is displayed
		s_assert.assertTrue(storeFrontPCUserPage.validatePCPerkCartDisplayed(), "CRP Cart is not displayed");
		//add product to cart..
		storeFrontHomePage.hoverOnShopLinkAndClickAllProductsLinks(); 
		storeFrontHomePage.selectProductAndProceedToBuy();
		//validate PC Perks Cart is displayed?
		s_assert.assertTrue(storeFrontPCUserPage.validatePCPerkCartDisplayed(), "CRP Cart is not displayed");
		//validate adhoc cart is displayed?
		s_assert.assertTrue(storeFrontPCUserPage.validateAdhocCartIsDisplayed(), "Ad-hoc Cart is not displayed");
		//validate 'My Act' dropdown in the top Nav is present
		s_assert.assertTrue(storeFrontPCUserPage.validateMyAccountDDPresentInTopNav(), "My act DD is not displayed in the top Nav");
		s_assert.assertAll(); 
	}

	//Hybris Project-3842:Verify Top Nav as Logged in PC User(.biz)
	@Test 
	public void testVerifyTopNavLoggedInPCUserbizSite_3842() throws InterruptedException	{
		country = driver.getCountry();
		env = driver.getEnvironment(); 
		storeFrontHomePage = new StoreFrontHomePage(driver);
		RFO_DB = driver.getDBNameRFO();
		String PWS = storeFrontHomePage.getBizPWS(country, env);
		PWS = storeFrontHomePage.convertComSiteToBizSite(PWS);
		storeFrontHomePage.openPWS(PWS);
		List<Map<String, Object>> randomPCUserList =  null;
		String pcUserEmailID = null;
		String accountIdForPCUser = null;
		while(true){
			randomPCUserList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguement

					(DBQueries_RFO.GET_RANDOM_ACTIVE_PC_WITH_ORDERS_AND_AUTOSHIPS_RFO,countryId),RFO_DB);
			pcUserEmailID = (String) getValueFromQueryResult(randomPCUserList, "UserName");  
			accountIdForPCUser = String.valueOf(getValueFromQueryResult(randomPCUserList, "AccountID"));
			logger.info("Account Id of the user is "+accountIdForPCUser);

			storeFrontPCUserPage = storeFrontHomePage.loginAsPCUser(pcUserEmailID, password);
			boolean isSiteNotFoundPresent = driver.getCurrentUrl().contains("sitenotfound");
			if(isSiteNotFoundPresent){
				logger.info("SITE NOT FOUND for the user "+pcUserEmailID);
				driver.get(driver.getURL());
			}
			else
				break;
		}
		logger.info("login is successful");
		//validate(after logging as PC) on homapage PC Perks cart is displayed
		s_assert.assertTrue(storeFrontPCUserPage.validatePCPerkCartDisplayed(), "CRP Cart is not displayed");
		//add product to cart..
		storeFrontHomePage.hoverOnShopLinkAndClickAllProductsLinks(); 
		storeFrontHomePage.selectProductAndProceedToBuy();
		//validate PC Perks Cart is displayed?
		s_assert.assertTrue(storeFrontPCUserPage.validatePCPerkCartDisplayed(), "CRP Cart is not displayed");
		//validate adhoc cart is displayed?
		s_assert.assertTrue(storeFrontPCUserPage.validateAdhocCartIsDisplayed(), "Ad-hoc Cart is not displayed");
		//validate 'My Act' dropdown in the top Nav is present
		s_assert.assertTrue(storeFrontPCUserPage.validateMyAccountDDPresentInTopNav(), "My act DD is not displayed in the top Nav");
		s_assert.assertAll(); 
	}

	//Hybris Project-3840:Verify Top Nav as Logged in RC User(.biz)
	@Test 
	public void testVerifyTopNavLoggedInRCUserbizSite_3840() throws InterruptedException	{
		country = driver.getCountry();
		env = driver.getEnvironment(); 
		storeFrontHomePage = new StoreFrontHomePage(driver);
		RFO_DB = driver.getDBNameRFO();
		String PWS = storeFrontHomePage.getBizPWS(country, env);
		PWS = storeFrontHomePage.convertComSiteToBizSite(PWS);
		storeFrontHomePage.openPWS(PWS);
		List<Map<String, Object>> randomRCUserList =  null;
		String rcUserEmailID = null;
		String accountIdForRCUser = null;
		while(true){
			randomRCUserList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguement
					(DBQueries_RFO.GET_RANDOM_ACTIVE_RC_HAVING_ORDERS_RFO,countryId),RFO_DB);
			rcUserEmailID = (String) getValueFromQueryResult(randomRCUserList, "UserName");  
			accountIdForRCUser = String.valueOf(getValueFromQueryResult(randomRCUserList, "AccountID"));
			logger.info("Account Id of the user is "+accountIdForRCUser);

			storeFrontRCUserPage = storeFrontHomePage.loginAsRCUser(rcUserEmailID, password);
			boolean isError = driver.getCurrentUrl().contains("error");
			if(isError){
				logger.info("login error for the user "+rcUserEmailID);
				driver.get(driver.getURL());
			}
			else
				break;
		}
		logger.info("login is successful");
		//add product to cart..
		storeFrontHomePage.hoverOnShopLinkAndClickAllProductsLinks(); 
		storeFrontHomePage.selectProductAndProceedToBuy();
		//validate adhoc cart is displayed?
		s_assert.assertTrue(storeFrontRCUserPage.validateAdhocCartIsDisplayed(), "Ad-hoc Cart is not displayed");
		//validate 'My Act' dropdown in the top Nav is present
		s_assert.assertTrue(storeFrontRCUserPage.validateMyAccountDDPresentInTopNav(), "My act DD is not displayed in the top Nav");
		s_assert.assertAll(); 
	}

	//Hybris Project-3819 Verify links in meet your consultant banner
	@Test 
	public void testVerifyLinksInMeetYourConsultantBanner_3819() {
		RFO_DB = driver.getDBNameRFO();
		List<Map<String, Object>> randomConsultantList =  null;
		String consultantEmailID = null;
		String accountId = null;
		storeFrontHomePage = new StoreFrontHomePage(driver);
		while(true){
			randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguement(DBQueries_RFO.GET_RANDOM_ACTIVE_CONSULTANT_WITH_ORDERS_AND_AUTOSHIPS_RFO,countryId),RFO_DB);
			consultantEmailID = (String) getValueFromQueryResult(randomConsultantList, "UserName");  
			accountId = String.valueOf(getValueFromQueryResult(randomConsultantList, "AccountID"));
			logger.info("Account Id of the user is "+accountId);
			storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailID, password);
			boolean isLoginError = driver.getCurrentUrl().contains("error");
			if(isLoginError){
				logger.info("Login error for the user "+consultantEmailID);
				driver.get(driver.getURL());
			}
			else
				break;
		}
		logger.info("login is successful");
		//click meet your consultant banner link
		storeFrontConsultantPage.clickOnMeetYourConsultantLink();
		//validate we are navigated to "Meet your Consultant" page on .COM
		s_assert.assertTrue(storeFrontConsultantPage.validateMeetYourConsultantPage(),"Meet your consultant page is not displayed");
		s_assert.assertAll();
	}

	//Hybris Project-3825:Verify Top Nav as Logged in RC User(.com)
	@Test 
	public void testVerifyTopNavLoggedInRCUser_3825() throws InterruptedException{
		List<Map<String, Object>> randomRCUserList =  null;
		String rcUserEmailID = null;
		String accountIdForRCUser = null;
		storeFrontHomePage = new StoreFrontHomePage(driver);
		while(true){
			randomRCUserList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguement(DBQueries_RFO.GET_RANDOM_ACTIVE_RC_HAVING_ORDERS_RFO,countryId),RFO_DB);
			rcUserEmailID = (String) getValueFromQueryResult(randomRCUserList, "UserName");  
			accountIdForRCUser = String.valueOf(getValueFromQueryResult(randomRCUserList, "AccountID"));
			logger.info("Account Id of the user is "+accountIdForRCUser);
			storeFrontRCUserPage = storeFrontHomePage.loginAsRCUser(rcUserEmailID, password);
			boolean isSiteNotFoundPresent = driver.getCurrentUrl().contains("sitenotfound");
			if(isSiteNotFoundPresent){
				logger.info("SITE NOT FOUND for the user "+rcUserEmailID);
				driver.get(driver.getURL());
			}
			else
				break;
		}
		logger.info("login is successful");
		//validate home page
		s_assert.assertTrue(storeFrontRCUserPage.validateHomePage(),"home -page is not displayed");
		//add product to cart..
		storeFrontHomePage.hoverOnShopLinkAndClickAllProductsLinks(); 
		storeFrontHomePage.selectProductAndProceedToBuy();
		//validate adhoc cart is displayed?
		s_assert.assertTrue(storeFrontRCUserPage.validateAdhocCartIsDisplayed(), "Ad-hoc Cart is not displayed");
		//validate 'My Act' dropdown in the top Nav is present
		s_assert.assertTrue(storeFrontRCUserPage.validateMyAccountDDPresentInTopNav(), "My act DD is not displayed in the top Nav");
		s_assert.assertAll(); 
	}

	//Hybris Project-3820:Verify the Links in the top Navigation on .COM home Page
	@Test 
	public void testVerifyLinksInTheTopNavigationOnHomePage_3820()	{
		//Navgate to app home page
		storeFrontHomePage = new StoreFrontHomePage(driver);
		//click on logo and validate the homepage
		storeFrontHomePage.clickOnRodanAndFieldsLogo();
		s_assert.assertTrue(storeFrontHomePage.validateHomePage(),"Home page is not displayed ");
		//click login  link and validate username,password,login button & forgot pwd link
		s_assert.assertTrue(storeFrontHomePage.validateLoginFunctionality(),"All the Elements of login functionality are not displayed!");
		//validate 'shop','About' &'Become a Consultant' Menu 
		s_assert.assertTrue(storeFrontHomePage.validateTopNavigationMenuElements(),"Top Menu Navigation Elements are not displayed/present");
		//validate country flag dropdown
		s_assert.assertTrue(storeFrontHomePage.validateCountryFlagDropDownBtn(),"Country flag Drop down button is not present in UI on homepage");
		s_assert.assertAll();
	}	

	//Hybris Project-3822:Verify Footer Links on .COM home Page
	@Test 
	public void testVerifyFooterLinksOnHomePage_3822(){
		//Navgate to app home page
		storeFrontHomePage = new StoreFrontHomePage(driver);
		//validate RF Connection link
		s_assert.assertTrue(storeFrontHomePage.validateRFConnectionLink(),"RF Connection link is not redirecting to proper screen");
		//validate Carrers link
		s_assert.assertTrue(storeFrontHomePage.validateCareersLink(),"Careers link is not redirecting to proper screen");
		//validtae Contact-Us Link
		s_assert.assertTrue(storeFrontHomePage.validateContactUsLink(),"Contact Us link is not redirecting to proper screen");
		//validate Disclaimer link
		s_assert.assertTrue(storeFrontHomePage.validateDisclaimerLink(),"Disclaimer link is not redirecting to proper screen");
		//validate Privacy-policy link
		s_assert.assertTrue(storeFrontHomePage.validatePrivacyPolicyLink(),"PrivacyPolicy link is not redirecting to proper screen");
		//validate Satisfaction-Guarantee link
		s_assert.assertTrue(storeFrontHomePage.validateSatisfactionGuaranteeLink(),"SatisfactionGuarantee link is not redirecting to proper screen");
		//validate Terms&Conditions link
		s_assert.assertTrue(storeFrontHomePage.validateTermsConditionsLink(),"TermsConditions link is not redirecting to proper screen");
		//validate pressroom link
		s_assert.assertTrue(storeFrontHomePage.validatePressRoomLink(),"PressRoom link is not redirecting to proper screen");
		//validate country flag dropdown
		s_assert.assertTrue(storeFrontHomePage.validateCountryFlagDropDownBtn(),"Country flag Drop down button is not present in UI on homepage");
		//validate Derm RF Link
		s_assert.assertTrue(storeFrontHomePage.validateDermRFLink()," Derm RF link is not redirecting to proper screen");
		s_assert.assertAll();
	}

	//Hybris Project-4677:Verify that Country cannot be modified
	@Test 
	public void testCountryCannotBeModified_4677() throws InterruptedException  {
		RFO_DB = driver.getDBNameRFO();
		List<Map<String, Object>> randomConsultantList =  null;
		String consultantEmailID = null;
		String accountId = null;
		storeFrontHomePage = new StoreFrontHomePage(driver);
		storeFrontAccountInfoPage=new StoreFrontAccountInfoPage(driver);
		while(true){
			randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguement(DBQueries_RFO.GET_RANDOM_ACTIVE_CONSULTANT_WITH_ORDERS_AND_AUTOSHIPS_RFO,countryId),RFO_DB);
			consultantEmailID = (String) getValueFromQueryResult(randomConsultantList, "UserName");  
			accountId = String.valueOf(getValueFromQueryResult(randomConsultantList, "AccountID"));
			logger.info("Account Id of the user is "+accountId);
			storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailID, password);
			boolean isLoginError = driver.getCurrentUrl().contains("error");
			if(isLoginError){
				logger.info("Login error for the user "+consultantEmailID);
				driver.get(driver.getURL());
			}
			else
				break;
		}
		logger.info("login is successful");
		//goto account info page..
		storeFrontConsultantPage.clickOnWelcomeDropDown();
		storeFrontAccountInfoPage=storeFrontConsultantPage.clickAccountInfoLinkPresentOnWelcomeDropDown();
		//validate country can't be modified
		s_assert.assertTrue(storeFrontAccountInfoPage.validateCountryCanOrNotBeModified(),"country can be modified on account info page");
		s_assert.assertAll();	
	}

	// Hybris Project-4031:from .com  Login as a existing RC and access Solution Tool
	@Test 
	public void testLoginAsExstingRCAndAccessSolutionTool_4031(){
		RFO_DB = driver.getDBNameRFO();
		country = driver.getCountry();
		env = driver.getEnvironment();  
		storeFrontHomePage = new StoreFrontHomePage(driver);
		storeFrontRCUserPage=new StoreFrontRCUserPage(driver);
		String PWS = storeFrontHomePage.getBizPWS(country, env);
		PWS = storeFrontHomePage.convertBizSiteToComSite(PWS);
		storeFrontHomePage.openPWS(PWS);
		List<Map<String, Object>> randomRCUserList =  null;
		String rcUserEmailID = null;
		String accountIdForRCUser = null;
		while(true){
			randomRCUserList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguement(DBQueries_RFO.GET_RANDOM_RC_RFO,countryId),RFO_DB);
			rcUserEmailID = (String) getValueFromQueryResult(randomRCUserList, "UserName");  
			accountIdForRCUser = String.valueOf(getValueFromQueryResult(randomRCUserList, "AccountID"));
			logger.info("Account Id of the user is "+accountIdForRCUser);
			storeFrontRCUserPage = storeFrontHomePage.loginAsRCUser(rcUserEmailID, password);
			boolean isError = driver.getCurrentUrl().contains("error");
			if(isError){
				logger.info("login error for the user "+rcUserEmailID);
				driver.get(driver.getURL());
			}
			else
				break;
		}
		logger.info("login is successful");
		//Access Solution Tool..
		s_assert.assertTrue(storeFrontRCUserPage.validateAccessSolutionTool(),"Solution tool is not giving the expected results");
		s_assert.assertAll();
	}

	//Hybris Project-1895:To verify the Meet the consultant banner on PWS sites
	@Test 
	public void testValidateMeetConsultantBannerPWSSite_1895()  {
		country = driver.getCountry();
		env = driver.getEnvironment();  
		storeFrontHomePage = new StoreFrontHomePage(driver);
		storeFrontConsultantPage=new StoreFrontConsultantPage(driver);
		storeFrontHomePage.openPWSSite(country, env);

		//click meet your consultant banner link
		storeFrontConsultantPage.clickOnMeetYourConsultantLink();
		//validate we are navigated to "Meet your Consultant" page on .COM
		s_assert.assertTrue(storeFrontConsultantPage.validateMeetYourConsultantPage(),"Meet your consultant page is not displayed");
		//validate 'edit your information' link shouldn't be present as user doesn't logged in..
		s_assert.assertFalse(storeFrontConsultantPage.validateEditYourInformationLink(), "edit your Information link is present in UI");
		s_assert.assertFalse(storeFrontHomePage.verifyConsultantSinceOnMeetYourConsultantPage(), "Consultant since is not present");
		s_assert.assertAll();
	}

	//Hybris Project-1904:To Verify the cancel functionality on edit meet the consultant page from com site
	@Test 
	public void testCancelFunctionalityOnEditMeetYourConsultantPageComSite_1904()  {
		RFO_DB = driver.getDBNameRFO();
		country = driver.getCountry();
		env = driver.getEnvironment();  
		storeFrontHomePage = new StoreFrontHomePage(driver);
		String consultantEmailID = null;
		while(true){
			List<Map<String, Object>> sponserList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguementPWS(DBQueries_RFO.GET_RANDOM_CONSULTANT_WITH_PWS_RFO,driver.getEnvironment(),driver.getCountry(),countryId),RFO_DB);
			consultantEmailID = String.valueOf(getValueFromQueryResult(sponserList, "Username"));
			String PWS = String.valueOf(getValueFromQueryResult(sponserList, "URL"));
			String comPWS = storeFrontHomePage.convertBizSiteToComSite(PWS);
			storeFrontHomePage.openPWS(comPWS);

			//Login with same PWS consultant
			storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailID, password);
			boolean isLoginError = driver.getCurrentUrl().contains("error");
			if(isLoginError){
				logger.info("Login error for the user "+consultantEmailID);
				driver.get(driver.getURL());
			}
			else
				break;
		}
		logger.info("login is successful");
		//click meet your consultant banner link
		storeFrontConsultantPage.clickOnMeetYourConsultantLink();
		//validate we are navigated to "Meet your Consultant" page
		s_assert.assertTrue(storeFrontConsultantPage.validateMeetYourConsultantPage(),"Meet your consultant page is not displayed");
		//click on 'Personalize My  Profile' link..
		storeFrontHomePage.clickOnPersonalizeMyProfileLink();
		//click on cancel button on 'editConsultantInfo' page
		storeFrontHomePage.clickCancelBtnOnEditConsultantInfoPage();
		//validate we are navigated to "Meet your Consultant" page
		s_assert.assertTrue(storeFrontConsultantPage.validateMeetYourConsultantPage(),"Meet your consultant page is not displayed");
		s_assert.assertAll();
	}

	//Hybris Project-1905:To Verify the Submission Guidelines link on edit meet the consultant page from biz site
	@Test 
	public void testSubmissionGuidelinesLinkOnEditMeetTheConsultantPageBizSite_1905()  {
		RFO_DB = driver.getDBNameRFO();
		country = driver.getCountry();
		env = driver.getEnvironment();  
		storeFrontHomePage = new StoreFrontHomePage(driver);
		String consultantEmailID = null;
		while(true){
			List<Map<String, Object>> sponserList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguementPWS(DBQueries_RFO.GET_RANDOM_CONSULTANT_WITH_PWS_RFO,driver.getEnvironment(),driver.getCountry(),countryId),RFO_DB);
			consultantEmailID = String.valueOf(getValueFromQueryResult(sponserList, "Username"));
			String PWS = String.valueOf(getValueFromQueryResult(sponserList, "URL"));
			String comPWS = storeFrontHomePage.convertComSiteToBizSite(PWS);
			storeFrontHomePage.openPWS(comPWS);

			//Login with same PWS consultant
			storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailID, password);
			boolean isLoginError = driver.getCurrentUrl().contains("error");
			if(isLoginError){
				logger.info("Login error for the user "+consultantEmailID);
				driver.get(driver.getURL());
			}
			else
				break;
		}
		logger.info("login is successful");
		//click meet your consultant banner link
		storeFrontConsultantPage.clickOnMeetYourConsultantLink();
		//validate we are navigated to "Meet your Consultant" page
		s_assert.assertTrue(storeFrontConsultantPage.validateMeetYourConsultantPage(),"Meet your consultant page is not displayed");
		//click on 'Personalize My  Profile' link..
		storeFrontHomePage.clickOnPersonalizeMyProfileLink();
		// Click on Submission Guidelines link in the MeetYourConsultant edit information page & validate SG Pdf is open..
		s_assert.assertTrue(storeFrontHomePage.validateSubmissionGuideLinesLink(),"Submission Guoidelines link is not giving the expected results");
		s_assert.assertAll();
	}

	// Hybris Project-1920:To verify the contact us functionality in edit meet the consultant page for com PWS site
	@Test 
	public void testContactUsFunctionalityInEditMeetConsultantPagecomPWSSite_1920(){
		RFO_DB = driver.getDBNameRFO();
		country = driver.getCountry();
		env = driver.getEnvironment(); 
		String comPWS = null;
		storeFrontHomePage = new StoreFrontHomePage(driver);
		String consultantEmailID = null;
		while(true){
			List<Map<String, Object>> sponserList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguementPWS(DBQueries_RFO.GET_RANDOM_CONSULTANT_WITH_PWS_RFO,driver.getEnvironment(),driver.getCountry(),countryId),RFO_DB);
			consultantEmailID = String.valueOf(getValueFromQueryResult(sponserList, "Username"));
			String PWS = String.valueOf(getValueFromQueryResult(sponserList, "URL"));
			comPWS = storeFrontHomePage.convertBizSiteToComSite(PWS);
			storeFrontHomePage.openPWS(comPWS);

			//Login with same PWS consultant
			storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailID, password);
			boolean isLoginError = driver.getCurrentUrl().contains("error");
			if(isLoginError){
				logger.info("Login error for the user "+consultantEmailID);
				driver.get(driver.getURL());
			}
			else
				break;
		}
		logger.info("login is successful");
		//click meet your consultant banner link
		storeFrontConsultantPage.clickOnMeetYourConsultantLink();
		//validate we are navigated to "Meet your Consultant" page
		s_assert.assertTrue(storeFrontConsultantPage.validateMeetYourConsultantPage(),"Meet your consultant page is not displayed");
		//click on 'Personalize My  Profile' link..
		storeFrontHomePage.clickOnPersonalizeMyProfileLink();
		//select the checkbox next to the email field and click save..
		storeFrontHomePage.checkEmailFieldCBOnEditConsultantInfoPage();
		storeFrontHomePage.clickOnSaveAfterEditPWS();
		//validate we are navigated to "Meet your Consultant" page
		s_assert.assertTrue(storeFrontConsultantPage.validateMeetYourConsultantPage(),"Meet your consultant page is not displayed");

		logout();

		storeFrontHomePage.openPWS(comPWS);

		//Login with same PWS consultant
		storeFrontHomePage.loginAsConsultant(consultantEmailID, password);
		storeFrontConsultantPage.clickOnMeetYourConsultantLink();
		s_assert.assertFalse(storeFrontHomePage.verifyEmailIdIsPresentInContactBox(), "Email Address is not Present in contact box After Edit");
		s_assert.assertTrue(storeFrontHomePage.verifyEnterYourNameFunctionalityIsPresentOnMeetMyConsultantPage(), "Enter your name box is not present on com site");
		s_assert.assertTrue(storeFrontHomePage.verifyEnterYourEmailFunctionalityIsPresentOnMeetMyConsultantPage(), "Enter your email box is not present on com site");
		s_assert.assertTrue(storeFrontHomePage.verifyEnterYourMessageFunctionalityIsPresentOnMeetMyConsultantPage(), "Enter your Message box is not present on com site");
		s_assert.assertTrue(storeFrontHomePage.verifySubmitButtonIsPresentOnMeetMyConsultantPage(), "Send button is not present on com site");

		logout();

		String bizPWS = storeFrontHomePage.convertComSiteToBizSite(comPWS);
		storeFrontHomePage.openPWS(bizPWS);

		//Login with same PWS consultant
		storeFrontHomePage.loginAsConsultant(consultantEmailID, password);
		storeFrontConsultantPage.clickOnMeetYourConsultantLink();
		s_assert.assertFalse(storeFrontHomePage.verifyEmailIdIsPresentInContactBox(), "Email Address is not Present in contact box After Edit");
		s_assert.assertTrue(storeFrontHomePage.verifyEnterYourNameFunctionalityIsPresentOnMeetMyConsultantPage(), "Enter your name box is not present on com site");
		s_assert.assertTrue(storeFrontHomePage.verifyEnterYourEmailFunctionalityIsPresentOnMeetMyConsultantPage(), "Enter your email box is not present on com site");
		s_assert.assertTrue(storeFrontHomePage.verifyEnterYourMessageFunctionalityIsPresentOnMeetMyConsultantPage(), "Enter your Message box is not present on com site");
		s_assert.assertTrue(storeFrontHomePage.verifySubmitButtonIsPresentOnMeetMyConsultantPage(), "Send button is not present on com site");

		s_assert.assertAll();
	}

	//Hybris Project-1898:To verify the contact your sponsor section in getting started page
	@Test 
	public void testContactYourSponsorSectionInGettingStartedPage_1898() throws InterruptedException{
		storeFrontHomePage = new StoreFrontHomePage(driver);
		RFO_DB = driver.getDBNameRFO();
		phoneNumber = TestConstants.PHONE_NUMBER_CA;
		storeFrontHomePage = new StoreFrontHomePage(driver);
		String bizPWS = null;
		int randomNum = CommonUtils.getRandomNum(10000, 1000000);
		String firstName=TestConstants.FIRST_NAME+randomNum;
		while(true){
			List<Map<String, Object>> sponserList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguementPWS(DBQueries_RFO.GET_RANDOM_CONSULTANT_WITH_PWS_RFO,driver.getEnvironment(),driver.getCountry(),countryId),RFO_DB);
			String consultantEmailID = String.valueOf(getValueFromQueryResult(sponserList, "Username"));
			String PWS = String.valueOf(getValueFromQueryResult(sponserList, "URL"));
			bizPWS = storeFrontHomePage.convertComSiteToBizSite(PWS);
			storeFrontHomePage.openPWS(bizPWS);
			storeFrontHomePage.clickOnSponsorName();
			s_assert.assertTrue(storeFrontHomePage.verifyJoinMyTeamLinkPresent(), "Join My Team Link is not present on the Com page");
			s_assert.assertTrue(storeFrontHomePage.verifyContactBoxIsPresent(), "Contact Box is not Present");
			s_assert.assertTrue(storeFrontHomePage.verifyEmailIdIsPresentInContactBox(), "Email Address is not Present in contact box");
			//Login with same PWS consultant
			storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailID, password);
			boolean isLoginError = driver.getCurrentUrl().contains("error");
			if(isLoginError){
				logger.info("Login error for the user "+consultantEmailID);
				driver.get(driver.getURL());
			}
			else
				break;
		}
		storeFrontHomePage.clickOnWelcomeDropDown();
		storeFrontHomePage.clickAccountInfoLinkPresentOnWelcomeDropDown();
		storeFrontHomePage.clickOnYourAccountDropdown();
		storeFrontHomePage.clickOnEditMyPWS();
		storeFrontHomePage.enterPhoneNumberOnEditPWS(phoneNumber);
		s_assert.assertTrue(storeFrontHomePage.verifyConsultantSinceOnMeetYourConsultantPage(), "Email Address is not Present in contact box After Edit");
		String emailAddress = firstName+randomNum+"@xyz.com"; 
		storeFrontHomePage.updateEmailOnMeetYourConsultantPage(emailAddress);
		storeFrontHomePage.clickOnSaveAfterEditPWS();
		logout();
		storeFrontHomePage.openPWS(bizPWS);
		storeFrontHomePage.clickOnSponsorName();

		s_assert.assertTrue(storeFrontHomePage.verifyEmailIdIsPresentInContactBoxAfterUpdate(emailAddress), "Email Address is not Present in contact box After Edit");
		s_assert.assertTrue(storeFrontHomePage.verifyPhoneNumberIsPresentInContactBox(phoneNumber), "Phone number is not Present in contact box After Edit");
		s_assert.assertAll();

	}

	// Hybris Project-4030:from .com  Login as a existing PC and access Solution Tool
	@Test 
	public void testLoginAsExstingPCAndAccessSolutionTool_4030()  {
		RFO_DB = driver.getDBNameRFO();
		country = driver.getCountry();
		env = driver.getEnvironment();  
		storeFrontHomePage = new StoreFrontHomePage(driver);
		storeFrontPCUserPage=new StoreFrontPCUserPage(driver);
		String bizPWS = storeFrontHomePage.getBizPWS(country, env);
		String comPWS = storeFrontHomePage.convertBizSiteToComSite(bizPWS);
		storeFrontHomePage.openPWS(comPWS);

		List<Map<String, Object>> randomPCUserList =  null;
		String pcUserEmailID = null;
		String accountIdForPCUser = null;
		while(true){
			randomPCUserList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguement(DBQueries_RFO.GET_RANDOM_ACTIVE_PC_WITH_ORDERS_AND_AUTOSHIPS_RFO,countryId),RFO_DB);
			pcUserEmailID = (String) getValueFromQueryResult(randomPCUserList, "UserName");  
			accountIdForPCUser = String.valueOf(getValueFromQueryResult(randomPCUserList, "AccountID"));
			logger.info("Account Id of the user is "+accountIdForPCUser);

			storeFrontPCUserPage = storeFrontHomePage.loginAsPCUser(pcUserEmailID, password);
			boolean isSiteNotFoundPresent = driver.getCurrentUrl().contains("error");
			if(isSiteNotFoundPresent){
				logger.info("login error for the user "+pcUserEmailID);
				driver.get(driver.getURL());
			}
			else
				break;
		}
		logger.info("login is successful");
		//Access Solution Tool..
		s_assert.assertTrue(storeFrontPCUserPage.validateAccessSolutionTool(),"Solution tool is not giving the expected results");
		s_assert.assertAll();
	}

	//Hybris Project-1897:To verify the Meet the consultant banner on solution tool page
	@Test 
	public void testMeetConsultantBannerOnSolutionToolPage_1897(){
		RFO_DB = driver.getDBNameRFO();  
		country = driver.getCountry();
		env = driver.getEnvironment();  
		storeFrontHomePage = new StoreFrontHomePage(driver);
		String PWS = storeFrontHomePage.getBizPWS(country, env);
		PWS = storeFrontHomePage.convertBizSiteToComSite(PWS);
		storeFrontHomePage.openPWS(PWS);
		List<Map<String, Object>> randomConsultantList =  null;
		String consultantEmailID = null;
		String accountId = null;
		while(true){
			randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguement(DBQueries_RFO.GET_RANDOM_ACTIVE_CONSULTANT_WITH_ORDERS_AND_AUTOSHIPS_RFO,countryId),RFO_DB);
			consultantEmailID = (String) getValueFromQueryResult(randomConsultantList, "UserName");  
			accountId = String.valueOf(getValueFromQueryResult(randomConsultantList, "AccountID"));
			logger.info("Account Id of the user is "+accountId);
			storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailID, password);
			boolean isLoginError = driver.getCurrentUrl().contains("error");
			if(isLoginError){
				logger.info("Login error for the user "+consultantEmailID);
				driver.get(driver.getURL());
			}
			else
				break;
		}
		logger.info("login is successful");
		//click learn more link
		storeFrontHomePage.clickLearnMoreLinkUnderSolutionToolAndSwitchControl();
		//validate consultant info on top right corner..
		s_assert.assertTrue(storeFrontHomePage.validateConsultantNameOnTopRightCorner(),"Consultant Info is not present on right top Corner");
		s_assert.assertAll();
	}

	// Hybris Project-4028:Access Solution tool from .COM Site Category pages Left Menu
	@Test 
	public void testAccessSolutionToolcomSiteCategoryPagesLeftMenu_4028()	 {
		country = driver.getCountry();
		env = driver.getEnvironment();  
		storeFrontHomePage = new StoreFrontHomePage(driver);
		String PWS = storeFrontHomePage.getBizPWS(country, env);
		PWS = storeFrontHomePage.convertBizSiteToComSite(PWS);
		storeFrontHomePage.openPWS(PWS);
		//Access Solution Tool..
		s_assert.assertTrue(storeFrontHomePage.validateAccessSolutionTool(),"Solution tool is not giving the expected results");
		s_assert.assertAll();
	}

	//Hybris Project-3977:Search for a sponsor from "Connect with a consultant" page
	@Test 
	public void testSearchForASponsorFromConnectWithAConsultantPage_3977() throws InterruptedException{
		RFO_DB = driver.getDBNameRFO(); 
		List<Map<String, Object>> randomConsultantList =  null;
		String accountID = null;
		String consultantEmailId = null;
		country = driver.getCountry();
		String sponsorID = null;
		storeFrontHomePage = new StoreFrontHomePage(driver);
		randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguementPWS(DBQueries_RFO.GET_RANDOM_CONSULTANT_WITH_PWS_RFO,driver.getEnvironment(),driver.getCountry(),countryId),RFO_DB);
		consultantEmailId =  String.valueOf(getValueFromQueryResult(randomConsultantList, "Username"));
		logger.info("Consultant with PWS is "+consultantEmailId);
		accountID = String.valueOf(getValueFromQueryResult(randomConsultantList, "AccountID"));
		logger.info("Account Id of the user is "+accountID);

		// Get Account Number
		List<Map<String, Object>>sponsorIdList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguement(DBQueries_RFO.GET_ACCOUNT_NUMBER_FOR_PWS,accountID),RFO_DB);
		sponsorID = (String) getValueFromQueryResult(sponsorIdList, "AccountNumber");
		storeFrontHomePage.clickOnConnectWithAConsultant();
		s_assert.assertTrue(storeFrontHomePage.verifyFindYourSponsorPage(), "Find your sponsor page is not present");

		// assert for name
		storeFrontHomePage.searchCID();
		s_assert.assertTrue(storeFrontHomePage.verifySponsorListIsPresentAfterClickOnSearch(), "sponsor list is not present when serach by name");

		// assert for prefix
		storeFrontHomePage.searchCID();
		s_assert.assertTrue(storeFrontHomePage.verifySponsorListIsPresentAfterClickOnSearch(), "sponsor list is not present when serach by prefix");

		// assert for CID
		storeFrontHomePage.searchCID(sponsorID);
		s_assert.assertTrue(storeFrontHomePage.verifySponsorListIsPresentAfterClickOnSearch(), "sponsor list is not present when serach by CID");
		storeFrontHomePage.mouseHoverSponsorDataAndClickContinue();

		String currentPWS = driver.getCurrentUrl();
		s_assert.assertTrue(currentPWS.contains("com"), "After select sponsor current url does not contain .com");
		s_assert.assertFalse(currentPWS.contains("corp"), "After select sponsor current url does  contain corp");
		s_assert.assertAll();
	}

	// Hybris Project-1892:To verify the Meet the consultant page UI for com and biz site
	@Test
	public void testVerifyMeetConsultantPage_1892() throws InterruptedException{
		RFO_DB = driver.getDBNameRFO(); 
		List<Map<String, Object>> randomConsultantList =  null;
		String consultantEmailID = null;
		String accountID = null;
		country = driver.getCountry();
		storeFrontHomePage = new StoreFrontHomePage(driver);

		//Get Biz PWS from database to login. 
		randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguementPWS(DBQueries_RFO.GET_RANDOM_ACTIVE_CONSULTANT_WITH_PWS_RFO,driver.getEnvironment()+".biz",driver.getCountry(),countryId),RFO_DB);
		String bizPWS=(String) getValueFromQueryResult(randomConsultantList, "URL"); 
		//Open Biz PWS.
		storeFrontHomePage.openConsultantPWS(bizPWS);
		while(true){
			if(driver.getCurrentUrl().contains("sitenotfound")){
				randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguementPWS(DBQueries_RFO.GET_RANDOM_ACTIVE_CONSULTANT_WITH_PWS_RFO,driver.getEnvironment()+".biz",driver.getCountry(),countryId),RFO_DB);
				bizPWS=(String) getValueFromQueryResult(randomConsultantList, "URL");  
				storeFrontHomePage.openConsultantPWS(bizPWS); 
				continue;
			}else
				break;
		} 
		logger.info("biz pws to login is "+bizPWS);

		//Verify details on biz site.
		while(true){
			randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguementPWS(DBQueries_RFO.GET_RANDOM_ACTIVE_CONSULTANT_WITH_PWS_RFO,driver.getEnvironment()+".biz",driver.getCountry(),countryId),RFO_DB);
			consultantEmailID= (String) getValueFromQueryResult(randomConsultantList, "Username"); 
			accountID = String.valueOf(getValueFromQueryResult(randomConsultantList, "AccountID"));
			logger.info("Account Id of the user is "+accountID);
			storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailID, password);
			boolean isLoginError = driver.getCurrentUrl().contains("error");
			if(isLoginError){
				logger.info("Login error for the user "+consultantEmailID);
				storeFrontHomePage.openConsultantPWS(bizPWS);  
			}
			else
				break;
		}
		//s_assert.assertTrue(storeFrontConsultantPage.verifyConsultantPage(),"Consultant Page doesn't contain Welcome User Message");
		logger.info("login is successful");
		storeFrontConsultantPage.clickOnMeetYourConsultantLink();
		//validate we are navigated to "Meet your Consultant" page
		s_assert.assertTrue(storeFrontConsultantPage.validateMeetYourConsultantPage(),"Meet your consultant page is not displayed");
		//Validate Contact me section on meet your consultant page.
		s_assert.assertTrue(storeFrontHomePage.verifyContactBoxIsPresent(),"Contact me section is not present");
		s_assert.assertTrue(storeFrontHomePage.verifyEnterYourNameFunctionalityIsPresentOnMeetMyConsultantPage(),"Enter your Name functionality is not present on meet your consultant page");
		s_assert.assertTrue(storeFrontHomePage.verifyEnterYourEmailFunctionalityIsPresentOnMeetMyConsultantPage(),"Enter your email functionality is not present on meet your consultant page");
		s_assert.assertTrue(storeFrontHomePage.verifyEnterYourMessageFunctionalityIsPresentOnMeetMyConsultantPage(),"Enter your Message functionality is not present on meet your consultant page");
		//Validate Follow me section on meet your consultant page.
		storeFrontHomePage.addFollowMeSection(TestConstants.FACEBOOK_LINK);
		s_assert.assertTrue(storeFrontHomePage.verifyFollowMeSectionIsPresent(),"Follow me section is not present");
		//Validate Footer section on meet your consultant page.
		s_assert.assertTrue(storeFrontHomePage.verifyPrivacyPolicyLink(),"Privacy Policy Link is not present");
		s_assert.assertTrue(storeFrontHomePage.verifySatisfactionGuaranteeLink(),"Satisfaction guarantee link is not present");
		s_assert.assertTrue(storeFrontHomePage.verifyDisclaimerLink(),"Disclaimer link is not present");
		s_assert.assertTrue(storeFrontHomePage.verifyContactUsLink(),"Contact us link is not present");
		logout();
		//Verify details on com site.
		//Get com PWS from database to login. 
		randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguementPWS(DBQueries_RFO.GET_RANDOM_ACTIVE_CONSULTANT_WITH_PWS_RFO,driver.getEnvironment()+".com",driver.getCountry(),countryId),RFO_DB);
		String comPWS=(String) getValueFromQueryResult(randomConsultantList, "URL"); 
		//Open Biz PWS.
		storeFrontHomePage.openConsultantPWS(comPWS);
		while(true){
			if(driver.getCurrentUrl().contains("sitenotfound")){
				randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguementPWS(DBQueries_RFO.GET_RANDOM_ACTIVE_CONSULTANT_WITH_PWS_RFO,driver.getEnvironment()+".com",driver.getCountry(),countryId),RFO_DB);
				comPWS=(String) getValueFromQueryResult(randomConsultantList, "URL");  
				storeFrontHomePage.openConsultantPWS(comPWS); 
				continue;
			}else
				break;
		} 
		logger.info("com pws to login is "+comPWS);
		storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailID, password);
		//s_assert.assertTrue(storeFrontConsultantPage.verifyConsultantPage(),"Consultant Page doesn't contain Welcome User Message");
		logger.info("login is successful");
		storeFrontConsultantPage.clickOnMeetYourConsultantLink();
		//validate we are navigated to "Meet your Consultant" page
		s_assert.assertTrue(storeFrontConsultantPage.validateMeetYourConsultantPage(),"Meet your consultant page is not displayed");
		//Validate Contact me section on meet your consultant page.
		s_assert.assertTrue(storeFrontHomePage.verifyContactBoxIsPresent(),"Contact me section is not present");
		s_assert.assertTrue(storeFrontHomePage.verifyEnterYourNameFunctionalityIsPresentOnMeetMyConsultantPage(),"Enter your Name functionality is not present on meet your consultant page");
		s_assert.assertTrue(storeFrontHomePage.verifyEnterYourEmailFunctionalityIsPresentOnMeetMyConsultantPage(),"Enter your email functionality is not present on meet your consultant page");
		s_assert.assertTrue(storeFrontHomePage.verifyEnterYourMessageFunctionalityIsPresentOnMeetMyConsultantPage(),"Enter your Message functionality is not present on meet your consultant page");
		//Validate Follow me section on meet your consultant page.
		storeFrontHomePage.addFollowMeSection(TestConstants.FACEBOOK_LINK);
		s_assert.assertTrue(storeFrontHomePage.verifyFollowMeSectionIsPresent(),"Follow me section is not present");
		//Validate Footer section on meet your consultant page.
		s_assert.assertTrue(storeFrontHomePage.verifyPrivacyPolicyLink(),"Privacy Policy Link is not present");
		s_assert.assertTrue(storeFrontHomePage.verifySatisfactionGuaranteeLink(),"Satisfaction guarantee link is not present");
		s_assert.assertTrue(storeFrontHomePage.verifyDisclaimerLink(),"Disclaimer link is not present");
		s_assert.assertTrue(storeFrontHomePage.verifyContactUsLink(),"Contact us link is not present");
		s_assert.assertAll();
	}

	// Hybris Project-1900:To verify the More About Me section for PWS Biz
	@Test
	public void testToVerifyTheMoreAboutMeSectionForPWSBiz_1900() throws InterruptedException{
		RFO_DB = driver.getDBNameRFO();
		List<Map<String, Object>> randomConsultantList =  null;

		String consultantEmailId =null;
		String accountId = null;

		country = driver.getCountry();
		env = driver.getEnvironment();
		storeFrontHomePage = new StoreFrontHomePage(driver);
		storeFrontHomePage.openPWSSite(country, env);
		while(true){
			randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguementPWS(DBQueries_RFO.GET_RANDOM_ACTIVE_CONSULTANT_WITH_PWS_RFO,driver.getEnvironment()+".com",driver.getCountry(),countryId),RFO_DB);
			consultantEmailId = (String) getValueFromQueryResult(randomConsultantList, "UserName");  
			accountId = String.valueOf(getValueFromQueryResult(randomConsultantList, "AccountID"));
			logger.info("Account Id of the user is "+accountId);

			storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailId, password);
			boolean isError = driver.getCurrentUrl().contains("error");
			if(isError){
				logger.info("login error for the user "+consultantEmailId);
				driver.get(driver.getURL());
			}
			else
				break;
		} 
		storeFrontConsultantPage.clickOnWelcomeDropDown();
		storeFrontConsultantPage.clickOnEditMyPWS();
		storeFrontConsultantPage.addNewContentOfYourOwnCopy();
		storeFrontConsultantPage.clickResetToDefaultCopyLink();
		s_assert.assertTrue(storeFrontConsultantPage.verifyDefaultContentReseted(),"Default content is not reseted");
		storeFrontConsultantPage.addNewContentOfYourOwnCopy();
		storeFrontConsultantPage.clickSaveButton();
		s_assert.assertTrue(storeFrontConsultantPage.verifyNewlyAddedContentSaved(),"newly added content not saved");
		s_assert.assertTrue(storeFrontConsultantPage.validateMeetYourConsultantPage(),"This is not meet your consultant page");
		s_assert.assertAll();
	}

	//Hybris Project-1899:To verify the More About Me section for PWS Com
	@Test
	public void testToVerifyTheMoreAboutMeSectionForPWSCom_1899(){
		RFO_DB = driver.getDBNameRFO();
		List<Map<String, Object>> randomConsultantList =  null;

		String consultantEmailId =null;
		String accountId = null;

		country = driver.getCountry();
		env = driver.getEnvironment();
		storeFrontHomePage = new StoreFrontHomePage(driver);
		storeFrontHomePage.openComPWSSite(country, env);
		while(true){
			randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguementPWS(DBQueries_RFO.GET_RANDOM_ACTIVE_CONSULTANT_WITH_PWS_RFO,driver.getEnvironment()+".com",driver.getCountry(),countryId),RFO_DB);
			consultantEmailId = (String) getValueFromQueryResult(randomConsultantList, "UserName");  
			accountId = String.valueOf(getValueFromQueryResult(randomConsultantList, "AccountID"));
			logger.info("Account Id of the user is "+accountId);

			storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailId, password);
			boolean isError = driver.getCurrentUrl().contains("error");
			if(isError){
				logger.info("login error for the user "+consultantEmailId);
				driver.get(driver.getURL());
			}
			else
				break;
		} 
		logger.info("login is successful");
		storeFrontConsultantPage.clickOnMeetYourConsultantLink();
		storeFrontHomePage.clickOnPersonalizeMyProfileLink();
		storeFrontConsultantPage.addNewContentOfYourOwnCopyInComPWS();
		storeFrontConsultantPage.clickResetToDefaultCopyLinkInComPWS();
		s_assert.assertTrue(storeFrontConsultantPage.verifyDefaultContentResetedForComPWS(),"Default content is not reseted");
		storeFrontConsultantPage.addNewContentOfYourOwnCopyInComPWS();
		storeFrontConsultantPage.clickSaveButton();
		s_assert.assertTrue(storeFrontConsultantPage.verifyNewlyAddedContentSaved(),"newly added content not saved");
		s_assert.assertTrue(storeFrontConsultantPage.validateMeetYourConsultantPage(),"This is not meet your consultant page");
		s_assert.assertAll();
	}

	//Hybris Project-4055:View Meet your consultant Page on .BIZ & .COM as Logged in US Consultant (PWS Owner)
	@Test
	public void testViewYourConsultantPageOnBizAndCOMLoggedInUSConsultant_4055(){
		RFO_DB = driver.getDBNameRFO();
		List<Map<String, Object>> randomConsultantList =  null;

		String consultantEmailId =null;
		String accountId = null;

		country = driver.getCountry();
		env = driver.getEnvironment();
		storeFrontHomePage = new StoreFrontHomePage(driver);
		storeFrontHomePage.openPWSSite(country, env);
		while(true){
			randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguementPWS(DBQueries_RFO.GET_RANDOM_ACTIVE_CONSULTANT_WITH_PWS_RFO,driver.getEnvironment()+".com",driver.getCountry(),countryId),RFO_DB);
			consultantEmailId = (String) getValueFromQueryResult(randomConsultantList, "UserName");  
			accountId = String.valueOf(getValueFromQueryResult(randomConsultantList, "AccountID"));
			logger.info("Account Id of the user is "+accountId);

			storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailId, password);
			boolean isError = driver.getCurrentUrl().contains("error");
			if(isError){
				logger.info("login error for the user "+consultantEmailId);
				driver.get(driver.getURL());
			}
			else
				break;
		} 
		storeFrontConsultantPage.clickOnMeetYourConsultantLink();
		s_assert.assertTrue(storeFrontConsultantPage.verifyPersonalizeMyProfileLinkPresent(),"Personalize my profile link is not present at meet your consultant page");
		storeFrontHomePage.openComPWSSite(country, env);
		storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailId, password);
		storeFrontConsultantPage.clickOnMeetYourConsultantLink();
		s_assert.assertTrue(storeFrontConsultantPage.verifyPersonalizeMyProfileLinkPresent(),"Personalize my profile link is not present at meet your consultant page");
		s_assert.assertAll();
	}

	// Hybris Project-4056:Edit the Meet Your Consultant Page and Personalise and Save the changes
	@Test
	public void testEditTheMeetYourConsultantPageAndPersonaliseAndSaveTheChanges_4056(){
		RFO_DB = driver.getDBNameRFO();
		List<Map<String, Object>> randomConsultantList =  null;

		String consultantEmailId =null;
		String accountId = null;

		country = driver.getCountry();
		env = driver.getEnvironment();
		String phoneNumber = TestConstants.PHONE_NUMBER;
		storeFrontHomePage = new StoreFrontHomePage(driver);
		storeFrontHomePage.openPWSSite(country, env);
		while(true){
			randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguementPWS(DBQueries_RFO.GET_RANDOM_ACTIVE_CONSULTANT_WITH_PWS_RFO,driver.getEnvironment()+".com",driver.getCountry(),countryId),RFO_DB);
			consultantEmailId = (String) getValueFromQueryResult(randomConsultantList, "UserName");  
			accountId = String.valueOf(getValueFromQueryResult(randomConsultantList, "AccountID"));
			logger.info("Account Id of the user is "+accountId);

			storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailId, password);
			boolean isError = driver.getCurrentUrl().contains("error");
			if(isError){
				logger.info("login error for the user "+consultantEmailId);
				driver.get(driver.getURL());
			}
			else
				break;
		} 
		storeFrontConsultantPage.clickOnMeetYourConsultantLink();
		storeFrontHomePage.clickOnPersonalizeMyProfileLink();
		storeFrontConsultantPage.enterPhoneNumberOnEditPWS(phoneNumber);
		storeFrontConsultantPage.clickSaveButton();
		s_assert.assertTrue(storeFrontHomePage.verifyContactBoxIsPresent(),"contactBox is not present");
		s_assert.assertTrue(storeFrontConsultantPage.validateEditedPhoneNumberSaved(phoneNumber),"Information is not edited in personalize my profile");
		s_assert.assertAll();
	}

	//Hybris Project-4054:Login to Canadian PWS site with US Consultant's Credentials(Owner of the PWS site)
	@Test
	public void testLoginToCanadianPWSsiteWithUSConsultantCredential_4054(){
		RFO_DB = driver.getDBNameRFO();
		List<Map<String, Object>> randomConsultantList =  null;

		String consultantEmailId =null;
		String accountId = null;

		country = "ca";
		env = driver.getEnvironment();
		storeFrontHomePage = new StoreFrontHomePage(driver);
		storeFrontHomePage.openPWSSite(country, env);
		while(true){
			randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguementPWS(DBQueries_RFO.GET_RANDOM_ACTIVE_CONSULTANT_WITH_PWS_RFO,driver.getEnvironment()+".com",driver.getCountry(),countryId),RFO_DB);
			consultantEmailId = (String) getValueFromQueryResult(randomConsultantList, "UserName");  
			accountId = String.valueOf(getValueFromQueryResult(randomConsultantList, "AccountID"));
			logger.info("Account Id of the user is "+accountId);

			storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailId, password);
			boolean isError = driver.getCurrentUrl().contains("error");
			if(isError){
				logger.info("login error for the user "+consultantEmailId);
				driver.get(driver.getURL());
			}
			else
				break;
		} 
		logger.info("login is successful");
		s_assert.assertTrue(storeFrontConsultantPage.verifyShopSkinCareLinkPresent(),"shop skincare Link is not present in header");
		s_assert.assertTrue(storeFrontConsultantPage.verifyAboutRFLinkPresent(),"ABOUT R+F link is not present in the header");
		s_assert.assertAll();
	}

	//Hybris Project-4280:Login with USer Name and verify Edit Meet your Consultant Page
	@Test
	public void testLoginWithUserNameAndVerifyEditMeetYourConsultantPage_4280() {
		RFO_DB = driver.getDBNameRFO();  
		List<Map<String, Object>> randomConsultantList =  null;
		String consultantWithPWSEmailID = null; //TestConstants.CONSULTANT_USERNAME;
		String consultantPWSURL = null; //TestConstants.CONSULTANT_COM_URL;
		storeFrontHomePage = new StoreFrontHomePage(driver);
		randomConsultantList =DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguementPWS(DBQueries_RFO.GET_RANDOM_CONSULTANT_WITH_PWS_RFO,driver.getEnvironment(),driver.getCountry(),countryId),RFO_DB);
		consultantWithPWSEmailID = (String) getValueFromQueryResult(randomConsultantList, "UserName");
		consultantPWSURL = (String) getValueFromQueryResult(randomConsultantList, "URL");

		// For .com site
		consultantPWSURL = storeFrontHomePage.convertBizSiteToComSite(consultantPWSURL);
		storeFrontHomePage.openPWS(consultantPWSURL);
		storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantWithPWSEmailID, password);
		storeFrontHomePage.clickOnUserName();
		storeFrontHomePage.clickOnPersonalizeMyProfileLink();
		//Clear Home Town City Name Field
		storeFrontConsultantPage.eraseHomeTownCityName();
		storeFrontHomePage.clickOnSaveAfterEditPWS();
		//click on Personalize My Profile link again and validate the change made
		storeFrontHomePage.clickOnPersonalizeMyProfileLink();
		//validate HomeTown City field is blank
		s_assert.assertTrue(storeFrontConsultantPage.validateHomeTownCityFieldValueIsNull(),"Home Town City Field Value is not null");

		// For .biz site
		consultantPWSURL = storeFrontHomePage.convertComSiteToBizSite(consultantPWSURL);
		storeFrontHomePage.openPWS(consultantPWSURL);
		storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantWithPWSEmailID, password);
		storeFrontHomePage.clickOnUserName();
		storeFrontHomePage.clickOnPersonalizeMyProfileLink();
		//Clear Home Town City Name Field
		storeFrontConsultantPage.eraseHomeTownCityName();
		storeFrontHomePage.clickOnSaveAfterEditPWS();
		//click on Personalize My Profile link again and validate the change made
		storeFrontHomePage.clickOnPersonalizeMyProfileLink();
		//validate HomeTown City field is blank
		s_assert.assertTrue(storeFrontConsultantPage.validateHomeTownCityFieldValueIsNull(),"Home Town City Field Value is not null");
		s_assert.assertAll();
	}

	//Hybris Project-3997:Login in as RC user and go to find a consultant page
	@Test
	public void testLoginAsRCUserAndValidateSearchFieldOnFindAConsPage_3997(){
		RFO_DB = driver.getDBNameRFO();
		List<Map<String, Object>> randomRCList =  null;
		String rcUserEmailID =null;
		String accountId = null;
		storeFrontHomePage = new StoreFrontHomePage(driver);
		while(true){
			randomRCList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguement(DBQueries_RFO.GET_RANDOM_ACTIVE_RC_HAVING_ORDERS_RFO,countryId),RFO_DB);
			rcUserEmailID = (String) getValueFromQueryResult(randomRCList, "UserName");  
			accountId = String.valueOf(getValueFromQueryResult(randomRCList, "AccountID"));
			logger.info("Account Id of the user is "+accountId);

			storeFrontRCUserPage = storeFrontHomePage.loginAsRCUser(rcUserEmailID, password);
			boolean isError = driver.getCurrentUrl().contains("error");
			if(isError){
				logger.info("login error for the user "+rcUserEmailID);
				driver.get(driver.getURL());
			}
			else
				break;
		} 
		logger.info("login is successful");
		//Navigate to find A Consultant page..
		storeFrontHomePage.clickFindAConsultantLinkOnHomePage();
		//verify search field should be present on find a consultant page
		s_assert.assertTrue(storeFrontHomePage.validateConsultantSearchFieldPresent(),"Sponsor/Consultant Search field is not present on 'Find A Consultant' Page");
		s_assert.assertAll();
	}

	// Hybris Project-3995:Login in as PC user and go to find a consultant page
	@Test
	public void testLoginAsPCUserAndValidateSearchFieldOnFindAConsPage_3995() throws InterruptedException{
		int randomNum = CommonUtils.getRandomNum(10000, 1000000);  
		String newBillingProfileName = TestConstants.NEW_BILLING_PROFILE_NAME+randomNum;
		String lastName = "lN";
		country = driver.getCountry();
		storeFrontHomePage = new StoreFrontHomePage(driver);
		String firstName=TestConstants.FIRST_NAME+randomNum;
		storeFrontHomePage.hoverOnShopLinkAndClickAllProductsLinks();

		// Products are displayed?
		s_assert.assertTrue(storeFrontHomePage.areProductsDisplayed(), "quickshop products not displayed");
		logger.info("Quick shop products are displayed");

		//Select a product with the price less than $80 and proceed to buy it
		storeFrontHomePage.applyPriceFilterLowToHigh();
		storeFrontHomePage.selectProductAndProceedToBuyWithoutFilter();

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
		storeFrontHomePage.clickPlaceOrderBtn();
		s_assert.assertTrue(storeFrontHomePage.verifyPCPerksTermsAndConditionsPopup(),"PC Perks terms and conditions popup not visible when checkboxes for t&c not selected and place order button clicked");
		logger.info("PC Perks terms and conditions popup is visible when checkboxes for t&c not selected and place order button clicked");
		storeFrontHomePage.clickOnPCPerksTermsAndConditionsCheckBoxes();
		storeFrontHomePage.clickPlaceOrderBtn();
		storeFrontHomePage.clickOnRodanAndFieldsLogo();
		s_assert.assertTrue(storeFrontHomePage.verifyWelcomeDropdownToCheckUserRegistered(), "User NOT registered successfully");
		//Navigate to find A Consultant page..
		storeFrontHomePage.clickFindAConsultantLinkOnHomePage();
		//verify search field should be present on find a consultant page
		s_assert.assertTrue(storeFrontHomePage.validateConsultantSearchFieldPresent(),"Sponsor/Consultant Search field is not present on 'Find A Consultant' Page");
		s_assert.assertAll();
	}

	//Hybris Project-3993:Search with US terminated consultnat's Full name
	@Test
	public void testSearchWithUSTerminatedConsultantFullName_3993() throws InterruptedException
	{
		RFO_DB = driver.getDBNameRFO(); 
		List<Map<String, Object>> randomConsultantList =  null;
		String consultantEmailID = null;
		String accountID = null;
		storeFrontHomePage = new StoreFrontHomePage(driver);
		while(true){
			randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguement(DBQueries_RFO.GET_RANDOM_ACTIVE_CONSULTANT_WITH_ORDERS_AND_AUTOSHIPS_RFO,countryId),RFO_DB);
			consultantEmailID = (String) getValueFromQueryResult(randomConsultantList, "UserName");  
			accountID = String.valueOf(getValueFromQueryResult(randomConsultantList, "AccountID"));
			logger.info("Account Id of the user is "+accountID);
			storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailID, password);
			boolean isLoginError = driver.getCurrentUrl().contains("error");
			if(isLoginError){
				logger.info("Login error for the user "+consultantEmailID);
				driver.get(driver.getURL());
			}
			else
				break;
		}
		logger.info("login is successful");
		storeFrontConsultantPage.clickOnWelcomeDropDown();
		storeFrontAccountInfoPage = storeFrontConsultantPage.clickAccountInfoLinkPresentOnWelcomeDropDown();
		storeFrontAccountInfoPage.clickOnYourAccountDropdown();
		storeFrontAccountTerminationPage = storeFrontAccountInfoPage.clickTerminateMyAccount();
		storeFrontAccountTerminationPage.fillTheEntriesAndClickOnSubmitDuringTermination();
		s_assert.assertTrue(storeFrontAccountTerminationPage.validateConfirmAccountTerminationPopUp(), "confirm account termination pop up is not displayed");
		s_assert.assertTrue(storeFrontAccountTerminationPage.verifyAccountTerminationIsConfirmedPopup(), "Account still exist");
		storeFrontAccountTerminationPage.clickConfirmTerminationBtn();  
		storeFrontAccountTerminationPage.clickOnCloseWindowAfterTermination();
		storeFrontHomePage.clickOnCountryAtWelcomePage();
		//connect with a consultant
		storeFrontHomePage.clickConnectUnderConnectWithAConsultantSection();
		//search with terminated consultant
		storeFrontHomePage.enterSponsorNameAndClickOnSearchForPCAndRC(consultantEmailID);
		//verify invalid sponsor
		s_assert.assertTrue(storeFrontHomePage.validateInvalidSponsor(),"Terminated Sponsor is Present!!");
		s_assert.assertAll(); 
	}

	//Hybris Project-3989:Search with CA terminated consultnat's Full name
	@Test
	public void testSearchWithCATerminatedConsultantFullName_3989() throws InterruptedException	{
		RFO_DB = driver.getDBNameRFO(); 
		List<Map<String, Object>> randomConsultantList =  null;
		String consultantEmailID = null;
		String accountID = null;
		storeFrontHomePage = new StoreFrontHomePage(driver);
		while(true){
			randomConsultantList = DBUtil.performDatabaseQuery(DBQueries_RFO.callQueryWithArguement(DBQueries_RFO.GET_RANDOM_ACTIVE_CONSULTANT_WITH_ORDERS_AND_AUTOSHIPS_RFO,countryId),RFO_DB);
			consultantEmailID = (String) getValueFromQueryResult(randomConsultantList, "UserName");  
			accountID = String.valueOf(getValueFromQueryResult(randomConsultantList, "AccountID"));
			logger.info("Account Id of the user is "+accountID);
			storeFrontConsultantPage = storeFrontHomePage.loginAsConsultant(consultantEmailID, password);
			boolean isLoginError = driver.getCurrentUrl().contains("error");
			if(isLoginError){
				logger.info("Login error for the user "+consultantEmailID);
				driver.get(driver.getURL());
			}
			else
				break;
		}
		logger.info("login is successful");
		storeFrontConsultantPage.clickOnWelcomeDropDown();
		storeFrontAccountInfoPage = storeFrontConsultantPage.clickAccountInfoLinkPresentOnWelcomeDropDown();
		storeFrontAccountInfoPage.clickOnYourAccountDropdown();
		storeFrontAccountTerminationPage = storeFrontAccountInfoPage.clickTerminateMyAccount();
		storeFrontAccountTerminationPage.fillTheEntriesAndClickOnSubmitDuringTermination();
		s_assert.assertTrue(storeFrontAccountTerminationPage.validateConfirmAccountTerminationPopUp(), "confirm account termination pop up is not displayed");
		s_assert.assertTrue(storeFrontAccountTerminationPage.verifyAccountTerminationIsConfirmedPopup(), "Account still exist");
		storeFrontAccountTerminationPage.clickConfirmTerminationBtn();  
		storeFrontAccountTerminationPage.clickOnCloseWindowAfterTermination();
		storeFrontHomePage.clickOnCountryAtWelcomePage();
		//connect with a consultant
		storeFrontHomePage.clickConnectUnderConnectWithAConsultantSection();
		//search with terminated consultant
		storeFrontHomePage.enterSponsorNameAndClickOnSearchForPCAndRC(consultantEmailID);
		//verify invalid sponsor
		s_assert.assertTrue(storeFrontHomePage.validateInvalidSponsor(),"Terminated Sponsor is Present!!");
		s_assert.assertAll(); 
	}

}
