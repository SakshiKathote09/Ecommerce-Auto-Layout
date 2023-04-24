//
//  Order1+CoreDataClass.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 08/04/23.
//
//

import Foundation
import CoreData
import UIKit

@objc(Order1)
public class Order1: NSManagedObject
{
    static func addOrder(id : Int,order_date:Date,post_id:Int, product_id : Int,product_type:String)
      {
          let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
          let pt = Order1(context: context)
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
      
      static func viewAllOrder() -> [Order1]? {
          let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
          let request: NSFetchRequest<Order1> = Order1.fetchRequest()
          print("inside view all companies")

          do {
              let pp = try context.fetch(request)
              print("view all successful using core data")
              return pp
          } catch let error {
              print("Error fetching companies: \(error.localizedDescription)")
              return nil
          }
      }
      static func updateOrder(id: Int, orderDate: Date, postId: Int, productId: Int, productType: String) {
          let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
          
          do {
              let request = NSFetchRequest<Order1>(entityName: "Order")
              request.predicate = NSPredicate(format: "id == %d", id)
              let results = try context.fetch(request)
              
              if let order = results.first {
                  order.order_date = orderDate
                  order.post_id = Int64(postId)
                  order.product_id = Int64(productId)
                  order.product_type = productType
                  
                  try context.save()
                  print("Updated order: \(order)")
              } else {
                  print("Order with ID \(id) not found")
              }
          } catch let error {
              print("Could not update. \(error), \(error.localizedDescription)")
          }
      }
    static func dorder(id: Int) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Order1> = Order1.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let companies = try context.fetch(fetchRequest)
            if let company = companies.first {
                context.delete(company)
                try context.save()
                print("Company with ID \(id) deleted successfully")
            } else {
                print("No company found with ID: \(id)")
            }
        } catch {
            print("Error deleting company with ID \(id): \(error.localizedDescription)")
        }
    }


}
