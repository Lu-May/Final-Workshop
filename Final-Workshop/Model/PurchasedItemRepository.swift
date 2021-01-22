//
//  PurchasedItemRepository.swift
//  Final-Workshop
//
//  Created by Yuehuan Lu on 2021/1/21.
//

import Foundation
import RealmSwift

@objcMembers class PurchasedItemRepository: Object {
  @objc dynamic var count = 0
  @objc dynamic var promotion = false
  @objc dynamic var item: ItemRepository?
  @objc dynamic var subtotal = 0.0
  @objc dynamic var subreceipt = ""

  
  convenience init(_ count: Int, _ promotion: Bool, _ item: ItemRepository, _ subtotal: Double, _ subreceipt: String) {
    self.init()
    self.count = count
    self.promotion = promotion
    self.item = item
    self.subtotal = subtotal
    self.subreceipt = subreceipt
  }
}

extension PurchasedItemRepository {
  static func all(in realm: Realm = try! Realm()) -> Results<PurchasedItemRepository> {
    return realm.objects(PurchasedItemRepository.self)
  }

  static func add(count: Int, promotion: Bool, item: ItemRepository, subtotal: Double, subreceipt: String, in realm: Realm = try! Realm()) {
    let item = PurchasedItemRepository(count, promotion, item, subtotal, subreceipt)
      try! realm.write {
        realm.add(item)
      }
  }

//  func toggleCompleted(_ price: Double) {
//    guard let realm = realm else { return }
//    try! realm.write {
//      self.price = price
//    }
//  }
//  
  func delete() {
    guard let realm = realm else { return }
    try! realm.write {
      realm.delete(self)
    }
  }
}