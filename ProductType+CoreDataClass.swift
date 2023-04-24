//
//  ProductType+CoreDataClass.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 07/04/23.
//
//

import Foundation
import CoreData
import UIKit

@objc(ProductType)
public class ProductType: NSManagedObject
{
    static func addProductType(id:Int,name: String)
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let pt = ProductType(context: context)
        pt.id = Int64(id)
        pt.name = name

        do {
            try context.save()
            print("Saved company: \(pt)")
        } catch let error {
            print("Could not save. \(error), \(error.localizedDescription)")
        }
    }
    
    
    static func viewAllProductType() -> [ProductType]? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<ProductType> = ProductType.fetchRequest()
        print("inside view all product type")

        do {
            let products = try context.fetch(request)
            print("view all successful using core data")
            return products
        } catch let error {
            print("Error fetching products: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func updateProductType(id: Int, name: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Product_Type")
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1
        
        do {
            let results = try context.fetch(request)
            if results.count == 0 {
                print("No product type found with ID: \(id)")
                return
            }
            
            if let pt = results.first as? ProductType {
                // Update the company attributes
                pt.id = Int64(id)
                pt.name = name
                
                // Save the changes to the database
                try context.save()
                
                print("Product_Type updated successfully!")
            }
        } catch let error {
            print("Error updating company: \(error.localizedDescription)")
        }
    }

}
