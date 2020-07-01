//
//  RestaurantTableViewCell.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/17.
//  Copyright © 2020 骆荟州. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {


    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var average: UILabel!
    @IBOutlet weak var stars: StarView!
    @IBOutlet weak var category: UILabel!
    
    var restaurant: Restaurant? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    
    private func updateView() {
        guard let restaurant = restaurant else { return }
        
        name.text = restaurant.Name
        average.text = "人均￥\(restaurant.AvgConsumption)"
        stars.rate = restaurant.Rate
        category.text = restaurant.Category
        OrderSystemDataManager.LoadListImg(forList: .RestaurantList, id: restaurant.Id, completion: { img in
            self.restaurantImage.image = img
            if let img = img {
                self.restaurant?.Images.append(img)
            }
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        name.text = ""
        average.text = ""
        stars.rate = -1
        category.text = ""
        restaurantImage.image = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
