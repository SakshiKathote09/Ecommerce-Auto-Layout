//
//  OrderTableViewController.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 08/04/23.
//

import UIKit
import CoreData

class OrderTableViewController: UITableViewController,UISearchResultsUpdating, UINavigationControllerDelegate, OrderViewControllerDelegate {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet var OrderTable: UITableView!
    
    var order = [Order1]()
       var filteredOrder = [Order1]()
       var searchController: UISearchController!
    
    var isFiltering: Bool = false
    
    
    override func viewDidLoad() {
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
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addOrders))

        // Set the tint color and font of the button
        addButton.tintColor = .black
        addButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!], for: .normal)

        // Set the button as the right bar button item
        navigationItem.rightBarButtonItem = addButton

        // Create the left bar button item
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editOrders))

        // Set the tint color and font of the button
        editButton.tintColor = .black
        editButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!], for: .normal)

        // Set the button as the left bar button item
        navigationItem.leftBarButtonItem = editButton

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
                  filteredOrder = order.filter { o in
                      return "\"o.id?".lowercased().contains(searchText.lowercased())
                  }
              } else {
                  filteredOrder = []
              }

              tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            isFiltering = false
           filteredOrder.removeAll()
           tableView.reloadData()
    }
    
    @objc func addOrders()
    {
        let orderviewcontroller = storyboard?.instantiateViewController(withIdentifier: "OrderViewController") as! OrderViewController
        orderviewcontroller.delegate = self // Set the delegate to self

        navigationController?.pushViewController(orderviewcontroller, animated: true)
    }
    @objc func editOrders()
    {
        //CompanyUpdate
        let orderviewcontroller = storyboard?.instantiateViewController(withIdentifier: "OrderUpdate") as! OrderViewController
        orderviewcontroller.delegate = self // Set the delegate to self

        navigationController?.pushViewController(orderviewcontroller, animated: true)
    }
    func addNewOrder(_ orders : Order1)
    {
        order.append(orders)
        self.tableView.reloadData()
        
    }
    func editNewOrder(_ orders : Order1)
    {
        if let index = order.firstIndex(of: orders) {
                order[index] = orders
                tableView.reloadData()
            }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
        if let order = Order1.viewAllOrder() {
            self.order = order
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
        if isFiltering {
            return filteredOrder.count
        } else {
            return order.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("inside table view")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let or: Order1
            if isFiltering {
                or = filteredOrder[indexPath.row]
            } else {
                or = order[indexPath.row]
            }
        cell.textLabel?.text = "\(or.id)"
            
        if let orderDate = or.order_date {
          cell.detailTextLabel?.text = "\(orderDate)"
        } else {
          cell.detailTextLabel?.text = ""
        }

            
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
           let postId = String(or.id).lowercased() as? String,
           postId.contains(searchText.lowercased()) {
               cell.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
        } else {
               cell.backgroundColor = UIColor.clear
        }
        
        return cell
         
    }

    
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCompany = order[indexPath.row]
        let filteredCompanies = order.filter { $0.id == selectedCompany.id }
        guard let selectedFilteredCompany = filteredOrder.first else {
            return
        }
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "OrderViewAllController") as! OrderViewAllController
        detailVC.order = selectedFilteredCompany
        navigationController?.pushViewController(detailVC, animated: true)

    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete {
            let o1 = order[indexPath.row]
            let alertController = UIAlertController(title: "Delete Order", message: "Are you sure you want to delete \(o1.id)?", preferredStyle: .alert)
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                fatalError("Could not get app delegate.")
            }

            let context = appDelegate.persistentContainer.viewContext
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive)
            { (_) in
                context.delete(o1)
                // Delete the order from the data source
                self.order.remove(at: indexPath.row)
                
                // Delete the corresponding row from the table view
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true, completion: nil)
        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowOrderDetail" {
            if let or1 = sender as? Order1,
               let destinationVC = segue.destination as? OrderViewAllController {
                // Pass the selected company to the detail view controller
                destinationVC.order = or1            }
        }
    }


    @objc func infoButtonTapped(_ sender: UIButton) {
        let selectedCompany = order[sender.tag]
           let filteredCompanies = order.filter { $0.id == selectedCompany.id }
           guard let selectedFilteredCompany = filteredCompanies.first else {
               return
           }
           let detailVC = storyboard?.instantiateViewController(withIdentifier: "OrderViewAllController") as! OrderViewAllController
           detailVC.order           = selectedFilteredCompany
           navigationController?.pushViewController(detailVC, animated: true)
        }
        
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

