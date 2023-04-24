//
//  ProductPostViewController.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 07/04/23.
//

import UIKit
import CoreData
class ProductPostViewController: UIViewController {
    
    weak var delegate: ProductPostViewControllerDelegate?
    @IBOutlet weak var idPP: UITextField!
    
    @IBOutlet weak var updateScrollView: UIScrollView!
    @IBOutlet weak var addScrollView: UIScrollView!
    @IBOutlet weak var DescdText: UITextField!
    @IBOutlet weak var PriceIdText: UITextField!
    @IBOutlet weak var Date: UIDatePicker!
    @IBOutlet weak var ProductIdText: UITextField!
    @IBOutlet weak var CompanyIdText: UITextField!
    @IBOutlet weak var ProductTypeIdText: UITextField!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundimage = UIKit.UIImageView(frame: UIScreen.main.bounds)
        backgroundimage.image = UIImage(named: "marble")
        backgroundimage.contentMode = .scaleToFill
        view.insertSubview(backgroundimage, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
     //    Do any additional setup after loading the view.
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

 

    @IBAction func Submit(_ sender: UIButton)
    {
        let idstr = idPP.text
        let id = Int(idstr ?? "")
        
        
        let priceString = PriceIdText.text
        let price = Double(priceString ?? "") ?? 0.0

        let productTypeIdString = ProductTypeIdText.text
        let productTypeId = Int(productTypeIdString ?? "")
        let companyIdString = CompanyIdText.text
        let companyId = Int(companyIdString ?? "")

        let productIdString = ProductIdText.text
        let productId = Int(productTypeIdString ?? "")

        let selectedDate = Date.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: selectedDate)



        let description = DescdText.text ?? ""
        
        func companyExists(id: Int) -> Bool {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Company> = Company.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %ld", Int64(companyId ?? 0))
           // fetchRequest.predicate = NSPredicate(format: "name == name ", String(name))
            do {
                let matchingCompanies = try context.fetch(fetchRequest)
                return matchingCompanies.count > 0
            } catch {
                return false
            }
        }
        func productExists(id: Int) -> Bool {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Product1> = Product1.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %ld", Int64(productId ?? 0))
           // fetchRequest.predicate = NSPredicate(format: "name == name ", String(name))
            do {
                let matchingCompanies = try context.fetch(fetchRequest)
                return matchingCompanies.count > 0
            } catch {
                return false
            }
        }
        func productTypeExists(id: Int) -> Bool {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<ProductType1> = ProductType1.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %ld", Int64(productTypeId ?? 0))
           // fetchRequest.predicate = NSPredicate(format: "name == name ", String(name))
            do {
                let matchingCompanies = try context.fetch(fetchRequest)
                return matchingCompanies.count > 0
            } catch {
                return false
            }
        }
        func productpostexists(id: Int) -> Bool {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Product_Post1> = Product_Post1.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %ld", Int64(id))
           // fetchRequest.predicate = NSPredicate(format: "name == name ", String(name))
            do {
                let matchingCompanies = try context.fetch(fetchRequest)
                return matchingCompanies.count > 0
            } catch {
                return false
            }
        }
        
        
        if companyExists(id: companyId ?? 0) && productTypeExists(id: productTypeId ?? 0) && productExists(id: productId ?? 0) && !productpostexists(id: id ?? 0)
        {
            Product_Post1.addProduct_Post(id: id ?? 0, productTypeId: productTypeId ?? 0, companyid: companyId ?? 0, productId: productId ?? 0,postedDate: selectedDate, price: price, desc: description)
            
            
            let alertController = UIAlertController(title: "Success", message: "Product Post added successfully", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            
        }
        else
        {
           
            let alertController = UIAlertController(title: "Error", message: "company,product or product type id does not exists or post id already exists", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            
        }
    }
    
    
    @IBOutlet weak var updateId: UITextField!
    
    @IBOutlet weak var updateDesc: UITextField!
    @IBOutlet weak var updatePrice: UITextField!
    @IBOutlet weak var updatePid: UITextField!
    @IBOutlet weak var updateCId: UITextField!
    @IBOutlet weak var updatePTid: UITextField!
    
    @IBAction func Update(_ sender: UIButton)
    {
        let priceString = updatePrice.text
        let price =  Double(priceString ?? "") ?? 0.0
   //     let selectedDate = updatedate.date
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/dd/yyyy"
//        let dateString = dateFormatter.string(from: selectedDate)
        
        guard let idtypestr = updateId.text,let id = Int(idtypestr),
              let productTypeIdStr = updatePTid.text, let productTypeId = Int(productTypeIdStr),
              let companyIdStr = updateCId.text, let companyId = Int(companyIdStr),
              let productIdStr = updatePid.text, let productId = Int(productIdStr),
             // let priceStr = updatePrice.text,let price = Decimal(string: priceStr) ?? 0.0,
              let description = updateDesc.text
                else
        {
            let alertController = UIAlertController(title: "Error", message: "Please fill all fields", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
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
        func productExists(id: Int) -> Bool {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Product1> = Product1.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %ld", Int64(id))
           // fetchRequest.predicate = NSPredicate(format: "name == name ", String(name))
            do {
                let matchingCompanies = try context.fetch(fetchRequest)
                return matchingCompanies.count > 0
            } catch {
                return false
            }
        }
        func productTypeExists(id: Int) -> Bool {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<ProductType1> = ProductType1.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %ld", Int64(id))
           // fetchRequest.predicate = NSPredicate(format: "name == name ", String(name))
            do {
                let matchingCompanies = try context.fetch(fetchRequest)
                return matchingCompanies.count > 0
            } catch {
                return false
            }
        }
        
        if companyExists(id:companyId ) && productTypeExists(id: productTypeId ) && productExists(id: productId )
        {
            
            Product_Post1.updateProduct_Post(id:id,productTypeId: productTypeId, companyid: companyId, productId: productId, price: price, desc: description)
            
            let alertController = UIAlertController(title: "Success", message: "Product Post added successfully", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
        else
        {
            let alertController = UIAlertController(title: "Error", message: "Product Post cannot be updated ", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
protocol ProductPostViewControllerDelegate: AnyObject {
    func addNewPP(_ productPost: Product_Post1)
    func editNewPP(_ productPost : Product_Post1)
}

