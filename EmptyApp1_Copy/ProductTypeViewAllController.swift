//
//  ProductTypeViewAllController.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 07/04/23.
//

import UIKit

class ProductTypeViewAllController: UIViewController {

    @IBOutlet weak var TextViewPt: UITextView!
    var productType: ProductType1?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let productType = productType {
            
            let detailText = "ID: \(productType.id)\nName: \(productType.name ?? "")"
               TextViewPt.text = detailText
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
