//
//  AddingFoodView.swift
//  health-tracker
//
//  Created by Taha Chaudhry on 19/08/2024.
//

import SwiftUI

struct AddingFoodView: View {
    @ObservedObject public var viewModel: ViewModel
    
    @Binding public var isAddingFood: Bool
    @State public var foodName: String = ""
    @State public var foodCalories: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("Name") {
                    TextField("Cheeseburger with Fries...", text: $foodName)
                        .padding()
                }
                
                Section("Calories") {
                    TextField("1700...", text: $foodCalories)
                        .padding()
                        .keyboardType(.numberPad)
                }
                
                Button {
                    guard foodName != "" else {
                        return
                    }
                    
                    guard foodCalories != "" else {
                        return
                    }
                    
                    let foodItem = FoodItem(context: viewModel.viewContext)
                    foodItem.name = foodName
                    foodItem.calories = Int16(foodCalories) ?? 0
                    
                    viewModel.foodLog.mealsHad += 1
                    viewModel.foodLog.caloriesConsumed += foodItem.calories
                    viewModel.foodLog.addItem(foodItem)
                    
                    isAddingFood = false
                } label: {
                    Text("Add")
                }
                .buttonStyle(ConfirmButtonStyle())
                .listRowBackground(Color.clear)
            }
        }
    }
}

#Preview {
    struct Preview: View {
        @State private var isAddingFood: Bool = false
        var body: some View {
            AddingFoodView(viewModel: PreviewViewModel(), isAddingFood: $isAddingFood)
                .preferredColorScheme(.dark)
        }
    }
    return Preview()
}
