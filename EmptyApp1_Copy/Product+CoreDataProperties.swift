//
//  Product+CoreDataProperties.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 06/04/23.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var companyId: Int64
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var productDescription: String?
    @NSManaged public var productRating: NSDecimalNumber?
    @NSManaged public var quantity: Int64
    @NSManaged public var logo: Data?

}

extension Product : Identifiable {

}
