//
//  ActivitySummaryView.swift
//  health-tracker
//
//  Created by Taha Chaudhry on 20/08/2024.
//

import SwiftUI

struct ActivitySummaryView: View {
    @ObservedObject public var viewModel: ViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient(gradient: Gradient(colors: colorScheme == .dark ? [Color.blue.opacity(0.2), Color.black] : [Color.black, Color.indigo]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(maxWidth: .infinity, minHeight: 150, maxHeight: 150)
                .shadow(color: colorScheme == .dark ? Color.white.opacity(0.12) : Color.black, radius: 10)
            VStack {
                HStack {
                    ZStack {
                        Circle()
                            .frame(maxWidth: 40, maxHeight: 40)
                            .foregroundStyle(.black)
                            .shadow(color: Color.white.opacity(0.2), radius: 3)
                        Image(systemName: "figure.run")
                            .foregroundStyle(.white)
                    }
                    Text("\(viewModel.activity.wrappedName)")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.white)
                    Spacer()
                }.padding([.leading, .trailing])
                
                VStack {
                    HStack {
                        Text("\(viewModel.activity.formattedTime) elapsed")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    HStack {
                        Label("\(viewModel.activity.averageHeartbeat) BPM", systemImage: "heart.fill")
                            .foregroundStyle(.pink)
                        Label("\(viewModel.activity.caloriesBurned) CAL", systemImage: "flame.fill")
                            .foregroundStyle(.red)
                        Spacer()
                        Spacer()
                        Image(systemName: "arrow.right")
                            .foregroundStyle(.white)
                            .padding(.trailing)
                        
                    }
                }.padding(.leading)
                
            }
        }.padding()
    }
    
    // Placeholder function for navigation action
    func navigateToFullView() {
        // Navigate to the detailed activity view
        // This would typically use a NavigationLink in a real app
        print("Navigating to full activity view...")
    }
}

#Preview {
    VStack {
        ActivitySummaryView(viewModel: PreviewViewModel())
            .preferredColorScheme(.dark)
        Spacer()
    }
}
