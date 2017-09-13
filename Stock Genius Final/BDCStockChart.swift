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
    case daily
    case weekly
    case monthly
    case quarterly
    case yearly
}

class BDCStockChart: UIView {
    
    let chart = Chart()
    public var data : [(x: Date, y: Float)] = [] {
        didSet {
            sortedData = data.sorted(by: {$0.x < $1.x})
            formatDefaultIntervalType()
            formatChart()
        }
    }
    public var chartBackgroundColor = UIColor.black {
        didSet {
            chart.backgroundColor = chartBackgroundColor
        }
    }
    public var xAxisDateFormat = "M/yy"
    
    public var dateIntervalType : DateIntervalType = .weekly {
        didSet {
            formatDefaultXAxisLabels()
            switch dateIntervalType {
            case .daily:
                xAxisDateFormat = "E"
            case .weekly:
                xAxisDateFormat = "M/d"
            case .monthly:
                xAxisDateFormat = "MMM"
            case .quarterly:
                xAxisDateFormat = "MMM"
            case .yearly:
                xAxisDateFormat = "yyyy"
            }
        }
    }
    
    public var xLabels : [Float] = []
    
    
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
    
    private func commonInit() {
        self.addSubview(chart)
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        chart.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        chart.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        chart.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        
        chartBackgroundColor = SGConstants.mainBlackColor
        backgroundColor = SGConstants.mainBlackColor
    }
    
    private func formatChart() {
        
        createChartData()
        let series = ChartSeries(data: chartData)
        series.area = true
        chart.series.removeAll()
        chart.add(series)
        chart.xLabels = xLabels
        chart.xLabelsFormatter = { self.dateStringFromInt(Int($1))}
        chart.axesColor = UIColor.white.withAlphaComponent(0.2)
        chart.labelColor = UIColor.white.withAlphaComponent(0.9)
        chart.gridColor = UIColor.white.withAlphaComponent(0.1)
        chart.axesColor = UIColor.red
        chart.axesColor = SGConstants.mainBlackColor
        chart.yLabelsOnRightSide = true

    }
    
    private func dateStringFromInt(_ int: Int) -> String {
        let date = sortedData[int].x
        print("\(date)")
        return date.string(withFormat: xAxisDateFormat)!
    
    }
    
    private func createChartData() {
        
        chartData.removeAll()
        
        for index in 0...sortedData.count - 1 {
            let stockDay = sortedData[index]
            let x = Float(index)
            let y = stockDay.y
            let value = (x,y)
            chartData.append(value)
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
        let firstIndex = Int(firstInMonth[0])
        let firstDate = sortedData[firstIndex].x
        let firstMonth = calendar.component(.month, from: firstDate)
        
        for index in firstInMonth {
            
            let idx = Int(index)
            let date = sortedData[idx].x
            let month = calendar.component(.month, from: date)
            let adjustedMonth = month < firstMonth ? month + 12 : month
            if adjustedMonth % firstMonth == 0 {
                firstInQuarter.append(Float(idx))
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
    
    private func adjustedWeekday(component: Int) -> Int {
        return component == 1 ? 7 : component - 1
    }
    
    private func formatDefaultIntervalType() {
        
        let startDate = sortedData[0].x
        let lastDate = sortedData[sortedData.count - 1].x

        let years  = lastDate.interval(ofComponent: .year, fromDate: startDate)
        let months = lastDate.interval(ofComponent: .month, fromDate: startDate)
        let days = lastDate.interval(ofComponent: .day, fromDate: startDate)
        
        if years > 0 {
            dateIntervalType = .yearly
        } else if months >= 6 {
            dateIntervalType = .quarterly
        } else if days < 7 {
            dateIntervalType = .daily
        } else if days < 42 {
            dateIntervalType = .weekly
        } else {
            dateIntervalType = .monthly
        }
        
    }
    
    private func formatDefaultXAxisLabels() {
        switch dateIntervalType {
        case .daily:
            xLabels = firstInDayIndices()
        case .weekly:
            xLabels = firstInWeekIndices()
        case .monthly:
            xLabels = firstInMonthIndices()
        case .quarterly:
            xLabels = firstInQuarterIndices()
        case .yearly:
            xLabels = firstInYearIndices()
        }
    }
    
    
}
