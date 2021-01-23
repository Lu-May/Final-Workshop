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

extension ItemRepository {
  static func all(in realm: Realm = try! Realm()) -> Results<ItemRepository> {
    return realm.objects(ItemRepository.self)
  }

  @discardableResult
  static func add(item: Item, in realm: Realm = try! Realm())
    -> ItemRepository {
    let item = ItemRepository(item: item)
      try! realm.write {
        realm.add(item, update: .modified)
      }
      return item
  }

  func delete() {
    guard let realm = realm else { return }
    try! realm.write {
      realm.delete(self)
    }
  }
}
