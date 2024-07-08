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
            TimerView()
                .padding(.top, 35)
            
            //Using the custom time picker
            
            TimePicker(hour: $flipClockTime.hour, minutes: $flipClockTime.minutes, seconds: $flipClockTime.seconds)
            
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(background.gradient)
    }
    
    @ViewBuilder
    func TimerView() -> some View {
        //Fliping Clock
        let size : CGSize = .init(width: 100, height: 120)
        HStack(spacing: 10){
            TimerViewHelper("Hours", value: $flipClockTime.hour, size: size)
            TimerViewHelper("Minutes", value: $flipClockTime.minutes, size: size)
            TimerViewHelper("Seconds", value: $flipClockTime.seconds, size: size)
        }
        .frame(maxWidth: .infinity)
    }
    @ViewBuilder
    func TimerViewHelper(_ title: String, value: Binding<Int>, size: CGSize) -> some View {
        VStack(spacing: 10){
            FlipClockTextEffect(value: value, size: size, fontSize: 60, cornerRadius: 18, foreground: .black, background: .white)
            
            Text(title)
                .font(.callout)
                .foregroundStyle(.white.opacity(0.8))
        }
    }
}

#Preview {
   ContentView()
}
