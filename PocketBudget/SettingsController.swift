//
//  SettingsController.swift
//  PocketBudget
//
//  Created by Andrew Webber on 11/26/17.
//  Copyright © 2017 Andrew Webber. All rights reserved.
//

import UIKit

class SettingsController: UITabBarController, UIPickerViewDataSource, UIPickerViewDelegate  {

    //picker initialization
    //var pickerData: [String] = [String]()
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    let pickerData = ["Hourly","Weekly","Yearly"]
    
    override func viewDidLoad() {
        pickerView.delegate = self
        pickerView.dataSource = self
        super.viewDidLoad()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }


}
