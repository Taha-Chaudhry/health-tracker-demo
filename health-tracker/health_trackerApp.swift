//
//  health_trackerApp.swift
//  health-tracker
//
//  Created by Taha Chaudhry on 18/08/2024.
//

import SwiftUI
import CoreData

@main
struct health_trackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ViewModel())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

func loadMockUserData(context: NSManagedObjectContext) {
   // Locate the JSON file in the app bundle
   guard let url = Bundle.main.url(forResource: "mockUserData", withExtension: "json") else {
      print("JSON file not found")
      return
   }
   
   do {
      let data = try Data(contentsOf: url)
      
      let decoder = JSONDecoder()
      let response = try decoder.decode(Response.self, from: data)
      
      let user = User(context: context)
      user.id = UUID()
      user.name = response.user.name
      user.age = Int16(response.user.age)
      user.weight = Int16(response.user.weight)
      user.sex = response.user.sex
      
      
      let activity = Activity(context: context)
      activity.id = UUID()
      activity.name = response.user.activity.name
      activity.averageHeartbeat = Int16(response.user.activity.averageHeartbeat)
      activity.caloriesBurned = Int16(response.user.activity.caloriesBurned)
      activity.timeElapsed = Int16(response.user.activity.timeElapsed)
      
      user.activity = activity
      
      let foodLog = FoodLog(context: context)
      foodLog.id = UUID()
      var totalCalories = 0
      var mealsHad = 0
      
      for foodItemResponse in response.user.foodLog.items {
         let foodItem = FoodItem(context: context)
         foodItem.id = UUID()
         foodItem.name = foodItemResponse.name
         foodItem.calories = Int16(foodItemResponse.calories)
         
         totalCalories += foodItemResponse.calories
         mealsHad += 1
         
         foodLog.addItem(foodItem)
      }
      
      foodLog.caloriesConsumed = Int16(totalCalories)
      foodLog.mealsHad = Int16(mealsHad)
      
      user.foodLog = foodLog
      try context.save()
      
   } catch {
      print("Failed to load and parse JSON mock data: \(error)")
   }
}
