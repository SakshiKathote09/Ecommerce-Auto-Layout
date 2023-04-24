//
//  Order+CoreDataProperties.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 08/04/23.
//
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var id: Int64
    @NSManaged public var order_date: Date?
    @NSManaged public var post_id: Int64
    @NSManaged public var product_type: String?
    @NSManaged public var product_id: Int64

}

extension Order : Identifiable {

}
