//
//  Product1+CoreDataProperties.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 08/04/23.
//
//

import Foundation
import CoreData


extension Product1 {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product1> {
        return NSFetchRequest<Product1>(entityName: "Product1")
    }

    @NSManaged public var companyId: Int64
    @NSManaged public var id: Int64
    @NSManaged public var logo: Data?
    @NSManaged public var name: String?
    @NSManaged public var productDescription: String?
    @NSManaged public var productRating: NSDecimalNumber?
    @NSManaged public var quantity: Int64

}

extension Product1 : Identifiable {

}
