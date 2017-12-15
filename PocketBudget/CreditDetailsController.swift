//
//  CreditDetailsController.swift
//  PocketBudget
//
//  Created by Andrew Webber on 12/4/17.
//  Copyright © 2017 Andrew Webber. All rights reserved.
//

import UIKit

class CreditDetailsController: UIViewController {
    
    @IBOutlet weak var lblSummary: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    var detailCredit = Credits()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblSummary.text = detailCredit.summary
        lblAmount.text = String("$\(detailCredit.amountDisplay)")
        lblDate.text = detailCredit.dateAdded
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
