//
//  PastPicksVC.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/5/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class PastPicksVC: UIViewController {

    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.formatHeaderViewForVC(.pastPicks)
        view.backgroundColor = SGConstants.mainBlackColor
        formatTableView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension PastPicksVC : UITableViewDelegate, UITableViewDataSource {
    
    func formatTableView() {
        mainTableView.register(UINib(nibName: "PastPicksStockCell", bundle: nil), forCellReuseIdentifier: "PastPicksStockCell")
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorStyle = .none
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section < 2 ? 0 : 13
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PastPicksStockCell") as! PastPicksStockCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let clearView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        clearView.backgroundColor = UIColor.clear
        let performanceView = PastPicksPerformanceView()
        let quarterSummary = PastPicksSectionHeaderView()
        if section == 0 {
            return clearView
        } else {
            return section == 1 ? performanceView : quarterSummary
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 60
        } else {
            return section == 1 ? 120 : 40
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerView.adjustHeaderViewForOffset(scrollView.contentOffset.y)
        print("\(scrollView.contentOffset.y)")
        //        if scrollView.contentOffset.y < 0 {
        //            let home = CGPoint(x: 0, y: 0)
        //            scrollView.setContentOffset(home, animated: false)
        //        }
    }
    
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}
