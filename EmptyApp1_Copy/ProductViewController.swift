//
//  ProductViewController.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 06/04/23.
//

import UIKit
import CoreData

class ProductViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate
{
    weak var delegate: ProductViewControllerDelegate?
    
    @IBOutlet weak var updateScrollView: UIScrollView!
    @IBOutlet weak var addScrollView: UIScrollView!
    @IBOutlet weak var CompanyIdTextField: UITextField!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var ProductImageView: UIImageView!
    @IBOutlet weak var QuantityTextField: UITextField!
    @IBOutlet weak var ProductRatingTextField: UITextField!
    @IBOutlet weak var ProductDTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var idTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if addScrollView.isDescendant(of: vi
//
        let backgroundimage = UIKit.UIImageView(frame: UIScreen.main.bounds)
        backgroundimage.image = UIImage(named: "marble")
        backgroundimage.contentMode = .scaleToFill
        view.insertSubview(backgroundimage, at: 0)
        
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
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
    
    @IBAction func Selectimage(_ sender: UIButton)
    {
        let imagePicker = UIImagePickerController()
   imagePicker.delegate = self
   imagePicker.sourceType = .photoLibrary
   present(imagePicker, animated: true, completion: nil)
}
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        ProductImageView.image = selectedImage
        
    
    }
    dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SubmitTap(_ sender: UIButton)
    {
        idTextField.delegate = self
        nameTextField.delegate = self
        ProductDTextField.delegate = self
        ProductRatingTextField.delegate = self
        QuantityTextField.delegate = self
        CompanyIdTextField.delegate = self
        
        
        let idstr = idTextField.text
        let id = Int(idstr ?? "") ?? 0
        let name = nameTextField.text ?? ""
        let productDesc = ProductDTextField.text ?? ""
        let productRatingString = ProductRatingTextField.text
        let productRating = Decimal(string: productRatingString ?? "") ?? 0.0
        let companyIdString = CompanyIdTextField.text
        let companyId = Int(companyIdString ?? "") ?? 0
        let quantityString = QuantityTextField.text
        let quantity = Int(quantityString ?? "") ?? 0
        let logoData = ProductImageView.image?.pngData()
        
        if name.isEmpty || productDesc.isEmpty == true || quantityString?.isEmpty == true
        {
            let alertController = UIAlertController(title: "Error", message: "Please fill in all fields.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
        func isCompanyMatchingProduct(product: Product1, company: Company) -> Bool {
            return product.companyId == company.id
        }
        
        func companyExists(id: Int) -> Bool {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Company> = Company.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %ld", Int64(id))
            do {
                let matchingCompanies = try context.fetch(fetchRequest)
                return !matchingCompanies.isEmpty
            } catch {
                return false
            }
        }
        func ProductExists(id: Int) -> Bool {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Product1> = Product1.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %ld", Int64(id))
            do {
                let matchingProducts = try context.fetch(fetchRequest)
                return !matchingProducts.isEmpty
            } catch {
                return false
            }
        }
        
        if companyExists(id: companyId)
        {
            if ProductExists(id: id)
            {
                let alertController = UIAlertController(title: "Error", message: "Product with same ID already exists", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alertController, animated: true, completion: nil)
            }
            else
            {
                // Add the product to the database
                Product1.addProduct(id: id, name: name, productDescription: productDesc, productRating: productRating, companyId: companyId, quantity: quantity,logo:logoData)
                
                let alertController = UIAlertController(title: "Success", message: "Product Added Successfully", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
        else
        {
            let alertController = UIAlertController(title: "Error", message: "No matching company found", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
      
    
    
    @IBOutlet weak var updateQ: UITextField!
    @IBOutlet weak var updateRating: UITextField!
    @IBOutlet weak var updatePD: UITextField!
    @IBOutlet weak var updateId: UITextField!

    @IBOutlet weak var updateName: UITextField!

    @IBOutlet weak var updateCompanyId: UITextField!


    @IBAction func Update(_ sender: UIButton)
    {
        let idstr = updateId.text
        let id = Int(idstr ?? "") ?? 0
        let name = updateName.text ?? ""
        let productDesc = updatePD.text ?? ""
        let companyIdString = updateCompanyId.text
        let productRatingString = updateRating.text
        let productRating = Decimal(string: productRatingString ?? "") ?? 0.0
        let companyId = Int(companyIdString ?? "") ?? 0
        let quantityString = updateQ.text
        let quantity = Int(quantityString ?? "") ?? 0
        
        func canUpdateProduct(productId: Int, companyId: Int) -> Bool
        {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let productRequest: NSFetchRequest<Product1> = Product1.fetchRequest()
            productRequest.predicate = NSPredicate(format: "id == %ld AND companyId == %ld", Int64(productId), Int64(companyId))
            do {
                let matchingProducts = try context.fetch(productRequest)
                return matchingProducts.count > 0
            } catch {
                return false
            }
        }
        if productRating > 5.0 {
            let alert = UIAlertController(title: "Error", message: "Product rating cannot be greater than 5", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        if canUpdateProduct(productId: id, companyId: companyId)
        {
            Product1.updateProduct(id: id, name: name, productDescription: productDesc, productRating: productRating, companyId: companyId, quantity: quantity)
            
            let alertController = UIAlertController(title: "Success", message: "Product Updated Successfully", preferredStyle: .alert)
            
            // Change the background color of the alert
            alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.green
            
            // Add a custom icon to the alert
            let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
            imageView.image = UIImage(named: "successIcon")
            alertController.view.addSubview(imageView)
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
        }
        else
        {
            let alertController = UIAlertController(title: "Error", message: "Product cannot be Updated ", preferredStyle: .alert)
            let attributedTitle = NSAttributedString(string: "Error", attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
                NSAttributedString.Key.foregroundColor: UIColor(red: 0.22, green: 0.74, blue: 0.44, alpha: 1.0)
            ])
            alertController.setValue(attributedTitle, forKey: "attributedTitle")
            let attributedMessage = NSAttributedString(string: "Error in Updating Product", attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.darkGray
            ])
            alertController.setValue(attributedMessage, forKey: "attributedMessage")
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            okAction.setValue(UIColor(red: 0.22, green: 0.74, blue: 0.44, alpha: 1.0), forKey: "titleTextColor")
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
protocol ProductViewControllerDelegate: AnyObject {
    func addNewProduct(_ product : Product1)
    func editNewProducts(_ product : Product1)
}

