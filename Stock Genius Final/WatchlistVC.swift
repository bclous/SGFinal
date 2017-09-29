//
//  WatchlistVC.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 9/27/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class WatchlistVC: UIViewController , SectionHeaderClearViewDelegate {

   
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    
    let sectionHeaderClearView : SectionHeaderClearView = SectionHeaderClearView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataStore.shared.updateWatchListPortfolioFromCoreData()
        headerView.formatHeaderViewForVC(.watchlist)
        formatTableView()
        formatSectionHeaderClearView()
        view.backgroundColor = SGConstants.mainBlackColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updatePrices()
    }
    
    public func updatePrices() {
        DataStore.shared.watchlistPortfolio.updatePrices { (success) in
            self.mainTableView.reloadData()
        }
    }
    
    func sectionHeaderButtonTapped(_ button: SectionHeaderButton) {
        let addStockVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addStockVC") as! AddStockVC
        addStockVC.delegate = self
        present(addStockVC, animated: false, completion: nil)
    }
    
    func formatSectionHeaderClearView() {
        sectionHeaderClearView.delegate = self
        sectionHeaderClearView.leftButton.isEnabled = false
        sectionHeaderClearView.rightButton.isEnabled = true
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

extension WatchlistVC: HeaderViewDelegate {
    
    func refreshButtonTapped() {
        let addStockVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addStockVC") as! AddStockVC
        addStockVC.delegate = self
        present(addStockVC, animated: true, completion: nil)
    }
    
}

extension WatchlistVC : UITableViewDelegate, UITableViewDataSource {
    
    func formatTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UINib(nibName: "MainStockCell", bundle: nil), forCellReuseIdentifier: "mainStockCell")
        mainTableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainStockCell") as! MainStockCell
        let stock = DataStore.shared.watchlistPortfolio.holdings[indexPath.row]
        cell.formatCellWithStock(stock, isOneDayReturn: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStore.shared.watchlistPortfolio.holdings.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionHeaderClearView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerView.adjustHeaderViewForOffset(scrollView.contentOffset.y)
        sectionHeaderClearView.rightButton.isEnabled = scrollView.contentOffset.y <= 0
    }

}

extension WatchlistVC : AddStockVCDelegate {
    
    func dismissRequired(_ viewController: UIViewController) {
        updatePrices()
        viewController.dismiss(animated: true, completion: nil)
    }
}
