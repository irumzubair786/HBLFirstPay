//
//  BranchLocatorCell.swift
//  First Pay
//
//  Created by Arsalan Amjad on 27/12/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit

class BranchLocatorCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var backview: UIView!
    @IBOutlet weak var lblnumber: UILabel!
    @IBOutlet weak var lblcode: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
}
