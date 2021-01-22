//
//  NavigationController.swift
//  Final-Workshop
//
//  Created by Yuehuan Lu on 2021/1/4.
//

import UIKit

class ItemListViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  let itemViewModel = ItemViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "商品列表"
    tableView.dataSource = self
    
    itemViewModel.getItems() { [weak self] in
      self?.tableView.reloadData()
    }
    
    itemViewModel.getPromotions() { [weak self] in
      self?.tableView.reloadData()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if itemViewModel.clearAfterReceipt {
      tableView.reloadData()
    }
  }
  
  @IBAction func clickToCartPageButton(_ sender: Any) {
    let cartPageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CartPageViewController") as CartPageViewController
    itemViewModel.setclearAfterReceiptFalse()
    cartPageViewController.configure(self.itemViewModel)
    self.navigationController?.pushViewController(cartPageViewController, animated: true)
  }
}

extension ItemListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemViewModel.items?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? ItemCell else {
      return UITableViewCell()
    }
    
    cell.configure(with: itemViewModel.items?[indexPath.row] ?? ItemRepository(), promotion: itemViewModel.promotions) { [weak self] count in
      self?.itemViewModel.addPurchasedItem(count, cellForRowAt: indexPath.row)
    }
    return cell
  }
}


