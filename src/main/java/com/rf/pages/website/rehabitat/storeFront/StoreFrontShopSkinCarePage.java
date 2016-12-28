package com.rf.pages.website.rehabitat.storeFront;

import org.openqa.selenium.By;
import org.openqa.selenium.interactions.Actions;

import com.rf.core.driver.website.RFWebsiteDriver;
import com.rf.core.utils.CommonUtils;
import com.rf.pages.website.rehabitat.storeFront.basePage.StoreFrontWebsiteBasePage;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class StoreFrontShopSkinCarePage extends StoreFrontWebsiteBasePage{
	public StoreFrontShopSkinCarePage(RFWebsiteDriver driver) {
		super(driver);		
	}

	private static final Logger logger = LogManager
			.getLogger(StoreFrontShopSkinCarePage.class.getName());

	private final By CHECKOUT_BUTTON_POPUP_LOC = By.xpath("//a[contains(text(),'Checkout')]");
	private final By ADD_TO_CART_BUTTON_AT_PRODUCT_DETAIL_PAGE = By.id("addToCartButton");
	private final By ADD_TO_CART_FIRST_PRODUCT_LOC = By.xpath("//div[@id='product_listing']/descendant::button[text()='Add to cart'][1]");
	private final By ADD_TO_BAG_OF_FIRST_PRODUCT = By.xpath("//div[@id='product_listing']/descendant::span[contains(text(),'One Time Order')][1]");
	private final By SORT_FILTER_DD_LOC = By.id("sortOptions1");
	private final By SHOP_BY_PRICE_FILTER_OPTION_HIGH_TO_LOW_LOC = By.xpath("//select[@id='sortOptions1']/descendant::option[2]");
	private final By SHOP_BY_PRICE_FILTER_OPTION_LOW_TO_HIGH_LOC = By.xpath("//select[@id='sortOptions1']/descendant::option[3]");
	private final By REFINE_PRODUCT_CATEGORY_FILTER_DD_LOC = By.xpath("//div[@id='product-facet']/descendant::div[text()[normalize-space()='Shop by Category']]");
	private final By TOTAL_PRODUCTS_LOC = By.xpath("//div[@id='product_listing']//following::div[@class='product-item']");

	private String priceOfProductLoc = "//div[contains(@class,'product__listing')]//div[@class='product-item'][%s]//span[@id='cust_price']";
	private String categoryNameLoc = "//div[@id='product-facet']//descendant::ul[2]/li/descendant::span[contains(text(),'%s')]/preceding::label[1]";
	private String randomProductCategoryCheckbox = "//div[@id='product-facet']//descendant::ul[2]/li[%s]//descendant::label[2]";
	private String randomCategoryName = randomProductCategoryCheckbox+"/following::span[@class='facet__list__text']";
	/**
	 * This method click on the checkOut Button on the popup on the cart.
	 * @return
	 */
	public StoreFrontCartPage checkoutTheCartFromPopUp(){
		driver.click(CHECKOUT_BUTTON_POPUP_LOC);
		logger.info("Clicked on checkout button on the popup");
		return new StoreFrontCartPage(driver);
	}

	/***
	 * This method click add to bag button for first product
	 * 
	 * @param
	 * @return store front shop skincare page object
	 * 
	 */
	public StoreFrontShopSkinCarePage selectFirstProduct(){
		driver.pauseExecutionFor(5000);
		driver.moveToElementByJS(ADD_TO_CART_FIRST_PRODUCT_LOC);
		driver.click(ADD_TO_BAG_OF_FIRST_PRODUCT);
		return this;
	}

	/***
	 * This method add first product to bag
	 * 
	 * @param
	 * @return store front shop skincare page object
	 * 
	 */
	public StoreFrontShopSkinCarePage addFirstProductToBag(){
		driver.clickByJS(RFWebsiteDriver.driver, driver.findElement(ADD_TO_CART_FIRST_PRODUCT_LOC));
		logger.info("Added first product to the bag");
		return this;
	}

	/***
	 * This method select sort by price filter High to low
	 * 
	 * @param
	 * @return store front Home page object
	 * 
	 */
	public StoreFrontShopSkinCarePage productPriceFilterHighToLow(){
		driver.click(SORT_FILTER_DD_LOC);
		logger.info("Sort filter dropdown clicked");
		driver.click(SHOP_BY_PRICE_FILTER_OPTION_HIGH_TO_LOW_LOC);
		logger.info("Price filter 'HIGH TO LOW' selected");
		driver.waitForPageLoad();
		return this;
	}
	/***
	 * This method select sort by price filter High to low via double click
	 * 
	 * @param
	 * @return store front Home page object
	 * 
	 */
	public StoreFrontShopSkinCarePage productPriceFilterHighToLowSelect(){
		Actions action=new Actions(RFWebsiteDriver.driver);
		action.moveToElement(driver.findElement(SORT_FILTER_DD_LOC)).doubleClick().build().perform();
		driver.pauseExecutionFor(2000);
		logger.info("Sort filter dropdown clicked");
		action.moveToElement(driver.findElement(SHOP_BY_PRICE_FILTER_OPTION_HIGH_TO_LOW_LOC)).doubleClick().build().perform();
		logger.info("Price filter 'HIGH TO LOW' selected");
		driver.waitForPageLoad();
		return this;
	}
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
	/***
	 * This method select sort by price filter Low to High via double click.
	 * 
	 * @param
	 * @return store front Home page object
	 * 
	 */
	public StoreFrontShopSkinCarePage productPriceFilterLowToHighSelect(){
		Actions action=new Actions(RFWebsiteDriver.driver);
		action.moveToElement(driver.findElement(SORT_FILTER_DD_LOC)).doubleClick().build().perform();
		driver.pauseExecutionFor(2000);
		logger.info("Sort filter dropdown clicked");
		action.moveToElement(driver.findElement(SHOP_BY_PRICE_FILTER_OPTION_LOW_TO_HIGH_LOC)).doubleClick().build().perform();
		logger.info("Price filter 'LOW TO HIGH' selected");
		driver.waitForPageLoad();
		return this;
	}
	/***
	 * This method verify the product price filter Low to High applied successfully
	 * 
	 * 
	 * @param
	 * @return boolean value.
	 * 
	 */

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
	 * This method click on first product name on all product page
	 * 
	 * @param
	 * @return object of product detail page
	 * 
	 */
	public StoreFrontProductDetailPage clickNameOfFirstProduct(){
		String productName = driver.findElement(PRODUCTS_NAME_LINK_LOC).getText();
		driver.click(PRODUCTS_NAME_LINK_LOC);
		logger.info("product name "+productName+ "Clicked");
		driver.waitForPageLoad();
		return new StoreFrontProductDetailPage(driver);
	}
	/***
	 * This method Refine Product by category name
	 * 
	 * @param
	 * @return store front Home page object
	 * 
	 */
	public StoreFrontShopSkinCarePage refineProductByCategory(String categoryName){
		driver.click(REFINE_PRODUCT_CATEGORY_FILTER_DD_LOC);
		logger.info("Refine category filter dropdown clicked");
		driver.click(By.xpath(String.format(categoryNameLoc, categoryName)));
		logger.info("Product category selected is "+categoryName);
		driver.waitForPageLoad();
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
		driver.click(REFINE_PRODUCT_CATEGORY_FILTER_DD_LOC);
		logger.info("Refine category filter dropdown clicked");
		int randomNum = CommonUtils.getRandomNum(2,7);
		logger.info("Random selected category is "+(randomNum-1));
		String categoryName=driver.findElement(By.xpath(String.format(randomCategoryName,randomNum))).getText().trim();
		driver.click(By.xpath(String.format(randomProductCategoryCheckbox, randomNum)));
		logger.info("Product category selected is "+categoryName);
		driver.waitForPageLoad();
		driver.waitForLoadingImageToDisappear();
		return categoryName;
	}
	/***
	 * This method get first product name from all product page
	 * 
	 * @param
	 * @return product name.
	 * 
	 */

	public String getFirstProductNameFromAllProductPage(){
		driver.pauseExecutionFor(2000);
		String firstProductName = driver.findElement(PRODUCTS_NAME_LINK_LOC).getText().split("\\.")[0].trim();
		logger.info("Product name from all product page is "+firstProductName);
		return firstProductName;
	}
}