//
//  ShoppingCartBarView.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/22.
//  Copyright © 2020 骆荟州. All rights reserved.
//

import UIKit


protocol ShoppingCartBarViewDelegate {
    //用户点击其它区域想查看购物车时，通知其代理打开购物车
    func OpenShoppingCart(sender: ShoppingCartBarView?)
    //用户点击“下单”时，通知代理执行下单流程
    func PlaceOrderTapped(sender: ShoppingCartBarView?)
}

class ShoppingCartBarView: UIView {

    @IBOutlet var innerView: UIView!

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var btnPlaceOrder: UIButton!
    //显示餐品总价
    @IBOutlet weak var lblPrice: UILabel!
    //显示餐品数量
    @IBOutlet weak var lblNum: UILabel!
    
    var delegate: ShoppingCartBarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViewFromNib()
    }
    
    @IBAction private func BtnPlaceOrderTapped(_ sender: Any) {

        delegate?.PlaceOrderTapped(sender: self)
    }
    
    @objc private func BarTapped() {
        delegate?.OpenShoppingCart(sender: self)
    }
    
    
    func UpdateView(totalPrice: Float, num: Int) {
        let price = totalPrice >= 0 ? totalPrice : 0.0
        let number = num >= 0 ? num : 0
        lblPrice.text = "\(price.roundTo(places: 1))"
        lblNum.text = "共\(number)种餐品"
    }
    
    private func initViewFromNib(){
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ShoppingCartBarView", bundle: bundle)
        self.innerView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        self.innerView.frame = bounds
        
        //背景高斯模糊效果
        let blur = UIBlurEffect(style: .systemChromeMaterial)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.frame = bounds
        effectView.contentView.addSubview(contentView)
        effectView.layer.masksToBounds = true
        effectView.layer.cornerRadius = 25
        innerView.addSubview(effectView)
        self.addSubview(innerView)
        
        //阴影效果
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 5.0
        //增加点击手势
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BarTapped)))
        
        lblPrice.text = "0.0"
        lblNum.text = "共0种餐品"
    }
    
}
