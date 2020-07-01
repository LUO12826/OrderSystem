//
//  ShoppingCartTableViewCell.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/23.
//  Copyright © 2020 骆荟州. All rights reserved.
//

import UIKit

class ShoppingCartTableViewCell: UITableViewCell, NumberUpDownDelegate {
    
    var Dish: Dish? {
        didSet {
            updateView()
        }
    }
    
    var delegate: ModifyDishNumDelegate?
    
    @IBOutlet weak var ImgDish: UIImageView!
    @IBOutlet weak var lblDishName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var numUpDown: NumberUpDownView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        ImgDish.image = nil
    }
    
    func NumberUpDownDidChanged(sender: NumberUpDownView, operation: NumberUpDown, value: Int) {
        guard let dish = self.Dish else {
            return
        }
        dish.Num = value
        lblPrice.text = "\(dish.Price * Float(dish.Num))"
        delegate?.DishNumChanged(dishId: dish.Id, num: value)
    }
    
    private func updateView() {
        guard let dish = self.Dish else { return }
        if dish.Images.count > 0 {
            ImgDish.image = dish.Images[0]
        }
        lblDishName.text = dish.Name
        lblPrice.text = "\(dish.Price * Float(dish.Num).roundTo(places: 1))"
        numUpDown.value = dish.Num
    }
    
    private func initView() {
        numUpDown.delegate = self
    }
}

