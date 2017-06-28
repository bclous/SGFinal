//
//  ViewController.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 6/27/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class CurrentPicksVC: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        formatTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CurrentPicksVC : UITableViewDelegate, UITableViewDataSource {
    
    func formatTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell")!
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let clearView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        clearView.backgroundColor = UIColor.clear
        let blackView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 30))
        blackView.backgroundColor = UIColor.black
        return section == 0 ? clearView : blackView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 50 : 50
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerView.adjustHeaderViewForOffset(scrollView.contentOffset.y)
        print("\(scrollView.contentOffset.y)")
    }
    
}

