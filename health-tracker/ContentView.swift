//
//  ContentView.swift
//  health-tracker
//
//  Created by Taha Chaudhry on 18/08/2024.
//

import SwiftUI
import CoreData
import os

func loadMockUserData(context: NSManagedObjectContext) {
   guard let url = Bundle.main.url(forResource: "mockUserData", withExtension: "json") else {
      ViewModel().logger.error("JSON file not found")
      return
   }
   
   do {
      let data = try Data(contentsOf: url)
      
      let decoder = JSONDecoder()
      let response = try decoder.decode(Response.self, from: data)
      
      let myUser = User(context: context)
      myUser.id = UUID()
      myUser.name = response.user.name
      myUser.age = Int16(response.user.age)
      myUser.weight = Int16(response.user.weight)
      myUser.sex = response.user.sex
      
      
      let myActivity = Activity(context: context)
      myActivity.id = UUID()
      myActivity.name = response.user.activity.name
      myActivity.averageHeartbeat = Int16(response.user.activity.averageHeartbeat)
      myActivity.caloriesBurned = Int16(response.user.activity.caloriesBurned)
      myActivity.timeElapsed = Int16(response.user.activity.timeElapsed)
      
      myUser.activity = myActivity
      
      let myFoodLog = FoodLog(context: context)
      myFoodLog.id = UUID()
      var totalCalories = 0
      var mealsHad = 0
      
      for foodItemResponse in response.user.foodLog.items {
         let myFoodItem = FoodItem(context: context)
         myFoodItem.id = UUID()
         myFoodItem.name = foodItemResponse.name
         myFoodItem.calories = Int16(foodItemResponse.calories)
         
         totalCalories += foodItemResponse.calories
         mealsHad += 1
         
         myFoodLog.addItem(myFoodItem)
      }
      
      myFoodLog.caloriesConsumed = Int16(totalCalories)
      myFoodLog.mealsHad = Int16(mealsHad)
      
      myUser.foodLog = myFoodLog
      
      try context.save()
      
   } catch {
      ViewModel().logger.error("Failed to load and parse JSON mock data: \(error)")
   }
}




struct Response: Decodable {
    let user: UserResponse
}

struct UserResponse: Decodable, Equatable {
    let name: String
    let sex: String
    let age: Int
    let weight: Int
    let activity: ActivityResponse
    let foodLog: FoodLogResponse
}

struct ActivityResponse: Decodable, Equatable {
    let name: String
    let averageHeartbeat: Int
    let caloriesBurned: Int
    let timeElapsed: Int
}

struct FoodLogResponse: Decodable, Equatable {
    let items: [FoodItemResponse]
}

struct FoodItemResponse: Decodable, Equatable {
    let name: String
    let calories: Int
}

struct ContentView: View {
   @ObservedObject public var viewModel: ViewModel
   
   var body: some View {
      if viewModel.isLoggedIn {
         ScrollView {
            MetricsView(viewModel: viewModel)
            
            if viewModel.activity.wrappedName != "Activity name not found" {
               ActivitySummaryView(viewModel: viewModel)
            }
            
            FoodLogView(viewModel: viewModel)
            
            ZStack {
               RoundedRectangle(cornerRadius: 15)
                  .frame(maxWidth: .infinity, maxHeight: 100)
                  .foregroundStyle(.secondary)
               Toggle(isOn: $viewModel.mockServerEnabled) {
                  Text("Use Mock Server")
                     .foregroundStyle(.white)
                     .padding()
               }
               .padding([.leading, .trailing])
               .disabled(true)
            }.padding()
         }
         .padding(.top)
      } else {
         LoginView(viewModel: viewModel)
      }
   }
}

// MARK: ViewModel
class ViewModel: ObservableObject {
   public let logger = Logger(
      subsystem: Bundle.main.bundleIdentifier!,
      category: String(describing: ViewModel.self)
   )
   
   @AppStorage("isLoggedIn") public var isLoggedIn: Bool = true
   @Published public var isLoading: Bool = false
   @Published public var showNamePresenceError: Bool = false
   @Published public var showSexPresenceError: Bool = false
   
   @Published public var name: String = ""
   @Published public var age: Int = 0
   @Published public var weight: Int = 140
   @Published public var sex: String = ""
   
   // MARK: Enable Mock Server (WireMock)
   @Published public var mockServerEnabled: Bool = false
   @Published public var isError: Bool = false
   
   @Published public var isViewingProfile: Bool = false
   
   @Published public var isAddingFood: Bool = false
   @Published public var hasPressedAdd: Bool = false
   @Published public var addedFoodName: String = ""
   @Published public var addedFoodCalories: String = ""
   
   var viewContext: NSManagedObjectContext {
      PersistenceController.shared.container.viewContext
   }
   
   @Published var users: [User] = []
   var user: User {
      users.first ?? User(context: viewContext)
   }
   
   
   @Published var foodLogs: [FoodLog] = []
   var foodLog: FoodLog {
      return foodLogs.first ?? FoodLog(context: viewContext)
   }
   
   @Published var activities: [Activity] = []
   var activity: Activity {
      return activities.first ?? Activity(context: viewContext)
   }
   
   init() {
      fetchData()
   }
   
   func fetchData() {
      if mockServerEnabled {
         networkRequestData()
      } else {
         loadMockUserData(context: viewContext)
         fetchUsers()
         fetchFoodLog()
         fetchActivity()
      }
   }
   
   // MARK: Login Logic
   
   func networkRequestData() {
      let url = URL(string: "http://localhost:8080/api/users/1")!
      var request = URLRequest(url: url)
      request.httpMethod = "GET"
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      let task = URLSession.shared.dataTask(with: request) { data, _, error  in
         if let error = error {
            self.logger.error("Error while fetching data: \(error)")
            return
         }
         
         guard let data = data else {
            return
         }
         do {
            let response = try! JSONDecoder().decode(Response.self, from: data)
            self.storeInCoreData(response: response)
         }
      }
      task.resume()
   }
   
   func login() {
      logger.info("Logging in")
      guard !(name == "" && sex == "") else {
         showNamePresenceError = true
         showSexPresenceError = true
         return
      }
      
      
      guard name != "" else {
         showNamePresenceError = true
         showSexPresenceError = false
         return
      }
      
      guard sex != "" else {
         showSexPresenceError = true
         showNamePresenceError = false
         return
      }
      
      showNamePresenceError = false
      showSexPresenceError = false
      
      isLoading = true
      
      user.name = name
      user.sex = sex
      user.weight = Int16(weight)
      
      // Simulate Login Network Request delay
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
         withAnimation(.easeInOut(duration: 1)) {
            self.isLoading = false
         }
         
         withAnimation(.easeOut(duration: 0.25)) {
            self.isLoggedIn = true
         }
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
         self.name = ""
         self.sex = ""
         self.weight = 140
      }
   }
   
   func logout() {
      logger.info("Logging out")
      isLoggedIn = false
   }
   
   
   func fetchUsers() {
      do {
         let request: NSFetchRequest<User> = User.fetchRequest()
         users = try viewContext.fetch(request)
      } catch {
         logger.error("Error fetching data: \(error)")
      }
   }
   
   func fetchFoodLog() {
      DispatchQueue.global(qos: .background).async { [weak self] in
         guard let self = self else { return }
         
         do {
            guard let _ = user.id else { return logger.error("No user with that id") }
            
            let request: NSFetchRequest<FoodLog> = FoodLog.fetchRequest()
            request.predicate = NSPredicate(format: "user.id == %@", user.id! as NSUUID)
            foodLogs = try viewContext.fetch(request)
            
            let fetchedFoodLogs = try self.viewContext.fetch(request)
            
            DispatchQueue.main.async {
               self.foodLogs = fetchedFoodLogs
            }
            
         } catch {
            logger.error("Error fetching food log: \(error)")
         }
      }
   }
   
   func fetchActivity() {
      DispatchQueue.global(qos: .background).async { [weak self] in
         guard let self = self else { return }
         
         do {
            guard let _ = user.id else { return logger.error("No user with that id") }
            
            let request: NSFetchRequest<Activity> = Activity.fetchRequest()
            request.predicate = NSPredicate(format: "user.id == %@", user.id! as NSUUID)
            
            let fetchedActivities = try self.viewContext.fetch(request)
            
            DispatchQueue.main.async {
               self.activities = fetchedActivities
            }
         } catch {
            logger.error("Error fetching data: \(error)")
         }
      }
   }
   
   func deleteEntity(_ entity: NSManagedObject) {
      guard let entityName = entity.entity.name else { return logger.error("Couldn't find \(entity) to delete") }
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
      fetchRequest.predicate = NSPredicate(format: "SELF == %@", entity.objectID)
      let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
      
      do {
         try viewContext.execute(batchDeleteRequest)
         try viewContext.save()
      } catch {
         logger.error("Failed to delete entity: \(error.localizedDescription)")
      }
   }
   
   func checkForUpdates() {
      logger.info("Checking for updates")
//
//      let request: NSFetchRequest<User> = User.fetchRequest()
//      request.predicate = NSPredicate(format: "id == %@", user.id! as NSUUID)
//
//      do {
//         let result = try viewContext.fetch(request)
//         
//         // If no user with this id is found, load mock data
//         if result.isEmpty {
//            logger.info("User not found, loading mock data")
//            loadMockUserData(context: viewContext)
//         } else {
//            logger.info("User with this ID exists")
//         }
//         
//      } catch {
//         logger.error("Failed to fetch user: \(error)")
//         loadMockUserData(context: viewContext) // Optionally handle errors by loading mock data
//      }
      
//      guard let _ = user.id else {
//         loadMockUserData(context: viewContext)
//         return
//      }
      
      
//      guard let url = Bundle.main.url(forResource: "mockUserData", withExtension: "json"),
//            let data = try? Data(contentsOf: url) else {
//         logger.error("Failed to load mockUserData.json")
//         return
//      }
//      
//      let decoder = JSONDecoder()
//      guard let response = try? decoder.decode(Response.self, from: data) else {
//         logger.error("Failed to decode JSON data")
//         return
//      }
//      
//      guard let items = foodLog.items as? Set<FoodItem> else {
//         return
//      }
//      
//      let foodLogArray = Array(items).sorted { $0.wrappedName < $1.wrappedName }
//      
//      let currentFoodLog = FoodLogResponse(items: foodLogArray.map { FoodItemResponse(name: $0.wrappedName, calories: Int($0.calories)) } )
//      
//      let currentActivity = ActivityResponse(
//         name: activity.wrappedName,
//         averageHeartbeat: Int(activity.averageHeartbeat),
//         caloriesBurned: Int(activity.caloriesBurned),
//         timeElapsed: Int(activity.timeElapsed)
//      )
//      
//      let currentUser = UserResponse(
//         name: self.name,
//         sex: self.sex,
//         age: self.age,
//         weight: self.weight,
//         activity: currentActivity,
//         foodLog: currentFoodLog
//      )
//      
//      if response.user != currentUser {
//         deleteEntity(user)
//         users = []
//         deleteEntity(activity)
//         activities = []
//         deleteEntity(foodLog)
//         foodLogs = []
//         
//         storeInCoreData(response: response)
//         
//         logger.info("ViewModel data updated from JSON")
//      } else {
//         logger.info("ViewModel data is up-to-date")
//      }
   }
   
   func storeInCoreData(response: Response) {
      let user = User(context: viewContext)
      user.id = UUID()
      user.name = response.user.name
      user.sex = response.user.sex
      user.age = Int16(response.user.age)
      user.weight = Int16(response.user.weight)
      
      let activity = Activity(context: viewContext)
      activity.id = UUID()
      activity.name = response.user.activity.name
      activity.averageHeartbeat = Int16(response.user.activity.averageHeartbeat)
      activity.caloriesBurned = Int16(response.user.activity.caloriesBurned)
      activity.timeElapsed = Int16(response.user.activity.timeElapsed)
      
      user.activity = activity
      

      
      let foodLog = FoodLog(context: viewContext)
      foodLog.id = UUID()
      
      for item in response.user.foodLog.items {
         let foodItem = FoodItem(context: viewContext)
         foodItem.id = UUID()
         foodItem.name = item.name
         foodItem.calories = Int16(item.calories)
         
         foodLog.mealsHad += 1
         foodLog.caloriesConsumed += Int16(item.calories)
         foodLog.addItem(foodItem)
      }
      
      user.foodLog = foodLog
      do {
         try viewContext.save()
         self.fetchUsers()
         self.fetchFoodLog()
         self.fetchActivity()
      } catch {
         logger.error("Failed to save data to Core Data: \(error)")
      }
   }
}

class PreviewViewModel: ViewModel {
   override var viewContext: NSManagedObjectContext {
      PersistenceController.preview.container.viewContext
   }
   
   override func fetchData() {
      fetchUsers()
      fetchFoodLog()
      fetchActivity()
   }
}







#Preview {
    ContentView(viewModel: PreviewViewModel())
        .preferredColorScheme(.dark)
}

// MARK: Sleep/Steps Charts

//            GroupBox(label: Label("Sleep", systemImage: "bed.double.fill")) {
//
//            }.padding()
            
//            GroupBox(label: Label("Weekly Steps", systemImage: "shoeprints.fill")) {
//                Chart {
//                    BarMark(x: .value("Type", "SU"),
//                            y: .value("Sleep", 5))
//                    .opacity(0.5)
//                    .cornerRadius(10)
//
//                    BarMark(x: .value("Type", "M"),
//                            y: .value("Sleep", 6))
//                    .opacity(0.5)
//                    .cornerRadius(10)
//
//                    BarMark(x: .value("Type", "TU"),
//                            y: .value("Sleep", 7))
//                              .cornerRadius(10)
//
//                    BarMark(x: .value("Type", "W"),
//                            y: .value("Sleep", 6))
//                    .opacity(0.5)
//                    .cornerRadius(10)
//
//                    BarMark(x: .value("Type", "TH"),
//                            y: .value("Sleep", 10))
//                    .opacity(0.5)
//                    .cornerRadius(10)
//
//                    BarMark(x: .value("Type", "F"),
//                            y: .value("Sleep", 8))
//                    .opacity(0.5)
//                    .cornerRadius(10)
//
//                    BarMark(x: .value("Type", "SA"),
//                            y: .value("Sleep", 7))
//                    .opacity(0.5)
//                    .cornerRadius(10)
//
//                }
//                .aspectRatio(1, contentMode: .fit)
//                .chartYScale(domain: [0, 10])
//                .chartYAxis {
//                    AxisMarks(
//                        format: .number,
//                            values: [2, 4, 6, 8, 10]
//                        )
//                }
//            }.padding()
