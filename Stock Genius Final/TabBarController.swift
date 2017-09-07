//
//  TabBarController.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/1/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, TabBarDelegate {
    
    var currentPicksNeedsUpate = false

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
