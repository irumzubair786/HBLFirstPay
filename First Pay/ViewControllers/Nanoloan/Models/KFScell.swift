//
//  KFScell.swift
//  First Pay
//
//  Created by Arsalan Amjad on 11/09/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit

class KFScell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBOutlet weak var lbname: UILabel!
    
    
    @IBOutlet weak var lblnoofins: UILabel!
    @IBOutlet weak var lblrepayment: UILabel!
    @IBOutlet weak var lblloanamount: UILabel!
    @IBOutlet weak var lblnameofproduct: UILabel!
    @IBOutlet weak var lblloanno: UILabel!
    
    @IBOutlet weak var lblq4: UILabel!
    @IBOutlet weak var lblq3: UILabel!
    @IBOutlet weak var lblq2: UILabel!
    @IBOutlet weak var lblq1: UILabel!
    @IBOutlet weak var lbltotalpayableamount: UILabel!
    @IBOutlet weak var lblinstallmentamount: UILabel!
    @IBOutlet weak var lblprocessingfee: UILabel!
    @IBOutlet weak var lblmarkup: UILabel!
    @IBOutlet weak var lblcnic: UILabel!
    @IBOutlet weak var lblq7: UILabel!
    @IBOutlet weak var lblq5: UILabel!
    @IBOutlet weak var lblq6: UILabel!
    
    @IBOutlet weak var lblmarkupAmount: UILabel!
    @IBOutlet weak var lblfed: UILabel!
    
    @IBOutlet weak var lbltenure: UILabel!
    
    
}
