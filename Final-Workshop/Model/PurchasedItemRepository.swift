//
//  PurchasedItemRepository.swift
//  Final-Workshop
//
//  Created by Yuehuan Lu on 2021/1/21.
//

import Foundation
import RealmSwift

@objcMembers class PurchasedItemRepository: Object {
  @objc dynamic var barcode = ""
  @objc dynamic var count = 0
  @objc dynamic var promotion = false
  @objc dynamic var item: ItemRepository?
  var subtotal: Double {
    if promotion {
      if count >= 3 {
        return Double((count/3)*2 + count%3) * Double(item?.price ?? 0)
      }
    }
    return Double(count) * Double(item?.price ?? 0)
  }

  override static func primaryKey() -> String? {
      return "barcode"
    }
  
  convenience init(_ barcode: String, _ count: Int, _ promotion: Bool, _ item: ItemRepository) {
    self.init()
    self.barcode = item.barcode
    self.count = count
    self.promotion = promotion
    self.item = item
  }
}

extension PurchasedItemRepository {
  static func all(in realm: Realm = try! Realm()) -> Results<PurchasedItemRepository> {
    return realm.objects(PurchasedItemRepository.self)
  }
  
  static func add(barcode: String, count: Int, promotion: Bool, item: ItemRepository, in realm: Realm = try! Realm()) {
    let item = PurchasedItemRepository(barcode ,count, promotion, item)
      try! realm.write {
        realm.add(item, update: .modified)
      }
  }
  
  func delete() {
    guard let realm = realm else { return }
    try! realm.write {
      realm.delete(self)
    }
  }
}
