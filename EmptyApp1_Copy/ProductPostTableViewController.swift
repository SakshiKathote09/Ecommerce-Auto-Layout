//
//  ProductPostTableViewController.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 07/04/23.
//

import UIKit
import CoreData

class ProductPostTableViewController: UITableViewController,ProductPostViewControllerDelegate,UISearchResultsUpdating,UINavigationControllerDelegate {

    @IBOutlet var PPTableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
        var productposts = [Product_Post1]()
       var filteredPP = [Product_Post1]()
       var searchController: UISearchController!
   // var imagePicker = UIImagePickerController()

    var isFiltering: Bool = false
    
    override func viewDidLoad()
    {
        
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        super.viewDidLoad()
        self.tabBarItem.title = "My Title"
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
        tableView.dataSource = self
        tableView.delegate = self
        
        
        // Set the background image
        let backgroundImage = UIImage(named: "marble")
        let backgroundImageView = UIImageView(image: backgroundImage)
        tableView.backgroundView = backgroundImageView
        
        
        //  searchBar.delegate = self
        // Create the right bar button item
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPP))

        // Set the tint color and font of the button
        addButton.tintColor = .black
        addButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!], for: .normal)

        // Set the button as the right bar button item
        navigationItem.rightBarButtonItem = addButton

        // Create the left bar button item
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPP))

        // Set the tint color and font of the button
        editButton.tintColor = .black
        editButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!], for: .normal)

        // Set the button as the left bar button item
        navigationItem.leftBarButtonItem = editButton
        
    }
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
                  filteredPP = productposts.filter { pp in
                      return "\"pp.id?".lowercased().contains(searchText.lowercased())
                  }
              } else {
                  filteredPP = []
              }

              tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            isFiltering = false
           filteredPP.removeAll()
           tableView.reloadData()
    }

    @objc func addPP()
    {
        let productpostviewcontroller = storyboard?.instantiateViewController(withIdentifier: "ProductPostViewController") as! ProductPostViewController
        productpostviewcontroller.delegate = self // Set the delegate to self

        navigationController?.pushViewController(productpostviewcontroller, animated: true)
        
    }
    @objc func editPP()
    {
        //CompanyUpdate
        let productpostviewcontroller = storyboard?.instantiateViewController(withIdentifier: "ProductPostUpdate") as! ProductPostViewController
        productpostviewcontroller.delegate = self // Set the delegate to self

        navigationController?.pushViewController(productpostviewcontroller, animated: true)
    }
    func addNewPP(_ productPost: Product_Post1) {
        productposts.append(productPost)
        self.tableView.reloadData()
    }
    func editNewPP(_ productPost: Product_Post1)
    {
        if let index = productposts.firstIndex(of: productPost) {
                productposts[index] = productPost
                tableView.reloadData()
            }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
        if let productposts = Product_Post1.viewAllPP() {
            self.productposts = productposts
            tableView.reloadData()
        } else {
            print("No companies found.")
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
            return filteredPP.count
        } else {
            return productposts.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("inside table view")
        let cell = tableView.dequeueReusableCell(withIdentifier: "PPCell", for: indexPath)
            let pp: Product_Post1
            if isFiltering {
                pp = filteredPP[indexPath.row]
            } else {
                pp = productposts[indexPath.row]
            }
        cell.textLabel?.text = "\(pp.id)"
            
            
        cell.detailTextLabel?.text = "\(pp.desc ?? "")"
            
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
               let postId = String(pp.id).lowercased() as? String,
               postId.contains(searchText.lowercased()) {
                   cell.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
            } else {
                   cell.backgroundColor = UIColor.clear
            }
            
            return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCompany = productposts[indexPath.row]
        let filteredCompanies = productposts.filter { $0.id == selectedCompany.id }
        guard let selectedFilteredCompany = filteredCompanies.first else {
            return
        }
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "ProductPostViewAllController") as! ProductPostViewAllController
        detailVC.productPost = selectedFilteredCompany
        navigationController?.pushViewController(detailVC, animated: true)

    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        
            if editingStyle == .delete {
                let pp1 = productposts[indexPath.row]
                let alertController = UIAlertController(title: "Delete product post", message: "Are you sure you want to delete product post", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive)
                { (_) in
                    
                    // Fetch the products associated with the company
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                        fatalError("Could not get app delegate.")
                    }

                    let context = appDelegate.persistentContainer.viewContext
                    let fetchRequest: NSFetchRequest<Order1> = Order1.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: " post_id == %ld", pp1.id)
                
                do {
                    let order = try context.fetch(fetchRequest)
                    
                    // Check if the products array is empty or not
                    if !order.isEmpty {
                        // Products exist, show alert
                        let alertController = UIAlertController(title: "Delete Product Post", message: "This product post has order associated with it. Please delete the order before deleting the product post.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        // No products associated, proceed with deleting the company
                        context.delete(pp1)
                        try context.save()
                        self.productposts.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                } catch {
                    print("Error fetching products: \(error.localizedDescription)")
                }
            }
                alertController.addAction(cancelAction)
                alertController.addAction(deleteAction)
                
                present(alertController, animated: true, completion: nil)
            
        }


    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailPP" {
            if let productpost = sender as? Product_Post1,
               let destinationVC = segue.destination as? ProductPostViewAllController {
                // Pass the selected company to the detail view controller
                destinationVC.productPost = productpost
            }
        }
    }


    @objc func infoButtonTapped(_ sender: UIButton) {
        let selectedCompany = productposts[sender.tag]
           let filteredCompanies = productposts.filter { $0.id == selectedCompany.id }
           guard let selectedFilteredCompany = filteredCompanies.first else {
               return
           }
           let detailVC = storyboard?.instantiateViewController(withIdentifier: "ProductPostViewAllController") as! ProductPostViewAllController
           detailVC.productPost = selectedFilteredCompany
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
