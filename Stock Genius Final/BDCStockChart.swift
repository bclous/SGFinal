//
//  BDCStockChart.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 9/11/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit
import SwiftChart

enum DateIntervalType {
    case intraday
    case daily
    case weekly
    case monthly
    case quarterly
    case yearly
}

class BDCStockChart: UIView, ChartDelegate {
    
    let chart = Chart()
    public var data : [(x: Date, y: Float)] = []
    public var chartBackgroundColor = UIColor.black {
        didSet {
            chart.backgroundColor = chartBackgroundColor
        }
    }
    public var xAxisDateFormat = "M/yy"
    private var lineLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 8))
    
    public var dateIntervalType : DateIntervalType = .weekly {
        didSet {
    
            switch dateIntervalType {
            case .daily:
                xAxisDateFormat = "E-d"
            case .weekly:
                xAxisDateFormat = "M/d"
            case .monthly:
                xAxisDateFormat = "MMM"
            case .quarterly:
                xAxisDateFormat = "MMM"
            case .yearly:
                xAxisDateFormat = "yyyy"
            case .intraday:
                xAxisDateFormat = xAxisLabels().count < 4 ? "h:mm a" : "h a"
            }
        }
    }
    
    private var sortedData : [(x: Date, y: Float)] = []
    private var chartData : [(x: Float, y: Float)] = []
    private let calendar = Calendar.current


    var isIntraday = false

    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Float, left: CGFloat) {
       
        let index : Int = indexes[0] ?? 0
        let value = chart.valueForSeries(0, atIndex: index)
        if let value = value {
            lineLabel.isHidden = false
            lineLabel.text = value.stringWithDecimals(2)
            lineLabel.frame.origin.x = left < 3 ? left : left - 3
        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        print("hi")
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        print("hi")
    }
    
    private func commonInit() {
        self.addSubview(chart)
        chart.delegate = self
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        chart.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        chart.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        chart.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        chart.xLabelsSkipLast = false
        chart.lineWidth = 1
        
        chartBackgroundColor = SGConstants.mainBlackColor
        backgroundColor = SGConstants.mainBlackColor
        formatLineLabel()
    }
    
    private func formatLineLabel() {
        
        addSubview(lineLabel)
        lineLabel.text = "444.44"
        lineLabel.textColor = SGConstants.fontColorWhiteSecondary
        lineLabel.font = lineLabel.font.withSize(10.0)
        
    }
    
    
    public func formatChartWithData(_ data: [(x: Date, y: Float)], isDaily: Bool) {

        lineLabel.isHidden = true
        if !data.isEmpty {
            self.data = data
            sortedData = data.sorted(by: {$0.x < $1.x})
            formatChart(isDaily: isDaily)
        }
    }
    
    
    
    private func formatChart(isDaily: Bool) {
        
        createChartData()
        let series = ChartSeries(data: chartData)
        series.area = true
        chart.series.removeAll()
        chart.add(series)
        formatDefaultIntervalType(isDaily: isDaily)
        chart.xLabels = xAxisLabels()
        chart.yLabels = yAxisLabels()
        chart.xLabelsFormatter = { self.dateStringFromInt(Int($1))}
        chart.axesColor = UIColor.white.withAlphaComponent(0.2)
        chart.labelColor = UIColor.white.withAlphaComponent(0.9)
        chart.gridColor = UIColor.white.withAlphaComponent(0.1)
        chart.axesColor = UIColor.red
        chart.axesColor = SGConstants.mainBlackColor
        chart.yLabelsOnRightSide = true
        chart.xLabelsSkipLast = true
 

    }
    
    private func dateStringFromInt(_ int: Int) -> String {
        
        let adjusted = sortedData.count - 1 == int ? int : int + 1
        let adjustedForDaily = dateIntervalType == .intraday ? int : adjusted
        let date = sortedData[adjustedForDaily].x
        return date.string(withFormat: xAxisDateFormat)!
    
    }
    
    private func createChartData() {
        
        chartData.removeAll()
        
        if !sortedData.isEmpty {
            for index in 0...sortedData.count - 1 {
                let stockDay = sortedData[index]
                let x = Float(index)
                let y = stockDay.y
                let value = (x,y)
                chartData.append(value)
            }
        }
    }
    
    private func firstInDayIndices() -> [Float] {
        
        var indices : [Int] = []
        
        for index in 0...sortedData.count - 1 {
            indices.append(index)
        }
        
        var indicesFloat : [Float] = []
        
        for index in indices {
            indicesFloat.append(Float(index))
        }
        
        return indicesFloat

    }
    
    private func firstInWeekIndices() -> [Float] {
        
        var indices : [Int] = []
        
        for index in 0...sortedData.count - 1 {
            let firstDay = sortedData[index]
            let firstWeekDay = calendar.component(.weekday, from: firstDay.x)
            let adjustedFirstWeekday = adjustedWeekday(component: firstWeekDay)
            
            if index == 0 {
                if adjustedFirstWeekday == 1 {
                    indices.append(index)
                }
            }
            
            if index < sortedData.count - 1 {
                
                let nextDay = sortedData[index + 1]
                let nextWeekDay = calendar.component(.weekday, from: nextDay.x)
                let adjustedNextWeekday = adjustedWeekday(component: nextWeekDay)
                
                if adjustedNextWeekday < adjustedFirstWeekday {
                    indices.append(index + 1)
                }
            }
        }
        
        var indicesFloat : [Float] = []
        
        for index in indices {
            indicesFloat.append(Float(index))
        }
        
        return indicesFloat
    }
    
    private func firstInMonthIndices() -> [Float] {
        
        var indices : [Int] = []
        
        for index in 0...sortedData.count - 1 {
            let firstDay = sortedData[index]
            let firstMonth = calendar.component(.month, from: firstDay.x)
            
            if index < sortedData.count - 1 {
                
                let nextDay = sortedData[index + 1]
                let nextMonth = calendar.component(.month, from: nextDay.x)
                
                if nextMonth != firstMonth {
                    indices.append(index + 1)
                }
            }
        }
        
        var indicesFloat : [Float] = []
        
        for index in indices {
            indicesFloat.append(Float(index))
        }
        
        return indicesFloat

    }
    
    private func firstInQuarterIndices() -> [Float] {
        
        var firstInQuarter : [Float] = []
        let firstInMonth = firstInMonthIndices()
        for index in 0...firstInMonth.count-1  {
            
            if index == 0 {
                firstInQuarter.append(firstInMonth[index])
            } else if (index) % 3 == 0 {
                firstInQuarter.append(firstInMonth[index])
            }
            

        }
        
        return firstInQuarter
    }
    
    private func firstInYearIndices() -> [Float] {
        var indices : [Int] = []
        
        for index in 0...sortedData.count - 1 {
            let firstDay = sortedData[index]
            let firstYear = calendar.component(.year, from: firstDay.x)
            
            if index < sortedData.count - 1 {
                
                let nextDay = sortedData[index + 1]
                let nextYear = calendar.component(.year, from: nextDay.x)
                
                if nextYear > firstYear {
                    indices.append(index + 1)
                }
            }
        }
        
        var indicesFloat : [Float] = []
        
        for index in indices {
            indicesFloat.append(Float(index))
        }
        
        return indicesFloat

    }
    
    private func intraDayIndices() -> [Float] {
        
        if sortedData.count < 45 {
            return firstIndex()
        } else if sortedData.count <= 75 {
            return firstInHourIndices(includeFirst: true)
        } else {
            return firstInHourIndices(includeFirst: false)
        }

    }
    
    private func firstIndex() -> [Float] {
        let firstIndex : Float = 0
        return [firstIndex]
    }
    
    private func firstInHourIndices(includeFirst: Bool) -> [Float] {
        
        var indices: [Float] = []
        
        if includeFirst {
            let firstIndex : Float = 0
            indices.append(firstIndex)
        }
        
        for index in 0...sortedData.count - 1 {
            
            let date = sortedData[index].x
            let minuteString = date.string(withFormat: "mm")
            if minuteString == "00" {
                indices.append(Float(index))
            }
        }
        
        return indices
        
    }
    
    
    
    private func adjustedWeekday(component: Int) -> Int {
        return component == 1 ? 7 : component - 1
    }
    
    private func formatDefaultIntervalType(isDaily: Bool) {
        
        if isDaily {
            dateIntervalType = .intraday
        } else if sortedData.count <= 6 {
            dateIntervalType = .daily
        } else if sortedData.count <= 30 {
            dateIntervalType = .weekly
        } else if sortedData.count <= 135 {
            dateIntervalType = .monthly
        } else if sortedData.count <= 255 {
            dateIntervalType = .quarterly
        } else {
            dateIntervalType = .yearly
        }
    }
    
    private func xAxisLabels() -> [Float] {
        switch dateIntervalType {
        case .daily:
            return firstInDayIndices()
        case .weekly:
            return firstInWeekIndices()
        case .monthly:
            return firstInMonthIndices()
        case .quarterly:
            return firstInQuarterIndices()
        case .yearly:
            return firstInYearIndices()
        case .intraday:
            return intraDayIndices()
        }
    }
    
    
    private func yAxisLabels() -> [Float] {
        
        var minY : Float = sortedData[0].y
        var maxY : Float = 0
        
        for (_, closingPrice) in sortedData {
            maxY = closingPrice > maxY ? closingPrice : maxY
            minY = closingPrice < minY ? closingPrice : minY
        }
        
        var intMaxY = Int((maxY) + 1)
        var intMinY = Int(minY)
        var intMidY = 0
        var spread = intMaxY - intMinY
        
        if spread < 2 {
            return [Float(intMinY), Float(intMaxY)]
        } else {
            
            if spread % 2 == 0 {
                intMidY = spread / 2 + intMinY
            } else {
                if intMinY == 0 {
                    intMaxY += 1
                    spread = intMaxY - intMinY
                    intMidY = spread / 2 + intMinY
                } else {
                    intMinY -= 1
                    spread = intMaxY - intMinY
                    intMidY = spread / 2 + intMinY
                }
            }
            
            return [Float(intMinY), Float(intMidY),Float(intMaxY)]
        }
        
    }
    
    
    
    
}
