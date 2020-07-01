//
//  OrderViewController.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/13.
//  Copyright © 2020 骆荟州. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {

    private let OrderTableViewCellID = "OrderTableViewCell"
    
    //新订单数量。改变时，改变tab栏的角标
    var NewOrderCount: Int = 0 {
        didSet {
            if NewOrderCount == 0 {
                tabBarController?.tabBar.items?[1].badgeValue = nil
            }
            else {
                tabBarController?.tabBar.items?[1].badgeValue = "\(NewOrderCount)"
            }
        }
    }
    
    //如果在订单明细控制器删除了订单，将其改为true
    var OrderDeleted: Bool = false
    
    private var firstLoad: Bool = true
    
    //选中的订单，保留备用
    private var selectedOrder: Order?
    
    @IBOutlet weak var OrderTableView: UITableView!
    
    private var orders = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        loadOrders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (NewOrderCount != 0 || OrderDeleted) && !firstLoad {
            loadOrders()
        }
        NewOrderCount = 0
        OrderDeleted = false
        firstLoad = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func loadOrders() {
        OrderSystemDataManager.LoadOrderList(completion: { data in
            guard let orders = data else { return }
            self.orders = orders
            self.OrderTableView.reloadData()
        })
    }
    
    private func updateView() {
        OrderTableView.reloadData()
    }
    
    private func initView() {
        OrderTableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: OrderTableViewCellID)
        navigationController?.navigationBar.tintColor = kThemeColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OrderToOrderDetailSegue" {
            let detailController = segue.destination as! OrderDetailViewController
            detailController.Order = selectedOrder
            detailController.sourceController = self
        }
    }
    
}


//遵循tableView协议。
extension OrderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = OrderTableView.dequeueReusableCell(withIdentifier: OrderTableViewCellID) as! OrderTableViewCell
        cell.Order = orders[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOrder = orders[indexPath.row]
        performSegue(withIdentifier: "OrderToOrderDetailSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "删除", handler: { a, b, c in
            let orderId = self.orders[indexPath.row].Id
            self.orders.remove(at: indexPath.row)
            self.OrderTableView.deleteRows(at: [indexPath], with: .automatic)
            OrderSystemDataManager.DeleteOrder(withOrderId: orderId, completion: nil)
        })
    
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}
