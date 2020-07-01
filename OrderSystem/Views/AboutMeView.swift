//
//  AboutMeView.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/26.
//  Copyright © 2020 骆荟州. All rights reserved.
//

import UIKit

class AboutMeView: UIView {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblAppName: UILabel!
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var lbldescription: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNo: UILabel!
    @IBOutlet weak var lblDepartment: UILabel!
    
    var aboutMe: AboutMe? {
        didSet {
            updateView()
        }
    }
    
    var aboutApp: AboutApp? {
        didSet {
            updateView()
        }
    }
    
    @IBOutlet var innerView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViewFromNib()
    }
    
    private func updateView() {
        if aboutMe != nil {
            lblName.text = aboutMe!.Name
            lblNo.text = aboutMe!.No
            lblDepartment.text = aboutMe!.Department
            imgAvatar.image = aboutMe!.Avatar
        }
        if aboutApp != nil {
            lblAppName.text = aboutApp!.Name
            lblVersion.text = "版本 " + aboutApp!.Version
            lbldescription.text = aboutApp!.Description + "\n" + aboutApp!.Thanks
            imgIcon.image = aboutApp!.Icon
        }
    }
    
    private func initViewFromNib(){
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AboutMeView", bundle: bundle)
        self.innerView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        self.innerView.frame = bounds
        self.addSubview(innerView)
    }
}
