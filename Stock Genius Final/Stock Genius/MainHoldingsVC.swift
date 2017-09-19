//
//  MainHoldingsVC.swift
//  Stock Genius
//
//  Created by Brian Clouser on 4/17/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

protocol MainHoldingsDelegate : class {
    func individualStockChosen(holding: Holding)
    func adjustHeaderBorder(show: Bool)
}


class MainHoldingsVC: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var bubbleView: MainHoldingsHeaderBubbleView!
    @IBOutlet weak var bubbleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bubbleViewTopConstraint: NSLayoutConstraint!
    
    var holdings : [Holding]?
    var portfolio : Portfolio?
    var isTodayShown = true
    var priceRefreshInProgress = false
    weak var delegate : MainHoldingsDelegate?
    var showBorder = false
    var borderCurrentlyShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatTableView()
        formatBubbleView()
    }
    
    func formatBubbleView() {
        bubbleView.resetFrame(height: 140, width: view.frame.width)
        bubbleView.createBubbles()
        bubbleView.animateBubbles()
        
    }
    
    func refreshPrices() {
        priceRefreshInProgress = true
        //bubbleView.resetFrame(height: 240, width: view.frame.width)
        bubbleView.fastMode = true
        bubbleView.spinner.startAnimating()
        bubbleView.animateBubbles()
        mainTableView.reloadData()
        SGDispatch.shared.refreshPrices()
    }
    
    func priceRefreshComplete(success: Bool) {
        priceRefreshInProgress = false
        bubbleView.spinner.stopAnimating()
        bubbleViewTopConstraint.constant = -72
        bubbleView.fastMode = false
        view.layoutIfNeeded()
        mainTableView.reloadData()
    }

}

extension MainHoldingsVC: UITableViewDelegate, UITableViewDataSource, SectionHeaderDelegate, UIScrollViewDelegate {
    
    func formatTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorStyle = .none
        mainTableView.register(UINib(nibName: "StockHoldingTableViewCell", bundle: nil), forCellReuseIdentifier: "stockCell")
        mainTableView.register(UINib(nibName: "StockHoldingTableCell2", bundle: nil), forCellReuseIdentifier: "stockCell2")
        mainTableView.register(UINib(nibName: "SummaryTableViewCell", bundle: nil), forCellReuseIdentifier: "summaryCell")
        mainTableView.register(UINib(nibName: "OtherStocksTableViewCell", bundle: nil), forCellReuseIdentifier: "otherStocksCell")
        let refreshControl = UIRefreshControl()
        mainTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshRequested), for: .valueChanged)

        
    }
    
    func refreshRequested() {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if (indexPath.row != 10 && indexPath.row != 11) {
            if let holdings = holdings {
                let holding = indexPath.row <= 9 ? holdings[indexPath.row] : holdings[indexPath.row - 2]
                self.delegate?.individualStockChosen(holding: holding)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row <= 9 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell2") as! StockHoldingCell2
            
            if let stocks = holdings {
                cell.stock = stocks[indexPath.row]
                cell.isTodayReturn = isTodayShown
                cell.formatCell()
            }
            return cell
        } else if indexPath.row == 10 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell") as! SummaryTableViewCell
            if let port = portfolio {
                cell.portfolio = port
                cell.isCurrent = true
                cell.isToday = isTodayShown
                cell.formatCell()
            }
            
            return cell
        } else if indexPath.row == 11 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "otherStocksCell") as! OtherStocksTableViewCell
            cell.formatCell()
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell2") as! StockHoldingCell2
            
            if let stocks = holdings {
                cell.stock = stocks[indexPath.row - 2]
                cell.isTodayReturn = isTodayShown
                cell.formatCell()
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 32
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 10 ? 120 : 60
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let headerHeight : CGFloat = priceRefreshInProgress ? 212 : 140
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: headerHeight))
            headerView.backgroundColor = UIColor.clear
            return headerView
        } else {
            let sectionView = SectionHeaderView()
            sectionView.delegate = self
            sectionView.adjustButtonColors(today: isTodayShown)
            sectionView.showBorderView = showBorder
            sectionView.adjustBorderView()
            
            if let date = portfolio?.startDate {
                sectionView.setSinceDate(date: date)
                bubbleView.currentPicksIdentifiedLabel.text = "Identified on \(date) from 13-F Data"
            }
        
            return sectionView
        }
    }
    
    func sectionHeaderButtonTapped(today: Bool) {
        isTodayShown = today
        mainTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row == 10 || indexPath.row == 11 ? false : true
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let bubbleHeaderHeight : CGFloat = priceRefreshInProgress ? 212 : 140
        return section == 0 ? bubbleHeaderHeight : 60
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("\(scrollView.contentOffset.y)")
        
        adjustHeadersForOffset(scrollView.contentOffset.y)
        
        if scrollView.contentOffset.y < 0 && !priceRefreshInProgress {
            bubbleViewTopConstraint.constant = -72 - scrollView.contentOffset.y
        } else if priceRefreshInProgress {
            bubbleViewTopConstraint.constant = 0
        } else {
            bubbleViewTopConstraint.constant = -72
        }
        
        if scrollView.contentOffset.y < 0 && priceRefreshInProgress {
            bubbleViewHeight.constant = 212 - scrollView.contentOffset.y
        } else {
            bubbleViewHeight.constant = 212
        }
        
        if scrollView.contentOffset.y < -72 && !priceRefreshInProgress {
            refreshPrices()
        }
        
        view.layoutIfNeeded()
        
    }
    
    func adjustHeadersForOffset(_ offset: CGFloat) {
        
        if offset >= 140 && !borderCurrentlyShown {
            delegate?.adjustHeaderBorder(show: false)
            showBorder = true
            borderCurrentlyShown = true
            mainTableView.reloadData()
        } else if offset < 140 && borderCurrentlyShown {
            delegate?.adjustHeaderBorder(show: true)
            showBorder = false
            borderCurrentlyShown = false
            mainTableView.reloadData()
        }
    }
    
    
}
