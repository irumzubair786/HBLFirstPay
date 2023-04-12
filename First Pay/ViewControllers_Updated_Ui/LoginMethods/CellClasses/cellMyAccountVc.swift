//
//  cellMyAccountVc.swift
//  First Pay
//
//  Created by Irum Butt on 11/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class cellMyAccountVc: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet weak var labelConsumed: UILabel!
    @IBOutlet weak var progressbar: UIProgressView!
    @IBOutlet weak var labelDailyName: UILabel!
    
    @IBOutlet weak var labelRemaining: UILabel!
    @IBOutlet weak var labelTotalAmount: UILabel!
    @IBOutlet weak var buttonEdit: UIButton!
    
    

}
