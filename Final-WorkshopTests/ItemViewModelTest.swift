//
//  ItemViewModelTest.swift
//  Final-WorkshopTests
//
//  Created by Yuehuan Lu on 2021/1/10.
//

import Quick
import Nimble
@testable import Final_Workshop

class MockItemQueryService: ItemQueryService {
  override func getSearchResults(completion: @escaping ItemQueryService.ItemQueryResult) {
    let itemDatas = [Item(barcode: "123", name: "cat", unit: "只", price: 5)]
    completion(itemDatas, "error")
  }
}

class MockPromotionQueryService: PromotionQueryService {
  override func getSearchResults(completion: @escaping PromotionQueryService.PromotionQueryResult) {
    let promotionDatas = ["one", "two"]
    completion(promotionDatas, "error")
  }
}

class ItemViewModelTest: QuickSpec {
  let viewModel = ItemViewModel()
  
  override func spec() {
    describe("clearPurchaseedItems") { [self] in
      context("when array has member") {
        it("shoulds be cleared") {
          viewModel.clearPurchaseedItems()
          viewModel.purchasedItems = [PurchasedItem(
            count: 3,
            promotion: true,
            item: Item(barcode: "12345678", name: "cat", unit: "one", price: 30)
          )]
          expect(viewModel.purchasedItems.count) == 1
          viewModel.clearPurchaseedItems()
          expect(viewModel.purchasedItems) == []
          expect(viewModel.clearAfterReceipt) == true
          expect(viewModel.purchasedItems.count == 0) == true
        }
      }
      
      context("when array has no member") {
        it("returns a empty array") {
          expect(viewModel.purchasedItems.count) == 0
          viewModel.clearPurchaseedItems()
          expect(viewModel.purchasedItems) == []
        }
      }
    }
    
    describe("getItems") { [self] in
      context("when query items") {
        it("gets items list") {
          viewModel.itemQueryService = MockItemQueryService()
          viewModel.getItems() {
            expect(viewModel.items.count) == 1
            expect(viewModel.items[0].barcode) == "123"
            expect(viewModel.items[0].name) == "cat"
            expect(viewModel.items[0].unit) == "只"
            expect(viewModel.items[0].price) == 5
          }
        }
      }
    }
    
    describe("getpromotions") { [self] in
      context("when query promotions") {
        it("gets promotions") {
          viewModel.promotionQueryService = MockPromotionQueryService()
          viewModel.getPromotions() {
            expect(viewModel.promotions.count) == 2
            expect(viewModel.promotions) == ["one", "two"]
          }
        }
      }
    }
    
    describe("addPurchasedItem") { [self] in
      context("when add purchased item") {
        it("adds to purchasedItems") {
          viewModel.addPurchasedItem(6, cellForRowAt: 0)
          expect(viewModel.purchasedItems[0].count) == 6
          expect(viewModel.purchasedItems[0].promotion) == false
          expect(viewModel.purchasedItems[0].item.barcode) == "123"
        }
      }
    }
    
    describe("receiptPrint") { [self] in
      context("when there has no product") {
        it("print a receipt with zero") {
          viewModel.clearPurchaseedItems()
          expect(viewModel.receiptPrint()) ==
            """
  ***Receipts***
  ----------------------
  总计：¥0.00
  节省：¥0.00
  **********************
  """
        }
      }
      
      context("when there has products") {
        it("prints receipt") {
          viewModel.purchasedItems = [PurchasedItem(
            count: 6,
            promotion: true,
            item: Item(barcode: "12345678", name: "cat", unit: "只", price: 5)
          )]
          expect(viewModel.receiptPrint()) ==
            """
  ***Receipts***
  名称：cat，数量：6只，单价：¥5.00
  小计：¥20.00
  ----------------------
  总计：¥20.00
  节省：¥10.00
  **********************
  """
        }
      }
    }
    
    describe("format") { [self] in
      context("when parameter is zero") {
        it("returns 0 if parameter has more than two zero or no zero after point") {
          expect(viewModel.format(0.0000)) == "0.00"
          expect(viewModel.format(0)) == "0.00"
        }
      }
      
      context("when parameter has less than two digits") {
        it("returns two digits when paremeter is a int number") {
          expect(viewModel.format(3)) == "3.00"
          expect(viewModel.format(49)) == "49.00"
        }
        
        it("returns two digits when parameter has one digit") {
          expect(viewModel.format(12.2)) == "12.20"
          expect(viewModel.format(23.8)) == "23.80"
        }
      }
      
      context("when parameter has more than two digits") {
        it("returns two digits") {
          expect(viewModel.format(12.322)) == "12.32"
          expect(viewModel.format(12.328)) == "12.33"
        }
      }
    }
  }
}
