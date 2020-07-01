//
//  MenuHeaderView.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/25.
//  Copyright © 2020 骆荟州. All rights reserved.
//

import UIKit

class MenuHeaderView: UIView {

    var restaurant: Restaurant? {
        didSet {
            updateView()
        }
    }
    
    @IBOutlet var innerView: UIView!
    @IBOutlet weak var imgRestaurant: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblAvg: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViewFromNib()
    }
    
    private func initViewFromNib(){
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "MenuHeaderView", bundle: bundle)
        self.innerView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        self.innerView.frame = bounds
        self.addSubview(innerView)
    }
    
    private func updateView() {
        guard let rest = self.restaurant else {
            return
        }
        
        imgRestaurant.image = rest.Images[0]
        lblName.text = rest.Name
        lblCategory.text = rest.Category
        lblAvg.text = "人均￥\(rest.AvgConsumption)"
        lblRate.text = "\(rest.Rate)"
        lblDescription.text = rest.Description
        lblAddress.text = rest.Address
    }
}
