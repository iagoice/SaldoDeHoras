//
//  User+CoreDataProperties.swift
//  SaldoDeHoras
//
//  Created by Iago Mordente Rezende Leão Corrêa on 26/06/18.
//  Copyright © 2018 Iago Mordente Rezende Leão Corrêa. All rights reserved.
//
//

import Foundation
import CoreData
import FBSDKLoginKit


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var checksofuser: NSSet?
    @NSManaged public var optionsOfUser: Options?
    @NSManaged public var dayWorkedHours: Int16
    @NSManaged public var weekWorkedHours: Int16
    @NSManaged public var monthWorkedHours: Int16
    @NSManaged public var hoursBank: Int16
    @NSManaged public var paidHours: Int16
    
}

// MARK: Generated accessors for checksofuser
extension User {

    @objc(addChecksofuserObject:)
    @NSManaged public func addToChecksofuser(_ value: Check)

    @objc(removeChecksofuserObject:)
    @NSManaged public func removeFromChecksofuser(_ value: Check)

    @objc(addChecksofuser:)
    @NSManaged public func addToChecksofuser(_ values: NSSet)

    @objc(removeChecksofuser:)
    @NSManaged public func removeFromChecksofuser(_ values: NSSet)

}
