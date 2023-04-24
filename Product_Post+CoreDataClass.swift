//
//  Product_Post+CoreDataClass.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 07/04/23.
//
//

import Foundation
import CoreData
import UIKit

@objc(Product_Post)
public class Product_Post: NSManagedObject
{
    static func addProduct_Post(id : Int , productTypeId : Int , companyid :Int , productId : Int,postedDate:Date ,price : Double, desc : String)
        {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let pt = Product_Post(context: context)
            pt.id = Int64(id)
            pt.productTypeId = Int64(productTypeId)
            pt.companyid = Int64(companyid)
            pt.productId = Int64(productId)
            pt.postedDate = postedDate
            pt.price = Double(price)
            pt.desc = desc

            do {
                try context.save()
                print("Saved company: \(pt)")
            } catch let error {
                print("Could not save. \(error), \(error.localizedDescription)")
            }
        }
        
        
        static func viewAllPP() -> [Product_Post]? {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let request: NSFetchRequest<Product_Post> = Product_Post.fetchRequest()
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
        
        static func updateProduct_Post(id : Int , productTypeId : Int , companyid :Int , productId : Int, price : Double, desc : String) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let request: NSFetchRequest<Product_Post> = Product_Post.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", id)
            request.fetchLimit = 1
            
            do {
                let results = try context.fetch(request)
                guard let pt = results.first else {
                    print("No product found with ID: \(id)")
                    return
                }
                
                // Update the product attributes
                pt.id = Int64(id)
                pt.productTypeId = Int64(productTypeId)
                pt.companyid = Int64(companyid)
                pt.productId = Int64(productId)
              //  pt.postedDate = postedDate
                pt.price = Double(price)
                pt.desc = desc

                
                // Save the changes to the database
                try context.save()
                
                print("Product updated successfully!")
            } catch let error {
                print("Error updating product: \(error.localizedDescription)")
            }
        }


}
