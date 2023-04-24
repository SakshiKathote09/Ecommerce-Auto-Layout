//
//  ProductPostViewAllController.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 07/04/23.
//

import UIKit

class ProductPostViewAllController: UIViewController {

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var productPost: Product_Post1?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let productPP = productPost {
            
            let detailText = "ID: \(productPP.id)\n Product Type ID: \(productPP.productTypeId)\n Company ID: \(productPP.companyid)\n Product ID: \(productPP.productId)\n Price:\(productPP.price)\nDescription: \(productPP.desc ?? "")"
               textView.text = detailText
        }
        // Do any additional setup after loading the view.
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
