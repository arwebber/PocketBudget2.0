//
//  DashboardController.swift
//  PocketBudget
//
//  Created by Andrew Webber on 11/26/17.
//  Copyright © 2017 Andrew Webber. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class DashboardController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: properties
    let ref = Database.database()
    var recentArray: [Debits] = []
    var creditArray: [Credits] = []
    var recentArray2: [Debits] = []
    var incomeArray: [Income] = []
    var currentUser = Auth.auth().currentUser!
    var incomeObject = Income()
    //var incomeString: String
    
    @IBOutlet weak var recentTable: UITableView!
    
    @IBOutlet weak var lblDailyAmount: UILabel!
    
    //test for income
    var incomeDouble: Double = 0
    var incomeType: String = ""
    var savingsDouble: Double = 0
    var savingsType: String = ""
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //MARK: credit properties
        var totalCredits: Double = 0
        
        ref.reference(withPath: "credits/\(currentUser.uid)").queryOrdered(byChild: "dateAdded").observe(.value, with:
            { snapshot in
                var FIRCreditArray: [Credits] = []
                
                for debit in snapshot.children {
                    let debit = Credits(snapshot: debit as! DataSnapshot)
                    FIRCreditArray.append(debit)
                    
                }
                
                self.creditArray = FIRCreditArray
                
                //sum up credits
                if(self.creditArray.count>0){
                    for i in 0...(self.creditArray.count-1) {
                        let creditDateToday = Date()
                        let creditFormatter = DateFormatter()
                        creditFormatter.dateFormat = "MM/dd/yyyy"
                        let creditDateString = creditFormatter.string(from: creditDateToday)
                        //print("*********************************************\(dateString)*********")
                        
                        if(creditDateString == self.creditArray[i].dateAdded){
                            if(self.creditArray[i].amountDisplay > 0){
                                totalCredits += self.creditArray[i].amountDisplay
                                //var tc: Double = 0
                                //tc += totalCredits
                                //let amountKey = self.creditArray[i].key
                                //self.ref.reference(withPath: "credits/\(self.currentUser.uid)/\(amountKey)").child("amount").setValue(0 as Double)
                                
                                
                            }
                        }
                    }
                }
                //
                //print("*********************************************\(totalCredits)*********")
        })
        
        
        
        //MARK: debit properties
        var totalOnceDebits: Double = 0
        var totalWeeklyDebits: Double = 0
        var totalMonthlyDebits: Double = 0
        var totalYearlyDebits: Double = 0
        
        ref.reference(withPath: "debits/\(currentUser.uid)").queryOrdered(byChild: "dateAdded").observe(.value, with:
            { snapshot in
                var debitsArray: [Debits] = []
                
                
                for debit in snapshot.children {
                    let debit = Debits(snapshot: debit as! DataSnapshot)
                    
                    let dateToday2 = Date()
                    let formatter2 = DateFormatter()
                    formatter2.dateFormat = "MM/dd/yyyy"
                    let dateString2 = formatter2.string(from: dateToday2)
                    if(dateString2 == debit.dateAddedd){
                        debitsArray.append(debit)
                    }
//                    debitsArray.append(debit)
                    
                }
                
                self.recentArray = debitsArray
                //self.recentArray2 = fireAccountArray
                
                
                if(self.recentArray.count>0){
                    //sum up debits
                    for i in 0...(self.recentArray.count-1) {
                        //self.recentArray2[i - 1] = self.recentArray[self.recentArray.count - i]
                        let dateToday = Date()
                        let formatter = DateFormatter()
                        formatter.dateFormat = "MM/dd/yyyy"
                        let dateString = formatter.string(from: dateToday)
                        //print("*********************************************\(dateString)*********")
                       
                        //working daily change
    //                    if(dateString == self.recentArray[i].dateAddedd){
    //                        totalOnceDebits += self.recentArray[i].amount
    //                    }
                        
                        if(self.recentArray[i].frequency == "Once"){
                            if(dateString == self.recentArray[i].dateAddedd){
                                totalOnceDebits += self.recentArray[i].amount
                            }
                        }else if(self.recentArray[i].frequency == "Weekly"){
                            totalWeeklyDebits += self.recentArray[i].amount
                        }else if(self.recentArray[i].frequency == "Monthly"){
                            totalMonthlyDebits += self.recentArray[i].amount
                        }else if(self.recentArray[i].frequency == "Yearly"){
                            totalYearlyDebits += self.recentArray[i].amount
                        }
                        
                    }
                    
                }
                self.recentTable.delegate = self;
                self.recentTable.dataSource = self;
                self.recentTable.reloadData()
        })
        
        //MARK: income properties
        var calculatedIncome: Double = 0
        var calculatedSavings: Double = 0
        var dailyBudget: Double = 0
        var eIncome: Double = 0
        let incomeRef = Database.database().reference().child("income")
        let userId = Auth.auth().currentUser?.uid
        incomeRef.child(userId!).observe(.value, with: { snapshot in
            // get the entire snapshot dictionary
            if let dictionary = snapshot.value as? [String: Any]
            {
                let income = dictionary["income"] as? Double
                let incomeType = dictionary["incomeType"] as? String
                let savingsAmount = dictionary["savingsAmount"] as? Double
                let savingsType = dictionary["savingsType"] as? String
                let extraIncome = dictionary["extraIncome"] as? Double
                
                //                var calculatedIncome: Double = 0
                //                var calculatedSavings: Double = 0
                //                var dailyBudget: Double = 0
                
                //adding extra income
                eIncome = extraIncome!
                eIncome = eIncome + totalCredits
                print("*********************************************\(eIncome)*********")
                
                if (incomeType == "Hourly"){
                    //income per year
                    calculatedIncome = income! * 40 * 52
                }else if (incomeType == "Weekly"){
                    calculatedIncome = income! * 52
                }else if (incomeType == "Yearly"){
                    calculatedIncome = income!
                }
                
                if (savingsType == "Percent"){
                    calculatedSavings = calculatedIncome * savingsAmount!
                    calculatedIncome -= calculatedSavings
                }else if (incomeType == "Dollar"){
                    if (incomeType == "Hourly" || incomeType == "Weekly"){
                        calculatedSavings = 52 * savingsAmount!
                        calculatedIncome -= calculatedSavings
                    }else if (incomeType == "Yearly"){
                        calculatedIncome -= calculatedSavings
                    }
                }
                //factored in extra income
                calculatedIncome = calculatedIncome + eIncome
                calculatedIncome = calculatedIncome - (totalWeeklyDebits*52)
                calculatedIncome = calculatedIncome - (totalMonthlyDebits*12)
                calculatedIncome = calculatedIncome - (totalYearlyDebits)
                dailyBudget = (calculatedIncome)/365
                dailyBudget -= totalOnceDebits
                
                if(income! > 0){
                    self.lblDailyAmount.text = String(format: "$%.02f", dailyBudget)
                }
                
            }
        })
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(named: "home"), tag: 1)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recentCell = tableView.dequeueReusableCell(withIdentifier: "recents") as! RecentsViewCell
        let debit = self.recentArray[indexPath.row]
        recentCell.lblDate?.text = debit.dateAddedd
        recentCell.lblAmount?.text = String(format: "$%.02f", debit.amount)
        recentCell.lblSummary?.text = debit.summary

        return recentCell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLogout_TouchUpInside(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            GIDSignIn.sharedInstance().signOut()
            //dismiss(animated: true, completion: nil)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "login")
            self.present(vc!, animated: true, completion: nil)
            
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
        
//        do{
//            try GIDSignIn.sharedInstance().signOut()
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "login")
//            self.present(vc!, animated: true, completion: nil)
//        }catch let e as NSError{
//             print ("Error signing out: \(e.localizedDescription)")
//        }
        
    }

}
