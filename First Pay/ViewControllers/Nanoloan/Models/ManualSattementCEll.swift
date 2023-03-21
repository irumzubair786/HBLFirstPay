//
//  ManualSattementCEll.swift
//  First Pay
//
//  Created by Arsalan Amjad on 11/09/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit

class ManualSattementCEll: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet weak var lblname: UILabel!
    
    @IBOutlet weak var lblinstallmentamount: UILabel!
    @IBOutlet weak var lblloanamount: UILabel!
    @IBOutlet weak var lblloanpurpose: UILabel!
    @IBOutlet weak var backview: UIView!
    @IBOutlet weak var lbltotalamount: UILabel!
    @IBOutlet weak var lblPrpductDetail: UILabel!
    
    
    
    
    
    

}
