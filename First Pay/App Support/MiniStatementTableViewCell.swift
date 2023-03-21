//
//  MiniStatementTableViewCell.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 16/11/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//

import UIKit

class MiniStatementTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var imgCreditDebit: UIImageView!
    @IBOutlet weak var lblFromAccountNo: UILabel!
    @IBOutlet weak var lblFromAccountTitle: UILabel!

    @IBOutlet weak var backview: UIView!
    
    
    @IBOutlet weak var lblfedamount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
       
    }
    
}
