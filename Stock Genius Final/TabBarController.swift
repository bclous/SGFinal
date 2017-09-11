//
//  TabBarController.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/1/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, TabBarDelegate, CurrentPicksVCDelegate {
    
    var chosenStock : CurrentStock?
    var currentPicksNeedsUpate = false
    var isTodayReturn = true

    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomTabBar()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        let currentPicksVC = viewControllers?[0] as? CurrentPicksVC
        if let currentPicksVC = currentPicksVC {
            currentPicksVC.needsPriceUpdate = currentPicksNeedsUpate
        }
    }
    
    private func addCustomTabBar() {
        let customTabBar = TabBar()
        view.addSubview(customTabBar)
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        customTabBar.topAnchor.constraint(equalTo: tabBar.topAnchor).isActive = true
        customTabBar.leftAnchor.constraint(equalTo: tabBar.leftAnchor).isActive = true
        customTabBar.rightAnchor.constraint(equalTo: tabBar.rightAnchor).isActive = true
        customTabBar.heightAnchor.constraint(equalTo: tabBar.heightAnchor).isActive = true
        customTabBar.delegate = self
        let currentPicksVC = self.viewControllers?[0] as! CurrentPicksVC
        currentPicksVC.delegate = self
        
        
    }
    
    func indexChosen(_ index: TabBarChoice) {
        switch index {
        case .currentPicks:
            selectedIndex = 0
        case .calculator:
            selectedIndex = 2
        case .pastPicks:
            selectedIndex = 1
        }
    }
    
    func currentStockChosen(stock: CurrentStock, isTodayReturn: Bool) {
        chosenStock = stock
        self.isTodayReturn = isTodayReturn
        performSegue(withIdentifier: "individualStockSegue", sender: nil)

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! IndividualStockVC
        destinationVC.stock = chosenStock
        destinationVC.isTodayReturn = isTodayReturn
        let currentPicksVC = self.viewControllers?[0] as! CurrentPicksVC
        currentPicksVC.mainTableView.reloadData()
    }
    

}
