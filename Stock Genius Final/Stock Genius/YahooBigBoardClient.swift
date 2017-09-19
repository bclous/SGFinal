 //
//  YahooBigBoardClient.swift
//  Stock Genius
//
//  Created by Brian Clouser on 3/27/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import Foundation
import BigBoard

protocol YahooBigBoardDelegate : class {
    func pricePullComplete(success: Bool)
    func priceRefreshComplete(success: Bool)
} 

class YahooBigBoardClient {
    
    static let shared = YahooBigBoardClient()
    weak var delegate : YahooBigBoardDelegate?
    var stocksWithPrices : [BigBoardStock] = []
    var stocksWithoutPrices : [BigBoardStock] = []
    var stocksPrePrices: [BigBoardStock] = []
    var BigBoardStocks : [BigBoardStock] = []

    
    func updatePrices(portfolio: Portfolio?, firstTime: Bool) {
        
        if let port = portfolio {
            let tickers = tickersFromPortfolio(portfolio: port)
            getStocksFromTickers(tickers: tickers, firstTime: firstTime)
        }
    }
    
    func getStocksFromTickers(tickers: [String], firstTime: Bool) {
        
        let _ = BigBoard.stocksWithSymbols(symbols: tickers, success: { (stocks) in
            self.pricePullComplete(stocksWithPrices: stocks, success: true, firstTime: firstTime)
        }) { (error) in
            print("\n\n\n getStocksFromTickers failed")
        }
    }
    
    func pricePullComplete(stocksWithPrices: [BigBoardStock], success: Bool, firstTime: Bool) {
        CDClient.mapPricesToCoreData(bigBoardStocks: stocksWithPrices)
        if firstTime {
            delegate?.pricePullComplete(success: success)
        } else {
            delegate?.priceRefreshComplete(success: success)
        }
        
    }
    

//    
//    func getHistoricPrices(startDate: String) {
//        //let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
////        let dateRange = BigBoardHistoricalDateRange(startDate: dateFromString(startDate)!, endDate: yesterday!)
//        
//        for stock in stocksPrePrices {
//            
//            let _ = stock.mapHistoricalDataWithFiveDayRange({ 
//                // we got here
//                print("\n\n\n\n\nsuccess\n\n\n\n\n")
//            }, failure: { (error) in
//                print("\n\n\n\n\nfail\n\n\n\n\n")
//            })
//            
////            let historicRequest = stock.mapHistoricalDataWithRange(dateRange: dateRange, success: { 
////                self.stocksWithPrices.append(stock)
////            }, failure: { (error) in
////                print("error pulling historical data: \(error)")
////            })
////            
////            let response = historicRequest?.response
////            if let response = response {
////                print("\(response)")
////            }
//        }
//        
//    }
    
//    func pullHistoricalPrices(tickers: [String], startDate: String) {
//        
//        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
//        
//        let tempStart = "05/16/2017"
//        let tempEnd = "05/18/2017"
//        let tempDateRange = BigBoardHistoricalDateRange(startDate: dateFromString(tempStart)!, endDate: dateFromString(tempEnd)!)
//        
//        let range = BigBoardHistoricalDateRange(startDate: Date() - 3.days, endDate: Date() - 2.days)
//        
//        let dateRange = BigBoardHistoricalDateRange(startDate: dateFromString(startDate)!, endDate: yesterday!)
//        
//        
//        let _ = BigBoard.stocksWithSymbols(symbols: tickers, success: { (stocks) in
//            
//            for stock in stocks {
//                
//                let request = stock.mapHistoricalDataWithRange(dateRange: range, success: {
//                
//                    self.stocksWithPrices.append(stock)
//                    if self.stocksWithPrices.count + self.stocksWithoutPrices.count == 31 {
//                        //self.pricePullComplete(stocksWithPrices: self.stocksWithPrices, stocksWithoutPrices: self.stocksWithoutPrices, success: self.stocksWithPrices.count == 31)
//                    }
//                }, failure: { (error) in
//
//                    self.stocksWithoutPrices.append(stock)
//                    if self.stocksWithPrices.count + self.stocksWithoutPrices.count == 31 {
//                        // self.pricePullComplete(stocksWithPrices: self.stocksWithPrices, stocksWithoutPrices: self.stocksWithoutPrices, success: false)
//                    }
//                })
//            }
//            
//
//        }) { (error) in
//            //self.pricePullComplete(stocksWithPrices: self.stocksWithPrices, stocksWithoutPrices: self.stocksWithoutPrices, success: false)
//        }
//    }
    
    // helper methods
    
    func tickersFromPortfolio(portfolio: Portfolio) -> [String] {
        
        var tickers : [String] = []
        let portHoldings = portfolio.holdings
        
        if let holdings = portHoldings {
            for holding in holdings {
                tickers.append((holding as! Holding).ticker!)
            }
        }
        return tickers
    }
    
    func dateFromString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.date(from: dateString)
    }

}
