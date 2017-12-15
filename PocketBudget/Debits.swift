//
//  Debits.swift
//  PocketBudget
//
//  Created by Andrew Webber on 12/3/17.
//  Copyright © 2017 Andrew Webber. All rights reserved.
//

import Foundation
import Firebase

struct Debits {
    //let key: String
    let dateAddedd: String
    let summary: String
    let amount: Double
    let frequency: String
    let category: String
    let ref: DatabaseReference?
    
    init() {
        //self.key = key
        self.dateAddedd = ""
        self.summary = ""
        self.amount = 0
        self.frequency = ""
        self.category = ""
        self.ref = nil
    }
    
    init(dateAdded: String, summary: String, amount: Double, frequency: String, category: String) {
        //self.key = key
        self.dateAddedd = dateAdded
        self.summary = summary
        self.amount = amount
        self.frequency = frequency
        self.category = category
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        //key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        dateAddedd = snapshotValue["dateAdded"] as! String
        summary = snapshotValue["summary"] as! String
        amount = snapshotValue["amount"] as! Double
        frequency = snapshotValue["frequency"] as! String
        category = snapshotValue["category"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            //"key": key as Any,
            "dateAdded": dateAddedd as Any,
            "summary": summary as Any,
            "amount": amount as Any,
            "frequency": frequency as Any,
            "category": category as Any
        ]
    }
}
