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
    
    var isInEditMode : Bool = false
    var indexEditInInProgress = 0
    var editType : EditType = .deleting
    
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
        self.mainTableView.reloadData()
        self.mainTableView.layoutIfNeeded()
        DataStore.shared.watchlistPortfolio.updatePrices { (success) in
            self.mainTableView.reloadData()
        }
    }
    
    func sectionHeaderButtonTapped(_ button: SectionHeaderButton) {
        let addStockVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addStockVC") as! AddStockVC
        addStockVC.delegate = self
        view.isUserInteractionEnabled = false
        present(addStockVC, animated: true) {
            self.view.isUserInteractionEnabled = true
        }
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
        mainTableView.register(UINib(nibName: "WatchlistCell", bundle: nil), forCellReuseIdentifier: "watchlistCell")
        mainTableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "watchlistCell") as! WatchlistCell
        let stock = DataStore.shared.watchlistPortfolio.holdings[indexPath.row]
        cell.delegate = self
        
        if isInEditMode {
            let activeEditCellState : WatchListCellState = editType == .deleting ? .editingActiveForDelete : .editingActiveForReorder
            let cellState = indexPath.row == indexEditInInProgress ? activeEditCellState : .editingInactive
            cell.formatCellWithStock(stock, index: indexPath.row, cellState: cellState)
        } else {
            cell.formatCellWithStock(stock, index: indexPath.row, cellState: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return !isInEditMode
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
    }

}

extension WatchlistVC : WatchListCellDelegate {
    
    func editingRequestedAtIndex(_ index: Int, editType: EditType) {
        isInEditMode = true
        indexEditInInProgress = index
        self.editType = editType
        mainTableView.reloadData()
    }
    
    func editingComplete() {
        if isInEditMode {
            isInEditMode = false
            mainTableView.reloadData()
        }
    }
    
    func reorderRequested(isUp: Bool, index: Int) {
        let newIndex = isUp ? index - 1 : index + 1
        let min = 0
        let max = DataStore.shared.watchlistPortfolio.holdings.count - 1
        
        if newIndex >= min && newIndex <= max {
            DataStore.shared.watchlistPortfolio.switchStockOrderAtIndex(index, withIndex: newIndex)
            indexEditInInProgress = newIndex

            view.isUserInteractionEnabled = false
            UIView.transition(with: mainTableView, duration: 2.0, options: .curveEaseIn, animations: {
                self.mainTableView.reloadData()
            }, completion: { (success) in
                self.view.isUserInteractionEnabled = true
            })
        }
            
    }
    
    func deleteRequestedAtIndex(_ index: Int) {
        DataStore.shared.watchlistPortfolio.removeStockFromIndex(index)
        isInEditMode = false
        var indexSet = IndexSet([0])
        mainTableView.reloadData()
        mainTableView.layoutIfNeeded()
        
        
        
//        UIView.transition(with: mainTableView, duration: 2.0, options: .curveEaseIn, animations: {
//            self.mainTableView.reloadData()
//        }, completion: { (success) in
//            self.view.isUserInteractionEnabled = true
//        })
    }
}

extension WatchlistVC : AddStockVCDelegate {
    
    func dismissRequired(_ viewController: UIViewController) {
        updatePrices()
        viewController.dismiss(animated: true, completion: nil)
    }
}
