//
//  DateExtension.swift
//  SaldoDeHoras
//
//  Created by Iago Mordente Rezende Leão Corrêa on 25/06/18.
//  Copyright © 2018 Iago Mordente Rezende Leão Corrêa. All rights reserved.
//

import Foundation

extension Date {
    static func isCheckFromToday (check: Check) -> Bool {
        let today = Date()
        let calendar = NSCalendar(identifier: .gregorian)
        let todayMonth = calendar?.component(.month, from: today)
        let todayDay = calendar?.component(.day, from: today)
        let todayYear = calendar?.component(.year, from: today)
        let checkMonth = calendar?.component(.month, from: check.date as! Date)
        let checkDay = calendar?.component(.day, from: check.date as! Date)
        let checkYear = calendar?.component(.year, from: check.date as! Date)
        
        return todayDay == checkDay && todayMonth == checkMonth && todayYear == checkYear
    }
    
    static func getWeekDays() -> [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dayOfWeek = calendar.component(.weekday, from: today)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound)
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
            .filter { !calendar.isDateInWeekend($0) }
        return days
    }
}
