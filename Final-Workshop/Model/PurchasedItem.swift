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
  
  var subreceipt: String {
    return "名称：\(item.name)，数量：\(count)\(item.unit)，单价：¥\(String(format: "%0.2f",item.price))\n小计：¥\(String(format: "%0.2f",subtotal))\n";
  }
}
