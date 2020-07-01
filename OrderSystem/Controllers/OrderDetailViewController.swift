//
//  OrderDetailViewController.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/25.
//  Copyright © 2020 骆荟州. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController {

    private let OrderItemTableViewCellID = "OrderItemTableViewCell"
    var sourceController: OrderViewController?
    var Order: Order?
    private var header: OrderDetailViewHeader!
    @IBOutlet weak var OrderDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateView()
    }
    
    
    private func initView() {
        OrderDetailTableView.register(UINib(nibName: "OrderItemTableViewCell", bundle: nil), forCellReuseIdentifier: OrderItemTableViewCellID)
        
        
        let headerHeight: CGFloat = 80.0
        header = OrderDetailViewHeader(frame: CGRect(x: 0, y: -headerHeight, width: kScreenWidth, height: headerHeight))
        OrderDetailTableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
        OrderDetailTableView.addSubview(header)
    }

    private func updateView() {
        guard let order = self.Order else {
            return
        }
        OrderDetailTableView.reloadData()
        header.order = order
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        if Order == nil { return }
        let alert = UIAlertController(title: "删除", message: "确实要删除此条订单么？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确认删除", style: .destructive, handler: { a in
            OrderSystemDataManager.DeleteOrder(withOrderId: self.Order!.Id, completion: { result in
                self.navigationController?.popViewController(animated: true)
            })
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
}

extension OrderDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = self.Order?.OrderItems {
            return items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = OrderDetailTableView.dequeueReusableCell(withIdentifier: OrderItemTableViewCellID) as! OrderItemTableViewCell
        if let items = self.Order?.OrderItems {
            cell.orderItem = items[indexPath.row]
        }
        return cell
    }
    
    
}
