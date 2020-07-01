//
//  DishesViewController.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/19.
//  Copyright © 2020 骆荟州. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    private let dishCellID = "dishCell"
    @IBOutlet weak var DishesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDishesCollectionView()
        DishesCollectionView.register(UINib(nibName: "DishesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: dishCellID)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dishCellID, for: indexPath) as! DishesCollectionViewCell
        cell.backgroundColor = UIColor.blue
        return cell
    }




    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
    private func initDishesCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let itemHeigh:CGFloat = 200
        let itemGap: CGFloat = 10.0
        
        let itemWidth = (kScreenWidth - 3 * CGFloat(itemGap)) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemHeigh)
        layout.minimumLineSpacing = itemGap
        layout.minimumInteritemSpacing = itemGap
        layout.sectionInset = UIEdgeInsets(top: 0, left: itemGap, bottom: 0, right: itemGap)
        
        DishesCollectionView.setCollectionViewLayout(layout, animated: false)
    }
}
