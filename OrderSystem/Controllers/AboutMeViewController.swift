//
//  AboutMeViewController.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/13.
//  Copyright © 2020 骆荟州. All rights reserved.
//

import UIKit

class AboutMeViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    private var aboutView: AboutMeView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        OrderSystemDataManager.GetAppInfo(forId: 1, completion: { data in
            guard let info = data else { return }
            self.aboutView?.aboutApp = info
            OrderSystemDataManager.GetDeveloperInfo(forId: 1, completion: { data in
                guard let info = data else { return }
                self.aboutView?.aboutMe = info
            })
        })

    }
    
    private func initView() {
        scrollView.contentSize = CGSize(width: kScreenWidth, height: 800)
        aboutView = AboutMeView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 800))
        scrollView.addSubview(aboutView!)
    }
    
}
