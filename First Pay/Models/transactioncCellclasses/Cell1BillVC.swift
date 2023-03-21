//
//  Cell1BillVC.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 11/05/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit

class Cell1BillVC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var viewcell: UIView!
   
    
    @IBOutlet weak var rupeelbl: UILabel!
    
}
