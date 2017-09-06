//
//  CurrentPortfolio.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 6/29/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class CurrentPortfolio: NSObject {
    
    var startDate : String
    var endDate : String
    var name : String
    var note : String
    var holdings : [CurrentStock]
    var index : CurrentStock
    var calcStocks : [CalculatorStock]
    var remainingCash : Float = 0
    
    override init() {
        self.startDate = ""
        self.endDate = ""
        self.name = ""
        self.note = ""
        self.holdings = []
        self.index = CurrentStock()
        self.calcStocks = []
        super.init()
    }
    
    
    public func updateCurrentPortfolioValues(dictionary: Dictionary<String, Any>) {
        
        endDate = dictionary["endDate"] as? String ?? ""
        startDate = dictionary["startDate"] as? String ?? ""
        name = dictionary["name"] as? String ?? ""
        
        let holdingsDictionary = dictionary["holdings"] as? Dictionary<String, Any>
        if holdingsDictionary != nil {
            let keys = holdingsDictionary!.keys
            for key in keys {
               
                    let newStockDictionary = holdingsDictionary![key] as? Dictionary<String, Any>
                    if newStockDictionary != nil {
                        
                        if key == "index" {
                            index.updateCurrentStockValues(dictionary: newStockDictionary!)
                        } else {
                            let newStock = CurrentStock()
                            newStock.updateCurrentStockValues(dictionary: newStockDictionary!)
                            self.holdings.append(newStock)
                        }
                    }
            }
            
            holdings.sort(by: {$0.rankInPortfolio < $1.rankInPortfolio})
        }
        
        updateCalcStocks()
        
    }
    
    public func dateForPeriodBegin() -> Date? {
        return Date.dateFromString(startDate, dateFormat: "MM/dd/yyyy")
    }
    
    public func averageReturn(isTodayReturn: Bool) -> Float {
        var totalReturn : Float = 0
        for holding in holdings {
            if holding.rankInPortfolio <= 10 {
                totalReturn = totalReturn + holding.percentageReturn(isTodayReturn: isTodayReturn)
            }
        }
        return holdings.count == 0 ? 0.0 : totalReturn / 10.0
    }
    
    public func averageReturnString(isTodayReturn: Bool) -> String {
        return String(format: "%.1f", abs(averageReturn(isTodayReturn: isTodayReturn)) * 100) + "%"
    }
    
    public func stockGeniusPlusMinus(isTodayReturn: Bool) -> Float {
        let indexReturn = index.percentageReturn(isTodayReturn: isTodayReturn)
        let avgReturn = averageReturn(isTodayReturn: isTodayReturn)
        let roundedIndexReturn = (indexReturn * 1000).rounded() / 1000
        let roundedAvgReturn = (avgReturn * 1000).rounded() / 1000
        return roundedAvgReturn - roundedIndexReturn
    }
    
    public func stockGeniusPlusMinusString(isTodayReturn: Bool) ->String {
        let difference = stockGeniusPlusMinus(isTodayReturn: isTodayReturn)
        return String(format: "%.1f", abs(difference) * 100) + "%"
    }

    
    public func nextUpdateTitle() -> String {
        
        if let days = daysUntilNextUpdate() {
            switch days {
            case 0:
                return "Next pick update: TONIGHT"
            case 1:
                return "Next pick update: TOMORROW"
            default:
                return "Next pick update: \(days) days"
            }
        } else {
            return "Next pick update: Not available"
        }
    }
    
    public func startDateString() -> String {
        return startDate.stringByConvertingDateStringFromFormat("MM/dd/yyyy", toFormat: "M.d.yyyy") ?? startDate
    }
    
    public func endDateString() -> String {
        return endDate.stringByConvertingDateStringFromFormat("MM/dd/yyyy", toFormat: "M.d.yyyy") ?? endDate
    }
    
    
    private func daysUntilNextUpdate() -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let endDate = dateFormatter.date(from: self.endDate)
        
        if let end = endDate {
            return end.interval(ofComponent: .day, fromDate: Date()) < 0 ? 0 : end.interval(ofComponent: .day, fromDate: Date())
        }
        
        return nil
    }
    
    // calculator methods
    
    public func updateCalculatorValues(portfolioAmount: Int) {
        
        resetCalcStockValues()
        addOriginalAmounts(portfolioAmount: portfolioAmount)
        addExtraShares(leftoverAmount: extraMoney(portfolioAmount: portfolioAmount))
        updateRemainingCash(portfolioAmount: portfolioAmount)
        
    }
    
    public func minimumInvestmentForCalculator() -> Float {
        let actualAmount = highestDollarPrice() * 10 / 0.97
        let rounded = round(actualAmount / 1000) * 1000 + 1000
        return rounded
    }
    
    private func updateCalcStocks() {
        for stock in holdings {
            if stock.rankInPortfolio <= 10 {
                let calcStock = CalculatorStock(stock: stock)
                self.calcStocks.append(calcStock)
            }
        }
        
        calcStocks.sort(by: {$0.stock.adjPriceCurrent < $1.stock.adjPriceCurrent})
    }
    
    private func highestDollarPrice() -> Float {
        var highest : Float = 0
        for calcStock in calcStocks {
            if calcStock.stock.adjPriceCurrent > highest {
                highest = calcStock.stock.adjPriceCurrent
            }
        }

        return highest
    }
    
    private func resetCalcStockValues() {
        for calcStock in calcStocks {
            calcStock.shares = 0
            calcStock.totalMoney = 0
        }
    }
    
    private func addOriginalAmounts(portfolioAmount: Int) {
        for calcStock in calcStocks {
            if calcStock.stock.adjPriceCurrent != 0 {
                print("adding \(modelAmountPerStock(portfolioAmount: portfolioAmount)) for \(calcStock.stock.ticker)")
                calcStock.addSharesForDollarAmount(modelAmountPerStock(portfolioAmount: portfolioAmount))
            }
        }
    }
    
    private func addExtraShares(leftoverAmount: Float) {
        
        var leftover = leftoverAmount
        
        for calcStock in calcStocks {
            if calcStock.stock.adjPriceCurrent <= leftover {
                calcStock.addSingleShare()
                leftover = leftover - calcStock.stock.adjPriceCurrent
                //print("leftover: \(leftover)")
            }
        }
        
        if leftover > calcStocks[0].stock.adjPriceCurrent {
            addExtraShares(leftoverAmount: leftover)
        }
        
    }
    
    private func updateRemainingCash(portfolioAmount: Int) {
        let totalAmount = Float(portfolioAmount)
        let invested = totalMoneyInvested()
        let remaining = totalAmount - invested
        remainingCash = remaining
    }
    
    private func modelAmountPerStock(portfolioAmount: Int) -> Float {
        let total = Float(portfolioAmount) * 0.97
        return total / Float(nonZeroPricedStocks())
    }
    
    private func nonZeroPricedStocks() -> Int {
        var index = 0
        for calcStock in calcStocks {
            if calcStock.stock.adjPriceCurrent != 0 {
                index += 1
            }
        }
        
        return index
    }
    
    private func extraMoney(portfolioAmount: Int) -> Float {
        
        var extra : Float = 0
        
        for calcStock in calcStocks {
            let stockExtra = modelAmountPerStock(portfolioAmount: portfolioAmount) - calcStock.totalMoney
            extra = extra + stockExtra
        }
        return extra
    }
    
    private func totalMoneyInvested() -> Float {
       
        var total : Float = 0
        
        for calcStock in calcStocks {
            total = calcStock.totalMoney + total
        }
        
        return total
    }
    
    func notesArray() -> [String] {
        var notes : [String] = []
        for stock in holdings {
            if stock.note != "" {
                notes.append(stock.note)
            }
        }
        return notes
    }
}

class CalculatorStock: NSObject {
    
    var stock : CurrentStock
    var shares : Int
    var totalMoney : Float
    
    override init() {
        self.stock = CurrentStock()
        self.shares = 0
        self.totalMoney = 0
        super.init()
    }
    
    convenience init(stock: CurrentStock) {
        self.init()
        self.stock = stock
        self.shares = 0
        self.totalMoney = 0
    }
    
    func remainingMoneyForModelAmount(_ amount: Float) -> Float {
        return amount - totalMoney
    }
    
    func addSharesForDollarAmount(_ amount: Float) {
    
        if stock.adjPriceCurrent != 0 {
            shares = shares + Int(amount / stock.adjPriceCurrent )
            totalMoney = totalMoney + (Float(shares) * stock.adjPriceCurrent)
            
            //print("added \(shares) to \(stock.ticker) for money of \(totalMoney)")
        }
    }
    
    func addSingleShare() {
        if stock.adjPriceCurrent != 0 {
            shares = shares + 1
            totalMoney = totalMoney + stock.adjPriceCurrent
        }
    }

}

extension Date {
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        return end - start
    }
}
