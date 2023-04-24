//
//  ProductTypeTableViewController.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 07/04/23.
//

import UIKit
import CoreData

class ProductTypeTableViewController: UITableViewController,ProductTypeViewControllerDelegate,UISearchResultsUpdating {
    

    @IBOutlet var ProductTypeView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var productType = [ProductType1]()
    var filteredPT = [ProductType1]()
    var searchController:UISearchController!
    
    
    var isFiltering: Bool = false
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        super.viewDidLoad()
        self.tabBarItem.title = "My Title"
        
       // tableView.register(ProductTypeCell.self, forCellReuseIdentifier: "ProductTypeCell")

        // Create the search controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false

        // Create an attributed string for the placeholder text
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let attributedPlaceholder = NSAttributedString(string: "Search", attributes: attributes)

        // Set the attributed placeholder string for the search bar
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = attributedPlaceholder


        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // companies = Company.viewAllCompanies()
       // productType = ProductType.viewAllProductType()
        tableView.dataSource = self
        tableView.delegate = self
        
        
        // Set the background image
        let backgroundImage = UIImage(named: "marble")
        let backgroundImageView = UIImageView(image: backgroundImage)
        tableView.backgroundView = backgroundImageView
        
        
        //  searchBar.delegate = self
        // Create the right bar button item
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addProductType))

        // Set the tint color and font of the button
        addButton.tintColor = .black
        addButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!], for: .normal)

        // Set the button as the right bar button item
        navigationItem.rightBarButtonItem = addButton

        // Create the left bar button item
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editProductType))

        // Set the tint color and font of the button
        editButton.tintColor = .black
        editButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!], for: .normal)

        // Set the button as the left bar button item
        navigationItem.leftBarButtonItem = editButton
        
        
    }
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
                  filteredPT = productType.filter { productType in
                      return productType.name?.lowercased().contains(searchText.lowercased()) ?? false
                  }
              } else {
                  filteredPT = []
              }

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            isFiltering = false
           filteredPT.removeAll()
           tableView.reloadData()
    }
    @objc func addProductType()
    {
        let productTypeviewcontroller = storyboard?.instantiateViewController(withIdentifier: "ProductTypeViewController") as! ProductTypeViewController
        productTypeviewcontroller.delegate = self // Set the delegate to self

        navigationController?.pushViewController(productTypeviewcontroller, animated: true)
        
    }
    @objc func editProductType()
    {
        //CompanyUpdate
        let ProductTypeViewController = storyboard?.instantiateViewController(withIdentifier: "ProductTypeUpdateViewController") as! ProductTypeViewController
        ProductTypeViewController.delegate = self // Set the delegate to self

        navigationController?.pushViewController(ProductTypeViewController, animated: true)
    }

    
    func addNewProductType(_ productTypes: ProductType1)
    {
       // companies.append(company)
        productType.append(productTypes)
        self.tableView.reloadData()
    }
    
    func editNewProductType(_ productTypes: ProductType1) {
        if let index = productType.firstIndex(of: productTypes) {
            productType[index] = productTypes
            tableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
        if let productType = ProductType1.viewAllProductType() {
            self.productType = productType
            tableView.reloadData()
        } else {
            print("No product type found.")
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isFiltering {
            return filteredPT.count
        } else {
            return productType.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("inside table view")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTypeCell", for: indexPath)
            let producttype: ProductType1
            if isFiltering {
                producttype = filteredPT[indexPath.row]
            } else {
                producttype = productType[indexPath.row]
            }
        cell.textLabel?.text = "\(producttype.id). \(producttype.name ?? "")"
    
            
        cell.detailTextLabel?.text = "Product Type"
            
        // Create the info button
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(infoButtonTapped(_:)), for: .touchUpInside)

        // Set the tint color and font of the button
        infoButton.tintColor = .black
        infoButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)

        // Set the button as the accessory view of the cell
        cell.accessoryView = infoButton

            
            if let searchText = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines),
               !searchText.isEmpty,
               let companyName = producttype.name?.trimmingCharacters(in: .whitespacesAndNewlines),
               !companyName.isEmpty,
               companyName.lowercased().contains(searchText.lowercased()) {
                cell.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
            } else {
                cell.backgroundColor = UIColor.clear
            }
            
            return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCompany = productType[indexPath.row]
        let filteredCompanies = productType.filter { $0.name == selectedCompany.name }
        guard let selectedFilteredCompany = filteredCompanies.first else {
            return
        }
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "ProductTypeViewAllController") as! ProductTypeViewAllController
        detailVC.productType = selectedFilteredCompany
        navigationController?.pushViewController(detailVC, animated: true)

    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let producttype = productType[indexPath.row]
            let alertController = UIAlertController(title: "Delete Product Type", message: "Are you sure you want to delete \(producttype.name ?? "")?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                
                // Fetch the products associated with the company
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    fatalError("Could not get app delegate.")
                }
                
                let context = appDelegate.persistentContainer.viewContext
                let fetchRequest: NSFetchRequest<Product_Post1> = Product_Post1.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "productTypeId == %ld", producttype.id)
                
                do {
                    let productPosts = try context.fetch(fetchRequest)
                    
                    // Check if the product posts array is empty or not
                    if !productPosts.isEmpty {
                        // Product posts exist, show alert
                        let alertController = UIAlertController(title: "Delete Product Type", message: "This product type has product posts associated with it. Please delete the product posts before deleting the product type.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        // No product posts associated, proceed with deleting the product type
                        context.delete(producttype)
                        try context.save()
                        self.productType.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                } catch {
                    print("Error fetching product posts: \(error.localizedDescription)")
                }
            }
                
                alertController.addAction(cancelAction)
                alertController.addAction(deleteAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            
    }


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProductTypeSeague" {
            if let productType = sender as? ProductType1,
               let destinationVC = segue.destination as? ProductTypeViewAllController {
                // Pass the selected company to the detail view controller
                destinationVC.productType = productType
            }
        }
    }


    @objc func infoButtonTapped(_ sender: UIButton) {
        let selectedCompany = productType[sender.tag]
           let filteredCompanies = productType.filter { $0.name == selectedCompany.name }
           guard let selectedFilteredCompany = filteredCompanies.first else {
               return
           }
           let detailVC = storyboard?.instantiateViewController(withIdentifier: "ProductTypeViewAllController") as! ProductTypeViewAllController
           detailVC.productType = selectedFilteredCompany
           navigationController?.pushViewController(detailVC, animated: true)
        }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
