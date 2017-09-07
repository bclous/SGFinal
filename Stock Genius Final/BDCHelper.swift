//
//  BDCHelper.swift
//  STClouser
//
//  Created by Brian Clouser on 9/4/17.
//  Copyright © 2017 Brian Clouser. All rights reserved.
//

import Foundation
import UIKit



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

