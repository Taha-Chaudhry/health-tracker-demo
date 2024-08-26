//
//  Steps+CoreDataProperties.swift
//  health-tracker
//
//  Created by Taha Chaudhry on 20/08/2024.
//
//

import Foundation
import CoreData


extension Steps {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Steps> {
        return NSFetchRequest<Steps>(entityName: "Steps")
    }

    @NSManaged public var stepsTaken: Int32
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var vitals: Vitals?

}

extension Steps : Identifiable {

}
