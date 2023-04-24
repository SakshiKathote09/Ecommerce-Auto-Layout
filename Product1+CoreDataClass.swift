//
//  Product1+CoreDataClass.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 08/04/23.
//
//

import Foundation
import CoreData
import UIKit

@objc(Product1)
public class Product1: NSManagedObject
{
    static func addProduct(id:Int,name: String, productDescription: String, productRating: Decimal, companyId: Int, quantity:Int,logo:Data?)
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let pt = Product1(context: context)
        pt.id = Int64(id)
        pt.name = name
        pt.productDescription = productDescription
        pt.productRating = NSDecimalNumber(decimal: productRating)
        pt.companyId = Int64(companyId)
        pt.quantity = Int64(quantity)
        pt.logo = logo

        do {
            try context.save()
            print("Saved company: \(pt)")
        } catch let error {
            print("Could not save. \(error), \(error.localizedDescription)")
        }
    }
    
    
    static func viewAllProducts() -> [Product1]? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Product1> = Product1.fetchRequest()
        print("inside view all products")

        do {
            let products = try context.fetch(request)
            print("view all successful using core data")
            return products
        } catch let error {
            print("Error fetching products: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func updateProduct(id: Int, name: String, productDescription: String, productRating: Decimal, companyId: Int, quantity: Int) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request: NSFetchRequest<Product1> = Product1.fetchRequest()
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
            pt.name = name
            pt.productDescription = productDescription
            pt.productRating = NSDecimalNumber(decimal: productRating)
            pt.companyId = Int64(companyId)
            pt.quantity = Int64(quantity)
            
            // Save the changes to the database
            try context.save()
            
            print("Product updated successfully!")
        } catch let error {
            print("Error updating product: \(error.localizedDescription)")
        }
    }

    static func deleteProduct(id: Int) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Product1> = Product1.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let pts = try context.fetch(fetchRequest)
            if let pt = pts.first {
                context.delete(pt)
                try context.save()
                print("Company with ID \(id) deleted successfully")
            } else {
                print("No company found with ID: \(id)")
            }
        } catch {
            print("Error deleting company with ID \(id): \(error.localizedDescription)")
        }
    }
    
    static func SearchProduct(id: Int) -> Product1? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Product1> = Product1.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %ld", id)

        do {
            let matchingProduct_Type = try context.fetch(fetchRequest)
            return matchingProduct_Type.first
        } catch {
            print("Error searching Product_Type: \(error)")
            return nil
        }
    }

    static func searchProductWithRating(productRating: Decimal) -> Product1? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Product1> = Product1.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productRating == %@", productRating as NSDecimalNumber)
        do {
            let matchingProducts = try context.fetch(fetchRequest)
            return matchingProducts.first
        } catch {
            print("Error searching products: \(error)")
            return nil
        }
    }

}
