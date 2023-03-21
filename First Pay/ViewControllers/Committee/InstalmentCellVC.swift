//
//  InstalmentCellVC.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 17/06/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit

class InstalmentCellVC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var backview: UIView!
    @IBOutlet weak var lblPayTo: UILabel!
    @IBOutlet weak var lblAccountNo: UILabel!
    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblFineAmount: UILabel!
    
}
