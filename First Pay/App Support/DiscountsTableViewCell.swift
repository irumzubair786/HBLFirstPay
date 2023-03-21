//
//  DiscountsTableViewCell.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 28/07/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit

class DiscountsTableViewCell: UITableViewCell {
    
//    @IBOutlet weak var lbldiscountPartner: UILabel!
//    @IBOutlet weak var lbldiscountDetails: UILabel!
//    @IBOutlet weak var lbladdress: UILabel!
//    @IBOutlet weak var lblnameOfCity: UILabel!
//    @IBOutlet weak var lblwebsite: UILabel!
    
    @IBOutlet weak var viewback: UIView!
    @IBOutlet weak var lblproduct: UILabel!
    
   
    @IBOutlet weak var lblDiscount: UILabel!
    
    @IBOutlet weak var imgview: UIImageView!
    @IBOutlet weak var lbldetail: UILabel!
    var discountActionBlock: (() -> Void)? = nil
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func committeeButtonPressed(sender: UIButton) {
              discountActionBlock?()
          }
    
}
