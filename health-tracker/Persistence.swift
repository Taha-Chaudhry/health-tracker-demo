//
//  Persistence.swift
//  health-tracker
//
//  Created by Taha Chaudhry on 18/08/2024.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        
        loadMockUserData(context: viewContext)
        
        
        
//        let user = User(context: viewContext)
//        user.id = UUID()
//        user.name = "Taha Chaudhry"
//        user.age = 17
//        user.weight = 60
//        user.sex = "Male"
//        
//        let activity = Activity(context: viewContext)
//        activity.id = UUID()
//        activity.name = "Running"
//        activity.averageHeartbeat = 90
//        activity.caloriesBurned = 173
//        activity.timeElapsed = 468
//        
//        user.activity = activity
//        
//        let foodLog = FoodLog(context: viewContext)
//        foodLog.id = UUID()
//        
//        var foodItems = [FoodItem]()
//        
//        let foodItem1 = FoodItem(context: viewContext)
//        foodItem1.id = UUID()
//        foodItem1.name = "Apple"
//        foodItem1.calories = 200
//        foodItems.append(foodItem1)
//        
//        let foodItem2 = FoodItem(context: viewContext)
//        foodItem2.id = UUID()
//        foodItem2.name = "Orange"
//        foodItem2.calories = 150
//        foodItems.append(foodItem2)
//        
//        let foodItem3 = FoodItem(context: viewContext)
//        foodItem3.id = UUID()
//        foodItem3.name = "Banana"
//        foodItem3.calories = 500
//        foodItems.append(foodItem3)
//        
//        
//        for item in foodItems {
//            foodLog.mealsHad += 1
//            foodLog.caloriesConsumed += item.calories
//            foodLog.addItem(item)
//        }
//        
//        user.foodLog = foodLog
        
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "health_tracker")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
