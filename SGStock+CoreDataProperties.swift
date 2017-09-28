//
//  SGStock+CoreDataProperties.swift
//  
//
//  Created by Brian Clouser on 9/28/17.
//
//

import Foundation
import CoreData


extension SGStock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SGStock> {
        return NSFetchRequest<SGStock>(entityName: "SGStock")
    }

    @NSManaged public var companyName: String?
    @NSManaged public var indexInPortfolio: Int64
    @NSManaged public var lastPrice: Float
    @NSManaged public var previousClose: Float
    @NSManaged public var ticker: String?
    @NSManaged public var portfolio: SGPortfolio?

}
