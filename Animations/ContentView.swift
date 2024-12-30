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
        ZStack {
            VStack {
                Stepper("Scale amount: \(scaleAmount.formatted())", value: $scaleAmount.animation(
                    .easeInOut(duration: 0.7)
                        .repeatCount(3, autoreverses: true)
                ), in: 1...10, step: 1)
                .zIndex(1) // Ensure Stepper stays on top
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(duration: 1, bounce: 0.5)) {
                        spinAmount += 360
                    }
                    scaleAmount += 1
                }) {
                    Image("pokestop")
                }
                .clipShape(Circle())
                .scaleEffect(scaleAmount)
                .overlay(Circle()
                    .stroke(.blue)
                    .scaleEffect(scaleAmount)
                    .opacity(2 - scaleAmount)
                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: scaleAmount)
                )
                .rotation3DEffect(.degrees(spinAmount), axis: (x: 0, y: 1, z: 0))
                .onAppear {
                    scaleAmount = 1
                }
                
                Spacer()
            }
            .padding(.all, 40)
        }
    }
}

#Preview {
    ContentView()
}
