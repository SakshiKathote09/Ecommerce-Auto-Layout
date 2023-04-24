//
//  Company+CoreDataClass.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 08/04/23.
//
//

import Foundation
import CoreData
import UIKit

@objc(Company)
public class Company: NSManagedObject
{
    static func addCompany(id: Int, name: String, address: String, country: String, zip: Int, companyType: String?, logo: Data?) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let company = Company(context: context)
        company.id = Int64(id)
        company.name = name
        company.address = address
        company.country = country
        company.zip = Int64(zip)
        company.companyType = companyType
        company.logo = logo
        
        do {
            try context.save()
            print("Saved company: \(company)")
            print("saveed data:",context)
        } catch let error {
            print("Could not save. \(error), \(error.localizedDescription)")
        }
        print("added to the company")
    }
    
    static func viewAllCompanies() -> [Company]? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        print("inside view all companies")

        do {
            let companies = try context.fetch(request)
            print("view all successful using core data")
            return companies
        } catch let error {
            print("Error fetching companies: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    static func updateCompany(id: Int, name: String, address: String, country: String, zip: Int, companyType: String?) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Company")
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1
        
        do {
            let results = try context.fetch(request)
            if results.count == 0 {
                print("No company found with ID: \(id)")
                return
            }
            
            if let company = results.first as? Company {
                // Update the company attributes
                company.id = Int64(id)
                company.name = name
                company.address = address
                company.country = country
                company.zip = Int64(zip)
                company.companyType = companyType
                
                // Save the changes to the database
                try context.save()
                
                print("Company updated successfully!")
            }
        } catch let error {
            print("Error updating company: \(error.localizedDescription)")
        }
    }
    
    static func deleteCompany(id: Int) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Company> = Company.fetchRequest()
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

struct CompanyData: Decodable {
    let id: String?
    let name: String?
    let address: String?
    let country: String?
    let zip: String?
    let companyType: String?
    let logo: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case address
        case country
        case zip = "zipcode"
        case companyType
        case logo
    }
}

