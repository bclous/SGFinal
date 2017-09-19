//
//  CalculatorVC.swift
//  Stock Genius
//
//  Created by Brian Clouser on 4/17/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class CalculatorVC: UIViewController {
    
    @IBOutlet weak var masterStackView: UIStackView!
    var isCalculatorDisplayed = true
    let calculatorInputView = CalculatorInputView()
    var bottomToBottomConstraint = NSLayoutConstraint()
    var topToBottomConstraint = NSLayoutConstraint()
    var topToHeaderConstraint = NSLayoutConstraint()
    var heightConstraint = NSLayoutConstraint()
    var holdings : [Holding]?
    var calculatorHoldings: [CalculatorHolding] = []
    var resetMode = false
    let numberFormatter = NumberFormatter()
    
    @IBOutlet weak var tapEditLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var minimumLabel: UILabel!
    @IBOutlet weak var cashRemainingLabel: UILabel!
    
    @IBOutlet var headerBackgroundViews: [UIView]!
    var numberInt: Int = 0
    var numberString: String = "$ 0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatCalculator()
        formatHeaderView()
        view.backgroundColor = SGConstants.offBlackColor
    }
    
    // create called by rootVC when holdings have been created
    
    func createCalculatorHoldings() {
        var index = 0
        if let currentHoldings = holdings {
            for holding in currentHoldings {
                if index < 10 {
                    let newCalcHolding = CalculatorHolding()
                    newCalcHolding.holding = holding
                    newCalcHolding.updateDollarPrice()
                    calculatorHoldings.append(newCalcHolding)
                    let outputView = masterStackView.arrangedSubviews[index] as! CalculatorOutputView
                    outputView.calculatorHolding = newCalcHolding
                    index += 1
                }
            }
        }
        updateOutputs()
        formatCalculatorForInvestmentAmount(originalInvestment())
    }
    
    // header view functions
    
    func formatHeaderView() {
        for view in headerBackgroundViews {
            view.backgroundColor = SGConstants.mainBlueColor
        }
        minimumLabel.isHidden = true
    }

    @IBAction func headerViewTapped(_ sender: Any) {
        
        if !isCalculatorDisplayed {
            adjustCalculatorView(show: true, animate: true)
            resetMode = true
        }
        
        tapEditLabel.isHidden = true
    }
    
    // calculator functions - probably should get these out of the VC at some point to clean up

    func updateCalcultor() {
        resetCalculator()
        addBaseShareAmounts()
        //addShareToAnyThatCanTakeIt()
        updateOutputs()
    }
    
    func resetCalculator() {
        for holding in calculatorHoldings {
            holding.resetShares()
        }
        
        calculatorHoldings.sort(by: {$0.dollarPx < $1.dollarPx})
    }
    
    func addBaseShareAmounts() {
        let amountPerStock = totalInvestmentPerHolding()
        
        for holding in calculatorHoldings {
            holding.addSharesFor(amount: amountPerStock)
        }
    }
    
    func addShareToAnyThatCanTakeIt() {
        
        print("left over: \(totalLeftOverForAllStocks()) and min: \(minimumAmountToProceed())")
        
        if totalLeftOverForAllStocks() < minimumAmountToProceed() {
            updateOutputs()
        } else {
            var amountLeft : Float = totalLeftOverForAllStocks()
            for holding in calculatorHoldings {
                if amountLeft > holding.dollarPx {
                    holding.addSharesFor(amount: holding.dollarPx)
                    amountLeft = amountLeft - holding.dollarPx
                }
            }
            addShareToAnyThatCanTakeIt()
        }
    }
    
    func updateOutputs() {
        
        var totalInvestment : Float = 0
        
        for subview in masterStackView.arrangedSubviews {
            if subview is CalculatorOutputView {
                (subview as! CalculatorOutputView).update()
            }
        }
        
        for holding in calculatorHoldings {
            totalInvestment = totalInvestment + holding.totalMoneyInvested
        }
        
        let cashRemaining = numberInt - Int(totalInvestment)
            
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if let number = numberFormatter.string(from: NSNumber(value: cashRemaining)) {
            cashRemainingLabel.text = "$ " + number
        }

    }
    
    func updateLabel() {
        
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if let number = numberFormatter.string(from: NSNumber(value: numberInt)) {
            numberString = "$ " + number
        }
        mainLabel.text = numberString
    }
    
    func calculateNewNumberInt(input: Int) {
        numberInt = numberInt * 10 + input
    }
    
    func totalLeftOverForAllStocks() -> Float {
        var leftover: Float = 0
        
        for holding in calculatorHoldings {
            leftover = leftover + totalLeftOverFromStock(stock: holding)
        }
        
        return leftover
    }
    
    func totalLeftOverFromStock(stock: CalculatorHolding) -> Float {
        let amountAvailable = totalInvestmentPerHolding()
        let amountUsed = stock.totalMoneyInvested
        let leftOver = amountAvailable - amountUsed
        return leftOver
    }
    
    func formatCalculatorForInvestmentAmount(_ amount: Int) {
        numberInt = amount
        updateLabel()
        updateCalcultor()
        formatMinimumLabel()
    }
    
    func formatMinimumLabel() {
        
        var minString = ""
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if let number = numberFormatter.string(from: NSNumber(value: Int(minimumInvestment()))) {
            minString = "Minimum: $" + number
        }
        minimumLabel.text = minString
    }
    
    func minimumAmountToProceed() -> Float {
        
        var minPrice : Float = 0
        
        for holding in calculatorHoldings {
            if minPrice == 0 {
                minPrice = holding.dollarPx
            } else {
                minPrice = holding.dollarPx < minPrice ? holding.dollarPx : minPrice
            }
        }
        return minPrice
    }
    
    func minimumInvestment() -> Float {
        let maxTotalDollar = maxDollarPrice() * 10.6
        let multiplier = Int(maxTotalDollar / 500)
        let finalMin = 500 * Float(multiplier) + 500
        return finalMin
    }
    
    func originalInvestment() -> Int {
        let minimum = minimumInvestment()
        let multiplier = Int(minimum / 5000)
        let investment = multiplier * 5000 + 5000
        return investment
    }
    
    func totalInvestmentPerHolding() -> Float {
        return (Float(numberInt) * 0.95) / 10
    }
    
    func maxDollarPrice() -> Float {
        var maxPrice : Float = 0
        if let currentHoldings = holdings {
            for holding in currentHoldings {
                maxPrice = holding.adjPxCurrent > maxPrice ? holding.adjPxCurrent : maxPrice
            }
        }
        return maxPrice
    }

}


// custom calculator popup extension 

extension CalculatorVC: CalculatorInputDelegate {
    
    func clearTapped() {
        numberInt = 0
        numberString = "$ 0"
        updateLabel()
    }
    
    func calculateTapped() {
        
        if minimumLabel.isHidden {
        resetMode = false
        adjustCalculatorView(show: false, animate: true)
        updateCalcultor()
        }
    }
    
    func numberTapped(_ number: Int) {
        
        if resetMode {
            numberInt = 0
            numberString = "$ 0"
            resetMode = false
        }
        
        if numberInt * 10 + number < 100000000 {
            calculateNewNumberInt(input: number)
            updateLabel()
        }
        
        minimumLabel.isHidden = numberInt < Int(minimumInvestment()) ? false : true
    }
    
    func formatCalculator() {
        
        view.addSubview(calculatorInputView)
        calculatorInputView.delegate = self
        calculatorInputView.translatesAutoresizingMaskIntoConstraints = false
        
        topToBottomConstraint = calculatorInputView.topAnchor.constraint(equalTo: view.bottomAnchor)
        topToHeaderConstraint = calculatorInputView.topAnchor.constraint(equalTo: headerView.bottomAnchor)
        bottomToBottomConstraint = calculatorInputView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        heightConstraint = calculatorInputView.heightAnchor.constraint(equalToConstant: 500)
        
        calculatorInputView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        calculatorInputView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        adjustCalculatorView(show: false, animate: false)
    }
    
    func adjustCalculatorView(show: Bool, animate: Bool) {
        
        view.isUserInteractionEnabled = false
        turnOffAllConstraints()
        topToHeaderConstraint.isActive = show
        bottomToBottomConstraint.isActive = show
        topToBottomConstraint.isActive = !show
        heightConstraint.isActive = !show
        
        let duration = animate ? 0.2 : 0
        
        UIView.animate(withDuration: duration, animations: {
            self.view.layoutIfNeeded()
        }) { (complete) in
            self.view.isUserInteractionEnabled = true
            self.isCalculatorDisplayed = !self.isCalculatorDisplayed
        }
    }
    
    func turnOffAllConstraints() {
        topToHeaderConstraint.isActive = false
        topToBottomConstraint.isActive = false
        bottomToBottomConstraint.isActive = false
        heightConstraint.isActive = false
    }
}


// Calculator Holding helper class 

class CalculatorHolding: NSObject {
    
    var numberOfShares = 0
    var holding : Holding?
    var ticker = ""
    var dollarPx : Float = 100
    var totalMoneyInvested : Float = 0
    
    func resetShares() {
        numberOfShares = 0
        totalMoneyInvested = 0
    }
    
    func addSharesFor(amount: Float) {
        if let stock = holding {
            let dollarPx = stock.adjPxCurrent == 0 ? 100 : stock.adjPxCurrent
            let shares = Int(amount / dollarPx)
            numberOfShares = numberOfShares + shares
            totalMoneyInvested = dollarPx * Float(numberOfShares)
        }
    }
    
    func updateDollarPrice() {
        if let stock = holding {
            dollarPx = stock.adjPxCurrent
        }
    }
}

