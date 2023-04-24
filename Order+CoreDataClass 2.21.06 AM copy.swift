//
//  Order+CoreDataClass.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 08/04/23.
//
//

import Foundation
import CoreData
import UIKit

@objc(Order)
public class Order: NSManagedObject
{
    static func addOrder(id : Int,order_date:Date,post_id:Int, product_id : Int,product_type:String)
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let pt = Order(context: context)
        pt.id = Int64(id)
        pt.order_date = order_date
        pt.post_id = Int64(post_id)
        pt.product_id = Int64(product_id)
        pt.product_type = product_type


        do {
            try context.save()
            print("Saved company: \(pt)")
        } catch let error {
            print("Could not save. \(error), \(error.localizedDescription)")
        }
    }

}
