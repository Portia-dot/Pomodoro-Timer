//
//  Home.swift
//  Pomodoro Timer
//
//  Created by Modamori Oluwayomi on 2024-06-30.
//

import SwiftUI

struct Home: View {
    
    @State private var timer: CGFloat = 0
    @State private var count: Int = 0
    @State private var background: Color = .red
    @State private var flipClockTime: Time = .init()
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Pomodoro")
                .font(.largeTitle.bold())
                .padding(.top, 15)
                .foregroundStyle(.white)
            
            //Fliping Clock
            let size : CGSize = .init(width: 100, height: 120)
            FlipingClockEffect(value: $flipClockTime.hour, size: size, fontSize: 60, cornerRadius: 18, foreground: .black, background: .white)
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(background.gradient)
    }
}

#Preview {
   ContentView()
}
