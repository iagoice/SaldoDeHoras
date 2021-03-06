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


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var checksofuser: NSSet?
    @NSManaged public var optionsOfUser: Options?

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

// MARK: Generated accessors for optionsOfUser
extension User {
    
    @objc(addOptionsOfUserObject:)
    @NSManaged public func addToOptionsOfUser(_ value: Options)
    
    @objc(removeOptionsOfUserObject:)
    @NSManaged public func removeFromOptionsOfUser(_ value: Options)

    
}

