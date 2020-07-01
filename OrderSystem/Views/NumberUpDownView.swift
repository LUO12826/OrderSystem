//
//  NumberUpDownView.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/23.
//  Copyright © 2020 骆荟州. All rights reserved.
//

import UIKit

enum NumberUpDown {
    case up
    case down
}

protocol NumberUpDownDelegate {
    
    func NumberUpDownDidChanged(sender: NumberUpDownView, operation: NumberUpDown, value: Int)
}


@IBDesignable class NumberUpDownView: UIView {
    
    var value: Int = 0 {
        didSet {
            updateView()
        }
    }

    var delegate: NumberUpDownDelegate?
    
    @IBOutlet var innerView: UIView!
    
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var minus: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViewFromNib()
    }
    
    @IBAction func plusTapped(_ sender: Any) {
        value += 1
        delegate?.NumberUpDownDidChanged(sender: self, operation: .up, value: value)
    }
    
    @IBAction func minusTapped(_ sender: Any) {
        value -= 1
        delegate?.NumberUpDownDidChanged(sender: self, operation: .down, value: value)
    }
    
    private func initViewFromNib(){
        // 需要这句代码，不能直接写UINib(nibName: "MyView", bundle: nil)，不然不能在storyboard中显示
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "NumberUpDownView", bundle: bundle)
        self.innerView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        self.innerView.frame = bounds
        self.addSubview(innerView)
        num.isHidden = true
        minus.isHidden = true
    }
    
    private func updateView() {
        if value > 0 {
            num.isHidden = false
            minus.isHidden = false
        }
        else {
            num.isHidden = true
            minus.isHidden = true
        }
        num.text = "\(value)"
    }
}
