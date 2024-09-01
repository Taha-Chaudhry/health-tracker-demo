//
//  Vitals+CoreDataProperties.swift
//  health-tracker
//
//  Created by Taha Chaudhry on 28/08/2024.
//
//

import Foundation
import CoreData


extension Vitals {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vitals> {
        return NSFetchRequest<Vitals>(entityName: "Vitals")
    }

    @NSManaged public var bloodPressure: Int16
    @NSManaged public var breathingRate: Int16
    @NSManaged public var caloriesBurned: Int16
    @NSManaged public var heartbeat: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var temperature: Int16
    @NSManaged public var stepData: NSSet?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for stepData
extension Vitals {

    @objc(addStepDataObject:)
    @NSManaged public func addToStepData(_ value: Steps)

    @objc(removeStepDataObject:)
    @NSManaged public func removeFromStepData(_ value: Steps)

    @objc(addStepData:)
    @NSManaged public func addToStepData(_ values: NSSet)

    @objc(removeStepData:)
    @NSManaged public func removeFromStepData(_ values: NSSet)

}

extension Vitals : Identifiable {

}
