//
//  ViewController.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 6/27/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class CurrentPicksVC: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatTableView()
        view.backgroundColor = SGConstants.mainBlackColor
    }

}

extension CurrentPicksVC : UITableViewDelegate, UITableViewDataSource, CurrentPicksToggleDelegate {
    
    func formatTableView() {
        mainTableView.register(UINib(nibName: "MainStockCell", bundle: nil), forCellReuseIdentifier: "mainStockCell")
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorStyle = .none
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainStockCell") as! MainStockCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let clearView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        clearView.backgroundColor = UIColor.clear
        let toggleView = MainStocksSectionHeaderToggle()
        toggleView.delegate = self
        return section == 0 ? clearView : toggleView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 60 : 50
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerView.adjustHeaderViewForOffset(scrollView.contentOffset.y)
        print("\(scrollView.contentOffset.y)")
    }
    
    func toggleTapped(typeChosen: CurrentPicksReturnType) {
        // refresh table view
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}

