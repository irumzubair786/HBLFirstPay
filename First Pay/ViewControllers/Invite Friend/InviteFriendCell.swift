//
//  InviteFriendCell.swift
//  First Pay
//
//  Created by Arsalan Amjad on 12/02/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import UIKit

class InviteFriendCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var lblname: UILabel!
    
    @IBOutlet weak var lblnumer: UILabel!
    
    @IBOutlet weak var backview: UIView!
    
    @IBOutlet weak var lblincentvieamount: UILabel!
    
    @IBOutlet weak var lblInvitorCrdt: UILabel!
    
    
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var lblInviteeCerdt: UILabel!
    
}
