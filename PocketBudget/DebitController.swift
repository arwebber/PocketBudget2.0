//
//  DebitController.swift
//  PocketBudget
//
//  Created by Andrew Webber on 11/26/17.
//  Copyright © 2017 Andrew Webber. All rights reserved.
//

import UIKit
import Firebase

class DebitController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: properties
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var segAmount: UISegmentedControl!
    @IBOutlet weak var picCategory: UIPickerView!
    @IBOutlet weak var txtSummary: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblCategory: UILabel!
    let ref = Database.database()
    var currentUser = Auth.auth().currentUser!
    
    let pickerData = ["Misc","Groceries","Bills","Restaurant","Bar","Gas","Coffee","Clothes","Shopping"]
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        picCategory.delegate = self
        picCategory.dataSource = self
        super.viewDidLoad()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtAmount.resignFirstResponder()
        txtSummary.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    var debitAmount: Double = 0
    var debitFrequency: String = "Once"
    var debitCategory: String = ""
    var debitSummary: String = ""
    
    @IBAction func segAmount_Selection(_ sender: Any) {
        if segAmount.selectedSegmentIndex == 0{
            //debitAmount = Int(txtAmount)!
            debitFrequency = "Once"
        }
        else if segAmount.selectedSegmentIndex == 1{
            debitFrequency = "Weekly"
        }
        else if segAmount.selectedSegmentIndex == 2{
            debitFrequency = "Monthly"
        }
        else if segAmount.selectedSegmentIndex == 3{
            debitFrequency = "Yearly"
        }
    }
    
    @IBAction func btnAdd_TouchUpInside(_ sender: Any) {
        //add try catch
        
        var alertController = UIAlertController(title: "Failed", message: (""), preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Okay" , style: UIAlertActionStyle.default){
            (result : UIAlertAction) -> Void in
            print("Okay")
        }
        
        if(txtSummary.text == ""){
            alertController = UIAlertController(title: "Failed", message: ("Please enter a summary."), preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(okAction)
            self.present(alertController, animated:true, completion: nil)
        }else if (txtAmount.text == ""){
            alertController = UIAlertController(title: "Failed", message: ("Please enter an amount."), preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(okAction)
            self.present(alertController, animated:true, completion: nil)
        }
        
        if(txtSummary.text != "" && txtAmount.text != ""){
            debitAmount = Double(txtAmount.text!)!
            debitCategory = pickerData[picCategory.selectedRow(inComponent: 0)]
            debitSummary = txtSummary.text!
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            let dateString = formatter.string(from: date)
            
            //let key = "2"//ref.reference().childByAutoId()
            
            let deb = Debits(dateAdded: dateString, summary: debitSummary, amount: debitAmount, frequency: debitFrequency, category: debitCategory)
            
            //let array: NSArray = [deb.toAnyObject()]

            ref.reference(withPath: "debits/\(currentUser.uid)").childByAutoId().setValue(deb.toAnyObject())
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "tab")
            self.present(vc!, animated: true, completion: nil)
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
