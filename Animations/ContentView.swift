//
//  ContentView.swift
//  Animations
//
//  Created by Kevin Darmawan on 29/12/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var scaleAmount = 1.0
    @State private var spinAmount: Double = 0
    var body: some View {
        print(scaleAmount)
        
        return VStack {
            Stepper("Scale amount: \(scaleAmount.formatted())", value: $scaleAmount.animation(
                .easeInOut(duration: 0.7)
                    .repeatCount(3, autoreverses: true)
            ), in: 1...10)
            Spacer()
            Button("Tap Me") {
                withAnimation(.spring(duration: 1, bounce: 0.5)) {
                    spinAmount += 360
                }
                scaleAmount += 1
            }
            .padding(50)
            .background(.red)
            .foregroundStyle(.white)
            .clipShape(.circle)
            .scaleEffect(scaleAmount)
            .overlay(Circle()
                .stroke(.red)
                .scaleEffect(scaleAmount)
                .opacity(2 - scaleAmount)
                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: scaleAmount)
            )
            .rotation3DEffect(.degrees(spinAmount), axis: (x:0, y:1, z:0))
            .onAppear {
                scaleAmount = 1
            }
            Spacer()
        }
        .padding(.all, 40)
    }
}

#Preview {
    ContentView()
}
