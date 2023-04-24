//
//  Order1+CoreDataProperties.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 08/04/23.
//
//

import Foundation
import CoreData


extension Order1 {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order1> {
        return NSFetchRequest<Order1>(entityName: "Order1")
    }

    @NSManaged public var product_type: String?
    @NSManaged public var product_id: Int64
    @NSManaged public var id: Int64
    @NSManaged public var order_date: Date?
    @NSManaged public var post_id: Int64

}

extension Order1 : Identifiable {

}
