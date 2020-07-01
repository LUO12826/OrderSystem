//
//  OrderTableViewCell.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/25.
//  Copyright © 2020 骆荟州. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    var Order: Order? {
        didSet {
            updateView()
        }
    }

    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var lblDishNum: UILabel!
    @IBOutlet weak var imgMoreDish: UIImageView!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet var imgsDish: [UIImageView]!
    @IBOutlet var lblDishName: [UILabel]!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgMoreDish.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    private func updateView() {
        guard let order = self.Order else {
            return
        }
        
        lblShopName.text = order.Restaurant?.Name
        lblDishNum.text = "\(order.OrderItems?.count ?? 0)种菜品"
        lblTime.text = order.OrderDate.toString(format: "yyyy-MM-dd")
        lblTotalPrice.text = "\(order.TotalPrice.roundTo(places: 1))"
        
        if let items = order.OrderItems {
            var count = 0
            if items.count > 3 {
                count = 3
                imgMoreDish.isHidden = false
            }
            else {
                count = items.count
                imgMoreDish.isHidden = true
            }
            for i in 0 ..< count {
                lblDishName[i].text = items[i].Dish?.Name
                OrderSystemDataManager.LoadListImg(forList: .DishesList, id: items[i].DishId, completion: { data in
                    if data == nil { return }
                    self.imgsDish[i].image = data!
                    items[i].Dish?.Images.append(data!)
                })
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for img in imgsDish {
            img.image = nil
        }
        for lbl in lblDishName {
            lbl.text = nil
        }
        lblTime.text = nil
        lblShopName.text = nil
        lblDishNum.text = nil
        lblTotalPrice.text = nil
    }
}
