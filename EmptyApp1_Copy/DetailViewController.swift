//
//  DetailViewController.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 05/04/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var DetailView: UITextView!
    
    
    @IBOutlet weak var ImageView: UIImageView!
    var company: Company?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if let company = company {
            // Set the image
           
            // Set the text
            let detailText = "ID: \(company.id)\nName: \(company.name ?? "")\nAddress: \(company.address ?? "")\nCountry: \(company.country ?? "")\nZip: \(company.zip)\nCompany Type: \(company.companyType ?? "")"
            DetailView.text = detailText
            
            self.title = company.name
            if let logoData = company.logo, let logoImage = UIImage(data: logoData) {
                ImageView.image = logoImage
                ImageView.contentMode = .scaleAspectFit // Set the content mode
            }
            
            
            
            

        }

    }
    // Do any additional setup after loading the view.
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
