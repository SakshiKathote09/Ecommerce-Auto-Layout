//
//  Company+CoreDataProperties.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 05/04/23.
//
//

import Foundation
import CoreData


extension Company {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Company> {
        return NSFetchRequest<Company>(entityName: "Company")
    }

    @NSManaged public var address: String?
    @NSManaged public var companyType: String?
    @NSManaged public var country: String?
    @NSManaged public var id: Int64
    @NSManaged public var logo: Data?
    @NSManaged public var name: String?
    @NSManaged public var zip: Int64

}

extension Company : Identifiable {

}
