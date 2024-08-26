//
//  LoginView.swift
//  health-tracker
//
//  Created by Taha Chaudhry on 21/08/2024.
//

import SwiftUI

struct LoginView: View {
   @ObservedObject public var viewModel: ViewModel
   @Environment(\.colorScheme) var colorScheme
   
   var body: some View {
      VStack(alignment: .leading) {
         Spacer()
         Text("Login")
            .font(.largeTitle)
            .padding(.top)
          
         HStack {
            Text("Full Name")
               .fontDesign(.rounded)
               .bold()
               .foregroundStyle(.secondary)
               .multilineTextAlignment(.leading)
            Spacer()
            Text("This field must be filled")
               .foregroundStyle(.red)
               .opacity(viewModel.showNamePresenceError ? 1 : 0)
         }
         TextField("John Doe...", text: $viewModel.name)
            .padding()
            .background(colorScheme == .dark ? .black : .white)
            .cornerRadius(6)
            .shadow(color: colorScheme == .dark ? Color.white.opacity(0.12) : Color.gray, radius: 3, x: 2, y: 2)
            .shadow(color: colorScheme == .dark ? Color.white.opacity(0.12) : Color.gray, radius: 3, x: -2, y: -2)
            .disableAutocorrection(true)
         HStack {
            Text("Sex")
               .fontDesign(.rounded)
               .bold()
               .foregroundStyle(.secondary)
               .multilineTextAlignment(.leading)
            Spacer()
            Text("This field must be filled")
               .foregroundStyle(.red)
               .opacity(viewModel.showSexPresenceError ? 1 : 0)
         }
         TextField("Male, Female, other..", text: $viewModel.sex)
            .padding()
            .background(colorScheme == .dark ? .black : .white)
            .cornerRadius(6)
            .shadow(color: colorScheme == .dark ? Color.white.opacity(0.12) : Color.gray, radius: 3, x: 2, y: 2)
            .shadow(color: colorScheme == .dark ? Color.white.opacity(0.12) : Color.gray, radius: 3, x: -2, y: -2)
            .padding(.bottom)
         
         
         Text("Weight")
            .fontDesign(.rounded)
            .bold()
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.leading)
            .padding(.top)
         Stepper {
            HStack (alignment: .firstTextBaseline) {
               Text("\(viewModel.weight)")
                  .font(.system(size: 50))
               Text("lbs")
                  .foregroundStyle(.secondary)
            }
         } onIncrement: {
            if viewModel.weight < 1500 {
               viewModel.weight += 1
            }
         } onDecrement: {
            if viewModel.weight != 1 {
               viewModel.weight -= 1
            }
         }
         
         
         Spacer()
         ZStack {
            ProgressView()
               .transition(.opacity)
               .opacity(viewModel.isLoading ? 1 : 0)
               .disabled(!viewModel.isLoading)
            VStack {
               Button {
                  viewModel.login()
               } label: {
                  ZStack {
                     Text("Login")
                  }
               }
               .buttonStyle(ConfirmButtonStyle())
               .opacity(viewModel.isLoading ? 0 : 1)
               .padding()
            }
         }
      }
      .padding([.leading, .trailing])
      .padding([.leading, .trailing])
   }
}

#Preview {
    LoginView(viewModel: PreviewViewModel())
}
