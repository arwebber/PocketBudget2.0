//
//  Credits.swift
//  PocketBudget
//
//  Created by Andrew Webber on 12/3/17.
//  Copyright © 2017 Andrew Webber. All rights reserved.
//

import Foundation
import Firebase

struct Credits {
    //let key: String
    let dateAdded: String
    let summary: String
    let amount: Double
    let amountDisplay: Double
    let ref: DatabaseReference?
    
    init() {
        //self.key = key
        self.dateAdded = ""
        self.summary = ""
        self.amount = 0
        self.amountDisplay = 0
        self.ref = nil
    }
    
    init(dateAdded: String, summary: String, amount: Double, amountDisplay: Double) {
        //self.key = key
        self.dateAdded = dateAdded
        self.summary = summary
        self.amount = amount
        self.amountDisplay = amountDisplay
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        //key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        dateAdded = snapshotValue["dateAdded"] as! String
        summary = snapshotValue["summary"] as! String
        amount = snapshotValue["amount"] as! Double
        amountDisplay = snapshotValue["amountDisplay"] as! Double
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "dateAdded": dateAdded as Any,
            "summary": summary as Any,
            "amount": amount as Any,
            "amountDisplay": amountDisplay as Any
        ]
    }
}
