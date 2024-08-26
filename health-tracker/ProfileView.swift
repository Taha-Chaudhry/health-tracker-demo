//
//  ProfileView.swift
//  health-tracker
//
//  Created by Taha Chaudhry on 20/08/2024.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject public var viewModel: ViewModel
    var body: some View {
        VStack {
            VStack {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 200))
                    .padding(.top, 100)
                Text(viewModel.user.wrappedFirstName)
                
                Divider()
                    .padding(.top, 20)
                HStack {
                    VStack {
                        Text("Age")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Text("\(viewModel.user.age)")
                            .font(.title3)
                    }.padding([.leading, .trailing], 20)
                    Spacer()
                    VStack {
                        Text("Weight")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Text("\(viewModel.user.weight) kg")
                            .font(.title3)
                    }.padding([.leading, .trailing], 20)
                    Spacer()
                    VStack {
                        Text("Sex")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Text("\(viewModel.user.wrappedSex)")
                            .font(.title3)
                    }.padding([.leading, .trailing], 20)
                }.padding()
                
                Button("Logout") {
                    withAnimation {
                        viewModel.logout()
                    }
                }
                .buttonStyle(ConfirmButtonStyle())
                .padding()
                .padding(.bottom, 60)
            }
            .padding()
            .padding(.top)
            Spacer()
        }.padding(.bottom)
    }
}

#Preview {
    ProfileView(viewModel: PreviewViewModel())
}
