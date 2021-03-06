//
//  IndividualStockVC.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 8/28/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit
import SafariServices

class IndividualStockVC: UIViewController, IndividualHeaderViewDelegate {
    
    var stock : CurrentStock = CurrentStock()
    @IBOutlet weak var headerView: IndividualHeaderView!
    @IBOutlet weak var mainTableView: UITableView!
    var isTodayReturn = true
    var timePeriod : IndividualSegmentType = .sinceStartDate
    let performanceView = BDCStockPerformanceView()
    let sectionClearView = SectionHeaderClearView()
    var chosenNewsItem : NewsItem?
    let pictureVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pictureVC") as! PictureVC

    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatTableView()
        formatHeaderView()
        updateNewsSection()
        updateMessagesSection()
        updateGraphSection()
        pictureVC.delegate = self
        view.backgroundColor = SGConstants.mainBlackColor
    }
    
    func formatHeaderView() {
        headerView.delegate = self
        headerView.formatHeaderViewWithStock(stock)
    }
    
    func updateNewsSection() {
        if stock.newsItems.isEmpty {
            stock.pullNewsData(numberOfArticles: 50, completion: { (success) in
                self.mainTableView.reloadData()
            })
        }
    }
    
    func updateMessagesSection() {
        stock.pullStockTwitsMessages { (success) in
            self.mainTableView.reloadData()
        }
    }
    
    func updateGraphSection() {
        let mainPicksToggle : IndividualSegmentType = isTodayReturn ? .today : .sinceStartDate
        let originalToggle = stock.lastToggleSegment ?? mainPicksToggle
        performanceView.formatGraphForStock(stock, durationType: originalToggle)
    }
    
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! WebBrowserVC
        destinationVC.ticker = stock.ticker
        destinationVC.newsItem = chosenNewsItem
        mainTableView.reloadData()
    }

}

extension IndividualStockVC: UITableViewDelegate, UITableViewDataSource, SectionHeaderClearViewDelegate {
    
    
    func formatTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UINib(nibName: "NewsItemCell", bundle: nil), forCellReuseIdentifier: "newsCell")
        mainTableView.register(UINib(nibName: "GraphTableViewCell", bundle: nil), forCellReuseIdentifier: "graphCell")
        mainTableView.register(UINib(nibName: "STMessageCell", bundle: nil), forCellReuseIdentifier: "messageCell")
        mainTableView.separatorStyle = .none
        mainTableView.estimatedRowHeight = 400.0
        mainTableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! NewsItemCell
            cell.formatCellWithNewsItem(stock.newsItems[indexPath.row])
            return cell
        } else if indexPath.section == 3 {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "messageCell") as! STMessageCell
            cell.formatCellWithMessage(stock.stockTwitsMessagesInOrder(mostRecentFirst: true)[indexPath.row], cellWidth: view.frame.width)
            cell.delegate = self
            return cell
        } else {
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            return 0
        case 2:
            return min(stock.newsItems.count,5)
        case 3:
            return stock.stockTwitsMessages.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 0
        case 1:
            return 0
        case 2,3:
            return UITableViewAutomaticDimension
        default:
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 60
        case 1:
            return 285
        case 2,3:
            return 40
        default:
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = sectionClearView
            view.delegate = self
            view.formatForIndividualStock()
            return view
        } else if section == 1{
            return performanceView
        } else if section == 2 {
            return NewsSectionHeaderView()
        } else {
            let header = NewsSectionHeaderView()
            header.headerLabel.text = "Recent Chatter"
            header.secondaryLabel.text = "StockTwits"
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let clearView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        clearView.backgroundColor = UIColor.clear
        return clearView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 30
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 2 {
            return true
        } else if indexPath.section == 3 {
            let message = stock.stockTwitsMessagesInOrder(mostRecentFirst: true)[indexPath.row]
            let url = message.firstLinkAddress()
            if let _ = url {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerView.adjustIndividualHeaderViewForOffset(scrollView.contentOffset.y)
    }
    
    func sectionHeaderButtonTapped(_ button: SectionHeaderButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            chosenNewsItem = stock.newsItems[indexPath.row]
            if let news = chosenNewsItem {
                let url = URL(string: news.articleURL)
                if let url = url {
                    let svc = SFSafariViewController(url: url)
                    present(svc, animated: true, completion: {
                        self.mainTableView.reloadData()
                    })
                }
                
            }

        } else if indexPath.section == 3 {
            
            let message = stock.stockTwitsMessagesInOrder(mostRecentFirst: true)[indexPath.row]
            let urlString = message.firstLinkAddress()
            
            if let urlString = urlString {
                let url = URL(string: urlString)
                if let url = url {
                    let svc = SFSafariViewController(url: url)
                    present(svc, animated: true, completion: {
                        self.mainTableView.reloadData()
                    })
                }
            }
        }
        
    }
    
}

extension IndividualStockVC : STMessageCellDelegate, PictureVCDelegate {
    
    func pictureTapped(message: STMessage) {
        pictureVC.message = message
        present(pictureVC, animated: false, completion: nil)
    }
    
    func screenTapped() {
        pictureVC.dismiss(animated: false, completion: nil)
    }
    
}

