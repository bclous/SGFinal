//
//  IndividualStockVC.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 8/28/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class IndividualStockVC: UIViewController, IndividualHeaderViewDelegate {
    
    var stock : CurrentStock?
    
    @IBOutlet weak var headerView: IndividualHeaderView!
    @IBOutlet weak var mainTableView: UITableView!
    var isTodayReturn = true
    var timePeriod : IndividualSegmentType = .sinceStartDate
    let performanceView = BDCStockPerformanceView()
    let sectionClearView = SectionHeaderClearView()
    var chosenNewsItem : NewsItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatTableView()
        formatHeaderView()
        formatPerformanceView()
        view.backgroundColor = SGConstants.mainBlackColor
    }
    
    func formatHeaderView() {
        headerView.delegate = self
        if let stock = stock {
            headerView.formatHeaderViewWithStock(stock)
            AlphaVantageClient.shared.pullNewsForStock(stock, numberOfArticles: 5, completion: { (success) in
                self.mainTableView.reloadData()
            })
        }
        
    }
    
    func formatPerformanceView() {
        
        if let stock = stock {
            performanceView.stocks = (stock: stock, index: DataStore.shared.currentPortfolio.index)
            performanceView.formatView()
        }
 
    }
    
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! WebBrowserVC
        destinationVC.ticker = stock!.ticker
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
        mainTableView.separatorStyle = .none
        mainTableView.estimatedRowHeight = 150.0
        mainTableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! NewsItemCell
            cell.formatCellWithNewsItem(stock!.newsItems[indexPath.row])
            return cell
        } else {
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            return 0
        case 2:
            if let stock = stock {
                return stock.newsItems.count
            } else {
                return 0
            }
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
        case 2:
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
            return 370
        case 2:
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
        } else  {
            return NewsSectionHeaderView()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerView.adjustIndividualHeaderViewForOffset(scrollView.contentOffset.y)
    }
    
    func sectionHeaderButtonTapped(_ button: SectionHeaderButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenNewsItem = stock!.newsItems[indexPath.row]
        performSegue(withIdentifier: "newsSegue", sender: nil)
    }
    
    
    
}
