//
//  MyTableTableViewController.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 05/04/23.
//

import UIKit
import Photos
import CoreData
import Network

class MyTableTableViewController: UITableViewController,CompanyViewControllerDelegate,UISearchResultsUpdating, UINavigationControllerDelegate
{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var MyTableView: UITableView!

    
        var companies = [Company]()
       var filteredCompanies = [Company]()
       var searchController: UISearchController!
    let urlString = "https://6429924debb1476fcc4c36b2.mockapi.io/company"
   // var imagePicker = UIImagePickerController()

    var isFiltering: Bool = false
    

    override func viewDidLoad()
    {
        print("inside load")
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        super.viewDidLoad()
        isConnectedToNetwork { isAvailable in
            if isAvailable {
                self.fetchData()
            } else {
                self.showAlert(message: "No internet connection")
            }
        }
        
        
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
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCompany))

        // Set the tint color and font of the button
        addButton.tintColor = .black
        addButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!], for: .normal)

        // Set the button as the right bar button item
        navigationItem.rightBarButtonItem = addButton

        // Create the left bar button item
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editCompany))

        // Set the tint color and font of the button
        editButton.tintColor = .black
        editButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!], for: .normal)

        // Set the button as the left bar button item
        navigationItem.leftBarButtonItem = editButton

       // view.addSubview(tableView)
    }
    
//    func updateSearchResults(for searchController: UISearchController) {
//        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
//                  filteredCompanies = companies.filter { company in
//                      return company.name?.lowercased().contains(searchText.lowercased()) ?? false
//                  }
//              } else {
//                  filteredCompanies = []
//              }
//
//              tableView.reloadData()
//    }
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        
        // Filter the companies array based on the search text
        filteredCompanies = companies.filter({ (company) -> Bool in
            if let name = company.name {
                return name.range(of: searchText, options: .caseInsensitive) != nil
            }
            return false
        })
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            isFiltering = false
           filteredCompanies.removeAll()
           tableView.reloadData()
    }
    @objc func editCompany()
    {
        //CompanyUpdate
        let companyViewController = storyboard?.instantiateViewController(withIdentifier: "CompanyUpdate") as! CompanyViewController
        companyViewController.delegate = self // Set the delegate to self

        navigationController?.pushViewController(companyViewController, animated: true)
    }

    func editNewCompany(_ company: Company) {
        if let index = companies.firstIndex(of: company) {
                companies[index] = company
                tableView.reloadData()
            }
    }
        
    @objc func addCompany() {
           let companyViewController = storyboard?.instantiateViewController(withIdentifier: "CompanyViewController") as! CompanyViewController
           companyViewController.delegate = self // Set the delegate to self

           navigationController?.pushViewController(companyViewController, animated: true)
       }

    func addNewCompany(_ company: Company) {
        companies.append(company)
        self.tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
        if let companies = Company.viewAllCompanies() {
            self.companies = companies
            print("data:",companies)
            //companies.sorted(by: <#T##(Company, Company) throws -> Bool#>)
            tableView.reloadData()
        } else {
            print("No companies found.")
        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation,  return the number of sections
       return 1
        
    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return companies.count
//    }
//
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCompanies.count
        } else {
            return companies.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("inside table view")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let company: Company
        if isFiltering {
            company = filteredCompanies[indexPath.row]
        } else {
            company = companies[indexPath.row]
        }
        cell.textLabel?.text = "\(company.id). \(company.name ?? "")"
        
        
        if let logoData = company.logo, let companyLogo = UIImage(data: logoData) {
            let cellWidth = cell.frame.width
            let logoSize = CGSize(width: cellWidth * 0.2, height: cellWidth * 0.1) // Set the logo size
            let logoRect = CGRect(origin: .zero, size: logoSize)
            UIGraphicsBeginImageContextWithOptions(logoSize, false, 0.0)
            companyLogo.draw(in: logoRect)
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
        
        
        cell.detailTextLabel?.text = "\(company.address ?? "") \(company.zip)"
        
        // Create the info button
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(infoButtonTapped(_:)), for: .touchUpInside)
        
        // Set the tint color and font of the button
        infoButton.tintColor = .black
        infoButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        
        // Set the button as the accessory view of the cell
        cell.accessoryView = infoButton
        
        
        //            if let searchText = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines),
        //               !searchText.isEmpty,
        //               let companyName = company.name?.trimmingCharacters(in: .whitespacesAndNewlines),
        //               !companyName.isEmpty,
        //               companyName.lowercased().contains(searchText.lowercased()) {
        //                cell.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
        //            } else {
        //                cell.backgroundColor = UIColor.clear
        //            }
        //
        //            return cell
        //
        //    }
        if let searchText = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           !searchText.isEmpty,
           let companyName = company.name?.trimmingCharacters(in: .whitespacesAndNewlines),
           !companyName.isEmpty,
           companyName.lowercased().contains(searchText.lowercased()) {

            cell.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)

            // Remove the company from the array and insert it at the beginning
            if let index = filteredCompanies.firstIndex(of: company) {
                filteredCompanies.remove(at: index)
                filteredCompanies.insert(company, at: 0)
            }

        } else {
            cell.backgroundColor = UIColor.clear
        }

        return cell


    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCompany = companies[indexPath.row]
        let filteredCompanies = companies.filter { $0.name == selectedCompany.name }
        guard let selectedFilteredCompany = filteredCompanies.first else {
            return
        }
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.company = selectedFilteredCompany
        navigationController?.pushViewController(detailVC, animated: true)

    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete {
            let company = companies[indexPath.row]
            let alertController = UIAlertController(title: "Delete Company", message: "Are you sure you want to delete \(company.name ?? "")?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive)
            { (_) in
                
                // Fetch the products associated with the company
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    fatalError("Could not get app delegate.")
                }

                let context = appDelegate.persistentContainer.viewContext
                let fetchRequest: NSFetchRequest<Product1> = Product1.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "companyId == %ld", company.id)

                
                do {
                    let products = try context.fetch(fetchRequest)
                    
                    // Check if the products array is empty or not
                    if !products.isEmpty {
                        // Products exist, show alert
                        let alertController = UIAlertController(title: "Delete Company", message: "This company has products associated with it. Please delete the products before deleting the company.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        // No products associated, proceed with deleting the company
                        context.delete(company)
                        try context.save()
                        self.companies.remove(at: indexPath.row)
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



    func fetchData() {
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let companies = try JSONDecoder().decode([CompanyData].self, from: data)
                try self.saveCompaniesToCoreData(companiesData: companies)
                print("Data saved to Core Data")
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    func companyExists(id: Int) -> Bool {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Company> = Company.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %ld", Int64(id))
        // fetchRequest.predicate = NSPredicate(format: "name == name ", String(name))
        do {
            let matchingCompanies = try context.fetch(fetchRequest)
            return matchingCompanies.count > 0
        } catch {
            return false
        }
    }

    func saveCompaniesToCoreData(companiesData: [CompanyData]) throws
    {
        print("inside save comapny core dsta")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            showAlert(message: "Error saving api data")
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        print(companiesData)
        print("Done printing")
        for company in companiesData {
            if let id = Int64(company.id ?? "8"), let zip = Int64(company.zip ?? "123456")
            {
                if !companyExists(id: Int(id)) {
                    // create a new Company object with the converted id and zip
                    let newCompany = Company(context: context)
                    newCompany.id = id
                    newCompany.name = company.name
                    newCompany.address = company.address
                    newCompany.country = company.country
                    newCompany.zip = zip
                    newCompany.companyType = company.companyType
                    // download and store logo data
                    print("download and stored the data")
                    if let logoURLString = company.logo,
                       let logoURL = URL(string: logoURLString)  {
                        do {
                            let logoData = try Data(contentsOf: logoURL)
                            newCompany.logo = logoData
                            print("logo datas:",logoData)
                        } catch {
                            print("Error downloading logo for company with id: \(company.id)")
                        }
                    }
                }
                                  
            }
        }
        
        DispatchQueue.main.async {
               do {
                   try context.save()
               } catch {
                   self.showAlert(message: "Error saving api data")
               }
           }
    }



    func downloadImage(from urlString: String) -> Data? {
        guard let url = URL(string: urlString) else {
            print("Invalid URL for image")
            return nil
        }

        do {
            let imageData = try Data(contentsOf: url)
            return imageData
        } catch {
            print("Error downloading image: \(error.localizedDescription)")
            return nil
        }
    }

    func isConnectedToNetwork(completion: @escaping (Bool) -> Void) {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                completion(true)
            } else {
                completion(false)
            }
        }
    }


    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCompanyDetailSegue" {
            if let company = sender as? Company,
               let destinationVC = segue.destination as? DetailViewController {
                // Pass the selected company to the detail view controller
                destinationVC.company = company
            }
        }
    }


    @objc func infoButtonTapped(_ sender: UIButton) {
        let selectedCompany = companies[sender.tag]
           let filteredCompanies = companies.filter { $0.name == selectedCompany.name }
           guard let selectedFilteredCompany = filteredCompanies.first else {
               return
           }
           let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
           detailVC.company = selectedFilteredCompany
           navigationController?.pushViewController(detailVC, animated: true)
        }
        
        // Handle the info button tap event
        // You can access the selected company from the sender's tag or indexPath
        // Example: let company = companies[sender.tag]
        // Perform the appropriate action with the selected compan

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

