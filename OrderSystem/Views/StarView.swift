//
//  starView.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/13.
//  Copyright © 2020 骆荟州. All rights reserved.
//

import UIKit

@IBDesignable class StarView: UIView {

    @IBOutlet var starImgs: [UIImageView]!
    
    @IBOutlet var innerView: UIView!
    
    
    var rate: Float {
        didSet {
            fillStars();
        }
    }
    
    override init(frame: CGRect) {
        rate = -1
        super.init(frame: frame)
        initViewFromNib()
    }
    
    required init?(coder: NSCoder) {
        rate = -1
        super.init(coder: coder)
        initViewFromNib()
    }
    

    private func fillStars() {
        if rate < 0 || rate > 5 {
            return
        }
        let intPart = Int(rate)
        let decimal = rate - Float(intPart)
        for i in 0..<intPart {
            starImgs[i].image = #imageLiteral(resourceName: "1")
        }
        for i in (intPart + 1)..<5 {
            starImgs[i].image = #imageLiteral(resourceName: "0")
        }
        switch decimal {
        case 0.0:
            starImgs[intPart].image = #imageLiteral(resourceName: "0")
        case 0.0...0.2:
            starImgs[intPart].image = #imageLiteral(resourceName: "0.2")
        case 0.2...0.5:
            starImgs[intPart].image = #imageLiteral(resourceName: "0.5")
        case 0.5...0.8:
            starImgs[intPart].image = #imageLiteral(resourceName: "0.8")
        case 0.8...1.0:
            starImgs[intPart].image = #imageLiteral(resourceName: "1")
        default:
            starImgs[intPart].image = #imageLiteral(resourceName: "1")
        }
    }
    
        private func initViewFromNib(){
            // 需要这句代码，不能直接写UINib(nibName: "MyView", bundle: nil)，不然不能在storyboard中显示
            
            let bundle = Bundle(for: type(of: self))
            let nib = UINib(nibName: "StarView", bundle: bundle)
            self.innerView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
            self.innerView.frame = bounds
            self.addSubview(innerView)
        }
}
