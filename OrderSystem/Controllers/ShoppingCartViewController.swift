//
//  ShoppingCartViewController.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/23.
//  Copyright © 2020 骆荟州. All rights reserved.
//

import UIKit

class ShoppingCartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ModifyDishNumDelegate {

    var delegate: ModifyDishNumDelegate?
    var Dishes: [Dish] = [Dish]()
    private let ShoppingCartTableViewCellID = "ShoppingCartTableViewCell"
    
    @IBOutlet weak var btnPlaceOrder: UIButton!
    @IBOutlet weak var ShoppingCartTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    @IBAction func btnPlaceOrderTapped(_ sender: Any) {
        if Dishes.count <= 0 { return }
        self.dismiss(animated: true, completion: {
            (self.delegate as? MenuViewController)?.PlaceOrderTapped(sender: nil)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Dishes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func DishNumChanged(dishId: Int, num: Int) {
        if num <= 0 {
            removeDish(withId: dishId)
            ShoppingCartTableView.reloadData()
        }
        delegate?.DishNumChanged(dishId: dishId, num: num)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ShoppingCartTableView.dequeueReusableCell(withIdentifier: ShoppingCartTableViewCellID) as! ShoppingCartTableViewCell
        cell.delegate = self
        cell.Dish = Dishes[indexPath.row]
        return cell
    }
    
    private func initView() {
        ShoppingCartTableView.register(UINib(nibName: "ShoppingCartTableViewCell", bundle: nil), forCellReuseIdentifier: ShoppingCartTableViewCellID)
        btnPlaceOrder.backgroundColor = kThemeColor
    }

    private func removeDish(withId id: Int) {
        
        for i in 0 ..< Dishes.count {
            if Dishes[i].Id == id {
                Dishes.remove(at: i)
                return
            }
        }
    }
    
}
