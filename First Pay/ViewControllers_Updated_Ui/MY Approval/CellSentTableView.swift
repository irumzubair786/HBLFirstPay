//
//  CellSentTableView.swift
//  First Pay
//
//  Created by Irum Zubair on 29/11/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class CellSentTableView: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var buttonStatus: UIButton!
    
    @IBOutlet weak var lblAmount: UILabel!
    
}
