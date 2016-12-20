package com.rf.test.website.rehabitat.storeFront.homePage.refinement;

import org.testng.annotations.Test;

import com.rf.test.website.rehabitat.storeFront.baseTest.StoreFrontWebsiteBaseTest;

public class RFRefineRemovalTest extends StoreFrontWebsiteBaseTest{

	/***
	 * qTest : TC-54 Removing all filters
	 * Description : This test validates shop by price filter at products page
	 *     
	 */
	@Test
	public void testRemovingAllFilters_54(){
		int totalNoOfProduct = 0;
		String priceRange0to49 = "0To49";
		String priceRange50to199 = "50To199";
		String priceRange200to499 = "200To499";
		sfHomePage.clickAllProducts();
		//0 to 49 price range
		sfHomePage.selectFirstOptionInShopByPriceFilter();
		totalNoOfProduct = sfHomePage.getTotalNoOfProduct();
		s_assert.assertTrue(sfHomePage.isShopByPriceFirstFilterChecked(), "Fisrt option of shop by price filter is not checked");
		for(int i=1; i<=totalNoOfProduct; i++){
			s_assert.assertTrue(sfHomePage.isShopByPriceFilterAppliedSuccessfully(i,priceRange0to49), "product no "+i+"is out of range according to filter i.e. '0 to 49'");
		}
		sfHomePage.selectFirstOptionInShopByPriceFilter();
		totalNoOfProduct = sfHomePage.getTotalNoOfProduct();
		s_assert.assertTrue(sfHomePage.isShopByPriceFilterRemovedSuccessfully(totalNoOfProduct, priceRange0to49), "0 to 49 Filter not removed successfully");
		//50 to 199 price range
		sfHomePage.selectSecondOptionInShopByPriceFilter();
		totalNoOfProduct = sfHomePage.getTotalNoOfProduct();
		s_assert.assertTrue(sfHomePage.isShopByPriceSecondFilterChecked(), "Second option of shop by price filter is not checked");
		for(int i=1; i<=totalNoOfProduct; i++){
			s_assert.assertTrue(sfHomePage.isShopByPriceFilterAppliedSuccessfully(i,priceRange50to199), "product no "+i+"is out of range according to filter i.e. '50 to 199'");
		}
		sfHomePage.selectSecondOptionInShopByPriceFilter();
		totalNoOfProduct = sfHomePage.getTotalNoOfProduct();
		s_assert.assertTrue(sfHomePage.isShopByPriceFilterRemovedSuccessfully(totalNoOfProduct, priceRange50to199), "50 to 199 Filter not removed successfully");
		//200 to 499 price range
		sfHomePage.selectThirdOptionInShopByPriceFilter();
		totalNoOfProduct = sfHomePage.getTotalNoOfProduct();
		s_assert.assertTrue(sfHomePage.isShopByPriceThirdFilterChecked(), "Third option of shop by price filter is not checked");
		for(int i=1; i<=totalNoOfProduct; i++){
			s_assert.assertTrue(sfHomePage.isShopByPriceFilterAppliedSuccessfully(i,priceRange200to499), "product no "+i+"is out of range according to filter i.e. '200 to 499'");
		}
		sfHomePage.selectThirdOptionInShopByPriceFilter();
		totalNoOfProduct = sfHomePage.getTotalNoOfProduct();
		s_assert.assertTrue(sfHomePage.isShopByPriceFilterRemovedSuccessfully(totalNoOfProduct, priceRange200to499), "200 to 499 Filter not removed successfully");
		s_assert.assertAll();
	}
}