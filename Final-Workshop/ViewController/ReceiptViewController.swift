//
//  CartPageViewController.swift
//  Final-Workshop
//
//  Created by Yuehuan Lu on 2021/1/4.
//

import UIKit

class ReceiptViewController: UIViewController {
  @IBOutlet weak var receiptLable: UILabel!
  
  var viewModel = ItemViewModel()
  
  func configure(_ itemViewModel: ItemViewModel) {
    viewModel = itemViewModel
  }
  
  override func viewDidAppear(_ animated: Bool) {
    viewModel.clearPurchaseedItems()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "购物小票"
    receiptLable.text = viewModel.receiptPrint()
  }
}
