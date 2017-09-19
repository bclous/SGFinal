//
//  RootVC.swift
//  Stock Genius
//
//  Created by Brian Clouser on 4/17/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

enum FunctionVC {
    case mainHoldings
    case pastHoldings
    case calculator
}

class RootVC: UIViewController  {

    @IBOutlet weak var splashView: SplashScreenView!
    @IBOutlet weak var masterScrollView: UIScrollView!
    @IBOutlet weak var pastHoldingsContainerView: UIView!
    @IBOutlet weak var mainHoldingsContainerView: UIView!
    @IBOutlet weak var calculatorContainerView: UIView!
    @IBOutlet weak var headerView: HeaderView!
    var chosenHolding : Holding?
 
    let mainHoldingsVC : MainHoldingsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainHoldingsVC") as! MainHoldingsVC
    let pastHoldingsVC : PastHoldingsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pastHoldingsVC") as! PastHoldingsVC
    let calculatorVC: CalculatorVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "calculatorVC") as! CalculatorVC

    var frameWidth : CGFloat = 375
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViewControllers()
        formatHeaderView()
        splashView.formatSplashScreen(loading: true)
        startIntialPull()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func loadViewControllers() {
        mainHoldingsVC.delegate = self
        constrainView(mainHoldingsVC.view, to: mainHoldingsContainerView)
        constrainView(pastHoldingsVC.view, to: pastHoldingsContainerView)
        constrainView(calculatorVC.view, to: calculatorContainerView)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! IndividualHoldingVC
        destinationVC.delegate = self
        destinationVC.holding = chosenHolding
    }
    
    func constrainView(_ view1: UIView, to view2: UIView) {
        view2.addSubview(view1)
        view1.translatesAutoresizingMaskIntoConstraints = false
        view1.leftAnchor.constraint(equalTo: view2.leftAnchor).isActive = true
        view1.rightAnchor.constraint(equalTo: view2.rightAnchor).isActive = true
        view1.topAnchor.constraint(equalTo: view2.topAnchor).isActive = true
        view1.bottomAnchor.constraint(equalTo: view2.bottomAnchor).isActive = true
    }
}

extension RootVC: MainHoldingsDelegate {
    
    func individualStockChosen(holding: Holding) {
        chosenHolding = holding
        performSegue(withIdentifier: "individualHoldingSegue", sender: self)
    }
    
    func adjustHeaderBorder(show: Bool) {
        headerView.bottomBorderView.isHidden = !show
    }
}

extension RootVC: SGDispatchDelegate {
    
    func startIntialPull() {
        SGDispatch.shared.delegate = self
        SGDispatch.shared.performInitialFireBasePull()
    }
    
    func readyToPresent(success: Bool) {
        mainHoldingsVC.holdings = SGDispatch.shared.holdingsInOrder()
        mainHoldingsVC.portfolio = SGDispatch.shared.currentPortfolio
        calculatorVC.holdings = SGDispatch.shared.holdingsInOrder()
        pastHoldingsVC.pastHoldings = SGDispatch.shared.pastPortfolios
        pastHoldingsVC.mainTableView.reloadData()
        mainHoldingsVC.mainTableView.reloadData()
        calculatorVC.createCalculatorHoldings()
        formatScrollView()
        
        UIView.animate(withDuration: 0.2) {
                self.splashView.alpha = 0
            }
    }
    
    func refreshComplete(success: Bool) {
        mainHoldingsVC.priceRefreshComplete(success: success)
    }
}

extension RootVC: IndividualHoldingsDelegate {
    
    func readyToReload() {
        mainHoldingsVC.mainTableView.reloadData()
    }
}

extension RootVC: UIScrollViewDelegate {
    
    func formatScrollView() {
        masterScrollView.delegate = self
        frameWidth = view.frame.width
        moveScrollViewTo(page: 2, animated: false)
    }
    
    func moveScrollViewTo(page: Int, animated: Bool) {
        let point = CGPoint(x: frameWidth * CGFloat((page - 1)), y: 0)
        masterScrollView.setContentOffset(point, animated: animated)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = masterScrollView.contentOffset.x
        print("\(offset)")
    }
    
}

extension RootVC : HeaderViewDelegate {
    
    func formatHeaderView() {
        headerView.delegate = self
    }
    func menuButtonTapped(sender: FunctionVC) {
        switch sender {
        case .mainHoldings:
            moveScrollViewTo(page: 2, animated: true)
        case .calculator:
            moveScrollViewTo(page: 3, animated: true)
        case .pastHoldings:
            moveScrollViewTo(page: 1, animated: true)
        }
    }
}
