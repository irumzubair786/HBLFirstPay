//
//  MyLoanCellVC.swift
//  First Pay
//
//  Created by Arsalan Amjad on 09/11/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit

class MyLoanCellVC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblInstallmentAmount: UILabel!
    @IBOutlet weak var lblLoanAmount: UILabel!
    @IBOutlet weak var backview: UIView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblloanpurpose: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    
   
    
    
    
    
    
}
