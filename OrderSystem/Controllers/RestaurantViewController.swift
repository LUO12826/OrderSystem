//
//  RestaurantViewController.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/13.
//  Copyright © 2020 骆荟州. All rights reserved.
//

import UIKit

class RestaurantViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let restaurantCellID = "restaurantCell"
    @IBOutlet weak var RestaurantTableView: UITableView!
    
    private var restaurantList: [Restaurant]?
    private var selectedItem: Restaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        OrderSystemDataManager.LoadRestaurantList(completion: { list in
            self.restaurantList = list
            if list != nil {
                self.RestaurantTableView.reloadData()
            }
        })
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: restaurantCellID) as! RestaurantTableViewCell
        cell.restaurant = restaurantList?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = restaurantList![indexPath.row]
        performSegue(withIdentifier: "restaurantToDishesSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "restaurantToDishesSegue" {
            let dest = segue.destination as! MenuViewController
            dest.restaurant = selectedItem
        }
    }
    
    private func initView() {
        RestaurantTableView.register(UINib(nibName: "RestaurantTableViewCell", bundle: nil), forCellReuseIdentifier: restaurantCellID)
        
        if kScreenWidth > 380 {
            RestaurantTableView.rowHeight = 265
        }
        else {
            RestaurantTableView.rowHeight = kScreenWidth * 14 / 20
        }
        
    }
}
