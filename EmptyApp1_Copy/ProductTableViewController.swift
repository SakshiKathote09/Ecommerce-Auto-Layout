//
//  ProductTableViewController.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 06/04/23.
//

import UIKit
import CoreData

class ProductTableViewController: UITableViewController,ProductViewControllerDelegate,UISearchResultsUpdating, UINavigationControllerDelegate
{
    

    @IBOutlet var ProductView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    var products = [Product1]()
    
       var filteredProducts = [Product1]()
       var searchController: UISearchController!
    
    
    var isFiltering: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage(named: "productType")
        let backgroundImageView = UIImageView(image: backgroundImage)
        tableView.backgroundView = backgroundImageView
        
        self.tabBarItem.title = "My Title"
        
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
        tableView.dataSource = self
        tableView.delegate = self
      //  searchBar.delegate = self
        // Define the button size
     

        
        let buttonSize = CGSize(width: 32, height: 32)

        // Create the "Add" button
        let addButton = UIButton(type: .system)
        addButton.tintColor = .black
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.frame = CGRect(origin: .zero, size: buttonSize)
        addButton.addTarget(self, action: #selector(addProducts), for: .touchUpInside)
        let addBarButtonItem = UIBarButtonItem(customView: addButton)

        // Create the "Edit" button
        let editButton = UIButton(type: .system)
        editButton.tintColor = .black
        editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        editButton.frame = CGRect(origin: .zero, size: buttonSize)
        editButton.addTarget(self, action: #selector(editProducts), for: .touchUpInside)
        let editBarButtonItem = UIBarButtonItem(customView: editButton)

        // Set the custom buttons on the navigation item
        navigationItem.rightBarButtonItem = addBarButtonItem
        navigationItem.leftBarButtonItem = editBarButtonItem

    }

    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
                  filteredProducts = products.filter { product in
                      return product.name?.lowercased().contains(searchText.lowercased()) ?? false
                  }
              } else {
                  filteredProducts = []
              }

              tableView.reloadData()
        print("Products....",products)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            isFiltering = false
           filteredProducts.removeAll()
           tableView.reloadData()
    }
    @objc func editProducts()
    {
        //CompanyUpdate
//        let companyViewController = storyboard?.instantiateViewController(withIdentifier: "CompanyUpdate") as! CompanyViewController
        let productViewController = storyboard?.instantiateViewController(withIdentifier: "ProductUpdate") as! ProductViewController
        productViewController.delegate = self // Set the delegate to self

        navigationController?.pushViewController(productViewController, animated: true)
    }

    func editNewProducts(_ product: Product1) {
        if let index = products.firstIndex(of: product) {
                products[index] = product
                tableView.reloadData()
            }
    }
        
    @objc func addProducts() {
           let productViewController = storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
           productViewController.delegate = self // Set the delegate to self

           navigationController?.pushViewController(productViewController, animated: true)
       }

    func addNewProduct(_ product: Product1) {
        products.append(product)
        self.tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
        if let products = Product1.viewAllProducts() {
            self.products = products
            tableView.reloadData()
        } else {
            print("No products found.")
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
            return filteredProducts.count
        } else {
            return products.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("inside table view")
//        print("products",products)
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
                let product: Product1
                if isFiltering {
                    product = filteredProducts[indexPath.row]
                    print("proudtcs post if:",product)
                } else {
                    product = products[indexPath.row]
                }
        cell.textLabel?.text = "\(product.id) \(product.name ?? "")"
            
        if let logoData = product.logo, let productLogo = UIImage(data: logoData) {
            let cellWidth = cell.frame.width
            let logoSize = CGSize(width: cellWidth * 0.2, height: cellWidth * 0.1) // Set the logo size
            let logoRect = CGRect(origin: .zero, size: logoSize)
            UIGraphicsBeginImageContextWithOptions(logoSize, false, 0.0)
            productLogo.draw(in: logoRect)
            let resizedLogo = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            cell.imageView?.contentMode = .center // set content mode
            cell.imageView?.image = resizedLogo
        }
        else {
                // Set default image if company logo is not available
                let imageNames = ["fb", "gp", "nike","puma","star"]
                let imageName = imageNames[indexPath.row % imageNames.count]
                cell.imageView?.image = UIImage(named: imageName)
            }

            
        if let rating = product.productRating {
            cell.detailTextLabel?.text = "\(product.productDescription ?? "") \(rating)"
        } else {
            cell.detailTextLabel?.text = "\(product.productDescription ?? "")"
        }


            
            let infoButton = UIButton(type: .infoLight)
            infoButton.addTarget(self, action: #selector(infoButtonTapped(_:)), for: .touchUpInside)
            cell.accessoryView = infoButton
            
            if let searchText = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines),
               !searchText.isEmpty,
               let productName = product.name?.trimmingCharacters(in: .whitespacesAndNewlines),
               !productName.isEmpty,
               productName.lowercased().contains(searchText.lowercased()) {
                cell.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
            } else {
                cell.backgroundColor = UIColor.clear
            }
            
            return cell
         
    }

    
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProduct = products[indexPath.row]
        let filteredProducts = products.filter { $0.name == selectedProduct.name }
        guard let selectedFilteredCompany = filteredProducts.first else {
            return
        }
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "ProductViewAll") as! ProductViewAllController
        detailVC.product = selectedFilteredCompany
        navigationController?.pushViewController(detailVC, animated: true)

    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = products[indexPath.row]
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest: NSFetchRequest<Product_Post1> = Product_Post1.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "productId == %ld", product.id)
            
            do {
                let pp1 = try context.fetch(fetchRequest)
                
                // Check if the products array is empty or not
                if !pp1.isEmpty {
                    // Products exist, show alert
                    let alertController = UIAlertController(title: "Delete Product", message: "This product has product post  associated with it. Please delete the product post before deleting the product.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    // No products associated, proceed with deleting the company
                    context.delete(product)
                    try context.save()
                    self.products.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            } catch {
                print("Error fetching products: \(error.localizedDescription)")
            }
            
            
        }


    }


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProductDetailSegue" {
            if let product = sender as? Product1,
               let destinationVC = segue.destination as? ProductViewAllController {
                // Pass the selected company to the detail view controller
               // destinationVC.company = company
                destinationVC.product = product
            }
        }
    }


    @objc func infoButtonTapped(_ sender: UIButton) {
        let selectedProduct = products[sender.tag]
           let filteredProducts = products.filter { $0.name == selectedProduct.name }
           guard let selectedFilteredProduct = filteredProducts.first else {
               return
           }
           let detailVC = storyboard?.instantiateViewController(withIdentifier: "ProductViewAll") as! ProductViewAllController
           detailVC.product = selectedFilteredProduct
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
