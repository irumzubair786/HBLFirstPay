//
//  PendingRequestsTableViewCell.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 16/03/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit

class PendingRequestsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblFrom: UILabel!
    @IBOutlet weak var lblDateAndTime: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var lblStatus: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
