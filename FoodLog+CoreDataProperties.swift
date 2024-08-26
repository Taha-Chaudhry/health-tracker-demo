//
//  FoodLog+CoreDataProperties.swift
//  health-tracker
//
//  Created by Taha Chaudhry on 18/08/2024.
//
//

import Foundation
import CoreData


extension FoodLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodLog> {
        return NSFetchRequest<FoodLog>(entityName: "FoodLog")
    }

    @NSManaged public var caloriesConsumed: Int16
    @NSManaged public var mealsHad: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var items: NSSet?
    @NSManaged public var user: User?
    
}

// MARK: Generated accessors for items
extension FoodLog {

    @objc(addItemsObject:)
    @NSManaged public func addItem(_: FoodItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeItem(_: FoodItem)

    @objc(addItems:)
    @NSManaged public func addItems(_: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeItems(_: NSSet)

}

extension FoodLog : Identifiable {

}
