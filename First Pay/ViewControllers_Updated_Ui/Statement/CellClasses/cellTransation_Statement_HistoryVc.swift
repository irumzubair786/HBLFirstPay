//
//  cellTransation_Statement_HistoryVc.swift
//  First Pay
//
//  Created by Irum Butt on 06/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class cellTransation_Statement_HistoryVc: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var lblbankName: UILabel!
    @IBOutlet weak var btnDetail: UIButton!
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var btn: UIButton!
    
    
}
