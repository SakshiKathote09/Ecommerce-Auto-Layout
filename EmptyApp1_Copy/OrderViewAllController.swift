//
//  OrderViewAllController.swift
//  EmptyApp1_Copy
//
//  Created by sakshi kathote on 08/04/23.
//

import UIKit

class OrderViewAllController: UIViewController {

    @IBOutlet weak var TextView: UITextView!
    var order: Order1?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let order = order {
            
            let detailText = "ID: \(order.id)\n Order Date: \(String(describing: order.order_date))\nPost ID: \(order.post_id)\nProduct ID: \(order.product_id)\n Product Type: \(order.product_type ?? "")"
            print("printing",detailText)
            TextView.text = detailText
            
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
