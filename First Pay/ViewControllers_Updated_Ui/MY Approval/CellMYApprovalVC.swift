//
//  CellMYApprovalVC.swift
//  First Pay
//
//  Created by Irum Zubair on 08/11/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class CellMYApprovalVC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var buttonDeclined: UIButton!
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var btnSent: UIButton!
    
  
    @IBOutlet weak var btnCancel: UIButton!
    
}
