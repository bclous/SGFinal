//
//  CalculatorVC.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/5/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class CalculatorVC: UIViewController, CalculatorInputDelegate, CalcHeaderViewDelegate {

    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var mainTableView: UITableView!
    let calcInputView = CalculatorInputView()
    var calcHiddenConstraint = NSLayoutConstraint()
    var calcShowingConstraint = NSLayoutConstraint()
    let headerHeight : CGFloat = 150
    var isCalculatorShowing = false
    var minimum = 15000
    let header = ShareCalcHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       headerView.formatHeaderViewForVC(.calculator)
        formatTableView()
        formatCalcInputView()
        view.backgroundColor = SGConstants.mainBlackColor
        let minimum = DataStore.shared.currentPortfolio.minimumInvestmentForCalculator()
        let originalAmount = max(minimum, 15000.0)
        DataStore.shared.currentPortfolio.updateCalculatorValues(portfolioAmount: Int(originalAmount))
        header.formatViewWithInvestmentAmount(Int(originalAmount), minimum: Int(minimum))
        mainTableView.reloadData()
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isCalculatorShowing {
            header.resetToCachedPortfolioAmount()
            // calc to cachedAmout
            adjustCalcInputView(show: false, animated: false)
        }
    }
    
    func formatCalcInputView() {
        calcInputView.delegate = self
        view.addSubview(calcInputView)
        calcInputView.translatesAutoresizingMaskIntoConstraints = false
        calcInputView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        calcInputView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        calcHiddenConstraint = calcInputView.topAnchor.constraint(equalTo: view.bottomAnchor)
        calcShowingConstraint = calcInputView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -49)
        calcInputView.heightAnchor.constraint(equalToConstant: calculatorHeight()).isActive = true
        adjustCalcInputView(show: false, animated: false)
    }
    
    func userTapped() {
        adjustCalcInputView(show: !isCalculatorShowing, animated: true)
        header.resetView()
        calcInputView.formatCalculator(readyToCalculate: header.isReadyToCalculate())
    }
    
    func numberTapped(_ number: Int) {
        header.formatViewWithNumber(number)
        calcInputView.formatCalculator(readyToCalculate: header.isReadyToCalculate())
    }
    
    func clearTapped() {
        header.resetView()
        calcInputView.formatCalculator(readyToCalculate: header.isReadyToCalculate())
    }
    
    func calculateTapped() {
        header.cacheNewPortfolioAmount()
        DataStore.shared.currentPortfolio.updateCalculatorValues(portfolioAmount: header.currentPortfolioAmount)
        mainTableView.reloadData()
        adjustCalcInputView(show: false, animated: true)
    }
    
    func calculatorHeight() -> CGFloat {
        return view.frame.height - (headerHeight + 30) - 38
    }
    
    func adjustCalcInputView(show: Bool, animated: Bool) {
        
        let point = CGPoint(x: 0, y: show ? 60 : 0)
        mainTableView.setContentOffset(point, animated: animated)
        
        calcHiddenConstraint.isActive = false
        calcShowingConstraint.isActive = false
        calcHiddenConstraint.isActive = !show
        calcShowingConstraint.isActive = show
        
        let duration = animated ? 0.3 : 0
        view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: duration, animations: { 
            self.view.layoutIfNeeded()
        }) { (complete) in
            self.view.isUserInteractionEnabled = true
            self.isCalculatorShowing = show
            self.header.headerButton.isEnabled = !show
        }
    }
}



extension CalculatorVC : UITableViewDelegate, UITableViewDataSource {
    
    func formatTableView() {
        mainTableView.register(UINib(nibName: "ShareCalcCell", bundle: nil), forCellReuseIdentifier: "shareCalcCell")
        mainTableView.register(UINib(nibName: "RemainingCashCell", bundle: nil), forCellReuseIdentifier: "RemainingCashCell")
        mainTableView.register(UINib(nibName: "DisclosureCell", bundle: nil), forCellReuseIdentifier: "DisclosureCell")
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorStyle = .none
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : DataStore.shared.currentPortfolio.calcStocks.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            
            if indexPath.row == 10 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RemainingCashCell") as! RemainingCashCell
                cell.formatCellWithRemainingCash(DataStore.shared.currentPortfolio.remainingCash)
                return cell
            } else if indexPath.row == 11 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DisclosureCell") as! DisclosureCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "shareCalcCell") as! ShareCalcCell
                cell.formatCellWithCalcStock(DataStore.shared.currentPortfolio.calcStocks[indexPath.row])
                return cell
            }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let clearView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        clearView.backgroundColor = UIColor.clear
        header.delegate = self
        return section == 0 ? clearView : header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 60 : headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 11 ? 180 : 40
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerView.adjustHeaderViewForOffset(scrollView.contentOffset.y)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}






