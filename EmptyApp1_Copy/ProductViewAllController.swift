//
//  ProductViewAllController.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 06/04/23.
//

import UIKit

class ProductViewAllController: UIViewController
{

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var TextView: UITextView!
    
    var product: Product1?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if let product = product {
            
            let detailText = "ID: \(product.id)\nName: \(product.name ?? "")\nDescription: \(product.productDescription ?? "")\nRating: \(product.productRating ?? 0)\nCompany ID: \(product.companyId )\nQuantity: \(product.quantity)\n"
               TextView.text = detailText
           
            self.title = product.name
                if let logoData = product.logo, let logoImage = UIImage(data: logoData) {
                    ImageView.image = logoImage
                    ImageView.contentMode = .scaleAspectFit // Set the content mode
                }
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
