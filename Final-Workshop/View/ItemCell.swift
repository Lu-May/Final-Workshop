//
//  ItemCell.swift
//  Final-Workshop
//
//  Created by Yuehuan Lu on 2021/1/4.
//

import UIKit
import RealmSwift

class ItemCell: UITableViewCell {
  @IBOutlet weak var nameLable: UILabel!
  @IBOutlet weak var unitLable: UILabel!
  @IBOutlet weak var priceLable: UILabel!
  @IBOutlet weak var promotionLable: UILabel?
  @IBOutlet weak var countLable: UILabel!
  @IBOutlet weak var stepper: UIStepper!
  
  var addItem: ((Int) -> Void)!
  
  func stepperInit( _ count: Double) -> Int {
    //设置stepper的范围与初始值
    stepper.maximumValue = 100
    stepper.minimumValue = 0
    stepper.value = count
    
    //设置每次递减的值
    stepper.stepValue = 1
    
    //设置stepper可以按住不放来连续更改值
    stepper.isContinuous = true
    
    stepper.addTarget(self, action: #selector(stepperValuesDidChanged(_:)), for: .valueChanged)
    return Int(stepper.value)
  }
  
  @objc func stepperValuesDidChanged(_ sender: UIStepper){
    setCountText(Int(stepper.value))
    addItem(Int(stepper.value))
  }
  
  func setCountText(_ input: Int) {
    countLable.text = "数量:\(input)"
  }
  
  func configure(with purchasedItem: PurchasedItemRepository, promotion: [String], addItem: @escaping (Int) -> Void) {
    self.addItem = addItem
    nameLable.text = purchasedItem.item?.name
    unitLable.text = "(单位:\(String(describing: purchasedItem.item?.unit ?? "")))"
    priceLable.text = "单价:¥\(String(describing: purchasedItem.item?.price ?? 0))"
    promotionLable?.text = promotion.contains(purchasedItem.item?.barcode ?? "") ? "买二送一" : ""
    
    setCountText(stepperInit(Double(purchasedItem.count)))
  }
}
