package com.rf.pages.website.rehabitat.storeFront;

import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;

import com.rf.core.driver.website.RFWebsiteDriver;
import com.rf.core.utils.CommonUtils;
import com.rf.core.website.constants.TestConstants;
import com.rf.pages.website.rehabitat.storeFront.basePage.StoreFrontWebsiteBasePage;

import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class StoreFrontShopSkinCarePage extends StoreFrontWebsiteBasePage{
	public StoreFrontShopSkinCarePage(RFWebsiteDriver driver) {
		super(driver);		
	}

	private static final Logger logger = LogManager
			.getLogger(StoreFrontShopSkinCarePage.class.getName());

	private final By YOUR_PRICE_FOR_ALL_PRODUCTS_LOC = By.xpath("//div[@id='product_listing']/descendant::span[contains(@id,'cust_price') and contains(text(),'$')]");
	private final By RETAIL_PRICE_FOR_ALL_PRODUCTS_LOC = By.xpath("//div[@id='product_listing']/descendant::span[contains(@id,'retail') and contains(text(),'$')]");
	private final By PAGINATION_NEXT_ARROW_LOC = By.xpath("//li[@class='pagination-next']/a");
	private final By SHOP_BY_PRICE_FILTER_SELECTED_OPTION_LOC = By.xpath("//select[@id='sortOptions1']/option[@selected]");
	private final By PRODUCT_QTY_ON_CHECKOUT_POPUP_LOC = By.xpath("//div[@id='cboxLoadedContent']//div[@class='qty']");
	private final By QTY_TF_ON_QUICK_VIEW_POPUP_LOC = By.xpath("//input[@id='qty']");
	private final By ADD_TO_CART_BTN_ON_QUICK_VIEW_POPUP_LOC = By.xpath("//div[@id='myModal' and contains(@style,'display')]//button[contains(text(),'Add to bag')]");
	private final By CHECKOUT_BUTTON_POPUP_LOC = By.xpath("//a[contains(text(),'Checkout')]");
	private final By SHOP_BY_PRICE_FILTER_OPTION_LOW_TO_HIGH_LOC = By.xpath("//select[@id='sortOptions1']/descendant::option[3]");
	private final By REFINE_PRODUCT_CATEGORY_FILTER_DD_LOC = By.xpath("//div[@id='product-facet']/descendant::div[text()[normalize-space()='Shop by Category'] or text()[normalize-space()='Shop by category']]");
	private final By ADD_TO_CART_BUTTON_FROM_QUICK_VIEW_POPUP_LOC=By.xpath("//div[@class='addToCartBtn-wrapper']/button");
	private final By CLOSE_QUICK_VIEW_OPTION_POPUP_LOC=By.xpath("//button[@class='close']");
	private final By PRODUCT_IMAGE_QUICK_VIEW_POPUP_LOC=By.xpath(".//*[@id='myModal']//div[@class='quick-view-popup']");
	private final By SUBSCRIBE_PLUS_SAVE_DD_OPTIONS_LOC=By.xpath("//div[@class='product-item'][1]//span[contains(text(),'subscribe + save')]");
	private final By ADD_TO_CRP_DD_OPTIONS_LOC=By.xpath("//div[@class='product-item'][1]//span[contains(text(),'Add to CRP')]");
	private final By PRODUCT_PRICE_ON_CEHCKOUT_POPUP = By.xpath("//div[@class='add-to-cart-item']//div[@class='details']/div[@class='price']");
	private final By YOUR_PRICE_ON_QUICK_VIEW_POPUP_LOC = By.xpath("//div[@class='quick-view-popup']//span[@id='cust_price']");
	private final By VIEW_PRODUCT_DETAILS_LINK_ON_QUICK_VIEW_LOC = By.xpath("//div[@id='quickViewPDP']//a[contains(text(),'View Product Details')]");
	private final By ADD_MORE_ITEMS_BUTTON_ON_CHCKOUT_POPUP_LOC = By.xpath("//a[contains(text(),'Add More Items')]");
	private final By CLOSE_BUTTON_FOR_CHCKOUT_POPUP_LOC = By.xpath("//button[@id='cboxClose']") ;
	private final By YES_ON_ENROLL_IN_CRP_POPUP_LOC = By.xpath("//div[@id='enrollCRPModal'][1]//input[@value='Yes']");
	private final By ADD_TO_CRP_OF_FIRST_PRODUCT = By.xpath("//div[@id='product_listing']/descendant::span[contains(text(),'Add to CRP')][1]");
	private final By QUANTITY_AT_QUICK_VIEW_OPTION_LOC=By.id("qty");

	private final By PRODUCT_POPUP_LOC=By.id("cboxClose");
	private final By SPECIFIC_PRICE_QUICK_VIEW_POPUP_LOC = By.xpath("//div[@id='myModal']//span[@id='cust_price' and contains(text(),'Your Price')]");
	private final By RETAIL_PRICE_QUICK_VIEW_POPUP_LOC = By.xpath("//div[@id='myModal']//span[@id='retail' and contains(text(),'Retail')]");
	private final By PC_PERKS_ORDER_BTN_ON_QUICK_VIEW_POPUP_LOC = By.xpath("//div[@id='myModal' and contains(@style,'display')]//button[contains(text(),'Add to bag')]/following-sibling::div//button[contains(@class,'addToCartButton_perks')]");
	private final By ONE_TIME_ORDER_BTN_ON_QUICK_VIEW_POPUP_LOC = By.xpath("//div[@id='myModal' and contains(@style,'display')]//button[contains(text(),'Add to bag')]/following-sibling::div//span[contains(text(),'One Time Order')]/ancestor::button");
	private final By PRODUCT_IMG_ON_QUICK_VIEW_POPUP_LOC = By.xpath("//div[@id='myModal' and contains(@style,'display')]//div[contains(@class,'product-image')]//img");
	private final By PC_PERKS_PROMO_MSG_LOC = By.xpath("//div[@id='pc_perks_comp']/div[@class='content']/div[contains(text(),'Subscribe + Save 10%')]");
	private final By PC_PERKS_SAVE_AMOUNT_LOC = By.xpath("//span[@class='pcli']");
	private final By SHOP_BY_PRICE_FILTER_OPTION_DEFAULT_LOC = By.xpath("//select[@id='sortOptions1']/descendant::option[1]");
	private final By CLEAR_ALL_LINK_LOC = By.id("clear_all");
	//private final By ADD_TO_CART_BTN_LOC = By.xpath("//div[@id='product_listing']/descendant::button[text()='Add to cart'][1]");
	private final By ADD_TO_CART_ONE_TIME_ORDER_LOC = By.xpath("//div[@id='product_listing']/descendant::span[contains(text(),'One Time Order')][1]");

	protected String addToCartButtonThroughProdIdLoc = "//a[contains(@href,'%s') and @class='name']/following::button[contains(text(),'Add to bag')][1]";
	private String productPriceThroughProdIdLoc = "//a[contains(@href,'%s') and @class='name']//following::span[contains(text(),'%s')][1]/following-sibling::span[contains(@class,'productPrice')]";
	private String addToCartDDThroughProdIdLoc = "//a[contains(@href,'%s') and @class='name']//following::span[contains(text(),'%s')][1]";
	private String randomCategoryIDLoc = "//div[@id='product-facet']//descendant::ul[2]/li[%s]//descendant::input[contains(@id,'ID')]";
	private String retailAndSVPriceLoc = "//div[@class='product-item'][%s]//span[@class='totalSV']";
	private String consultantPriceLoc="//div[@class='product-item'][%s]//span[@id='retail']";
	private String productPriceOnQuickViewPopupThroughOrderTypeLoc = "//*[@id='command']/descendant::span[contains(text(),'%s')]/following-sibling::span[contains(@class,'productPrice')]";
	private String appliedFilterLoc = "//div[@id='applied_filters']/descendant::li[%s]";
	private String productNameOnQuickViewPopupLoc = "//div[@id='myModal' and contains(@style,'display')]//div[contains(@class,'product-details')]/div[@class='name']/a[contains(text(),'%s')]";
	private String regimenNameInShopByCategoryDD = "//div[@id='product-facet']//descendant::ul[2]//span[contains(text(),'%s')]";
	private String specificPriceForProductLoc = "//div[contains(@class,'product__listing')]//div[@class='product-item'][%s]//em[@class='priceLabel' and contains(text(),'Your Price:')]/ancestor::span";
	private String productLinkThroughProductNameLoc = "//div[@id='product_listing']/descendant::a[@class='name' and contains(text(),'%s')]";
	private String addToCRPButtonThroughProductNumber = "//div[@id='product_listing']/descendant::span[contains(text(),'Add to CRP')][%s]";
	private String addToPCPerksButtonThroughProductNumber = "//div[@class='product-item'][%s]//span[contains(text(),'subscribe + save')]";
	private String quickViewForSpecificProductLoc = "//div[@class='product__listing product__grid']//div[@class='product-item'][%s]/a[@class='thumb']";
	private String productNameLoc = "//div[@class='product__listing product__grid']//a[contains(text(),'%s')]";
	private String categoryNameLoc = "//div[@id='product-facet']//descendant::ul[2]/li/descendant::span[contains(text(),'%s')]/preceding::label[1]";
	private String randomProductCategoryCheckbox = "//div[@id='product-facet']//descendant::ul[2]/li[%s]//descendant::label[2]";
	private String yourpriceOfProductLoc = "//div[contains(@class,'product__listing')]//div[@class='product-item'][%s]//em[contains(text(),'Your Price')]/..";
	private String productPriceThroughProductNumberLoc = "//div[@id='product_listing']/descendant::span[contains(text(),'%s')][%s]/following-sibling::span[contains(@class,'productPrice')]";
	private String addToCartDDLoc = "//div[@id='product_listing']/descendant::span[contains(text(),'%s')][%s]";
	private String randomCategoryName = randomProductCategoryCheckbox+"/following::span[1]/span[2]";
	private String quickViewLinkThroughProductIdLoc = "//a[contains(@href,'%s') and @class='name']/preceding::a[@class='thumb'][1]";

	/***
	 * This method verify the product price filter High to Low applied successfully
	 * 
	 * 
	 * @param
	 * @return boolean value.
	 * 
	 */

	public boolean isPriceFilterHighToLowAppliedSuccessfully(){
		int totalProducts = driver.findElements(TOTAL_PRODUCTS_LOC).size();
		if(totalProducts>=3){
			String firstProductPrice = driver.findElement(By.xpath(String.format(priceOfProductLoc, "1"))).getText().split("\\$")[1].trim();
			String secondProductPrice = driver.findElement(By.xpath(String.format(priceOfProductLoc, "2"))).getText().split("\\$")[1].trim();
			String thirdProductPrice = driver.findElement(By.xpath(String.format(priceOfProductLoc, "3"))).getText().split("\\$")[1].trim();
			double priceFirstProduct = Double.parseDouble(firstProductPrice);
			double priceSecondProduct = Double.parseDouble(secondProductPrice);
			double priceThirdProduct = Double.parseDouble(thirdProductPrice);
			if(priceFirstProduct>priceSecondProduct && priceSecondProduct>priceThirdProduct){
				return true;
			}
			else
				return false;
		}
		else if(totalProducts==1){
			return true;
		}
		else 
			return false;
	}

	/***
	 * This method select sort by price filter Low to High
	 * 
	 * @param
	 * @return store front Home page object
	 * 
	 */
	public StoreFrontShopSkinCarePage productPriceFilterLowToHigh(){
		driver.click(SORT_FILTER_DD_LOC);
		logger.info("Sort filter dropdown clicked");
		driver.click(SHOP_BY_PRICE_FILTER_OPTION_LOW_TO_HIGH_LOC);
		logger.info("Price filter 'LOW TO HIGH' selected");
		driver.waitForPageLoad();
		return this;
	}

	public boolean isPriceFilterLowToHighAppliedSuccessfully(){
		int totalProducts = driver.findElements(TOTAL_PRODUCTS_LOC).size();
		if(totalProducts>=3){
			String firstProductPrice = driver.findElement(By.xpath(String.format(priceOfProductLoc, "1"))).getText().split("\\$")[1].trim();
			String secondProductPrice = driver.findElement(By.xpath(String.format(priceOfProductLoc, "2"))).getText().split("\\$")[1].trim();
			String thirdProductPrice = driver.findElement(By.xpath(String.format(priceOfProductLoc, "3"))).getText().split("\\$")[1].trim();
			double priceFirstProduct = Double.parseDouble(firstProductPrice);
			double priceSecondProduct = Double.parseDouble(secondProductPrice);
			double priceThirdProduct = Double.parseDouble(thirdProductPrice);
			if(priceFirstProduct<priceSecondProduct && priceSecondProduct<priceThirdProduct){
				return true;
			}
			else
				return false;
		}
		else if(totalProducts==1){
			return true;
		}
		else 
			return false;
	}

	/***
	 * This method Refine Product by category name
	 * 
	 * @param
	 * @return store front Home page object
	 * 
	 */
	public StoreFrontShopSkinCarePage refineProductByCategory(String categoryName){
		driver.clickByJS(RFWebsiteDriver.driver,REFINE_PRODUCT_CATEGORY_FILTER_DD_LOC);
		logger.info("Refine category filter dropdown clicked");
		driver.clickByJS(RFWebsiteDriver.driver,By.xpath(String.format(categoryNameLoc, categoryName)));
		logger.info("Product category selected is "+categoryName);
		driver.waitForPageLoad();
		return this;
	}

	/***
	 * This method get product name from all product page
	 * 
	 * @param
	 * @return product name.
	 * 
	 */

	public String getProductNameFromAllProductPage(String productNumber){
		driver.pauseExecutionFor(2000);
		String productName = driver.findElement(By.xpath(String.format(productNameLinkLoc, productNumber))).getText().split("\\.")[0].trim();
		logger.info("Product name from all product page is "+productName);
		return productName;
	}

	/***
	 * This method get the product count having more price
	 * 
	 * @param totalNoOfProduct priceRange
	 * @return product count
	 * 
	 */
	public int getProductNumberAccordingToPriceRange(int totalNoOfProduct, double priceRange){
		int productNumber = 0;
		for(int i=1; i<=totalNoOfProduct; i++){
			String price = driver.findElement(By.xpath(String.format(yourpriceOfProductLoc, i))).getText().split("\\$")[1].trim();
			double priceFromUI = Double.parseDouble(price);
			if(priceFromUI>priceRange){
				productNumber = i;
				break;
			}
		}
		return productNumber;
	}

	/***
	 * This method verifies if the specified product is displayed
	 *  on the page or not
	 * @param productName
	 * @return
	 */
	public boolean isProductPresentOnPage(String productName){
		return driver.isElementVisible(By.xpath(String.format(productNameLoc, productName)));
	}

	/***
	 * This method press Escape
	 * 
	 * @param 
	 * @return shop skincare page Object
	 * 
	 */
	public StoreFrontShopSkinCarePage pressEscapeFromQuickViewPopup(){
		WebElement element = driver.findElement(ADD_TO_CART_BUTTON_FROM_QUICK_VIEW_POPUP_LOC);
		element.sendKeys(Keys.ESCAPE);
		return this;
	}
	/***
	 * This method click on add to cart button from quick view popup
	 * 
	 * @param 
	 * @return shop skincare page Object
	 * 
	 */
	public StoreFrontShopSkinCarePage clickAddToCartFromQuickViewPopup(){
		driver.pauseExecutionFor(5000);
		driver.click(ADD_TO_CART_BUTTON_FROM_QUICK_VIEW_POPUP_LOC);
		return this;
	}
	/***
	 * This method click close icon of quick view popup
	 * 
	 * @param 
	 * @return shop skincare page Object
	 * 
	 */
	public StoreFrontShopSkinCarePage closeQuickViewOptionPopup(){
		driver.click(CLOSE_QUICK_VIEW_OPTION_POPUP_LOC);
		return this;
	}

	/***
	 * This method validates Image of product in quick view popup.
	 * 
	 * @param 
	 * @return boolean value
	 * 
	 */
	public boolean isProductImageQuickViewPopupDisplayed(){
		driver.pauseExecutionFor(3000);
		return driver.findElement(PRODUCT_IMAGE_QUICK_VIEW_POPUP_LOC).isDisplayed();
	}

	/***
	 * This method validates presence of checkout popup.
	 * 
	 * @param 
	 * @return boolean value
	 * 
	 */
	public boolean isCheckoutPopupDisplayed(){
		driver.pauseExecutionFor(6000);
		return driver.isElementVisible(CHECKOUT_BUTTON_POPUP_LOC);
	}

	/**
	 * This method click on the Add more items Button on the popup on the cart.
	 * @return StoreFrontShopSkinCarePage object
	 */
	public StoreFrontShopSkinCarePage clickOnAddMoreItemsOnCheckoutPopUp(){
		driver.waitForElementIsPresent(ADD_MORE_ITEMS_BUTTON_ON_CHCKOUT_POPUP_LOC, 10);
		driver.click(ADD_MORE_ITEMS_BUTTON_ON_CHCKOUT_POPUP_LOC);
		logger.info("Clicked on Add more items Button on the checkout popup");
		driver.pauseExecutionFor(4000);
		return this;
	}

	/**
	 * This method click on close Button for the checkout popup.
	 * @return StoreFrontShopSkinCarePage object
	 */
	public StoreFrontShopSkinCarePage clickOnCloseButtonForCheckoutPopUp(){
		driver.click(CLOSE_BUTTON_FOR_CHCKOUT_POPUP_LOC);
		logger.info("Clicked on close btn for checkout popup");
		return this;
	}

	/**
	 * This method validates the Quantity of Product to be 1 on checkout popup.
	 * @return boolean
	 */
	public boolean isQuantityOfProductonIsPresentOnCheckoutPopUp(){
		return driver.getText(PRODUCT_QTY_ON_CHECKOUT_POPUP_LOC).contains("1");
	}

	/**
	 * This method get the price of product from checkout pop up.
	 * @return String - productPrice
	 */
	public String getProductPriceFromCheckoutPopup(){
		driver.pauseExecutionFor(2000);
		return driver.getText(PRODUCT_PRICE_ON_CEHCKOUT_POPUP).replace("$","");
	}

	/***
	 * This method validates the presence of Add more items Button
	 * 
	 * @param 
	 * @return boolean
	 * 
	 */
	public boolean isAddMoreItemsButtonPresentOnCheckoutPopup(){
		return driver.isElementVisible(ADD_MORE_ITEMS_BUTTON_ON_CHCKOUT_POPUP_LOC);
	}

	/***
	 * This method validates the presence of Checkout Button
	 * 
	 * @param 
	 * @return boolean
	 * 
	 */
	public boolean isCheckoutButtonPresentOnCheckoutPopup(){
		return driver.isElementVisible(CHECKOUT_BUTTON_POPUP_LOC);
	}

	/***
	 * This method validates the presence of Close Button on Popup
	 * 
	 * @param 
	 * @return boolean
	 * 
	 */
	public boolean isCloseButtonPresentForCheckoutPopup(){
		return driver.isElementVisible(CLOSE_BUTTON_FOR_CHCKOUT_POPUP_LOC);
	}

	/***
	 * This method validates the presence of Retail Price on Product listing page
	 * 
	 * @param 
	 * @return boolean
	 * 
	 */
	public boolean isRetailPricePresentForProductNumber(String productNumber){
		return driver.getText(By.xpath(String.format(priceOfProductLoc,productNumber))).contains("$");
	}

	/***
	 * This method validates the presence of Your Price on Quick view popup
	 * 
	 * @param 
	 * @return boolean
	 * 
	 */
	public boolean isPricePresentOnQuickViewPopup(){
		return driver.getText(YOUR_PRICE_ON_QUICK_VIEW_POPUP_LOC).contains("$");
	}

	/***
	 * This method click on view product details link on quick view popup
	 * 
	 * @param 
	 * @return StoreFrontProductDetailPage object
	 * 
	 */
	public StoreFrontProductDetailPage clickOnViewProductDetailsLinkOnQuickViewPopup(){
		driver.click(VIEW_PRODUCT_DETAILS_LINK_ON_QUICK_VIEW_LOC);
		return new StoreFrontProductDetailPage(driver);
	}

	/***
	 * This method verifies whether view product details link disaplyed on quick view popup
	 * or not
	 * 
	 * @param 
	 * @return boolean
	 * 
	 */
	public boolean isViewProductDetailsLinkDisplayedOnQuickViewPopup(){
		return driver.isElementVisible(VIEW_PRODUCT_DETAILS_LINK_ON_QUICK_VIEW_LOC);
	}

	/**
	 * This method click on quick view link of product
	 * @return StoreFrontShopSkinCarePage object
	 */
	public StoreFrontShopSkinCarePage clickOnQuickViewLinkForProduct(String productNum){
		driver.waitForElementPresent(By.xpath(String.format(quickViewForSpecificProductLoc, productNum)));
		driver.pauseExecutionFor(2000);
		driver.click(By.xpath(String.format(quickViewForSpecificProductLoc, productNum)));
		logger.info("Clicked on quick view for product number : " + productNum);
		driver.waitForLoadingImageToDisappear();
		return this;
	}

	//	/***
	//	 * This method validate all product page present
	//	 * 
	//	 * 
	//	 * @param
	//	 * @return boolean value.
	//	 * 
	//	 */
	//	public boolean isAllProductPageDisplayed(){
	//		return driver.isElementVisible(ADD_TO_CART_BTN_LOC);
	//	}

	/***
	 * This method click on yes button on popup saying do you want to enroll in CRP
	 * 
	 * @param
	 * @return store front shop skincare page object
	 * 
	 */
	public StoreFrontAutoshipCartPage acceptEnrollInCRPPopup(){
		try{
			driver.click(YES_ON_ENROLL_IN_CRP_POPUP_LOC);
			driver.waitForPageLoad();
			logger.info("Yes button on enroll in CRP popup clicked.");
		}
		catch(NoSuchElementException e){

		}
		return new StoreFrontAutoshipCartPage(driver);
	}

	/***
	 * This method return product quantity from quick view option
	 * 
	 * @param 
	 * @return quantity of product
	 * 
	 */
	public String getProductQuantityFromQuickViewOption(){
		return driver.findElement(QUANTITY_AT_QUICK_VIEW_OPTION_LOC).getAttribute("value");
	}

	/***
	 * This method return consultant price
	 * 
	 * @param 
	 * @return consultant price
	 * 
	 */
	public String getProductPrice(String productNumber){
		return driver.findElement(By.xpath(String.format(yourpriceOfProductLoc, productNumber))).getText();
	}
	/***
	 * This method return retail and SV price
	 * 
	 * @param 
	 * @return Retail and SV price
	 * 
	 */
	public String getProductRetailAndSVPrice(String productNumber){
		logger.info("Retail values are "+driver.findElement(By.xpath(String.format(retailAndSVPriceLoc, productNumber))).getText());
		return driver.findElement(By.xpath(String.format(retailAndSVPriceLoc, productNumber))).getText(); 
	}

	/***
	 * This method close product popup
	 * 
	 * @param 
	 * @return StoreFrontShopSkinCarePage object
	 * 
	 */
	public StoreFrontShopSkinCarePage closeProductPopup(){
		driver.findElement(PRODUCT_POPUP_LOC).click();
		return this;
	}

	/***
	 * This method validates the presence of Specific Price on Product listing page
	 * 
	 * @param 
	 * @return boolean
	 * 
	 */

	public boolean isSpecificPricePresentForProductNumber(String productNumber){
		return driver.getText(By.xpath(String.format(specificPriceForProductLoc,productNumber))).contains("$");
	}


	/***
	 * This method validates the presence of Specific Price on Quick View popup for PC, Consultant user
	 * 
	 * @param 
	 * @return boolean
	 * 
	 */

	public boolean isSpecificPricePresentOnQuickViewPopUp(){
		driver.waitForElementToBeVisible(SPECIFIC_PRICE_QUICK_VIEW_POPUP_LOC, 20);
		return driver.getText(SPECIFIC_PRICE_QUICK_VIEW_POPUP_LOC).contains("$");
	}


	/***
	 * This method validates the presence of Retail Price on on Quick View popup for PC, Consultant user
	 * 
	 * @param 
	 * @return boolean
	 * 
	 */

	public boolean isRetailPricePresentOnQuickViewPopUp(){
		driver.waitForElementToBeVisible(RETAIL_PRICE_QUICK_VIEW_POPUP_LOC, 20);
		return driver.getText(RETAIL_PRICE_QUICK_VIEW_POPUP_LOC).contains("$");
	}


	/***
	 * This method get splitted product middle name for search purpose
	 * 
	 * @param
	 * @return search entity.
	 * 
	 */

	public String getSplittedProductNameForSearchPurpose(String productName){
		String searchEntity = productName.split(" ")[1];
		logger.info("Entity to serch : " + searchEntity);
		return searchEntity;
	}


	/***
	 * This method click on the productName link from list using product name
	 * 
	 * @param
	 * @return search entity.
	 * 
	 */

	public StoreFrontProductDetailPage clickOnProductNameLink(String productName){
		driver.waitForElementToBeClickable(By.xpath(String.format(productLinkThroughProductNameLoc,productName)),20);
		//driver.click(By.xpath(String.format(productLinkThroughProductNameLoc,productName)));
		driver.clickByJS(RFWebsiteDriver.driver, By.xpath(String.format(productLinkThroughProductNameLoc,productName)));
		logger.info("Product Link clicked : " + productName);
		return new StoreFrontProductDetailPage(driver);
	}

	/***
	 * This method clickthe shop by category DD
	 * 
	 * @param
	 * @return StoreFrontShopSkincarePage obj
	 * 
	 */
	public StoreFrontWebsiteBasePage clickShopByCategoryDD(){
		driver.clickByJS(RFWebsiteDriver.driver, REFINE_PRODUCT_CATEGORY_FILTER_DD_LOC);
		logger.info("Refine category filter dropdown clicked");
		return this;
	}

	/***
	 * This method validates the category name is shop by category DD
	 * 
	 * @param 
	 * @return boolean
	 * 
	 */
	public boolean isCategoryNameVisibleInShopByCategoryDD(String categoryName){
		return driver.isElementVisible(By.xpath(String.format(regimenNameInShopByCategoryDD, categoryName)));
	}

	/***
	 * This method validates the presence of image on Quick view popup.
	 * 
	 * @param 
	 * @return boolean
	 * 
	 */
	public boolean isProductImagePresentAtQuickViewPopup(){
		driver.waitForElementToBeVisible(PRODUCT_IMG_ON_QUICK_VIEW_POPUP_LOC, 10);
		return driver.isElementVisible(PRODUCT_IMG_ON_QUICK_VIEW_POPUP_LOC);
	}

	/***
	 * This method validates the presence of product name on quick view poup
	 * 
	 * @param 
	 * @return boolean
	 * 
	 */
	public boolean isProductNamePresentAtQuickViewPopupAsExpected(String productName){
		driver.pauseExecutionFor(3000);
		return driver.isElementVisible(By.xpath(String.format(productNameOnQuickViewPopupLoc, productName)));
	}


	/***
	 * This method validates the presence of quantity text field  on quick view poup
	 * 
	 * @param 
	 * @return boolean
	 * 
	 */
	public boolean isQuantityTextFieldPresentAtQuickViewPopup(){
		return driver.isElementVisible(QUANTITY_AT_QUICK_VIEW_OPTION_LOC);
	}


	/***
	 * This method validates the presence of add to PC Perks button 
	 * 
	 * @param 
	 * @return boolean
	 * 
	 */
	public boolean isAddToPCPerksButtonPresentAtQuickViewPopup(){
		driver.moveToElement(ADD_TO_CART_BTN_ON_QUICK_VIEW_POPUP_LOC);
		return driver.isElementVisible(PC_PERKS_ORDER_BTN_ON_QUICK_VIEW_POPUP_LOC);
	}


	/***
	 * This method validates the presence of one time order button 
	 * 
	 * @param 
	 * @return boolean
	 * 
	 */
	public boolean isOneTimeOrderButtonPresentAtQuickViewPopup(){
		driver.moveToElement(ADD_TO_CART_BTN_ON_QUICK_VIEW_POPUP_LOC);
		return driver.isElementVisible(ONE_TIME_ORDER_BTN_ON_QUICK_VIEW_POPUP_LOC);
	}


	/***
	 * This method clicks the PC Perks button on Quick view popup 
	 * 
	 * @param 
	 * @return boolean
	 * 
	 */
	public StoreFrontShopSkinCarePage clickPCPerksButtonFromQuickViewPopup(){
		driver.moveToElement(ADD_TO_CART_BTN_ON_QUICK_VIEW_POPUP_LOC);
		driver.click(PC_PERKS_ORDER_BTN_ON_QUICK_VIEW_POPUP_LOC);
		logger.info("PC perks button clicked from quick view popup");
		return this;
	}

	/***
	 * This method validates the presence of PC Perks promo message and
	 * save amount on quick view popup 
	 * 
	 * @param 
	 * @return boolean
	 * 
	 */
	public boolean isPCPerksPromoMessageAndSaveAmountPresentOnQuickViewPopup(){
		return driver.isElementVisible(PC_PERKS_PROMO_MSG_LOC) &&
				driver.isElementVisible(PC_PERKS_SAVE_AMOUNT_LOC);		
	}

	/***
	 * This method clicks the Add to cart button on Quick view popup 
	 * 
	 * @param 
	 * @return StoreFrontShopSkinCarePage object
	 * 
	 */
	public StoreFrontShopSkinCarePage clickAddToCartButtonOnQuickViewPopup(){
		driver.click(ADD_TO_CART_BTN_ON_QUICK_VIEW_POPUP_LOC);
		logger.info("Add to Cart button clicked from quick view popup");
		return this;
	}

	/***
	 * This method verifies the Add to cart button on Quick view popup 
	 * 
	 * @param 
	 * @return boolean
	 * 
	 */
	public boolean isAddToCartButtonDisplayedOnQuickViewPopup(){
		return driver.isElementVisible(ADD_TO_CART_BTN_ON_QUICK_VIEW_POPUP_LOC);
	}

	/***
	 * This method enters the quantity of product on quick view popup
	 * 
	 * @param 
	 * @return StoreFrontShopSkinCarePage object
	 * 
	 */
	public StoreFrontShopSkinCarePage enterQuantityOfProductOnQuickViewPopup(String qty){
		driver.type(QUANTITY_AT_QUICK_VIEW_OPTION_LOC,qty+"\t");
		driver.pauseExecutionFor(5000);
		System.out.println("*** "+driver.findElement(QUANTITY_AT_QUICK_VIEW_OPTION_LOC).getText());
		return this;
	}

	/***
	 * This method Refine Product by random category and return category name
	 * 
	 * @param
	 * @return selected category name
	 * 
	 */
	public String refineProductByCategoryAndReturnCategoryName(){
		String categoryName = null;
		driver.click(REFINE_PRODUCT_CATEGORY_FILTER_DD_LOC);
		ArrayList<String> categoryNameList = new ArrayList<String>();
		List<WebElement> totalCategories = driver.findElements(TOTAL_CATEGORY_NAME_LOC);
		for(WebElement category : totalCategories){
			String catLabel = null;
			catLabel = category.getAttribute("id").trim();
			categoryNameList.add(catLabel);
		}
		while(true){
			int randomNumberForCategory = CommonUtils.getRandomNum(0,(categoryNameList.size()-1));
			categoryName = categoryNameList.get(randomNumberForCategory);
			driver.clickByJS(RFWebsiteDriver.driver,By.xpath(String.format(randomCategoryNameLoc,categoryName)));
			driver.waitForPageLoad();
			driver.waitForLoadingImageToDisappear();
			driver.pauseExecutionFor(5000);
			int totalProducts = driver.findElements(TOTAL_PRODUCTS_LOC).size();
			if(totalProducts>=3){
				break;
			}
			else{
				categoryNameList.remove(randomNumberForCategory);
				driver.click(REFINE_PRODUCT_CATEGORY_FILTER_DD_LOC);
				driver.clickByJS(RFWebsiteDriver.driver,By.xpath(String.format(randomCategoryNameLoc,categoryName)));
				continue;
			}
		}
		return categoryName.replaceAll("ID", "").trim();
	}

	/***
	 * This method select sort by price filter Low to High via JS click.
	 * 
	 * @param
	 * @return store front Home page object
	 * 
	 */
	public StoreFrontShopSkinCarePage productPriceFilterLowToHighSelect(){
		driver.clickByJS(RFWebsiteDriver.driver,SORT_FILTER_DD_LOC);
		logger.info("Sort filter dropdown clicked");
		driver.click(SHOP_BY_PRICE_FILTER_OPTION_LOW_TO_HIGH_LOC);
		logger.info("Price filter 'LOW TO HIGH' selected");
		driver.waitForPageLoad();
		driver.pauseExecutionFor(2000);
		return this;
	}

	/***
	 * This method select sort by price filter High to low via JS click
	 * 
	 * @param
	 * @return store front Home page object
	 * 
	 */
	public StoreFrontShopSkinCarePage productPriceFilterHighToLowSelect(){
		driver.clickByJS(RFWebsiteDriver.driver, SORT_FILTER_DD_LOC);
		logger.info("Sort filter dropdown clicked");
		driver.click(SHOP_BY_PRICE_FILTER_OPTION_HIGH_TO_LOW_LOC);
		logger.info("Price filter 'HIGH TO LOW' selected");
		driver.waitForPageLoad();
		return this;
	}

	/***
	 * This method select sort by price filter Default select option
	 * 
	 * @param
	 * @return store front shopSkincare page object
	 * 
	 */
	public StoreFrontShopSkinCarePage productPriceFilterDefault(){
		driver.click(SORT_FILTER_DD_LOC);
		logger.info("Sort filter dropdown clicked");
		driver.click(SHOP_BY_PRICE_FILTER_OPTION_DEFAULT_LOC);
		logger.info("Price filter 'Default select is' selected");
		driver.waitForPageLoad();
		return this;
	}

	/***
	 * This method click clear all link to remove all applied filters to product
	 * 
	 * @param
	 * @return store front shopSkincare page object
	 * 
	 */
	public StoreFrontShopSkinCarePage selectClearAllLink(){
		driver.click(CLEAR_ALL_LINK_LOC);
		logger.info("Clear all link clicked to remove all applied product filter.");
		driver.waitForPageLoad();
		return this;
	}


	/***
	 * This method verify add to cart dropdown option displayed or not
	 * 
	 * @param 
	 * @return Boolean
	 * 
	 */
	public boolean isAddToCartDDOptionsDisplayed(String userType){
		if(userType.equalsIgnoreCase("PC")){
			return driver.findElement(ADD_TO_CART_ONE_TIME_ORDER_LOC).isDisplayed();// && driver.findElement(SUBSCRIBE_PLUS_SAVE_DD_OPTIONS_LOC).isDisplayed();
		}
		else if(userType.equalsIgnoreCase("Consultant")){
			return driver.findElement(ADD_TO_CART_ONE_TIME_ORDER_LOC).isDisplayed() && driver.findElement(ADD_TO_CRP_DD_OPTIONS_LOC).isDisplayed();
		}
		else
			return false;
	}

	/***
	 * This method click on first product name on all product page
	 * 
	 * @param
	 * @return object of product detail page
	 * 
	 */
	public StoreFrontProductDetailPage clickNameOfProduct(String productNumber){
		String productName = driver.findElement(By.xpath(String.format(productNameLinkLoc, productNumber))).getText();
		if(driver.isElementVisible(driver.findElement(By.xpath(String.format(productNameLinkLoc, productNumber))))){
			driver.clickByJS(RFWebsiteDriver.driver,By.xpath(String.format(productNameLinkLoc, productNumber)));
			//driver.click(By.xpath(String.format(productNameLinkLoc, productNumber)));
		}
		logger.info("product name "+productName+ " Clicked");
		driver.waitForPageLoad();
		return new StoreFrontProductDetailPage(driver);
	}

	/***
	 * This method get your price of product
	 * 
	 * @param product number
	 * @return product price.
	 * 
	 */
	public String getYourPriceOfAProduct(String productNumber){
		String price = driver.findElement(By.xpath(String.format(yourpriceOfProductLoc, productNumber))).getText().split("\\$")[1].trim();
		logger.info(productNumber+"'s your price is"+price);
		return price;
	}

	/***
	 * This method performs mouse hover on add to cart button on all product page
	 * 
	 * @param
	 * @return base page object
	 * 
	 */
	public StoreFrontWebsiteBasePage mouseHoverOnAddToCart(){
		Actions build = new Actions(RFWebsiteDriver.driver);
		build.moveToElement(driver.findElement(By.xpath(String.format(addToCartButtonLoc,"1")))).build().perform();
		return this;
	}

	/***
	 * This method Refine Product by random category and return unique category name
	 * 
	 * @param selected category name
	 * @return category name
	 * 
	 */
	public String refineShopByCategoryAndReturnUniqueCategoryName(String selectedCategoryName){
		String categoryName = null;
		while(true){ 
			categoryName = refineShopByCategoryAndReturnCategoryName();
			if(categoryName.toLowerCase().contains(selectedCategoryName)){
				categoryName = refineShopByCategoryAndReturnCategoryName();
				continue;
			}
			else{
				break;
			}
		}
		return categoryName;
	}

	/***
	 * This method Refine Product by random category and return category name
	 * 
	 * @param
	 * @return selected category name
	 * 
	 */
	public String refineShopByCategoryAndReturnCategoryName(){
		String categoryName = null;
		clickShopByCategoryDD();
		logger.info("Refine category filter dropdown clicked");
		int randomNum = CommonUtils.getRandomNum(4,12);
		logger.info("Random selected category is "+(randomNum-1));
		categoryName=driver.findElement(By.xpath(String.format(randomCategoryIDLoc,randomNum))).getAttribute("id").split("ID")[0];
		driver.click(By.xpath(String.format(randomProductCategoryCheckbox,randomNum)));
		logger.info("Product category selected is "+categoryName);
		driver.waitForPageLoad();
		driver.waitForLoadingImageToDisappear();
		return categoryName;
	}

	/***
	 * This method validate the applied filter
	 * 
	 * @param filter number
	 * @return filter name
	 * 
	 */
	public String getAppliedFilterName(int filterNumber){
		logger.info(driver.getText(By.xpath(String.format(appliedFilterLoc,filterNumber))));
		return driver.getText(By.xpath(String.format(appliedFilterLoc,filterNumber)));
	}

	/***
	 * This method adds the product to the cart from quick view popup(adhoc/autoship/PC perks as specified)
	 * 
	 * @param Order type
	 * @return string price
	 * 
	 */
	public String addProductToCartFromQuickViewPopup(String orderType){
		String priceToAssert = null;
		driver.pauseExecutionFor(3000);
		driver.moveToElementByJS(ADD_TO_CART_BTN_ON_QUICK_VIEW_POPUP_LOC);
		driver.clickByAction(ADD_TO_CART_BTN_ON_QUICK_VIEW_POPUP_LOC);
		if(orderType.equals(TestConstants.ORDER_TYPE_ADHOC)&& driver.isElementVisible(By.xpath(String.format(productPriceOnQuickViewPopupThroughOrderTypeLoc,TestConstants.ORDER_TYPE_ADHOC)))){
			priceToAssert = driver.getText(By.xpath(String.format(productPriceOnQuickViewPopupThroughOrderTypeLoc,TestConstants.ORDER_TYPE_ADHOC))).replace("$","");
			driver.clickByJS(RFWebsiteDriver.driver,By.xpath(String.format(productPriceOnQuickViewPopupThroughOrderTypeLoc,TestConstants.ORDER_TYPE_ADHOC)));
		}
		else if(orderType.equals(TestConstants.ORDER_TYPE_PC_PERKS)&& driver.isElementVisible(By.xpath(String.format(productPriceOnQuickViewPopupThroughOrderTypeLoc,TestConstants.ORDER_TYPE_PC_PERKS)))){
			priceToAssert = driver.getText(By.xpath(String.format(productPriceOnQuickViewPopupThroughOrderTypeLoc,TestConstants.ORDER_TYPE_PC_PERKS))).replace("$","");
			driver.clickByJS(RFWebsiteDriver.driver,By.xpath(String.format(productPriceOnQuickViewPopupThroughOrderTypeLoc,TestConstants.ORDER_TYPE_PC_PERKS)));
		}
		else if(orderType.equals(TestConstants.ORDER_TYPE_CRP)&& driver.isElementVisible(By.xpath(String.format(productPriceOnQuickViewPopupThroughOrderTypeLoc,TestConstants.ORDER_TYPE_CRP)))){
			priceToAssert = driver.getText(By.xpath(String.format(productPriceOnQuickViewPopupThroughOrderTypeLoc,"Add to CRP"))).replace("$","");
			driver.clickByJS(RFWebsiteDriver.driver,By.xpath(String.format(productPriceOnQuickViewPopupThroughOrderTypeLoc,"Add to CRP")));
		}
		logger.info("Add To Cart clicked, order type is "+orderType);
		return priceToAssert;
	}

	/***
	 * This method adds the product to the cart(adhoc/autoship/PC perks as specified)
	 * 
	 * @param
	 * @return string price
	 * 
	 */
	public String addProductToCart(String productNumber,String orderType){
		String priceToAssert = null;
		driver.pauseExecutionFor(3000);
		driver.waitForElementPresent(By.xpath(String.format(addToCartButtonLoc, productNumber)), 15);
		driver.moveToElementByJS(By.xpath(String.format(addToCartButtonLoc, productNumber)));
		driver.clickByAction(By.xpath(String.format(addToCartButtonLoc, productNumber)));
		if(orderType.equals(TestConstants.ORDER_TYPE_ENROLLMENT)){
			logger.info("Adding product for Enrollment");
		}
		else if(orderType.equals(TestConstants.ORDER_TYPE_ADHOC)&& driver.isElementPresent(By.xpath(String.format(productPriceThroughProductNumberLoc,TestConstants.ORDER_TYPE_ADHOC,productNumber)))){
			priceToAssert = driver.getText(By.xpath(String.format(productPriceThroughProductNumberLoc,TestConstants.ORDER_TYPE_ADHOC,productNumber))).replace("$","");
			driver.clickByJS(RFWebsiteDriver.driver,By.xpath(String.format(addToCartDDLoc,TestConstants.ORDER_TYPE_ADHOC,productNumber)));
		}
		else if(orderType.equals(TestConstants.ORDER_TYPE_PC_PERKS)&& driver.isElementPresent(By.xpath(String.format(productPriceThroughProductNumberLoc,TestConstants.ORDER_TYPE_PC_PERKS,productNumber)))){
			priceToAssert = driver.getText(By.xpath(String.format(productPriceThroughProductNumberLoc,TestConstants.ORDER_TYPE_PC_PERKS,productNumber))).replace("$","");
			driver.clickByJS(RFWebsiteDriver.driver,By.xpath(String.format(addToCartDDLoc,TestConstants.ORDER_TYPE_PC_PERKS,productNumber)));
		}
		else if(orderType.equals(TestConstants.ORDER_TYPE_CRP)&& driver.isElementPresent(By.xpath(String.format(productPriceThroughProductNumberLoc,TestConstants.ORDER_TYPE_CRP,productNumber)))){
			priceToAssert = driver.getText(By.xpath(String.format(productPriceThroughProductNumberLoc,"Add to CRP",productNumber))).replace("$","");
			driver.clickByJS(RFWebsiteDriver.driver,By.xpath(String.format(addToCartDDLoc,"Add to CRP",productNumber)));
		}
		logger.info("Add To Cart clicked, order type is "+orderType);
		return priceToAssert;
	}

	/***
	 * This method adds the product to the cart(adhoc/autoship/PC perks as specified)
	 * 
	 * @param
	 * @return string price
	 * 
	 */
	public String addProductToCart(String productNumber,String orderType,String productId){
		String priceToAssert = null;
		clickSearchIcon();
		searchEntityAndHitEnter(productId);
		driver.moveToElementByJS(By.xpath(String.format(addToCartButtonThroughProdIdLoc,productId)));
		driver.clickByAction(By.xpath(String.format(addToCartButtonThroughProdIdLoc, productId)));
		if(orderType.equals(TestConstants.ORDER_TYPE_ENROLLMENT)){
			logger.info("Adding product for Enrollment");
		}
		else if(orderType.equals(TestConstants.ORDER_TYPE_ADHOC)&& driver.isElementVisible(By.xpath(String.format(productPriceThroughProdIdLoc,productId,TestConstants.ORDER_TYPE_ADHOC)))){
			priceToAssert = driver.getText(By.xpath(String.format(productPriceThroughProdIdLoc,productId,TestConstants.ORDER_TYPE_ADHOC))).replace("$","");
			driver.clickByJS(RFWebsiteDriver.driver,By.xpath(String.format(addToCartDDThroughProdIdLoc,productId,TestConstants.ORDER_TYPE_ADHOC)));
		}
		else if(orderType.equals(TestConstants.ORDER_TYPE_PC_PERKS)&& driver.isElementPresent(By.xpath(String.format(productPriceThroughProdIdLoc,productId,TestConstants.ORDER_TYPE_PC_PERKS)))){
			priceToAssert = driver.getText(By.xpath(String.format(productPriceThroughProdIdLoc,productId,TestConstants.ORDER_TYPE_PC_PERKS))).replace("$","");
			driver.clickByJS(RFWebsiteDriver.driver,By.xpath(String.format(addToCartDDThroughProdIdLoc,productId,TestConstants.ORDER_TYPE_PC_PERKS)));
		}
		else if(orderType.equals(TestConstants.ORDER_TYPE_CRP)&& driver.isElementPresent(By.xpath(String.format(productPriceThroughProdIdLoc,productId,TestConstants.ORDER_TYPE_CRP)))){
			priceToAssert = driver.getText(By.xpath(String.format(productPriceThroughProdIdLoc,productId,TestConstants.ORDER_TYPE_CRP))).replace("$","");
			driver.clickByJS(RFWebsiteDriver.driver,By.xpath(String.format(addToCartDDThroughProdIdLoc,productId,TestConstants.ORDER_TYPE_CRP)));
		}
		logger.info("Add To Cart clicked, order type is "+orderType);
		return priceToAssert;
	}

	/***
	 * This method validates that default filter has been applied
	 * 
	 * @param
	 * @return boolean
	 * 
	 */
	public boolean isDefaultFilterAppliedSuccessfully(){
		return driver.getAttribute(SHOP_BY_PRICE_FILTER_SELECTED_OPTION_LOC,"value").equalsIgnoreCase("relevance");
	}

	/**
	 * This method fetch the Quantity of Product from Checkout popup
	 * @return String
	 */
	public String getQuantityAddedFromCheckoutPopup(){
		return driver.getText(PRODUCT_QTY_ON_CHECKOUT_POPUP_LOC).replace("Quantity Added","").trim();
	}

	/**
	 * This method enters the quantity of Product on Quick view popup
	 * @return StoreFrontShopSkinCarePage Object
	 */
	public StoreFrontShopSkinCarePage enterQuantityonQuickViewPopup(String qty){
		driver.pauseExecutionFor(2000);
		driver.type(QTY_TF_ON_QUICK_VIEW_POPUP_LOC,qty);
		return this;
	}

	public String getProductNumToSelectForCard(String userType, String cardType,String defaultProdNumber){
		if(!cardType.equals(TestConstants.CARD_TYPE_AMEX)){
			return defaultProdNumber;
		}
		else{
			return getProductIndexWithPriceInRange(63,70,userType);
		}
	}


	private List<WebElement> getProductsPriceForUserType(String userType){
		List<WebElement> productsPrice = null;
		if(userType.equals(TestConstants.USER_TYPE_RC)){
			productsPrice = driver.findElements(RETAIL_PRICE_FOR_ALL_PRODUCTS_LOC);
		}
		else{
			productsPrice = driver.findElements(YOUR_PRICE_FOR_ALL_PRODUCTS_LOC);
		}
		return productsPrice;
	}

	private String getProductIndexWithPriceInRange(int minRange,int maxRange,String userType){
		while(true){
			int counter = 1;
			for(WebElement prodPrice : getProductsPriceForUserType(userType)){
				int price = Integer.valueOf(prodPrice.getText().replace(".00","").replaceAll("[^-?0-9]+","").trim());
				if(minRange <= price &&  price <= maxRange){
					return Integer.toString(counter);
				}
				counter++;
			}
			if(driver.isElementPresent(PAGINATION_NEXT_ARROW_LOC)){
				driver.click(PAGINATION_NEXT_ARROW_LOC);
				logger.info("Pagination Next Link Clicked");
			}
			else{
				break;
			}
		}
		logger.info("No Product Found for the Selected Range on All Products Page");
		return null;
	}

	/**
	 * This method click on quick view link of product
	 * @return StoreFrontShopSkinCarePage object
	 */
	public StoreFrontShopSkinCarePage clickOnQuickViewLinkThroughProductId(String productId){
		driver.waitForElementPresent(By.xpath(String.format(quickViewLinkThroughProductIdLoc, productId)));
		driver.pauseExecutionFor(2000);
		driver.click(By.xpath(String.format(quickViewLinkThroughProductIdLoc, productId)));
		logger.info("Clicked on quick view for product id : " + productId);
		driver.waitForLoadingImageToDisappear();
		return this;
	}

}