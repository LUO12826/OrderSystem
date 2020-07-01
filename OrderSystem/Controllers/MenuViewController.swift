//
//  DishesViewController.swift
//  OrderSystem
//
//  Created by 骆荟州 on 2020/5/19.
//  Copyright © 2020 骆荟州. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, ModifyDishNumDelegate {

    private let dishCellID = "dishCell"
    private var dishes = [Dish]()
    
    @IBOutlet weak var DishesCollectionView: UICollectionView!
    @IBOutlet weak var ShoppingCartBar: ShoppingCartBarView!
    
    private var headerView: MenuHeaderView!
    private var selectedDish: Dish?
    
    
    var restaurant: Restaurant? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDishesCollectionView()
        initView()
        updateView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _ = calcShoppingCartBarInfo()
    }
    
    //进行除了初始化DishesCollectionView外的其它操作。
    private func initView() {
        navigationController?.navigationBar.tintColor = kThemeColor
        ShoppingCartBar.delegate = self
    }
    
    //当获取了餐馆信息时，调用此方法更新菜品列表。
    private func updateView() {
        guard let restaurant = restaurant else { return }
        headerView?.restaurant = restaurant
        OrderSystemDataManager.LoadDishesList(for: restaurant.Id, completion: { data in
            guard let dishes = data else { return }
            self.dishes = dishes

            self.DishesCollectionView.reloadData()
        })
    }
    
    //遵循协议ModifyDishNumDelegate
    func DishNumChanged(dishId: Int, num: Int) {
        _ = calcShoppingCartBarInfo()
    }

    //当用户选购的菜品发生变化时，下方的购物车条中的信息应该改变。调用此方法计算改变后的值。
    private func calcShoppingCartBarInfo() -> (Float, Int) {
        var num = 0
        var totalPrice: Float = 0.0
        for dish in dishes {
            if dish.Num > 0 {
                num += 1
                totalPrice += dish.Price * Float(dish.Num)
            }
            
        }
        ShoppingCartBar.UpdateView(totalPrice: totalPrice, num: num)
        return (totalPrice, num)
    }
    
    //当用户打开购物车想查看其中的项目时，调用此方法生成项目。
    private func getShoppingCartItems() -> [Dish] {
        var cartItems = [Dish]()
        for dish in dishes {
            if dish.Num > 0 {
                cartItems.append(dish)
            }
        }
        return cartItems
    }
    
    //生成订单
    private func generateOrder() -> Order? {
        let dishes = getShoppingCartItems()
        guard let rest = restaurant else { return nil }
        if dishes.count <= 0 { return nil }
        let order = Order(id: -1, restaurantId: rest.Id, orderDate: Date())
        
        var orderitems = [OrderItem]()
        for dish in dishes {
            let item = OrderItem(id: -1, unitPrice: dish.Price, num: dish.Num, dishId: dish.Id, dish: nil)
            orderitems.append(item)
        }
        order.OrderItems = orderitems
        return order
    }
    
    //下单成功时的提示
    private func notifyOrderSucceed() {
        let orderVc = (tabBarController?.viewControllers?[1] as! UINavigationController).viewControllers[0] as? OrderViewController
        orderVc?.NewOrderCount += 1
        
        let message = "下单成功!"
        let alert = UIAlertController(title: "订单信息", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "返回首页", style: .default, handler: { a in
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "继续看看", style: .default, handler: { a in
            self.resetShoppingCart()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func resetShoppingCart() {
        for dish in dishes {
            dish.Num = 0
        }
        ShoppingCartBar.UpdateView(totalPrice: 0, num: 0)
    }
    
    //初始化DishesCollectionView，设置各类参数。
    private func initDishesCollectionView() {
        let layout = UICollectionViewFlowLayout()
        //每个cell的高度
        let itemHeigh:CGFloat = 130
        //cell间的间隔
        let itemGap: CGFloat = 10.0
        
        let itemWidth = (kScreenWidth - 2 * CGFloat(itemGap))
        layout.itemSize = CGSize(width: itemWidth, height: itemHeigh)
        layout.minimumLineSpacing = itemGap
        layout.minimumInteritemSpacing = itemGap
        layout.sectionInset = UIEdgeInsets(top: 0, left: itemGap, bottom: 0, right: itemGap)
        
        DishesCollectionView.setCollectionViewLayout(layout, animated: false)
        //让collectionView顶部留出空间
        let headerHeight: CGFloat = 260.0
        DishesCollectionView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 70, right: 0)
        DishesCollectionView.register(UINib(nibName: "DishesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: dishCellID)
        //加入headerView
        let header = MenuHeaderView()
        header.frame = CGRect(x: 0 , y: -headerHeight, width: kScreenWidth, height: headerHeight)
        headerView = header
        DishesCollectionView.addSubview(header)
        
    }
    
}

//遵循tableView协议
extension MenuViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dishes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dishCellID, for: indexPath) as! DishesCollectionViewCell
        cell.dish = dishes[indexPath.row]
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDish = dishes[indexPath.row]
        performSegue(withIdentifier: "MenuToDishDetailSegue", sender: nil)
    }
}

//准备转场
extension MenuViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "MenuToDishDetailSegue":
            let dest = segue.destination as! DishDetailViewController
            dest.dish = selectedDish
            return
        case "ShowShoppingCartSegue":
            let dest = segue.destination as! ShoppingCartViewController
            dest.delegate = self
            dest.Dishes = getShoppingCartItems()
            return
        default:
            return
        }
    }

}

//遵循底部购物车bar的协议
extension MenuViewController: ShoppingCartBarViewDelegate {
    
    func OpenShoppingCart(sender: ShoppingCartBarView?) {
        performSegue(withIdentifier: "ShowShoppingCartSegue", sender: nil)
    }
    
    ///处理下单事宜
    func PlaceOrderTapped(sender: ShoppingCartBarView?) {
        
        let price = calcShoppingCartBarInfo()
        if price.1 <= 0 { return }
        let message = "您当前选择了\(price.1)种菜品，金额共计\(price.0.roundTo(places: 1))元。"
        let alert = UIAlertController(title: "下单", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确认下单", style: .default, handler: { a in
            if let order = self.generateOrder() {
                OrderSystemDataManager.AddOrder(order: order, completion: { result in
                    if !result { print("faild"); return }
                    self.notifyOrderSucceed()
                })
            }
        }))
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
