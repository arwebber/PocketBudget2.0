//
//  SettingsController2.swift
//  PocketBudget
//
//  Created by Andrew Webber on 11/26/17.
//  Copyright © 2017 Andrew Webber. All rights reserved.
//

import UIKit
import Firebase

class SettingsController2: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: outlets
    @IBOutlet weak var lblIncome: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var savingsSelection: UISegmentedControl!
    @IBOutlet weak var savingsAmount: UITextField!
    
    //MARK: properties
    var incomeDouble: Double = 0
    var incomeType: String = ""
    var savingsDouble: Double = 0
    var savingsType: String = ""
    let ref = Database.database()
    var currentUser = Auth.auth().currentUser!
    var incomeArray: [Income] = []
    var ic = Income()
    
    let pickerData = ["Hourly","Weekly","Yearly"]
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
                
                self.lblIncome.text = "\(income!)"
                
                if(incomeType=="Hourly"){
                    self.pickerView.selectRow(0, inComponent: 0, animated: true)
                }else if(incomeType=="Weekly"){
                    self.pickerView.selectRow(1, inComponent: 0, animated: true)
                }else if(incomeType=="Yearly"){
                    self.pickerView.selectRow(2, inComponent: 0, animated: true)
                }
                
                if(savingsType=="Percent"){
                    self.savingsAmount.text = "\(savingsAmount!*100)"
                    self.savingsSelection.selectedSegmentIndex = 0
                }else{
                    self.savingsAmount.text = "\(savingsAmount!)"
                    self.savingsSelection.selectedSegmentIndex = 1
                }
            }
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Income", image: UIImage(named: "wrench"), tag: 1)
    }
    
        override func viewDidLoad() {
            pickerView.delegate = self
            pickerView.dataSource = self
            
            //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
            
            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            //tap.cancelsTouchesInView = false
            
            //view.addGestureRecognizer(tap)
            
            super.viewDidLoad()
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lblIncome.resignFirstResponder()
        savingsAmount.resignFirstResponder()
    }
    
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
    
    //start picker code
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return pickerData.count
        }
        
        // The data to return for the row and component (column) that's being passed in
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return pickerData[row]
        }
    
    
    
    @IBAction func savingsSelection_touchUpInside(_ sender: Any) {
        //start selection code
        if savingsSelection.selectedSegmentIndex == 0{
            savingsType = "Percent"
        }
        else if savingsSelection.selectedSegmentIndex == 1{
            savingsType = "Dollar"
        }

    }
    
    @IBAction func btnSave_TouchUpInside(_ sender: Any) {
        incomeDouble = Double(lblIncome.text!)!
        incomeType = pickerData[pickerView.selectedRow(inComponent: 0)]
        if(savingsType == "Percent"){
            savingsDouble = (Double(savingsAmount.text!)! / 100)
        }else if(savingsType == "Dollar"){
            savingsDouble = Double(savingsAmount.text!)!
        }else if(savingsType == ""){
            savingsType = "Percent"
            savingsDouble = (Double(savingsAmount.text!)! / 100)
        }else{
            
        }
        
        let income = Income(income: incomeDouble, incomeType: incomeType, savingsAmount: savingsDouble, savingsType: savingsType, extraIncome: 0)
        
        //let array: NSArray = [deb.toAnyObject()]
        
        ref.reference(withPath: "income/\(currentUser.uid)").setValue(income.toAnyObject())
        
    }
    

}
