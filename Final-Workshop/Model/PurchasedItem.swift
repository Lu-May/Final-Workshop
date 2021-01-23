//
//  PurchasedItem.swift
//  Final-Workshop
//
//  Created by Yuehuan Lu on 2021/1/5.
//

import Foundation

struct PurchasedItem {
  var count: Int
  var promotion: Bool
  var item: ItemRepository
  
  var subtotal: Float {
    if promotion {
      if count >= 3 {
        return Float((count/3)*2 + count%3) * Float(item.price)
      }
    }
    return Float(count) * Float(item.price)
  }
}
