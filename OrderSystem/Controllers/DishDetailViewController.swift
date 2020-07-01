//
//  DishDetailViewController.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/19.
//  Copyright © 2020 骆荟州. All rights reserved.
//

import UIKit

class DishDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var delegate: ModifyDishNumDelegate?
    var detailView: DishDetailView?
    var dish: Dish? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailView?.dish = dish
    }
    
    
    private func initView() {
        scrollView.contentSize = CGSize(width: kScreenWidth, height: 600)
        detailView = DishDetailView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 600))
        scrollView.addSubview(detailView!)
    }
}
