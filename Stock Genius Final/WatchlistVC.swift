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

}
