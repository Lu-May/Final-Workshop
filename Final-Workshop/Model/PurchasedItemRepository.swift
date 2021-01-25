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
  @objc dynamic var subtotal = 0.0

  override static func primaryKey() -> String? {
      return "barcode"
    }
  
  convenience init(_ barcode: String, _ count: Int, _ promotion: Bool, _ item: ItemRepository, _ subtotal: Double) {
    self.init()
    self.barcode = item.barcode
    self.count = count
    self.promotion = promotion
    self.item = item
    self.subtotal = subtotal
  }
}

extension PurchasedItemRepository {
  static func all(in realm: Realm = try! Realm()) -> Results<PurchasedItemRepository> {
    return realm.objects(PurchasedItemRepository.self)
  }
  
  static func add(barcode: String, count: Int, promotion: Bool, item: ItemRepository, subtotal: Double, in realm: Realm = try! Realm()) {
    let item = PurchasedItemRepository(barcode ,count, promotion, item, subtotal)
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
