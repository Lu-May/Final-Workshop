//
//  ItemListViewModel.swift
//  Final-Workshop
//
//  Created by Yuehuan Lu on 2021/1/7.
//

import Foundation
import RealmSwift

class ItemViewModel {
  var itemQueryService = ItemQueryService()
  var promotionQueryService = PromotionQueryService()
  var items: Results<ItemRepository>?
  var clearAfterReceipt = false
  var purchasedItemsRepository: Results<PurchasedItemRepository>?
  var purchasedItems: [PurchasedItem] = []
  var promotions: [String] = []
  
  func setclearAfterReceiptFalse() {
    clearAfterReceipt = false
  }
  
  func clearPurchaseedItems() {
    purchasedItems = []
    if let purchasedItems = self.purchasedItemsRepository {
      for purchasedItem in purchasedItems {
        purchasedItem.delete()
      }
    }
    
    clearAfterReceipt = true
  }
  
  func getItems(completion: @escaping () -> Void) {
    itemQueryService.getSearchResults() { items, _  in
      self.items = ItemRepository.all()

      if let item = self.items {
        for item in item {
          item.delete()
        }
      }
      if let itemList = items {
        for item in itemList {
          ItemRepository.add(item: item)
        }
      }
      completion()
    }
  }
  
  func getPromotions(completion: @escaping () -> Void) {
    promotionQueryService.getSearchResults() { promotions, _ in
      self.promotions = promotions ?? []
      completion()
    }
  }
  
  func addPurchasedItem(_ count: Int, cellForRowAt row: Int) {
    if let purchasedItems = self.purchasedItemsRepository {
      for purchasedItem in purchasedItems {
        purchasedItem.delete()
      }
    }
    
    let purchasedItem = purchasedItems.filter{ $0.item.barcode == self.items?[row].barcode }.first
    if purchasedItem != nil {
      let updatedItems = purchasedItems.map({ purchasedItem -> PurchasedItem in
        if purchasedItem.item.barcode == items?[row].barcode {
          var item = purchasedItem
          item.count = count
          return item
        }
        return purchasedItem
      })
      purchasedItems = updatedItems
    } else {
      self.purchasedItems.append(contentsOf: [PurchasedItem(
        count: count,
        promotion: promotions.contains(self.items?[row].barcode ?? ""),
        item: items?[row] ?? ItemRepository()
      )])
    }
    purchasedItems = purchasedItems.filter{ $0.count != 0 }
    for purchasedItem in purchasedItems {
      PurchasedItemRepository.add(barcode: purchasedItem.item.barcode ,count: purchasedItem.count, promotion: purchasedItem.promotion, item: ItemRepository(value: purchasedItem.item), subtotal: Double(purchasedItem.subtotal), subreceipt: purchasedItem.subreceipt)
    }
    self.purchasedItemsRepository = PurchasedItemRepository.all()
  }
  
  func receiptPrint() -> String {
    var totalPrice: Float = 0
    var totalPriceWithoutPromotion: Float = 0
    var receipt: String = ""
    var receiptLableText = ""
    for purchasedItem in purchasedItems {
      totalPrice += purchasedItem.subtotal
      totalPriceWithoutPromotion += Float(purchasedItem.count) * Float(purchasedItem.item.price)
      receipt += purchasedItem.subreceipt
    }
    
    receiptLableText = """
                        ***Receipts***
                        \(receipt)----------------------
                        总计：¥\(format(totalPrice))
                        节省：¥\(format(totalPriceWithoutPromotion - totalPrice))
                        **********************
                        """
    return receiptLableText
  }
  
  func format(_ variable: Float) -> String {
    return String(format: "%0.2f",variable);
  }
}
