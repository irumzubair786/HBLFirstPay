//
//  CommitteeTableViewCell.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 08/07/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit

class CommitteeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblFirstTitle: UILabel!
    @IBOutlet weak var lblSecondTitle: UILabel!
    
    @IBOutlet weak var backview: UIView!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblTotalParticipant: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblreadStatus: UILabel!
    

    @IBOutlet weak var lblstatus: UILabel!
    
    var comitteeActionBlock: (() -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func committeeButtonPressed(sender: UIButton) {
           comitteeActionBlock?()
       }

}


