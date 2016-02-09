package com.rf.pages.website.cscockpit;


import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.By;
import com.rf.core.driver.website.RFWebsiteDriver;
import com.rf.core.utils.CommonUtils;
import com.thoughtworks.selenium.webdriven.commands.IsElementPresent;

public class CSCockpitAutoshipSearchTabPage extends CSCockpitRFWebsiteBasePage{
	private static final Logger logger = LogManager
			.getLogger(CSCockpitAutoshipSearchTabPage.class.getName());

	private static String ddValuesLoc = "//div[@class='z-combobox-pp'][contains(@style,'display: block')]//tr[contains(@class,'z-combo-item')][@z.label='%s']";
	private static String autoshipSearchResultsLoc = "//div[@class='csSearchResults']//div[@class='z-listbox-header']//table/tbody[2]//div[contains(text(),'%s')]";
	private static String lastOrderStatusResultsLoc = "//div[@class='csListboxContainer']/descendant::table[2]/tbody[2]/tr[%s]/td[11]//span";
	private static String lastOrderNumberLoc = "//div[@class='csListboxContainer']/descendant::table[2]/tbody[2]/tr[%s]/td[10]//a";

	private static final By SEARCH_BY_FIELD_LOC = By.xpath("//span[text()='Search By:']//ancestor::div[1]");
	private static final By TEMPLATE_TYPE_FIELD_LOC = By.xpath("//span[text()='Template Type:']//ancestor::div[1]");
	private static final By SEARCH_BY_DD_FIRST_OPTION_LOC = By.xpath("//body[@class='gecko gecko34']/div[@class='z-combobox-pp']//tr/td[contains(text(),'Next')]");
	private static final By SEARCH_BY_DD_SECOND_OPTION_LOC = By.xpath("//body[@class='gecko gecko34']/div[@class='z-combobox-pp']/table//tr[2]");
	private static final By SEARCH_BY_DD_THIRD_OPTION_LOC = By.xpath("//body[@class='gecko gecko34']/div[@class='z-combobox-pp']/table//tr[3]");
	private static final By SEARCH_BY_DD_IMG_LOC = By.xpath("//span[contains(text(),'Search By')]/following::img[1]");
	private static final By TEMPLATE_TYPE_DD_IMG_LOC = By.xpath("//span[contains(text(),'Template Type')]/following::img[1]");
	private static final By LAST_ORDER_STATUS_DD_IMG_LOC = By.xpath("//span[contains(text(),'Last Order Status')]/following::img[1]");
	private static final By TEMPLATE_STATUS_DD_IMG_LOC = By.xpath("//span[contains(text(),'Template Status')]/following::img[1]");
	private static final By TEMPLATE_TYPE_DD_FOURTH_OPTION_LOC = By.xpath("//body[@class='gecko gecko34']/div[@class='z-combobox-pp']/table//tr[4]");
	private static final By ORDER_STATUS_FIELD_LOC = By.xpath("//span[text()='Last Order Status']//ancestor::div[1]");
	private static final By CUSTOMER_NAME_FIELD_LOC = By.xpath("//span[text()='Customer Name or CID']");
	private static final By SPONSOR_NAME_FIELD_LOC = By.xpath("//span[text()='Sponsor Name or CID']");
	private static final By TEMPLATE_NAME_FIELD_LOC = By.xpath("//span[text()='Template Number']");
	private static final By RUN_SELECTED_BUTTON_LOC = By.xpath("//td[text()='Run Selected']");
	private static final By SEARCH_AUTOSHIP_BUTTON_LOC = By.xpath("//td[text()='Search Autoship']");
	private static final By AUTOSHIP_TEMPLATE = By.xpath("//span[contains(text(),'Autoship Template #')]");
	private static final By CALENDER_ICON = By.xpath("//img[@class='z-datebox-img']");
	private static final By SEARCH_RESULT_SELECT_ALL_COLUMN = By.xpath("//div[@class='csSearchResults']//div[@class='z-listbox-header']//table/tbody[2]//a[text()='Select All']");
	private static final By CUSTOMER_NAME_TXT_AREA_LOC = By.xpath("//span[text()='Customer Name or CID']/following::input[1]");
	private static final By TOTAL_CUSTOMERS_FROM_RESULT_FIRST_PAGE = By.xpath("//div[@class='csListboxContainer']/descendant::table[2]/tbody[2]/tr");
	private static final By CALENDER_ICON__FOR_ALL_DUE_DATE = By.xpath("//img[@class='z-datebox-img']/../ancestor::span[@style='display: none;']");

	protected RFWebsiteDriver driver;

	public CSCockpitAutoshipSearchTabPage(RFWebsiteDriver driver) {
		super(driver);
		this.driver = driver;
	}

	public boolean isAutoshipTemplateDisplayedInAutoshipTemplateTab(){
		driver.isElementPresent(AUTOSHIP_TEMPLATE);
		return driver.isElementPresent(AUTOSHIP_TEMPLATE);  
	}

	public boolean verifySearchByFieldPresentOnAutoshipSearch() {
		return driver.isElementPresent(SEARCH_BY_FIELD_LOC);
	}

	public boolean verifyTemplateTypeFieldPresentOnAutoshipSearch() {
		return driver.isElementPresent(TEMPLATE_TYPE_FIELD_LOC);
	}

	public boolean verifyLastOrderStatusFieldPresentOnAutoshipSearch() {
		return driver.isElementPresent(ORDER_STATUS_FIELD_LOC);
	}

	public boolean verifyCustomerNameCidFieldPresentOnAutoshipPage() {
		return driver.isElementPresent(CUSTOMER_NAME_FIELD_LOC);
	}

	public boolean verifySponsorNameCidFieldPresentOnAutoshipPage() {
		return driver.isElementPresent(SPONSOR_NAME_FIELD_LOC);
	}

	public boolean verifyTemplateNumberCidFieldPresentOnAutoshipPage() {
		return driver.isElementPresent(TEMPLATE_NAME_FIELD_LOC);
	}

	public boolean verifyRunSelectedButtonPresent() {
		return driver.isElementPresent(RUN_SELECTED_BUTTON_LOC);
	}

	public boolean verifySearchAutoshipButtonPresent() {
		return driver.isElementPresent(SEARCH_AUTOSHIP_BUTTON_LOC);
	}

	public void clickSearchByDropDown(){
		driver.click(SEARCH_BY_DD_IMG_LOC);
	}

	public void clickTemplateTypeDropDown(){
		driver.click(TEMPLATE_TYPE_DD_IMG_LOC);
	}

	public void clickLastOrderStatusDropDown(){
		driver.click(LAST_ORDER_STATUS_DD_IMG_LOC);
	}

	public void clickTemplateStatusDropDown(){
		driver.click(TEMPLATE_STATUS_DD_IMG_LOC);
	}

	public boolean isSearchByDropDownValuePresent(String ddValue){	
		logger.info("Drop down value to be verified is "+ddValue);
		return driver.isElementPresent(By.xpath(String.format(ddValuesLoc, ddValue)));
	}

	public boolean isTemplateTypeDropDownValuePresent(String ddValue){	
		logger.info("Drop down value to be verified is "+ddValue);
		return driver.isElementPresent(By.xpath(String.format(ddValuesLoc, ddValue)));
	}

	public boolean islastOrderStatusDropDownValuePresent(String ddValue){
		logger.info("Drop down value to be verified is "+ddValue);
		return driver.isElementPresent(By.xpath(String.format(ddValuesLoc, ddValue)));
	}

	public boolean isTemplateStatusDropDownValuePresent(String ddValue){
		logger.info("Drop down value to be verified is "+ddValue);
		return driver.isElementPresent(By.xpath(String.format(ddValuesLoc, ddValue)));
	}

	public boolean isCalenderIconPresent(){
		return driver.isElementPresent(CALENDER_ICON);
	}

	public void clickSearchAutoshipButton() {
		driver.click(SEARCH_AUTOSHIP_BUTTON_LOC);
		driver.waitForCSCockpitLoadingImageToDisappear();
		driver.pauseExecutionFor(6000);
	}

	public boolean isSearchResultsColumnNamePresent(String value){
		logger.info("Column name to be verified is "+value);
		driver.waitForElementPresent(By.xpath(String.format(autoshipSearchResultsLoc, value)));
		return driver.isElementPresent(By.xpath(String.format(autoshipSearchResultsLoc, value)));
	}

	public boolean isSelectAllColumnPresent(){
		return driver.isElementPresent(SEARCH_RESULT_SELECT_ALL_COLUMN);
	}

	public void selectlastOrderStatusDropDownValue(String ddValue){
		logger.info("Drop down value to be verified is "+ddValue);
		driver.click(By.xpath(String.format(ddValuesLoc, ddValue)));
	}

	public String getLastOrderStatus(String customerSequenceNumber){
		driver.waitForElementPresent(By.xpath(String.format(lastOrderStatusResultsLoc, customerSequenceNumber)));
		String orderStatus = driver.findElement((By.xpath(String.format(lastOrderStatusResultsLoc, customerSequenceNumber)))).getText();
		return orderStatus;
	}

	public void enterCustomerNameOrCID(String customerName){
		driver.waitForElementNotPresent(CUSTOMER_NAME_TXT_AREA_LOC);
		driver.type(CUSTOMER_NAME_TXT_AREA_LOC, customerName);
	}

	public boolean isAutoshipSearchResultsPresent(){
		driver.waitForElementPresent(TOTAL_CUSTOMERS_FROM_RESULT_FIRST_PAGE);
		return driver.isElementPresent(TOTAL_CUSTOMERS_FROM_RESULT_FIRST_PAGE); 
	}

	public void selectSearchByDropDownValue(String ddValue){ 
		logger.info("Drop down value to be verified is "+ddValue);
		driver.click(By.xpath(String.format(ddValuesLoc, ddValue)));
	}

	public void clearCustomerNameOrCID(){
		driver.waitForElementNotPresent(CUSTOMER_NAME_TXT_AREA_LOC);
		driver.clear(CUSTOMER_NAME_TXT_AREA_LOC);
	}

	public void clickLastOrderNumber(String customerSequenceNumber){
		driver.waitForElementPresent(By.xpath(String.format(lastOrderNumberLoc, customerSequenceNumber)));
		if(driver.findElement((By.xpath(String.format(lastOrderNumberLoc, customerSequenceNumber)))).getText().isEmpty()==false){
			driver.click(By.xpath(String.format(lastOrderNumberLoc, customerSequenceNumber)));
		}else{
			int totalAutoshipOrderNumber = driver.findElements(TOTAL_CUSTOMERS_FROM_RESULT_FIRST_PAGE).size();
			for(int i=0; i<=totalAutoshipOrderNumber; i++){
				logger.info("total customers in the customer search result is "+totalAutoshipOrderNumber);
				int randomCustomerFromSearchResult = CommonUtils.getRandomNum(1, totalAutoshipOrderNumber);
				logger.info("Random Customer sequence number is "+randomCustomerFromSearchResult);
				if(driver.findElement((By.xpath(String.format(lastOrderNumberLoc, randomCustomerFromSearchResult)))).getText().isEmpty()==true){
					continue;
				}else{
					driver.click(By.xpath(String.format(lastOrderNumberLoc, randomCustomerFromSearchResult)));
					break;
				}
			}
		}

	}

	public boolean isCalenderIconPresentForAllDueDate(){
		driver.waitForElementPresent(CALENDER_ICON__FOR_ALL_DUE_DATE);
		return driver.isElementPresent(CALENDER_ICON__FOR_ALL_DUE_DATE);
	}

}