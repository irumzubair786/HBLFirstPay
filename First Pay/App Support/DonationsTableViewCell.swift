//
//  DonationsTableViewCell.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 30/04/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit

class DonationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var viewcell: UIView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
