//
//  MSDetailCell.swift
//  First Pay
//
//  Created by Arsalan Amjad on 11/09/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit

class MSDetailCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var backview: UIView!
    @IBOutlet weak var lblstatus: UILabel!
    @IBOutlet weak var lblamount: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var lblbalance: UILabel!
}
