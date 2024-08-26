//
//  MetricsView.swift
//  health-tracker
//
//  Created by Taha Chaudhry on 20/08/2024.
//

import SwiftUI

struct MetricsView: View {
    @ObservedObject public var viewModel: ViewModel
    var body: some View {
        VStack {
            HStack {
                Text("Hey \(viewModel.user.wrappedFirstName)!")
                    .font(.title)
                    .bold()
                
                Spacer()
                Button {
                    viewModel.isViewingProfile = true
                } label: {
                    Image(systemName: "person.circle")
                        .fontWeight(.light)
                        .font(.largeTitle)
                }.sheet(isPresented: $viewModel.isViewingProfile, content: {
                    ProfileView(viewModel: viewModel)
                        .presentationDetents([.medium])
                })
            }.padding([.leading, .trailing, .top])
            HStack {
                Text("Today's Metrics")
                    .font(.caption)
                    .bold()
                    .padding(.leading)
                Spacer()
            }
            HStack {
                VStack {
                    ZStack {
                        Circle()
                            .fill(RadialGradient(
                                gradient: Gradient(colors: [Color.orange, Color.red]),
                                center: .center,
                                startRadius: 5,
                                endRadius: 60
                            ))
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "flame.fill")
                            .foregroundStyle(.white)
                            .font(.system(size: 40))
                    }
                    Text("1000 CAL")
                        .font(.footnote)
                        .bold()
                    ProgressView(value: 0.8)
                        .progressViewStyle(GradientProgressBarStyle(
                            gradientColors: [Color.purple, Color.blue],
                            cornerRadius: 20,
                            barWidth: 60,
                            barHeight: 5
                        ))
                }.padding([.leading, .trailing, .top])
                
                VStack {
                    ZStack {
                        Circle()
                            .fill(RadialGradient(
                                gradient: Gradient(colors: [Color(red: 1.0, green: 0.45, blue: 0.8), Color(red: 1.0, green: 0.2, blue: 0.6)]),
                                center: .center,
                                startRadius: 5,
                                endRadius: 50
                            ))
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "heart.fill")
                            .foregroundStyle(.white)
                            .font(.system(size: 40))
                    }
                    
                    Text("90 BPM")
                        .font(.footnote)
                        .bold()
                }.padding([.bottom])
                
                VStack {
                    ZStack {
                        Circle()
                            .fill(RadialGradient(
                                gradient: Gradient(colors: [Color.green, Color.teal]),
                                center: .center,
                                startRadius: 15,
                                endRadius: 85
                            ))
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "figure.walk")
                            .foregroundStyle(.white)
                            .font(.system(size: 40))
                    }
                    
                    Text("200 STEPS")
                        .font(.footnote)
                        .bold()
                    ProgressView(value: 0.3)
                        .progressViewStyle(GradientProgressBarStyle(
                            gradientColors: [Color.purple, Color.blue],
                            cornerRadius: 20,
                            barWidth: 60,
                            barHeight: 5
                        ))
                }.padding([.leading, .trailing, .top])
            }
        }
    }
}

#Preview {
    VStack {
        MetricsView(viewModel: PreviewViewModel())
        Spacer()
    }
}
