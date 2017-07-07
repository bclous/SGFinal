//
//  PastPicksVC.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/5/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class PastPicksVC: UIViewController {

    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.formatHeaderViewForVC(.pastPicks)
        view.backgroundColor = SGConstants.mainBlackColor
        formatTableView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func readyToPresent() {
        mainTableView.reloadData()
        headerView.secondaryLabel.text = DataStore.shared.pastPortfoliosString()
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

extension PastPicksVC : UITableViewDelegate, UITableViewDataSource {
    
    func formatTableView() {
        mainTableView.register(UINib(nibName: "PastPicksStockCell", bundle: nil), forCellReuseIdentifier: "PastPicksStockCell")
        mainTableView.register(UINib(nibName: "PastPicksNoteCell", bundle: nil), forCellReuseIdentifier: "PastPicksNoteCell")
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorStyle = .none
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DataStore.shared.pastPortfolios.count + 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section < 2 {
            return 0
        } else {
            let portfolio = DataStore.shared.pastPortfolios[section - 2]
            return portfolio.numberOfRowsForPastPortfolio()
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let portfolio = DataStore.shared.pastPortfolios[indexPath.section - 2]

        if indexPath.row < 10 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PastPicksStockCell") as! PastPicksStockCell
            let stock = portfolio.holdings[indexPath.row]
            cell.formatCellWithPastStock(stock)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PastPicksNoteCell") as! PastPicksNoteCell
            let notes = portfolio.notesForPastPortfolio()
            cell.noteLabel.text = notes[indexPath.row - 10]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let clearView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        clearView.backgroundColor = UIColor.clear
        
        
        if section == 0 {
            return clearView
        } else if section == 1 {
            let performanceView = PastPicksPerformanceView()
            return performanceView
        } else {
            let quarterSummary = PastPicksSectionHeaderView()
            let portfolio = DataStore.shared.pastPortfolios[section - 2]
            quarterSummary.formatViewWithPortfolio(portfolio)
            return quarterSummary
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 60
        } else {
            return section == 1 ? 120 : 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row < 10 ? 52 : 30
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerView.adjustHeaderViewForOffset(scrollView.contentOffset.y)
        print("\(scrollView.contentOffset.y)")
    
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section >= 2 ? 30 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let clearView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        clearView.backgroundColor = UIColor.clear
        return clearView
    }
    
}
