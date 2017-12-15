//
//  CreditController.swift
//  PocketBudget
//
//  Created by Andrew Webber on 11/26/17.
//  Copyright © 2017 Andrew Webber. All rights reserved.
//

import UIKit
import Firebase

class CreditController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: properties
    let ref = Database.database()
    var creditsArray: [Credits] = []
    var currentUser = Auth.auth().currentUser!
    var creditAmount: Double = 0
    var creditAmountDisplay: Double = 0
    var creditSummary: String = ""
    var creditObject = Credits()
    
    var summary: String?
    var amount: Double?
    var date: String?
    
    
    //MARK: outlets
    @IBOutlet weak var creditsTable: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var txtSummary: UITextField!
    @IBOutlet weak var txtAmount: UITextField!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Credits", image: UIImage(named: "wallet"), tag: 1)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtAmount.resignFirstResponder()
        txtSummary.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        ref.reference(withPath: "credits/\(currentUser.uid)").queryOrdered(byChild: "dateAdded").observe(.value, with:
            { snapshot in
                var fireAccountArray: [Credits] = []
                
                for fireAccount in snapshot.children {
                    let fireAccount = Credits(snapshot: fireAccount as! DataSnapshot)
                    fireAccountArray.append(fireAccount)
                    
                }
                
                self.creditsArray = fireAccountArray
                
                self.creditsTable.delegate = self;
                self.creditsTable.dataSource = self;
                self.creditsTable.reloadData()
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recentCell = tableView.dequeueReusableCell(withIdentifier: "credits", for: indexPath) as! CreditViewCell
        let credit = self.creditsArray[indexPath.row]
        recentCell.lblDate?.text = credit.dateAdded
        recentCell.lblAmount?.text = String(format: "$%.02f", credit.amountDisplay)
        recentCell.lblSummary?.text = credit.summary
       
        return recentCell
        
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //let deleteRef = Database.database().reference(withPath: "debits/\(currentUser.uid)")
            let creditItem = creditsArray[indexPath.row]
            creditItem.ref?.removeValue()
        }
    }
    
    @IBAction func btn_AddTouchUpInside(_ sender: Any) {
        creditAmount = Double(txtAmount.text!)!
        //creditAmountDisplay = Double(txtAmount.text!)!
        //creditCategory = pickerData[picCategory.selectedRow(inComponent: 0)]
        creditSummary = txtSummary.text!
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let dateString = formatter.string(from: date)
        
        //let key = "2"//ref.reference().childByAutoId()
        
        let deb = Credits(dateAdded: dateString, summary: creditSummary, amount: creditAmount, amountDisplay: creditAmount)
        
        //let array: NSArray = [deb.toAnyObject()]
        
        ref.reference(withPath: "credits/\(currentUser.uid)").childByAutoId().setValue(deb.toAnyObject())

        txtAmount.text = ""
        txtSummary.text = ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        summary = self.creditsArray[indexPath.row].summary
        amount = self.creditsArray[indexPath.row].amount
        date = self.creditsArray[indexPath.row].dateAdded
        
        creditObject = Credits(dateAdded: date!, summary: summary!, amount: amount!, amountDisplay: amount!)
        performSegue(withIdentifier: "creditDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "creditDetails" {
            let vc = segue.destination as! CreditDetailsController
            vc.detailCredit = creditObject
        }
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
