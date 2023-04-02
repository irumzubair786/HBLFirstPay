//
//  NanoLoanHistoryPayAbleLoanAmountCell.swift
//  HBLFMB
//
//  Created by Apple on 22/03/2023.
//

import UIKit

class NanoLoanHistoryPayAbleLoanAmountCell: UITableViewCell {

    @IBOutlet weak var buttonRepay: UIButton!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var viewRepayButton: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBackGround.radius()
        DispatchQueue.main.async {
            self.viewBackGround.radiusLineDashedStroke()
            self.buttonRepay.radius(color: .clrGreen)
            self.viewRepayButton.radius()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonRepay(_ sender: Any) {
    }

    
}
