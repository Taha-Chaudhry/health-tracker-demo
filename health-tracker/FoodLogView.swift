//
//  FoodLogView.swift
//  health-tracker
//
//  Created by Taha Chaudhry on 20/08/2024.
//

import SwiftUI

struct FoodLogView: View {
    @ObservedObject public var viewModel: ViewModel
    
    var body: some View {
        if let items = viewModel.foodLog.items as? Set<FoodItem> {
        let foodLog = Array(items).sorted { $0.wrappedName < $1.wrappedName }
            GroupBox {
                HStack {
                    Label(foodLog.isEmpty ? "No Food Logged Yet!" : "\(viewModel.foodLog.caloriesConsumed) calories, \(viewModel.foodLog.mealsHad) meals", systemImage: "fork.knife")
                        .font(.title3)
                        .bold()
                    Spacer()
                }
                
                if foodLog.isEmpty {
                    NoItemsView(viewModel: viewModel)
                } else {
                    ItemScrollView(viewModel: viewModel, foodLog: foodLog)
                }
                
                
                Divider()
                HStack {
                    Button {
                        viewModel.isAddingFood = true
                    } label: {
                        Label("Add Food", systemImage: "plus")
                            .frame(maxWidth: .infinity, maxHeight: 30)
                        Spacer()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.yellow)
                }
                .padding(.top, 1)
                .sheet(isPresented: $viewModel.isAddingFood, content: {
                    AddingFoodView(viewModel: viewModel, isAddingFood: $viewModel.isAddingFood)
                        .presentationDetents([.medium])
                    
                })
            }
            .padding()
        }
    }
}

struct NoItemsView: View {
    @ObservedObject public var viewModel: ViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "basket.fill")
                .font(.system(size: 70))
                .foregroundStyle(.secondary)
                .padding(.top, 5)
            Text("When you add items to your food log, they will show up here")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 5)
        }
        .padding()
    }
}

struct ItemScrollView: View {
    @ObservedObject public var viewModel: ViewModel
    public var foodLog: Array<FoodItem>
    var string = "dddd"
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            ForEach(foodLog, id: \.self) { item in
                Divider()
                HStack {
                    HStack {
                        Text("•")
                            .bold()
                        Text(LocalizedStringKey(item.wrappedName))
                    }
                    .font(.subheadline)
                    Spacer()
                    HStack {
                        Text("\(item.calories)")
                            .font(.title2)
                        Text("cal")
                            .font(.subheadline)
                            .padding(.trailing, 12)
                    }
                }
                .padding([.top, .bottom], 4)
                .contentShape(Rectangle())
                .contextMenu {
                    Button {
                        viewModel.foodLog.mealsHad -= 1
                        viewModel.foodLog.caloriesConsumed -= item.calories
                        viewModel.foodLog.removeItem(item)
                        viewModel.fetchFoodLog()
                    } label: {
                        Label("Remove", systemImage: "xmark")
                    }
                }
            }
        }.frame(height: 140)
    }
}

#Preview {
    FoodLogView(viewModel: PreviewViewModel())
        .environment(\.locale, .init(identifier: "ar"))
}
