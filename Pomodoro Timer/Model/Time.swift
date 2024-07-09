//
//  Time.swift
//  Pomodoro Timer
//
//  Created by Modamori Oluwayomi on 2024-06-30.
//

import SwiftUI
struct Time: Hashable {
    var hour: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    
    var isZero : Bool {
        return hour == 0 && minutes == 0 && seconds == 0
    }
    
    var totalInSeconds: Int {
        return (hour * 60 * 60) + (minutes * 60) + seconds
    }
}
