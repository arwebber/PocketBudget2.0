//
//  Income.swift
//  PocketBudget
//
//  Created by Andrew Webber on 12/3/17.
//  Copyright © 2017 Andrew Webber. All rights reserved.
//

import Foundation
import Firebase

struct Income {
    let income: Double
    let incomeType: String
    let savingsAmount: Double
    let savingsType: String
    let extraIncome: Double
    let ref: DatabaseReference?
    
    init() {
        self.income = 0
        self.incomeType = ""
        self.savingsAmount = 0
        self.savingsType = ""
        self.extraIncome = 0
        self.ref = nil
    }
    
    init(income: Double, incomeType: String, savingsAmount: Double, savingsType: String, extraIncome: Double) {
        self.income = income
        self.incomeType = incomeType
        self.savingsAmount = savingsAmount
        self.savingsType = savingsType
        self.extraIncome = extraIncome
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        income = snapshotValue["income"] as! Double
        incomeType = snapshotValue["incomeType"] as! String
        savingsAmount = snapshotValue["savingsAmount"] as! Double
        savingsType = snapshotValue["savingsType"] as! String
        extraIncome = snapshotValue["extraIncome"] as! Double
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "income": income as Any,
            "incomeType": incomeType as Any,
            "savingsAmount": savingsAmount as Any,
            "savingsType": savingsType as Any,
            "extraIncome": extraIncome as Any
        ]
    }
}
