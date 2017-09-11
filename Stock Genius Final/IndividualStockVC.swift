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
    let toggleView = IndividualToggleView()
    let performanceView = IndividualPerformanceView()
    var isTodayReturn = true
    var timePeriod : IndividualSegmentType = .sixMonths
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatTableView()
        formatHeaderView()
        formatToggleView()
    }
    
    func formatHeaderView() {
        headerView.delegate = self
        if let stock = stock {
            headerView.formatHeaderViewWithStock(stock)
        }
    }
    
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

}

extension IndividualStockVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func formatTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UINib(nibName: "GraphTableViewCell", bundle: nil), forCellReuseIdentifier: "graphCell")
        mainTableView.register(UINib(nibName: "NewsItemCell", bundle: nil), forCellReuseIdentifier: "newsCell")
        mainTableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "graphCell") as! GraphTableViewCell
            cell.formatChartCell(stock: stock!, timePeriod: timePeriod)
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! NewsItemCell
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
            return 1
        case 2:
            return 0
        case 3:
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
            return 100
        case 1:
            return 150
        case 2:
            return 100
        case 3:
            return 150
        default:
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 60
        case 1:
            return 85
        case 2:
            return 85
        case 3:
            return 50
        default:
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            view.backgroundColor = UIColor.clear
            view.isUserInteractionEnabled = false
            return view
        } else if section == 1 {
            return toggleView
        } else if section == 2 {
            return performanceView
        } else {
            return NewsSectionHeaderView()
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerView.adjustIndividualHeaderViewForOffset(scrollView.contentOffset.y)
        print("\(scrollView.contentOffset.y)")
        
    }
    
    
}

extension IndividualStockVC : IndividualToggleViewDelegate {
    
    func formatToggleView() {
        toggleView.delegate = self
    }
    
    func toggleChosen(type: IndividualSegmentType) {
        timePeriod = type
    }
    
}
