//
//  WatchlistVC.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 9/27/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class WatchlistVC: UIViewController {

    @IBOutlet weak var headerView: HeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataStore.shared.updateWatchListPortfolioFromCoreData()

        headerView.formatHeaderViewForVC(.watchlist)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addStockButtonTapped(_ sender: Any) {
        
        let addStockVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addStockVC") as! AddStockVC
        addStockVC.delegate = self
        present(addStockVC, animated: false, completion: nil)
    }
    
}

extension WatchlistVC : AddStockVCDelegate {
    
    func dismissRequired(_ viewController: UIViewController) {
        viewController.dismiss(animated: false, completion: nil)
        print("\(DataStore.shared.watchlistPortfolio.holdings.count)")
    }
}
