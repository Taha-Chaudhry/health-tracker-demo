//
//  FoodItem+CoreDataProperties.swift
//  health-tracker
//
//  Created by Taha Chaudhry on 18/08/2024.
//
//

import Foundation
import CoreData


extension FoodItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodItem> {
        return NSFetchRequest<FoodItem>(entityName: "FoodItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var calories: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var log: FoodLog?
    
    var wrappedName: String {
        return name ?? "Item Name not found"
    }
}

extension FoodItem : Identifiable {

}
