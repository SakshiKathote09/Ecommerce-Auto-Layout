//
//  ProductTypeViewController.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 07/04/23.
//

import UIKit
import CoreData

class ProductTypeViewController: UIViewController,UITextFieldDelegate
{
    weak var delegate: ProductTypeViewControllerDelegate?

    var scrollView : UIScrollView!
    @IBOutlet weak var updateScrollView: UIScrollView!
    @IBOutlet weak var addScrollView: UIScrollView!
    @IBOutlet weak var namePT: UITextField!
    @IBOutlet weak var idPT: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundimage = UIKit.UIImageView(frame: UIScreen.main.bounds)
        backgroundimage.image = UIImage(named: "marble")
        backgroundimage.contentMode = .scaleToFill
        view.insertSubview(backgroundimage, at: 0)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

       }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

        
        // Do any additional setup after loading the view.
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
//    }
  
    @IBAction func submitTap(_ sender: UIButton)
    {
        let id = Int(idPT.text ?? "0") ?? 0
        let name = namePT.text ?? ""
        
        if name.isEmpty == true
        {
            let alertController = UIAlertController(title: "Error", message: "Please fill out name required field correctly", preferredStyle: .alert)

            let attributedTitle = NSAttributedString(string: "Error", attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
                NSAttributedString.Key.foregroundColor: UIColor.red
            ])
            alertController.setValue(attributedTitle, forKey: "attributedTitle")

            let attributedMessage = NSAttributedString(string: "Please fill out name required field correctly", attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.darkGray
            ])
            alertController.setValue(attributedMessage, forKey: "attributedMessage")

            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            okAction.setValue(UIColor.red, forKey: "titleTextColor")
            alertController.addAction(okAction)

            present(alertController, animated: true, completion: nil)
        }
        func productTypeExists(id: Int) -> Bool {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<ProductType1> = ProductType1.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %ld", Int64(id))
           // fetchRequest.predicate = NSPredicate(format: "name == name ", String(name))
            do {
                let matchingProductype = try context.fetch(fetchRequest)
                return matchingProductype.count > 0
            } catch {
                return false
            }
        }
        if productTypeExists(id:id)
        {
            let alert = UIAlertController(title: "Error", message: "A productType with the same ID already exists.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
        else
        {
            ProductType1.addProductType(id: id, name: name)
            
            let alertController = UIAlertController(title: "Success", message: "Product type added successfully", preferredStyle: .alert)
            let attributedTitle = NSAttributedString(string: "Success", attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
                NSAttributedString.Key.foregroundColor: UIColor(red: 0.22, green: 0.74, blue: 0.44, alpha: 1.0)
            ])
            alertController.setValue(attributedTitle, forKey: "attributedTitle")
            let attributedMessage = NSAttributedString(string: "product type added successfully", attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.darkGray
            ])
            alertController.setValue(attributedMessage, forKey: "attributedMessage")
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            okAction.setValue(UIColor(red: 0.22, green: 0.74, blue: 0.44, alpha: 1.0), forKey: "titleTextColor")
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            
        
        }
        namePT.text = ""
        idPT.text = ""
    }
    
    
    
    
    @IBOutlet weak var updateID: UITextField!
    
    @IBOutlet weak var updateName: UITextField!
    
    
    @IBAction func UpdateTap(_ sender: UIButton)
    {
        guard let idtypestr = updateID.text,let id = Int(idtypestr),
              let name = updateName.text
        else
        {
            let alert = UIAlertController(title: "Error", message: "This value already exists. Please enter a unique value.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        func productTypeExists(id: Int) -> Bool {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<ProductType1> = ProductType1.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %ld", Int64(id))
            // fetchRequest.predicate = NSPredicate(format: "name == name ", String(name))
            do {
                let matchingProductype = try context.fetch(fetchRequest)
                return matchingProductype.count > 0
            } catch {
                return false
            }
        }
        if productTypeExists(id:id)
        {
            ProductType1.updateProductType(id: id, name: name)
            
            let alertController = UIAlertController(title: "Success", message: "Product type Updated successfully", preferredStyle: .alert)
            let attributedTitle = NSAttributedString(string: "Success", attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
                NSAttributedString.Key.foregroundColor: UIColor(red: 0.22, green: 0.74, blue: 0.44, alpha: 1.0)
            ])
            alertController.setValue(attributedTitle, forKey: "attributedTitle")
            let attributedMessage = NSAttributedString(string: "Product type Updated successfully", attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.darkGray
            ])
            alertController.setValue(attributedMessage, forKey: "attributedMessage")
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            okAction.setValue(UIColor(red: 0.22, green: 0.74, blue: 0.44, alpha: 1.0), forKey: "titleTextColor")
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "A productType with the  ID doesnt exists.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
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
protocol ProductTypeViewControllerDelegate: AnyObject {
    func addNewProductType(_ productTypes: ProductType1)
    func editNewProductType(_ productTypes : ProductType1)
}

