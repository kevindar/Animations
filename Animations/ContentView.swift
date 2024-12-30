//
//  ContentView.swift
//  Animations
//
//  Created by Kevin Darmawan on 29/12/24.
//

import SwiftUI

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotatedModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotatedModifier(amount: 0, anchor: .topLeading)
        )
    }
}

struct ContentView: View {
    
    let letters = Array("Hello SwiftUI")
    
    @State private var scaleAmount = 1.0
    @State private var spinAmount: Double = 0
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero
    @State private var alakazam = true
    
    var body: some View {
        ZStack {
            VStack {
                // Animated Letters
                AnimatedLettersView(letters: letters, dragAmount: $dragAmount, enabled: $enabled, alakazam: $alakazam)
                    .zIndex(1)
                ZStack {
                    Rectangle()
                        .fill(.blue)
                        .frame(width: 200, height: 75)
                    // Abra Kadabra Button
                    if alakazam {
                        Rectangle()
                            .frame(width: 200, height: 75)
                            .foregroundStyle(.red)
                            .transition(.pivot)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        alakazam.toggle()
                    }
                }
                Spacer()
                
                // Stepper for Scale
                Stepper("Scale amount: \(scaleAmount.formatted())", value: $scaleAmount.animation(
                    .easeInOut(duration: 0.7).repeatCount(3, autoreverses: true)
                ), in: 1...10)
                .zIndex(2)
                .padding()
                
                Spacer()
                
                // Tap Me Button
                Button("Tap Me") {
                    withAnimation(.spring(duration: 1, bounce: 0.5)) {
                        spinAmount += 360
                        scaleAmount += 1
                        enabled.toggle()
                    }
                }
                .frame(width: 150, height: 150)
                .background(enabled ? .green : .red)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
                .scaleEffect(scaleAmount)
                .rotation3DEffect(.degrees(spinAmount), axis: (x: 0, y: 1, z: 0))
                
                Spacer()
            }
            .padding(40)
        }
    }
}

struct AnimatedLettersView: View {
    let letters: [Character]
    @Binding var dragAmount: CGSize
    @Binding var enabled: Bool
    @Binding var alakazam: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<letters.count, id: \.self) { num in
                Text(String(letters[num]))
                    .padding(5)
                    .font(.title)
                    .background(
                        GeometryReader { geometry in
                            LinearGradient(
                                colors: [enabled ? .blue : .yellow, enabled ? .pink : .red],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        }
                    )
                    .offset(dragAmount)
                    .animation(.linear.delay(Double(num) / 20), value: dragAmount)
            }
        }
        .gesture(
            DragGesture()
            .onChanged { dragAmount = $0.translation }
            .onEnded { _ in
                withAnimation(.bouncy) {
                    dragAmount = .zero
                    enabled.toggle()
                    alakazam.toggle()
                }
            }
        )
    }
}

struct CornerRotatedModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

#Preview {
    ContentView()
}
