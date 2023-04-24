//
//  CompanyViewController.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 04/04/23.
//

import UIKit

import CoreData
class CompanyViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate
{
    
    @IBOutlet var myView: UIView!
    
    weak var delegate: CompanyViewControllerDelegate?
  
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var UIImageView: UIImageView!
    
    var submitCompletion: ((Company) -> Void)?
    
    @IBOutlet weak var addScrollView: UIScrollView!
    
    

    @IBOutlet weak var updateScrollView: UIScrollView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedLogo: UIImage?
    var updatelogo: UIImage?
    var activeTextField: UITextField?
    
    @IBOutlet weak var idT: UITextField!
    
    @IBOutlet weak var zipT: UITextField!
    @IBOutlet weak var companyTypeT: UITextField!
    @IBOutlet weak var countryT: UITextField!
    @IBOutlet weak var addressT: UITextField!
    @IBOutlet weak var nameT: UITextField!
    
    private var textFields: [UITextField] = []
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
       // updateScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        let backgroundimage = UIKit.UIImageView(frame: UIScreen.main.bounds)
        backgroundimage.image = UIImage(named: "marble")
        backgroundimage.contentMode = .scaleToFill
        view.insertSubview(backgroundimage, at: 0)

          // Set the delegate of all text fields in the scroll view
        
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
      //  UIImageView.layer.borderWidth = 1
       // UIImageView.layer.borderColor = UIColor.lightGray.cgColor

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    //     Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

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

    @IBAction func SelectImage(_ sender: UIButton)
    {
                let imagePicker = UIImagePickerController()
           imagePicker.delegate = self
           imagePicker.sourceType = .photoLibrary
           present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                UIImageView.image = selectedImage
                
            
            }
            dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submit(_ sender: UIButton)
    {
        
        idT.delegate = self
        nameT.delegate = self
        companyTypeT.delegate = self
        addressT.delegate = self
        zipT.delegate = self
        countryT.delegate = self
    
     
        
        let id = Int(idT.text ?? "0") ?? 0
        let name = nameT.text ?? ""
        let address = addressT.text ?? ""
        let country = countryT.text ?? ""
        let zipString = zipT.text ?? ""
        let logoData = UIImageView.image?.pngData()
        let zip = Int(zipString) ?? 0
        //   let zip = Int(ZipTextField.text ?? "0") ?? 0
        let companyType = companyTypeT.text ?? ""
        guard let name = nameT.text ,!name.isEmpty else
        {
            let alertController = UIAlertController(title: "Error", message: "Please fill out all required fields", preferredStyle: .alert)
            
            let attributedTitle = NSAttributedString(string: "Error", attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
                NSAttributedString.Key.foregroundColor: UIColor.red
            ])
            alertController.setValue(attributedTitle, forKey: "attributedTitle")
            
            let attributedMessage = NSAttributedString(string: "Please fill out all required fields", attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.darkGray
            ])
            alertController.setValue(attributedMessage, forKey: "attributedMessage")
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            okAction.setValue(UIColor.red, forKey: "titleTextColor")
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
            return
            
        }
        if companyExists(id:id)
        {
            let alert = UIAlertController(title: "Error", message: "A company with the same ID already exists.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
        else
        {
            print("adding data to core data normal addition of company")

           Company.addCompany(id:id,name: name, address: address, country: country, zip: zip, companyType: companyType,logo:logoData)
            // delegate?.addNewCompany(company)
          //  navigationController?.popViewController(animated: true)
            // delegate?.didAddCompany()
            let alertController = UIAlertController(title: "Success", message: "Company added successfully", preferredStyle: .alert)
            let attributedTitle = NSAttributedString(string: "Success", attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
                NSAttributedString.Key.foregroundColor: UIColor(red: 0.22, green: 0.74, blue: 0.44, alpha: 1.0)
            ])
            alertController.setValue(attributedTitle, forKey: "attributedTitle")
            let attributedMessage = NSAttributedString(string: "Company added successfully", attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.darkGray
            ])
            alertController.setValue(attributedMessage, forKey: "attributedMessage")
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            okAction.setValue(UIColor(red: 0.22, green: 0.74, blue: 0.44, alpha: 1.0), forKey: "titleTextColor")
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            
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
    }
    
    
    @IBOutlet weak var ImageView: UIImageView!
    
    @IBAction func UpdateSelectImage(_ sender: UIButton)
    {
                let imagePicker = UIImagePickerController()
           imagePicker.delegate = self
           imagePicker.sourceType = .photoLibrary
           present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerControllerUpdate(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                ImageView.image = selectedImage
            
            }
            dismiss(animated: true, completion: nil)
    }

    
 
    @IBOutlet weak var Uid: UITextField!
    
    @IBOutlet weak var uCT: UITextField!
    @IBOutlet weak var uZip: UITextField!
    @IBOutlet weak var uCountry: UITextField!
    @IBOutlet weak var Uaddress: UITextField!
    @IBOutlet weak var uName: UITextField!
    @IBAction func Update(_ sender: UIButton)
    {
        
        Uid.delegate = self
        uName.delegate = self
        uCT.delegate = self
        Uaddress.delegate = self
        uZip.delegate = self
        uCountry.delegate = self
        
        guard let idtypestr = Uid.text,let id = Int(idtypestr),
              let name = uName.text,
           //   let logoData = ImageView.image?.pngData(),
              let address = Uaddress.text,
              let country = uCountry.text,
              let zipStr = uZip.text, let zip = Int(zipStr),
              let companyType = uCT.text
        else
        {
            let alert = UIAlertController(title: "Error", message: "This value already exists. Please enter a unique value.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        
        func companyTypeExists(companyType: String) -> Bool {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Company> = Company.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "companyType == %@", companyType)
            
            do {
                let matchingCompanies = try context.fetch(fetchRequest)
                return matchingCompanies.count > 0
            } catch {
                return false
            }
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
        
        if companyTypeExists(companyType: companyType)
        {
            let alert = UIAlertController(title: "Error", message: "This company  already exists. Please enter a unique value.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        else if companyExists(id: id)
        {
            Company.updateCompany(id: id, name: name, address: address, country: country, zip: zip, companyType: companyType)
            
            let alertController = UIAlertController(title: "Success", message: "Company Updated successfully", preferredStyle: .alert)
            let attributedTitle = NSAttributedString(string: "Success", attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
                NSAttributedString.Key.foregroundColor: UIColor(red: 0.22, green: 0.74, blue: 0.44, alpha: 1.0)
            ])
            alertController.setValue(attributedTitle, forKey: "attributedTitle")
            let attributedMessage = NSAttributedString(string: "Company Updated successfully", attributes: [
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
            let alert = UIAlertController(title: "Error", message: "This company id does not exists. Please enter a unique value.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
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
}
protocol CompanyViewControllerDelegate: AnyObject {
    func addNewCompany(_ company: Company)
    func editNewCompany(_ company : Company)
}
