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
        self.updateHoursBank()
        PersistenceService.saveContext()
    }
    
    public func resetWeek() {
        self.weekWorkedHours = 0
        self.dayWorkedHours = 0
        self.hoursBank = 0
        self.paidHours = 0
        PersistenceService.saveContext()
    }
    
    public func resetDay() {
        self.dayWorkedHours = 0
        
    }
    
    private func updateHoursBank () {
        self.hoursBank = self.weekWorkedHours - (self.optionsOfUser?.weekWorkHours)! - self.paidHours
    }
    
    private func calculateDayWorkedHours(date: Date) -> Int16 {
        guard let checks = self.checksofuser else { return Int16(Constants.zero) }
        var hours: Int16 = Int16(Constants.zero)
        let dayChecks = self.filterChecks(checks: checks, filter: .day, date: date)
        for (index, check) in dayChecks.enumerated() {
            if index.isEven() && index < dayChecks.count - Constants.Indices.last {
                let date = dayChecks[index+Constants.one].date! as Date
                let time = date.timeIntervalSince(check.date! as Date)/TimeInterval(Constants.Values.Time.secondsInHour)
                hours += Int16(time)
            }
        }
        
        return hours
    }
    
    func calculateDayWorkedHoursSoFar(date: Date) -> Int16 {
        guard let checks = self.checksofuser else { return Int16(Constants.zero) }
        let calendar = NSCalendar.current
        var hours: Int16 = Int16(Constants.zero)
        let dayChecks = self.filterChecks(checks: checks, filter: .day, date: date)
        for (index, check) in dayChecks.enumerated() {
            if index.isEven() && index < dayChecks.count - Constants.Indices.last {
                let timeIn =  Int16(calendar.component(.hour, from: check.date! as Date))
                let timeOut = Int16(calendar.component(.hour, from: dayChecks[index+Constants.one].date! as Date))
                hours += timeOut - timeIn
            }
        }
        if !dayChecks.count.isEven() && date == Date() {
            let lastCheck = dayChecks[dayChecks.count-Constants.Indices.last].date
            let checkHour = Int16(calendar.component(.hour, from: lastCheck! as Date))
            let now = Int16(calendar.component(.hour, from: Date()))
            let hoursFromLastCheck = now - checkHour
            hours += hoursFromLastCheck
        }
        return hours
    }
    
    private func calculateWeekWorkedHours() -> Int16 {
        var weekHoursWorked: Int16 = 0
        let weekDays = Date.getWeekDays(workSaturday: self.optionsOfUser!.workWeek == Constants.saturday)
        for day in weekDays {
            let weekDayHoursWorked = self.calculateDayWorkedHours(date: day)
            weekHoursWorked += weekDayHoursWorked
        }
        return weekHoursWorked
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
    
    func sortChecks (checks: NSSet) -> [Any] {
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
        
        return sortedChecks
    }
}
