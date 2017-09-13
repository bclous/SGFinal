//
//  BDCHelper.swift
//  STClouser
//
//  Created by Brian Clouser on 9/4/17.
//  Copyright © 2017 Brian Clouser. All rights reserved.
//

import Foundation
import UIKit


class BDCHelper {
    
    
    
    
}


extension Date {
    
    public static func dateFromString(_ dateString: String, dateFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: dateString)
        return date
    }
    
    public static func isoDateFromString(_ dateString: String) -> Date? {
        let isoFormatter = ISO8601DateFormatter()
        let date = isoFormatter.date(from: dateString)
        return date
    }
    
    public static func datesAreSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        let date1Day = calendar.component(.day, from: date1)
        let date1Month = calendar.component(.month, from: date1)
        let date1Year = calendar.component(.year, from: date1)
        let date2Day = calendar.component(.day, from: date2)
        let date2Month = calendar.component(.month, from: date2)
        let date2Year = calendar.component(.year, from: date2)
        
        return (date1Day == date2Day) && (date1Month == date2Month) && (date1Year == date2Year)
    }
    
    public func dateIsOnSameDayOrAfter(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        
        let startingYear = calendar.component(.year, from: date)
        let startingMonth = calendar.component(.month, from: date)
        let startingDay = calendar.component(.day, from: date)
        
        if year > startingYear {
            return true
        } else if year < startingYear {
            return false
        } else {
            if month > startingMonth {
                return true
            } else if month < startingMonth {
                return false
            } else {
                return day >= startingDay
            }
        }
        
    }
    
    public static func timeBetween(startingDate: Date, endingDate: Date) -> (years : Int, months: Int, days: Int, hours: Int, minutes: Int, seconds: Int) {
        
        let adjustedStartingDate = startingDate > endingDate ? endingDate : startingDate
        let adjustedEndingDate = startingDate > endingDate ? startingDate : endingDate
        
        let calendar = Calendar.current
        
        var seconds = 0
        var minutes = 0
        var hours = 0
        var days = 0
        var months = 0
        var years = 0
        var movingDate = adjustedStartingDate
        
        func calculateForComoponentType(_ type: Calendar.Component) {
            movingDate = movingDate.dateByAdding(value: 1, component: type)!
            if movingDate <= adjustedEndingDate {
                addOneForType(type)
                calculateForComoponentType(type)
            } else {
                if type == .second {
                    return
                } else {
                    movingDate = movingDate.dateByAdding(value: -1, component: type)!
                    let nextTypeDown = nextTypeDownTreeFromType(type)
                    calculateForComoponentType(nextTypeDown)
                }
            }
        }
        
        func addOneForType(_ type: Calendar.Component) {
            switch type {
            case .second:
                seconds += 1
            case .minute:
                minutes += 1
            case .hour:
                hours += 1
            case .day:
                days += 1
            case .month:
                months += 1
            case .year:
                years += 1
            default:
                print("ut oh")
            }
        }
        
        func nextTypeDownTreeFromType(_ type: Calendar.Component) -> Calendar.Component {
            switch type {
            case .year:
                return .month
            case .month:
                return .day
            case .day:
                return .hour
            case .hour:
                return .minute
            case .minute:
                return .second
            case .second:
                return .second
            default:
                return .second
            }

        }
        
        
        calculateForComoponentType(.year)
        
        return (years: years, months: months, days: days, hours: hours, minutes: minutes, seconds: seconds)

        
    }
    
    
    public func string(withFormat format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    public func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        return end - start
    }
    
    public func dateByAdding(value: Int, component: Calendar.Component) -> Date? {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: component, value: value, to: self)
        return newDate
    }

}

extension String {
    
    public func stringByConvertingDateStringFromFormat(_ originalFormat: String, toFormat newFormat: String) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = originalFormat
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = newFormat
        if let date = date {
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
}

extension UIViewController {
    
    public func presentAlertToUser(title: String, message:String, handler: @escaping (_ action: UIAlertAction) -> ()) {
        let importAlert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        importAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: handler))
        self.present(importAlert, animated: true, completion: nil)
    }
    
    public func constrainSubViewFullScreen(_ subView: UIView, isActive: Bool) {
        view.addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        subView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = isActive
        subView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = isActive
        subView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = isActive
        subView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = isActive
    }
    
}

