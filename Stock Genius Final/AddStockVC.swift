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

    @IBOutlet weak var mainTableView: UITableView!
    weak var delegate : AddStockVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatTableView()

        if DataStore.shared.availableSymbols.isEmpty {
            DataStore.shared.updateAvailableSymbols(completion: { (success) in
                self.mainTableView.reloadData()
            })
        }
    }
    
    func dismissVC() {
        delegate?.dismissRequired(self)
    }


}

extension AddStockVC : UITableViewDelegate, UITableViewDataSource {
    
    func formatTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UINib(nibName: "AddStockCell", bundle: nil), forCellReuseIdentifier: "stockCell")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell") as! AddStockCell
        cell.formatCellWithSymbolResult(DataStore.shared.availableSymbols[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStore.shared.availableSymbols.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = DataStore.shared.availableSymbols[indexPath.row]
        DataStore.shared.watchlistPortfolio.addStockToWatchListFromSymbolResult(result)
        dismissVC()
    }
    

}
