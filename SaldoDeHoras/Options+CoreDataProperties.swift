//
//  Options+CoreDataProperties.swift
//  SaldoDeHoras
//
//  Created by Iago Mordente Rezende Leão Corrêa on 26/06/18.
//  Copyright © 2018 Iago Mordente Rezende Leão Corrêa. All rights reserved.
//
//

import Foundation
import CoreData


extension Options {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Options> {
        return NSFetchRequest<Options>(entityName: "Options")
    }

    @NSManaged public var workWeek: String?
    @NSManaged public var weekWorkHours: Int16
    @NSManaged public var checkInTime: String?
    @NSManaged public var userOfOptions: User?

}
