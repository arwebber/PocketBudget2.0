//
//  RecentsViewCell.swift
//  PocketBudget
//
//  Created by Andrew Webber on 12/3/17.
//  Copyright © 2017 Andrew Webber. All rights reserved.
//

import UIKit

class RecentsViewCell: UITableViewCell {

    //MARK: properties
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSummary: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
