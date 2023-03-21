//
//  ParticipantTableViewCell.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 21/07/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit

class ParticipantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblFirstTitle: UILabel!
    @IBOutlet weak var lblSecondTitle: UILabel!
    @IBOutlet weak var lblDrawSequence: UILabel!
    @IBOutlet weak var lblRequestStatus: UILabel!
    @IBOutlet weak var lblReceived: UILabel!
    @IBOutlet weak var lblIniator: UILabel!
    @IBOutlet weak var lblInstalmentAmount: UILabel!
    
    @IBOutlet var btn_EditCommittee: UIButton!
    @IBOutlet var btn_RemoveCommittee: UIButton!
    
     var editCommitteeBlock: (() -> Void)? = nil
     var removeCommitteeBlock: (() -> Void)? = nil
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editCommitteeButtonPressed(sender: UIButton) {
              editCommitteeBlock?()
    }
    @IBAction func removeCommitteeButtonPressed(sender: UIButton) {
              removeCommitteeBlock?()
    }

}
