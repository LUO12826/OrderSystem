//
//  DishesCollectionViewCell.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/19.
//  Copyright © 2020 骆荟州. All rights reserved.
//

import UIKit

protocol ModifyDishNumDelegate {
    func DishNumChanged(dishId: Int, num: Int)
}

class DishesCollectionViewCell: UICollectionViewCell, NumberUpDownDelegate {
    
    private(set) var restaurantId: Int?
    private var observation: NSKeyValueObservation?
    var delegate: ModifyDishNumDelegate?
    
    var dishNum: Int = 0 {
        didSet {
            numUpDown.value = dishNum
        }
    }
    
    var dish: Dish? {
        didSet {
            updateView()
        }
    }
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var numUpDown: NumberUpDownView!
    
    @IBOutlet var imgTraits: [UIImageView]!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dishImage.image = nil
    }
    
    
    
    private func updateView() {
        guard let dish = self.dish else { return }
        
        numUpDown.delegate = self
        numUpDown.value = dish.Num
        lblName.text = dish.Name
        lblDescription.text = dish.Description
        lblPrice.text = "\(dish.Price)"
        updateTrait(isHot: dish.IsHot, isRecommand: dish.IsRecommand)
        
        observation = dish.observe(\Dish.Num, options: [.new,.old], changeHandler: { (p, change) in
            if let num = change.newValue {
                self.numUpDown.value = num
            }
        })
        
        OrderSystemDataManager.LoadListImg(forList: .DishesList, id: dish.Id, completion: { data in
            guard let img = data else { return }
            self.dishImage.image = img
            dish.Images.append(img)
        })
    }
    
    func setDishNum(num: Int) {
        dishNum = num
        numUpDown.value = num
    }
    
    func NumberUpDownDidChanged(sender: NumberUpDownView, operation: NumberUpDown, value: Int) {
        guard  let dish = self.dish else {
            return
        }
        dish.Num = value
        delegate?.DishNumChanged(dishId: dish.Id, num: dish.Num)
    }
    
    private func updateTrait(isHot: Bool, isRecommand: Bool) {
        var count = 0
        
        for img in imgTraits {
            img.image = nil
        }
        
        if isHot {
            imgTraits[count].image = UIImage(named: "hot")
            count += 1
        }
        if isRecommand {
            imgTraits[count].image = UIImage(named: "thumb")
        }
    }
    
    
    
    private func initView() {

    }
}
