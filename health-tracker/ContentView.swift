//
//  ContentView.swift
//  health-tracker
//
//  Created by Taha Chaudhry on 18/08/2024.
//

import SwiftUI
import CoreData
import os


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
   private static let logger = Logger(
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
            print("Error while fetching data:", error)
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
      isLoggedIn = false
   }
   
   
   func fetchUsers() {
      do {
         let request: NSFetchRequest<User> = User.fetchRequest()
         users = try viewContext.fetch(request)
      } catch {
         print("Error fetching data: \(error)")
      }
   }
   
   func fetchFoodLog() {
      DispatchQueue.global(qos: .background).async { [weak self] in
         guard let self = self else { return }
         
         do {
            guard let _ = user.id else { return print("No user with that id") }
            
            let request: NSFetchRequest<FoodLog> = FoodLog.fetchRequest()
            request.predicate = NSPredicate(format: "user.id == %@", user.id! as NSUUID)
            foodLogs = try viewContext.fetch(request)
            
            let fetchedFoodLogs = try self.viewContext.fetch(request)
            
            DispatchQueue.main.async {
               self.foodLogs = fetchedFoodLogs
            }
            
         } catch {
            print("Error fetching food log")
         }
      }
   }
   
   func fetchActivity() {
      DispatchQueue.global(qos: .background).async { [weak self] in
         guard let self = self else { return }
         
         do {
            guard let _ = user.id else { return print("No user with that id") }
            
            let request: NSFetchRequest<Activity> = Activity.fetchRequest()
            request.predicate = NSPredicate(format: "user.id == %@", user.id! as NSUUID)
            
            let fetchedActivities = try self.viewContext.fetch(request)
            
            DispatchQueue.main.async {
               self.activities = fetchedActivities
            }
         } catch {
            print("Error fetching data: \(error)")
         }
      }
   }
   
   func deleteEntity(_ entity: NSManagedObject) {
      guard let entityName = entity.entity.name else { return print("Couldn't find \(entity) to delete") }
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
      fetchRequest.predicate = NSPredicate(format: "SELF == %@", entity.objectID)
      let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
      
      do {
         try viewContext.execute(batchDeleteRequest)
         try viewContext.save()
      } catch {
         print("Failed to delete entity: \(error.localizedDescription)")
      }
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
         print("Failed to save data to Core Data: \(error)")
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
