//
//  ProductType1+CoreDataProperties.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 08/04/23.
//
//

import Foundation
import CoreData


extension ProductType1 {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductType1> {
        return NSFetchRequest<ProductType1>(entityName: "ProductType1")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?

}

extension ProductType1 : Identifiable {

}
