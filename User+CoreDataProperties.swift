//
//  User+CoreDataProperties.swift
//  health-tracker
//
//  Created by Taha Chaudhry on 20/08/2024.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var age: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var sex: String?
    @NSManaged public var weight: Int16
    @NSManaged public var activity: Activity?
    @NSManaged public var foodLog: FoodLog?
    @NSManaged public var vitals: Vitals?
    
    public var wrappedName: String {
        name ?? "Name not found"
    }
    
    public var wrappedFirstName: String {
        let firstName = String(name?.split(separator: " ")[0] ?? "FirstName")
        return firstName
    }
    
    public var wrappedSex: String {
        sex ?? "Sex not found"
    }

}

extension User : Identifiable {

}

