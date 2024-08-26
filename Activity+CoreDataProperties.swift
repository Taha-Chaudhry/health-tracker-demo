//
//  Activity+CoreDataProperties.swift
//  health-tracker
//
//  Created by Taha Chaudhry on 20/08/2024.
//
//

import Foundation
import CoreData


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var averageHeartbeat: Int16
    @NSManaged public var caloriesBurned: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var timeElapsed: Int16
    @NSManaged public var user: User?
    
    public var wrappedName: String {
        name ?? "Activity name not found"
    }
    
    public var formattedTime: String {
        let minutes = timeElapsed / 60
        let seconds = timeElapsed % 60
        return "\(minutes):\(String(format: "%02d", seconds))"
    }
}

extension Activity : Identifiable {

}
