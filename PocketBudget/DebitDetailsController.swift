//
//  DebitDetailsController.swift
//  PocketBudget
//
//  Created by Andrew Webber on 12/4/17.
//  Copyright © 2017 Andrew Webber. All rights reserved.
//

import UIKit

class DebitDetailsController: UIViewController {

    //MARK: properties
    @IBOutlet weak var lblSummary: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblFrequency: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    var detailDebit = Debits()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblSummary.text = detailDebit.summary
        lblAmount.text = String("$\(detailDebit.amount)")
        lblCategory.text = detailDebit.category
        lblFrequency.text = detailDebit.frequency
        lblDate.text = detailDebit.dateAddedd
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
