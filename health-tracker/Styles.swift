//
//  ProgressBarStyles.swift
//  health-tracker
//
//  Created by Taha Chaudhry on 19/08/2024.
//

import SwiftUI

struct GradientProgressBarStyle: ProgressViewStyle {
    var gradientColors: [Color]
    var cornerRadius: CGFloat
    var barWidth: CGFloat
    var barHeight: CGFloat
    
    @ViewBuilder
    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.gray.opacity(0.3))
                .frame(width: barWidth, height: barHeight)
            
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    LinearGradient(gradient: Gradient(colors: gradientColors),
                                   startPoint: .leading,
                                   endPoint: .trailing)
                )
                .frame(width: CGFloat(configuration.fractionCompleted ?? 0) * barWidth, height: barHeight)
        }
    }
}

struct ConfirmButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.yellow)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.6 : 1.0)
    }
}

#Preview {
    VStack {
        ProgressView(value: 0.5)
            .progressViewStyle(GradientProgressBarStyle(
                gradientColors: [Color.orange, Color.red],
                cornerRadius: 10,
                barWidth: 50,
                barHeight: 20
            ))
            .padding()
        Button("Confirm") {
        }
        .buttonStyle(ConfirmButtonStyle())
        .padding()
    }
}
