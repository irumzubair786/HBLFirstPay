//
//  cellLinkedAccount.swift
//  First Pay
//
//  Created by Irum Butt on 21/03/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Foundation
class cellLinkedAccount: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        if (selected) {
//           
//        } else {
////            let img = UIImage(named: "Doted")
////            img.i
////           buttonImgChecked.isUserInteractionEnabled = false
//        }
//    }
    @IBOutlet weak var LabelName: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var buttonback: UIButton!
    @IBOutlet weak var backView: UIView!
   
    @IBOutlet weak var buttonImgChecked: UIButton!
    @IBOutlet weak var labelBankName: UILabel!
    @IBOutlet weak var labelAccNo: UILabel!
}
