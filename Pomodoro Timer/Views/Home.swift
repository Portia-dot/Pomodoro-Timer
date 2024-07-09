//
//  Home.swift
//  Pomodoro Timer
//
//  Created by Modamori Oluwayomi on 2024-06-30.
//

import SwiftUI
import SwiftData

struct Home: View {
    
//    @State private var timer: CGFloat = 0
    @State private var count: Int = 0
    @State private var background: Color = .red
    @State private var flipClockTime: Time = .init()
    @State private var pickerTimer: Time = .init()
    @State private var startTimer: Bool = false
    @Environment(\.modelContext) private var context
    @State private var totalTimeInSeconds: Int = 0
    @State private var timerCount: Int =  0
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Query(sort: [SortDescriptor(\Recent.date, order: .reverse)], animation: .snappy)
    private var recents: [Recent]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Pomodoro")
                .font(.largeTitle.bold())
                .padding(.top, 15)
                .foregroundStyle(.white)
            TimerView()
                .padding(.top, 35)
                .offset(y: -15)
            
            //Using the custom time picker
            
            TimePicker(style: .init(.gray.opacity(0.15)), hour: $pickerTimer.hour, minutes: $pickerTimer.minutes, seconds: $pickerTimer.seconds)
                .environment(\.colorScheme, .light)
                .padding(15)
                .background(.white, in: .rect(cornerRadius: 10))
                .onChange(of: pickerTimer){ oldValue, newValue in
                    flipClockTime = newValue
                }
                .disableWithOpacity(startTimer)
            
            TimerButton()
            
            RecentView()
                .disableWithOpacity(startTimer)
            
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(background.gradient)
        .onReceive(timer) { _ in
            if startTimer {
                if timerCount > 0 {
                    timerCount -= 1
                    updateFlipClock()
                }else {
                    stopTimer()
                }
            }else {
                timer.upstream.connect().cancel()
            }
        }
    }
    
    //Update flip clock value
    
    func updateFlipClock() {
        let hour = (timerCount / 3600) % 24
        let minutes = (timerCount / 60) % 60
        let seconds = (timerCount) % 60
        
        flipClockTime = .init(hour: hour, minutes: minutes, seconds: seconds)
    }
    
    // Start and Stop Timer Button
    
    @ViewBuilder
    func TimerButton() -> some View {
        Button{
            startTimer.toggle()
            
            if startTimer {
                startTimerCount()
            }else{
                stopTimer()
            }
        }label: {
            Text(!startTimer ? "Start Timer" : "Stop Timer")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(.white, in: .rect(cornerRadius: 10))
                .contentShape(.rect(cornerRadius: 10))
        }
        .disableWithOpacity(flipClockTime.isZero && !startTimer)
    }
    
    
    func startTimerCount() {
        totalTimeInSeconds = flipClockTime.totalInSeconds
        timerCount = totalTimeInSeconds - 1
        //Check if its already exist
        if !recents.contains(where: { $0.totalInSeconds ==  totalTimeInSeconds}){
            //Save it in recents
            let recent = Recent(hour: flipClockTime.hour, minute: flipClockTime.minutes, seconds: flipClockTime.seconds)
            context.insert(recent)
        }
        
        updateFlipClock()
        
        timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    }
    
    func stopTimer() {
        startTimer = false
        totalTimeInSeconds = 0
        timerCount =  0
        flipClockTime = .init()
        withAnimation(.linear){
            pickerTimer = .init()
        }
        timer.upstream.connect().cancel()
    }
    
    @ViewBuilder
    func RecentView() -> some View {
        VStack(alignment: .leading, spacing: 10){
            Text("Recents")
                .font(.callout)
                .foregroundStyle(.white.opacity(0.8))
                .opacity(recents.isEmpty ? 0 : 1)
            
            ScrollView(.horizontal){
                HStack(spacing: 12){
                    ForEach(recents){ value in
                        let isHour = value.hour > 0
                        let isSeconds = value.minute == 0 && value.hour == 0 && value.seconds != 0
                        HStack(spacing: 0){
                            Text(isHour ? "\(value.hour)" : isSeconds ? "\(value.seconds)" : "\(value.minute)")
                            Text(isHour ? "h" : isSeconds ? "s" : "m")
                        }
                        .font(.callout)
                        .foregroundStyle(.black)
                        .frame(width: 50, height: 50)
                        .background(.white, in: .circle)
                        .contentShape(.contextMenuPreview, .circle)
                        .contextMenu{
                            Button("Delete", role: .destructive){
                                context.delete(value)
                            }
                        }
                        .onTapGesture {
                            withAnimation(.linear) {
                                pickerTimer = .init(hour: value.hour, minutes: value.minute, seconds: value.seconds)
                            }
                        }
                    }
                }
                .padding(.vertical, 10)
                .padding(.leading, 10)
            }
            .scrollIndicators(.hidden)
            .padding(.leading, -10)
            
            
        }
        .padding(.top, 10)
    }
    
    @ViewBuilder
    func TimerView() -> some View {
        //Fliping Clock
        let size : CGSize = .init(width: 100, height: 120)
        HStack(spacing: 0){
            TimerViewHelper("Hours", value: $flipClockTime.hour, size: size)
            TimerViewHelper("Minutes", value: $flipClockTime.minutes, size: size)
            TimerViewHelper("Seconds", value: $flipClockTime.seconds, size: size, isLast: true)
        }
        .frame(maxWidth: .infinity)
    }
    @ViewBuilder
    func TimerViewHelper(_ title: String, value: Binding<Int>, size: CGSize, isLast:Bool = false) -> some View {
        Group{
            VStack(spacing: 10){
                FlipClockTextEffect(value: value, size: size, fontSize: 60, cornerRadius: 18, foreground: .black, background: .white)
                
                Text(title)
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.8))
                    .fixedSize()
            }
            if !isLast {
                VStack(spacing: 15){
                    Circle()
                        .fill(.white)
                        .frame(width: 10, height: 10)
                    Circle()
                        .fill(.white)
                        .frame(width: 10, height: 10)
                }
                .frame(maxWidth: .infinity)
            }
        }
        
    }
}

#Preview {
   ContentView()
        .modelContainer(for: Recent.self)
}


extension View {
    @ViewBuilder
    func disableWithOpacity(_ condition: Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.5 : 1)
            .animation(.easeInOut(duration: 0.3), value: condition)
    }
}
