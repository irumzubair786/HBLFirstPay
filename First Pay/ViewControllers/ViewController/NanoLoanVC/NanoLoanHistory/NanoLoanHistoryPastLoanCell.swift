//
//  NanoLoanHistoryPastLoanCell.swift
//  HBLFMB
//
//  Created by Apple on 22/03/2023.
//

import UIKit

class NanoLoanHistoryPastLoanCell: UITableViewCell {

    @IBOutlet weak var viewBackGround: UIView!
    
    @IBOutlet weak var imageViewType: UIImageView!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonViewDetails: UIButton!
    
    @IBOutlet weak var labelAvailedDateTitle: UILabel!
    @IBOutlet weak var labelAvailedDate: UILabel!
    
    @IBOutlet weak var labelRePaymentTitle: UILabel!
    @IBOutlet weak var labelRePaymentAmount: UILabel!

    var modelCurrentLoan: NanoLoanApplyViewController.ModelCurrentLoan? {
        didSet {
            labelAmount.text = "Rs. \((modelCurrentLoan?.loanAvailedAmount ?? 0).twoDecimal())"
            labelRePaymentAmount.text = "Rs. \((modelCurrentLoan?.principalAmountOS ?? 0).twoDecimal())"
            labelAvailedDate.text = "\(modelCurrentLoan?.loanAvailDate ?? "")"
        }
    }
    
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
