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
  var clearAfterReceipt = false
  var purchasedItemsRepository: Results<PurchasedItemRepository>?
  var promotions: [String] = []
  
  func setclearAfterReceiptFalse() {
    clearAfterReceipt = false
  }
  
  func clearPurchaseedItems() {
    if let purchasedItemsRepository = purchasedItemsRepository {
      for purchasedItem in purchasedItemsRepository {
        PurchasedItemRepository.add(barcode: purchasedItem.barcode, count: 0, promotion: false, item: purchasedItem.item ?? ItemRepository(), subtotal: 0)      }
    }
    self.purchasedItemsRepository = PurchasedItemRepository.all()
    clearAfterReceipt = true
  }
  
  func getItems(completion: @escaping () -> Void) {
    itemQueryService.getSearchResults() { items, _  in
      self.purchasedItemsRepository = PurchasedItemRepository.all()
      
      if let itemList = items {
        for item in itemList {
          PurchasedItemRepository.add(barcode: item.barcode, count: 0, promotion: false, item: ItemRepository(item: item), subtotal: 0)
        }
      }
      self.purchasedItemsRepository = PurchasedItemRepository.all()
      completion()
    }
  }
  
  func getPromotions(completion: @escaping () -> Void) {
    promotionQueryService.getSearchResults() { promotions, _ in
      self.promotions = promotions ?? []
      completion()
    }
  }
  
  func getSubtotal(_ promotion: Bool, _ item: ItemRepository, _ count: Int) -> Double {
    if promotion {
      if count >= 3 {
        return Double((count/3)*2 + count%3) * Double(item.price)
      }
    }
    return Double(count) * Double(item.price)
  }
  
  func addPurchasedItem(_ count: Int, cellForRowAt row: Int) {
    
    PurchasedItemRepository.add(barcode: purchasedItemsRepository?[row].item?.barcode ?? "",count: count , promotion: promotions.contains(purchasedItemsRepository?[row].item?.barcode ?? ""), item: ItemRepository(value: purchasedItemsRepository?[row].item ?? ItemRepository()), subtotal: getSubtotal(promotions.contains(purchasedItemsRepository?[row].item?.barcode ?? ""), purchasedItemsRepository?[row].item ?? ItemRepository(), count))
    print(Realm.Configuration.defaultConfiguration.fileURL)
    self.purchasedItemsRepository = PurchasedItemRepository.all()
  }
  
  func receiptPrint() -> String {
    var totalPrice: Float = 0
    var totalPriceWithoutPromotion: Float = 0
    var receipt: String = ""
    var receiptLableText = ""
    if let purchasedItemsRepository = purchasedItemsRepository {
      for purchasedItem in purchasedItemsRepository.filter({ $0.count != 0 }) {
        totalPrice += Float(purchasedItem.subtotal)
        totalPriceWithoutPromotion += Float(purchasedItem.count) * Float(purchasedItem.item?.price ?? 0)
        receipt += "名称：\(purchasedItem.item?.name ?? "")，数量：\(purchasedItem.count)\(purchasedItem.item?.unit ?? "")，单价：¥\(String(format: "%0.2f",purchasedItem.item?.price ?? 0))\n小计：¥\(String(format: "%0.2f",purchasedItem.subtotal))\n"
      }
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
