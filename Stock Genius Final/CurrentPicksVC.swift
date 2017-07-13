//
//  ViewController.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 6/27/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit
import Alamofire

class CurrentPicksVC: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    var dataStore : DataStore?
    var isTodayReturn = true
    var ready = true
    @IBOutlet weak var nextUpdateView: NextUpdateView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatTableView()
        view.backgroundColor = SGConstants.mainBlackColor
        dataStore = DataStore.shared
        
    }
    
}

extension CurrentPicksVC : UITableViewDelegate, UITableViewDataSource, CurrentPicksToggleDelegate {
    
    func formatTableView() {
        mainTableView.register(UINib(nibName: "MainStockCell", bundle: nil), forCellReuseIdentifier: "mainStockCell")
        mainTableView.register(UINib(nibName: "NextTwentyCell", bundle: nil), forCellReuseIdentifier: "NextTwentyCell")
        mainTableView.register(UINib(nibName: "MainStockSummaryCell", bundle: nil), forCellReuseIdentifier: "MainStockSummaryCell")
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorStyle = .none
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        nextUpdateView.mainLabel.text = DataStore.shared.currentPortfolio.nextUpdateTitle()
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 31
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    
        if indexPath.row == 13 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NextTwentyCell") as! NextTwentyCell
            return cell
        } else if indexPath.row > 9 && indexPath.row < 13 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainStockSummaryCell") as! MainStockSummaryCell
            if ready {
                cell.formatCellWithPortfolio(DataStore.shared.currentPortfolio, summaryType: summaryTypeForIndexPath(indexPath), isTodayReturn: isTodayReturn)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainStockCell") as! MainStockCell
            if ready {
                cell.formatCellWithStock(DataStore.shared.currentPortfolio.holdings[arrayIndexFromIndexPath(indexPath)], isOneDayReturn: isTodayReturn)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let clearView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        clearView.backgroundColor = UIColor.clear
        let toggleView = MainStocksSectionHeaderToggle()
        toggleView.delegate = self
        toggleView.formatView(todayChosen: isTodayReturn)
        toggleView.rightLabel.text = "SINCE " + DataStore.shared.currentPortfolio.startDateString()
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
        isTodayReturn = typeChosen == .today
        mainTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func arrayIndexFromIndexPath(_ indexPath: IndexPath) -> Int {
        return indexPath.row < 10 ? indexPath.row : indexPath.row - 4
    }
    
    func summaryTypeForIndexPath(_ indexPath: IndexPath) -> SummaryType {
        switch indexPath.row {
        case 10:
            return .average
        case 11:
            return .index
        case 12:
            return .plusMinus
        default:
            return .average

        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 31
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let clearView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        clearView.backgroundColor = UIColor.clear
        return clearView

    }
    
}

