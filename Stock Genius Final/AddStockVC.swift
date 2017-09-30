//
//  AddStockVC.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 9/28/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

protocol AddStockVCDelegate :  class {
    func dismissRequired(_ viewController: UIViewController)
}

class AddStockVC: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    weak var delegate : AddStockVCDelegate?
    let searchController = UISearchController(searchResultsController: nil)
    var symbols = DataStore.shared.availableSymbols
    var filteredSymbols : [SymbolResult] = []
    var frame : CGRect = CGRect()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatTableView()
        formatSearchController()
        formatHeaderView()

        if symbols.isEmpty {
            DataStore.shared.updateAvailableSymbols(completion: { (success) in
                self.symbols = DataStore.shared.availableSymbols
                self.mainTableView.reloadData()
            })
        }
    }
    
    func dismissVC() {
        delegate?.dismissRequired(self)
    }
    
    func formatHeaderView() {
        headerView.backgroundColor = SGConstants.mainBlackColor
        
    }

    @IBAction func cancelTapped(_ sender: Any) {
        delegate?.dismissRequired(self)
    }
    
}

extension AddStockVC : UISearchResultsUpdating {
    
    func formatSearchController() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        mainTableView.tableHeaderView = searchController.searchBar
        frame = searchController.searchBar.frame
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        
        filteredSymbols = symbols.filter { (symbol) -> Bool in
            return symbol.ticker.lowercased().contains(searchText.lowercased()) || symbol.name.lowercased().contains(searchText.lowercased())
        }
        
        mainTableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

extension AddStockVC : UITableViewDelegate, UITableViewDataSource {
    
    func formatTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UINib(nibName: "AddStockCell", bundle: nil), forCellReuseIdentifier: "stockCell")
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let symbolArray = isFiltering() ? filteredSymbols : symbols
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell") as! AddStockCell
        cell.formatCellWithSymbolResult(symbolArray[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() ? filteredSymbols.count : symbols.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.frame = frame
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let symbolArray = isFiltering() ? filteredSymbols : symbols
        let result = symbolArray[indexPath.row]
        DataStore.shared.watchlistPortfolio.addStockToWatchListFromSymbolResult(result)
        searchController.dismiss(animated: false, completion: nil)
        dismissVC()
    }
    

}