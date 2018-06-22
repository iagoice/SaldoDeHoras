//
//  Check+CoreDataProperties.swift
//  SaldoDeHoras
//
//  Created by Iago Mordente Rezende Leão Corrêa on 22/06/18.
//  Copyright © 2018 Iago Mordente Rezende Leão Corrêa. All rights reserved.
//
//

import Foundation
import CoreData


extension Check {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Check> {
        return NSFetchRequest<Check>(entityName: "Check")
    }

    @NSManaged public var date: NSDate?

}
