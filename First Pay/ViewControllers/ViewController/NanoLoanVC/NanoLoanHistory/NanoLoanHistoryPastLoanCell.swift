//
//  NanoLoanHistoryPastLoanCell.swift
//  HBLFMB
//
//  Created by Apple on 22/03/2023.
//

import UIKit

class NanoLoanHistoryPastLoanCell: UITableViewCell {

    @IBOutlet weak var viewBackGround: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewBackGround.radius()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
