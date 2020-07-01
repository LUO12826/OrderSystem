//
//  OrderDetailViewHeader.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/26.
//  Copyright © 2020 骆荟州. All rights reserved.
//

import UIKit

class OrderDetailViewHeader: UIView {

    var order: Order? {
        didSet {
            updateView()
        }
    }
    
    @IBOutlet var innerView: UIView!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblRestaurantName: UILabel!
    @IBOutlet weak var lblNum: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViewFromNib()
    }
    
    private func updateView() {
        guard let order = self.order else {
            return
        }
        lblRestaurantName.text = order.Restaurant?.Name
        lblTotalPrice.text = "\(order.TotalPrice.roundTo(places: 1))"
        lblNum.text = "\(order.OrderItems?.count ?? 0)种餐品"
        lblDate.text = "下单于\(order.OrderDate.toString(format: "yyyy-M-d HH:mm"))"
    }
    
    private func initViewFromNib(){

        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "OrderDetailViewHeader", bundle: bundle)
        self.innerView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        self.innerView.frame = bounds
        self.addSubview(innerView)
    }
    
}
