//
//  DebitTableViewController.swift
//  PocketBudget
//
//  Created by Andrew Webber on 12/3/17.
//  Copyright © 2017 Andrew Webber. All rights reserved.
//

import UIKit
import Firebase

class DebitTableViewController: UITableViewController {

    //MARK: properties
    let ref = Database.database()
    
    var user: User!
    var debitArray: [Debits] = []
    var currentUser = Auth.auth().currentUser!
    var deb = Debits()
    var summary: String?
    var amount: Double?
    var category: String?
    var frequency: String?
    var date: String?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Add Expense", image: UIImage(named: "plus"), tag: 1)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return debitArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenses") as! DebitViewCell
        let debit = self.debitArray[indexPath.row]
        cell.lblDate?.text = debit.dateAddedd
        cell.lblAmount?.text = String(format: "$%.02f", debit.amount)
        cell.lblSummary?.text = debit.summary

        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //let deleteRef = Database.database().reference(withPath: "debits/\(currentUser.uid)")
            let debitItem = debitArray[indexPath.row]
            debitItem.ref?.removeValue()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        ref.reference(withPath: "debits/\(currentUser.uid)").queryOrdered(byChild: "dateAdded").observe(.value, with:
        //ref.reference(withPath: "test/").queryOrdered(byChild: "dateAdded").observe(.value, with:
            { snapshot in
                var fireAccountArray: [Debits] = []
                
                for fireAccount in snapshot.children {
                    let fireAccount = Debits(snapshot: fireAccount as! DataSnapshot)
                    fireAccountArray.append(fireAccount)
                    
                }
                
                self.debitArray = fireAccountArray
                self.tableView.reloadData()
        })
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        summary = self.debitArray[indexPath.row].summary
        amount = self.debitArray[indexPath.row].amount
        category = self.debitArray[indexPath.row].category
        frequency = self.debitArray[indexPath.row].frequency
        date = self.debitArray[indexPath.row].dateAddedd

        deb = Debits(dateAdded: date!, summary: summary!, amount: amount!, frequency: frequency!, category: category!)
        performSegue(withIdentifier: "debitDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "debitDetails" {
            let vc = segue.destination as! DebitDetailsController
            vc.detailDebit = deb
        }
    }

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }


   

}
