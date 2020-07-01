//
//  DishDetailView.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/26.
//  Copyright © 2020 骆荟州. All rights reserved.
//

import UIKit

class DishDetailView: UIView, NumberUpDownDelegate {

    
    
    var dish: Dish? {
        didSet {
            updateView()
        }
    }

    @IBOutlet var innerView: UIView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgDish: UIImageView!
    @IBOutlet weak var viewRecommand: UIView!
    @IBOutlet weak var viewHot: UIView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var numberUpDown: NumberUpDownView!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViewFromNib()
    
    }
    
    private func updateView() {
        guard let dish = self.dish else {
            return
        }
        numberUpDown.delegate = self
        
        if dish.Images.count > 0 {
            imgDish.image = dish.Images[0]
        }
        lblName.text = dish.Name
        lblDescription.text = dish.Description
        lblPrice.text = "\(dish.Price)"
        numberUpDown.value = dish.Num
        btnAdd.isHidden = dish.Num > 0
        viewHot.isHidden = !dish.IsHot
        viewRecommand.isHidden = !dish.IsRecommand
    }
    
    private func initViewFromNib(){
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DishDetailView", bundle: bundle)
        self.innerView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        self.innerView.frame = bounds
        self.addSubview(innerView)
    }
    
    @IBAction func btnAddTapped(_ sender: Any) {
        btnAdd.isHidden = true
        numberUpDown.value = 1
        dish?.Num = 1
    }
    
    func NumberUpDownDidChanged(sender: NumberUpDownView, operation: NumberUpDown, value: Int) {
        if value <= 0 {
            btnAdd.isHidden = false
        }
        dish?.Num = value
    }
}
