//
//  UserExtension.swift
//  SaldoDeHoras
//
//  Created by Iago Mordente Rezende Leão Corrêa on 02/07/18.
//  Copyright © 2018 Iago Mordente Rezende Leão Corrêa. All rights reserved.
//

import Foundation

extension User {
    
    func updateWorkedHours() {
        let today = Date()
        self.dayWorkedHours = calculateDayWorkedHours(date: today)
        self.weekWorkedHours = calculateWeekWorkedHours()
        self.monthWorkedHours = calculateMonthWorkedHours()
        self.updateHoursBank()
        PersistenceService.saveContext()
    }
    
    func updateHoursBank () {
        self.hoursBank = self.weekWorkedHours - (self.optionsOfUser?.weekWorkHours)! - self.paidHours
    }
    
    func calculateDayWorkedHours(date: Date) -> Int16 {
        guard let checks = self.checksofuser else { return 0 }
        let calendar = NSCalendar.current
        var hours: Int16 = 0
        let dayChecks = self.filterChecks(checks: checks, filter: .day, date: date)
        for (index, check) in dayChecks.enumerated() {
            if index.isEven() && index < dayChecks.count - 1 {
                let date = dayChecks[index+1].date! as Date
                let time = date.timeIntervalSince(check.date! as Date)/3600
                hours += Int16(time)
            }
        }
        
        return hours
    }
    
    func calculateDayWorkedHoursSoFar(date: Date) -> Int16 {
        guard let checks = self.checksofuser else { return 0 }
        let calendar = NSCalendar.current
        var hours: Int16 = 0
        let dayChecks = self.filterChecks(checks: checks, filter: .day, date: date)
        for (index, check) in dayChecks.enumerated() {
            if index.isEven() && index < dayChecks.count - 1 {
                let timeIn =  Int16(calendar.component(.hour, from: check.date! as Date))
                let timeOut = Int16(calendar.component(.hour, from: dayChecks[index+1].date! as Date))
                hours += timeOut - timeIn
            }
        }
        if !dayChecks.count.isEven() && date == Date() {
            let lastCheck = dayChecks[dayChecks.count-1].date
            let checkHour = Int16(calendar.component(.hour, from: lastCheck! as Date))
            let now = Int16(calendar.component(.hour, from: Date()))
            let hoursFromLastCheck = now - checkHour
            hours += hoursFromLastCheck
        }
        return hours
    }
    
    func calculateWeekWorkedHours() -> Int16 {
        var weekHoursWorked: Int16 = 0
        let weekDays = Date.getWeekDays(workSaturday: self.optionsOfUser!.workWeek == "Sábado")
        for day in weekDays {
            let weekDayHoursWorked = self.calculateDayWorkedHours(date: day)
            weekHoursWorked += weekDayHoursWorked
        }
        return weekHoursWorked
    }
    
    func calculateMonthWorkedHours () -> Int16 {
        guard let checks = self.checksofuser else { return 0 }
        var monthWorkedHours: Int16 = 0
        let calendar = Calendar.current
        return monthWorkedHours
    }
    
    func filterChecks (checks: NSSet, filter: Filter, date: Date) -> [Check] {
        var filteredChecks = [Check]()
        let calendar = Calendar(identifier: .gregorian)
        filteredChecks = checks.filter({ (checkIn) -> Bool in
            let check = checkIn as! Check
            let checkDate = check.date! as Date
            switch filter {
            case .day:
                return calendar.compare(date, to: checkDate, toGranularity: .day) == .orderedSame
            case .week:
                return calendar.compare(date, to: checkDate, toGranularity: .weekOfMonth) == .orderedSame
            case .month:
                return calendar.compare(date, to: checkDate, toGranularity: .month) == .orderedSame
            }
        }) as! [Check]
        filteredChecks.sort { (check1, check2) -> Bool in
            return check1.date!.compare(check2.date! as Date ) == .orderedAscending
        }
        return filteredChecks
    }
    
    func sortChecks (checks: NSSet) {
        let todayChecks = checks.filter { (check) -> Bool in
            if let checkDate = check as? Check {
                return Date.isCheckFromToday(check: checkDate)
            }
            return false
        }
        
        let sortedChecks = todayChecks.sorted { (firstDate, secondDate) -> Bool in
            guard let first  = firstDate  as? Check else { return false }
            guard let second = secondDate as? Check else { return false }
            return first.date!.compare(second.date! as Date) == .orderedAscending
        }
        self.checksofuser = nil
        self.addToChecksofuser(NSSet(array: sortedChecks))
        PersistenceService.saveContext()
    }
}
