//
//  Product_Post1+CoreDataProperties.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 08/04/23.
//
//

import Foundation
import CoreData


extension Product_Post1 {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product_Post1> {
        return NSFetchRequest<Product_Post1>(entityName: "Product_Post1")
    }

    @NSManaged public var companyid: Int64
    @NSManaged public var desc: String?
    @NSManaged public var id: Int64
    @NSManaged public var postedDate: Date?
    @NSManaged public var price: Double
    @NSManaged public var productId: Int64
    @NSManaged public var productTypeId: Int64

}

extension Product_Post1 : Identifiable {

}
