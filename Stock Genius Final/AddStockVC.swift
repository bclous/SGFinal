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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var unableToConnectLabel: UILabel!
    @IBOutlet weak var unableToConnectButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatTableView()
        formatSearchController()
        formatHeaderView()

        if symbols.isEmpty {
            spinner.isHidden = false
            spinner.startAnimating()
            DataStore.shared.updateAvailableSymbols(completion: { (success) in
                if success {
                    self.symbols = DataStore.shared.availableSymbols
                    self.removeCurrentWatchlistStocksFromSymbols()
                    self.mainTableView.reloadData()
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                    self.mainTableView.isHidden = false
                } else {
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                    self.unableToConnectLabel.isHidden = false
                    self.unableToConnectButton.isHidden = false
                }
            })
        } else {
            mainTableView.reloadData()
            mainTableView.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        removeCurrentWatchlistStocksFromSymbols()
    }
    
    func removeCurrentWatchlistStocksFromSymbols() {
        let currentTickers = DataStore.shared.watchlistTickers()
        
        symbols = symbols.filter { (symbol) -> Bool in
            return !currentTickers.contains(symbol.ticker)
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
    
    @IBAction func tryAgainTapped(_ sender: Any) {
        unableToConnectLabel.isHidden = true
        unableToConnectButton.isHidden = true
        spinner.isHidden = false
        spinner.startAnimating()
        
        DataStore.shared.updateAvailableSymbols { (success) in
            if success {
                self.symbols = DataStore.shared.availableSymbols
                self.removeCurrentWatchlistStocksFromSymbols()
                self.mainTableView.reloadData()
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
                self.mainTableView.isHidden = false
            } else {
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
                self.unableToConnectLabel.isHidden = false
                self.unableToConnectButton.isHidden = false
            }
        }
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

        
        let tickerMatches = filteredSymbols.filter { (symbol) -> Bool in
            return symbol.ticker.lowercased() == searchText.lowercased()
        }
        
        let tickerPartialMatches = filteredSymbols.filter { (symbol) -> Bool in
            print("\(String(symbol.ticker.characters.prefix(searchText.characters.count)).lowercased())")
            print("\(searchText.lowercased())")
            return String(symbol.ticker.characters.prefix(searchText.characters.count)).lowercased() == searchText.lowercased()
 
        }
        
        let nameMatches = filteredSymbols.filter { (symbol) -> Bool in
            symbol.name.lowercased() == searchText.lowercased()
        }
        
        if !tickerPartialMatches.isEmpty {
           
            for idx in (0...tickerPartialMatches.count - 1).reversed() {
                let symbol = tickerPartialMatches[idx]
                let index = filteredSymbols.index(of: symbol)
                if let index = index {
                    filteredSymbols.remove(at: index)
                    filteredSymbols.insert(symbol, at: 0)
                }
            }
        }
        
        for symbol in nameMatches {
            let index = filteredSymbols.index(of: symbol)
            if let index = index {
                filteredSymbols.remove(at: index)
                filteredSymbols.insert(symbol, at: 0)
            }
        }
        
        for symbol in tickerMatches {
            let index = filteredSymbols.index(of: symbol)
            if let index = index {
                filteredSymbols.remove(at: index)
                filteredSymbols.insert(symbol, at: 0)
            }
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
