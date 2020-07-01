//
//  OrderItemTableViewCell.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/25.
//  Copyright © 2020 骆荟州. All rights reserved.
//

import UIKit

class OrderItemTableViewCell: UITableViewCell {

    @IBOutlet weak var imgDish: UIImageView!
    @IBOutlet weak var lblDishName: UILabel!
    @IBOutlet weak var lblNum: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    var orderItem: OrderItem? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgDish.image = nil
    }
    
    private func updateView() {
        guard let item = self.orderItem, let dish = item.Dish else {
            return
        }
        lblDishName.text = dish.Name
        lblNum.text = "单价￥\(item.UnitPrice)，共\(item.Num)份"
        lblTotalPrice.text = "\(item.TotalPrice.roundTo(places: 1))"
        if dish.Images.count > 0 {
            imgDish.image = dish.Images[0]
        }
        else {
            OrderSystemDataManager.LoadListImg(forList: .DishesList, id: dish.Id, completion: { data in
                guard let img = data else { return }
                self.imgDish.image = img
                dish.Images.append(img)
            })
        }
    }
}
