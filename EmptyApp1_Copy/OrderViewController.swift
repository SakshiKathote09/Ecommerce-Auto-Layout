//
//  OrderViewController.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 08/04/23.
//

import UIKit
import CoreData

class OrderViewController: UIViewController,UITextFieldDelegate
{
    weak var delegate: OrderViewControllerDelegate?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var addScrollView: UIScrollView!
    
    @IBOutlet weak var updateScrollView: UIScrollView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var idText: UITextField!
    
    @IBOutlet weak var PTid: UITextField!
    @IBOutlet weak var pidText: UITextField!
    @IBOutlet weak var orderDate: UIDatePicker!
    @IBOutlet weak var PPidText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundimage = UIKit.UIImageView(frame: UIScreen.main.bounds)
        backgroundimage.image = UIImage(named: "marble")
        backgroundimage.contentMode = .scaleToFill
        view.insertSubview(backgroundimage, at: 0)
        
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
//    }

    
    @IBAction func SubmitTap(_ sender: UIButton)
    {
        let idstr = idText.text
        let id = Int(idstr ?? "")

        let productIdString = pidText.text
        let productId = Int(productIdString ?? "")

        let productpostIdString = PPidText.text
        let productPostId = Int(productpostIdString ?? "")

        let productType = PTid.text ?? ""

        let selectedDate = orderDate.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: selectedDate)
//
        func productPostExists(productPostId: Int) -> Bool {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Product_Post1> = Product_Post1.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %ld", Int64(productPostId))

            do {
                let matchingProductPosts = try context.fetch(fetchRequest)
                return matchingProductPosts.count > 0
            } catch {
                return false
            }
        }
        func productexists(productID: Int) -> Bool {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Product1> = Product1.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %ld", Int64(productID))

            do {
                let matchingProductPosts = try context.fetch(fetchRequest)
                return matchingProductPosts.count > 0
            } catch {
                return false
            }
        }
        func productype(productType: String) -> Bool {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<ProductType1> = ProductType1.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", productType)

            do {
                let matchingProductPosts = try context.fetch(fetchRequest)
                return matchingProductPosts.count > 0
            } catch {
                return false
            }
        }

        func orderExists(productPostId: Int) -> Bool {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Order1> = Order1.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "post_id == %ld", Int64(productPostId))

            do {
                let matchingOrders = try context.fetch(fetchRequest)
                return matchingOrders.count > 0
            } catch {
                return false
            }
        }
        if !productype(productType: productType) {
            let alertController = UIAlertController(title: "Error", message: "Product type does not exist", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
        if !productexists(productID:productId ?? 0){
            let alertController = UIAlertController(title: "Error", message: "Product  does not exist", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
        if !productPostExists(productPostId:productPostId ?? 0) {
            let alertController = UIAlertController(title: "Error", message: "Product Post does not exist", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
        else
        {
            Order1.addOrder(id: id ?? 0, order_date: selectedDate, post_id: productPostId ?? 0, product_id: productId ?? 0, product_type: productType )
            let alertController = UIAlertController(title: "Success", message: "Ordered successfully", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            //  }
            
        }
    }
    
    @IBOutlet weak var idUpdate: UITextField!
    
    @IBOutlet weak var PTupdate: UITextField!
    @IBOutlet weak var pidUpdate: UITextField!
    @IBOutlet weak var orderDateUpdate: UIDatePicker!
    @IBOutlet weak var ppIdUpdate: UITextField!
    
    
    @IBAction func Update(_ sender: UIButton)
    {
        guard let idstr = idUpdate.text, let id = Int(idstr),
              let productIdString = pidUpdate.text, let productId = Int(productIdString),
              let productpostIdString = ppIdUpdate.text, let productPostId = Int(productpostIdString),
              let productType = PTupdate.text,
              let selectedDate = orderDateUpdate.date as? NSDate
              else {
                  let alert = UIAlertController(title: "Error", message: "Invalid input values", preferredStyle: .alert)
                  let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                  alert.addAction(okAction)
                  present(alert, animated: true, completion: nil)
                  return
              }
        func productPostExists(productPostId: Int) -> Bool {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Product_Post1> = Product_Post1.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %ld", Int64(productPostId))

            do {
                let matchingProductPosts = try context.fetch(fetchRequest)
                return matchingProductPosts.count > 0
            } catch {
                return false
            }
        }
        func productexists(productID: Int) -> Bool {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Product1> = Product1.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "productID == %ld", Int64(productID))

            do {
                let matchingProductPosts = try context.fetch(fetchRequest)
                return matchingProductPosts.count > 0
            } catch {
                return false
            }
        }
        func productypeexists(productType: String) -> Bool {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<ProductType1> = ProductType1.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "productType == %@", productType)

            do {
                let matchingProductPosts = try context.fetch(fetchRequest)
                return matchingProductPosts.count > 0
            } catch {
                return false
            }
        }
        func orderExists(id: Int) -> Bool {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Order1> = Order1.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %ld", Int64(id))

            do {
                let matchingOrders = try context.fetch(fetchRequest)
                return matchingOrders.count > 0
            } catch {
                return false
            }
        }
        
        
        if orderExists(id: productPostId) {
            let alert = UIAlertController(title: "Error", message: "Order already exists for this product post", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }

        if !productPostExists(productPostId: productPostId) {
            let alert = UIAlertController(title: "Error", message: "Product post does not exist", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }

        if !productexists(productID: productId) {
            let alert = UIAlertController(title: "Error", message: "Product does not exist", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }

        if !productypeexists(productType: productType) {
            let alert = UIAlertController(title: "Error", message: "Product type does not exist", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }

        // If all values are valid and unique, update the order
        Order1.updateOrder(id: id, orderDate: selectedDate as Date, postId: productPostId, productId: productId, productType: productType)

        let alert = UIAlertController(title: "Success", message: "Order updated successfully", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        

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
protocol OrderViewControllerDelegate: AnyObject {
    func addNewOrder(_ orders : Order1)
    func editNewOrder(_ orders : Order1)
}

