//
//  IndividualHoldingVC.swift
//  Stock Genius
//
//  Created by Brian Clouser on 4/17/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

protocol IndividualHoldingsDelegate : class {
    func readyToReload()
}

class IndividualHoldingVC: UIViewController, WebBrowserViewControllerDelegate {
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var headerViewTitleLabel: UILabel!
    weak var delegate : IndividualHoldingsDelegate?
    var holding : Holding?
    var newsItems : [NewsItem] = []
    var chosenNewsItem : NewsItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SGConstants.offBlackColor

      
        if let holding = holding {
            formatViewForHolding(holding)
            newsItems = CDClient.newsItemsInOrderFromHolding(holding)
            mainTableView.reloadData()
        }
        
        formatTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
         delegate?.readyToReload()
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        delegate?.readyToReload()
        navigationController?.popToRootViewController(animated: true)
    }
    
    func formatViewForHolding(_ holding: Holding) {
        headerViewTitleLabel.text = holding.ticker
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! WebBrowserVC
        destinationVC.newsItem = chosenNewsItem
        destinationVC.delegate = self
        destinationVC.ticker = holding?.ticker
    }
    
    func readyToReload() {
        mainTableView.reloadData()
    }

    
}

extension IndividualHoldingVC: UITableViewDelegate, UITableViewDataSource {
    
    func formatTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! NewsItemTableViewCell
        cell.newsItem = newsItems[indexPath.row]
        cell.formatCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        chosenNewsItem = newsItems[indexPath.row]
        performSegue(withIdentifier: "newsItemSegue", sender: self)
        
    }
}


