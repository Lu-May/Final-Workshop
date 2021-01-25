//
//  ItemRepository.swift
//  Final-Workshop
//
//  Created by Yuehuan Lu on 2021/1/21.
//

import Foundation
import RealmSwift

@objcMembers class ItemRepository: Object {
  @objc dynamic var barcode = ""
  @objc dynamic var name = ""
  @objc dynamic var unit = ""
  @objc dynamic var price: Double = 0.0
  
  override static func primaryKey() -> String? {
      return "barcode"
    }
  
  convenience init(item: Item) {
    self.init()
    self.barcode = item.barcode
    self.name = item.name
    self.unit = item.unit
    self.price = Double(item.price)
  }
}
