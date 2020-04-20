//
//  User+CoreDataProperties.swift
//  
//
//  Created by Oleh Mykytyn on 18.04.2020.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var mail: String?
    @NSManaged public var name: String?

}
