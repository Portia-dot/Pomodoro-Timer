//
//  FlipingClockEffect .swift
//  Pomodoro Timer
//
//  Created by Modamori Oluwayomi on 2024-06-30.
//

import SwiftUI

struct FlipingClockEffect: View {
    @Binding  var value: Int
    
    var size: CGSize
    var fontSize: CGFloat
    var cornerRadius: CGFloat
    var foreground: Color
    var background: Color
    var animationDuration: CGFloat = 0.8
    
    @State private var nextValue: Int = 0
    @State private var currentValue: Int = 0
    @State private var rotation: CGFloat = 0
    var body: some View {
        let halfHeight = size.height * 0.5
        
        ZStack{
            UnevenRoundedRectangle(topLeadingRadius: cornerRadius, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: cornerRadius)
                .fill(background.shadow(.inner(radius: 1)))
                .overlay(alignment: .top){
                    TextView(currentValue)
                        .frame(width: size.width, height: size.height)
                        .drawingGroup()
                }
                .clipped()
                .frame(maxWidth: .infinity, alignment: .top)
            UnevenRoundedRectangle(topLeadingRadius: cornerRadius, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: cornerRadius)
                .fill(background.shadow(.inner(radius: 1)))
                .frame(height: halfHeight)
                .modifier(
                RotationModifider(rotation: rotation, currentValue: currentValue, nextValue: nextValue, fontSize: fontSize, foreground: foreground, size: size)
                )
                .clipped()
                .rotation3DEffect(
                    .init(degrees: rotation),
                    axis: (x: 1.0, y: 0.0, z: 0.0),
                    anchor: .bottom,
                    anchorZ: 0.01,
                    perspective: 0.4
                )
                .frame(maxHeight: .infinity, alignment: .top)
                .zIndex(10)
            UnevenRoundedRectangle(topLeadingRadius: cornerRadius, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: cornerRadius)
                .fill(background.shadow(.inner(radius: 1)))
                .frame(height: halfHeight)
                .modifier(
                RotationModifider(rotation: rotation, currentValue: currentValue, nextValue: nextValue, fontSize: fontSize, foreground: foreground, size: size)
                )
                .clipped()
                .rotation3DEffect(
                    .init(degrees: rotation),
                    axis: (x: 1.0, y: 0.0, z: 0.0),
                    anchor: .bottom,
                    anchorZ: 0.01,
                    perspective: 0.4
                )
                .frame(maxHeight: .infinity, alignment: .top)
                .zIndex(10)
        }
        .frame(width: size.width, height: size.height)
        .onChange(of: value, initial: true) { oldValue, newValue in
            currentValue = oldValue
            nextValue = newValue
            
            guard rotation == 0 else{
                currentValue = newValue
                return
            }
            guard oldValue != newValue else { return }
            
            withAnimation(.easeInOut(duration: animationDuration), completionCriteria: .logicallyComplete){
                rotation = -180
            }completion: {
                rotation = 0
                currentValue =  value
            }
        }
    }
    @ViewBuilder
    func TextView(_ value: Int) -> some View {
        Text("\(value)")
            .font(.system(size: fontSize).bold())
            .foregroundStyle(foreground)
            .lineLimit(1)
    }
}

fileprivate struct RotationModifider: ViewModifier, Animatable {
    var rotation: CGFloat
    var currentValue: Int
    var nextValue: Int
    var fontSize: CGFloat
    var foreground: Color
    var size: CGSize
    
    var animatableData: CGFloat {
        get {rotation}
        set {rotation = newValue}
    }
    func body(content: Content) -> some View {
        content
        
    }
}

#Preview {
   ContentView()
}
