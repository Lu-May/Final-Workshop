//
//  ItemListViewController.swift
//  Final-Workshop
//
//  Created by Yuehuan Lu on 2021/1/4.
//

import UIKit

class CartPageViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  var viewModel = ItemViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "购物车"
    tableView.dataSource = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
  }
  
  func configure(_ itemViewModel: ItemViewModel) {
    viewModel = itemViewModel
    viewModel.purchasedItems = viewModel.getPurchasedItem()
  }
  
  @IBAction func clickForwardToReceiptPage(_ sender: Any) {
    let receiptViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ReceiptViewController") as ReceiptViewController
    viewModel.purchasedItems = viewModel.clearPurchasedItem()
    receiptViewController.configure(viewModel)
    show(receiptViewController, sender: self)
  }
}

extension CartPageViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.purchasedItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as? CartCell else {
      return UITableViewCell()
    }
    
    cell.configure(with: (viewModel.purchasedItems[indexPath.row]))
    return cell
  }
}
