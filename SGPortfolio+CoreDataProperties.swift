//
//  SGPortfolio+CoreDataProperties.swift
//  
//
//  Created by Brian Clouser on 9/28/17.
//
//

import Foundation
import CoreData


extension SGPortfolio {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SGPortfolio> {
        return NSFetchRequest<SGPortfolio>(entityName: "SGPortfolio")
    }

    @NSManaged public var lastPriceUpdate: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var holdings: NSSet?

}

// MARK: Generated accessors for holdings
extension SGPortfolio {

    @objc(addHoldingsObject:)
    @NSManaged public func addToHoldings(_ value: SGStock)

    @objc(removeHoldingsObject:)
    @NSManaged public func removeFromHoldings(_ value: SGStock)

    @objc(addHoldings:)
    @NSManaged public func addToHoldings(_ values: NSSet)

    @objc(removeHoldings:)
    @NSManaged public func removeFromHoldings(_ values: NSSet)

}
