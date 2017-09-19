//
//  PastHoldingsVC.swift
//  Stock Genius
//
//  Created by Brian Clouser on 4/17/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class PastHoldingsVC: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    var pastHoldings : [Portfolio]?
    var readyToLayOut = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatTableView()
        readyToLayOut = true
    }
}

extension PastHoldingsVC: UITableViewDelegate, UITableViewDataSource {
    
    func formatTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorStyle = .none
        mainTableView.register(UINib(nibName: "PastHoldingTableViewCell", bundle: nil), forCellReuseIdentifier: "pastHoldingsCell")
             mainTableView.register(UINib(nibName: "SummaryTableViewCell", bundle: nil), forCellReuseIdentifier: "summaryCell")
        mainTableView.backgroundColor = UIColor.clear
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if indexPath.row == 10 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell") as! SummaryTableViewCell
            if let portfolios = pastHoldings {
                let portfolio = portfolios[indexPath.section - 1]
                cell.portfolio = portfolio
                cell.isCurrent = false
                cell.formatCell()
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "pastHoldingsCell", for: indexPath) as! PastHoldingTableViewCell
            
            if let portfolios = pastHoldings {
                let portfolio = portfolios[indexPath.section - 1]
                let holdings = CDClient.holdingsInOrderFrom(portfolio)
                let holding = holdings[indexPath.row]
                cell.holding = holding
                cell.formatCell()
                return cell
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 11
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let holdings = pastHoldings {
            return holdings.count + 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 10 ? 100 : 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = PastPerformanceGraphView()
            if readyToLayOut {
                //headerView.adjustGraph(toFullAmount: true, animated: true)
            }
            return headerView
        }
        
        let headerView = PastHoldingsHeaderView()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 180 : 60
    }
    
   func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}
