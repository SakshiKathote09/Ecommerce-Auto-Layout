//
//  ProductType+CoreDataProperties.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 07/04/23.
//
//

import Foundation
import CoreData


extension ProductType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductType> {
        return NSFetchRequest<ProductType>(entityName: "ProductType")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?

}

extension ProductType : Identifiable {

}
