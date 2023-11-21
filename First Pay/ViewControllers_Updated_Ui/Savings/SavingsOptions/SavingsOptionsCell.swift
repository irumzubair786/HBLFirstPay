//
//  SavingsOptionsCell.swift
//  First Pay
//
//  Created by Shakeel Ahmed on 12/11/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class SavingsOptionsCell: UITableViewCell {

    @IBOutlet weak var viewRightImage: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var imageViewForwardArrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
