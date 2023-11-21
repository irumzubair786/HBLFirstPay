//
//  SavingPlansCell.swift
//  First Pay
//
//  Created by Shakeel Ahmed on 17/11/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class SavingPlansCell: UITableViewCell {

    @IBOutlet weak var buttonCalculator: UIButton!
    @IBOutlet weak var viewBackGround: UIView!

    @IBOutlet weak var labelPackageDescription: UILabel!
    @IBOutlet weak var labelPackageName: UILabel!
    @IBOutlet weak var buttonSubscribe: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        buttonSubscribe.circle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func buttonSubscribe(_ sender: Any) {
        
    }
    @IBAction func buttonCalculator(_ sender: Any) {
        
    }
    
}
