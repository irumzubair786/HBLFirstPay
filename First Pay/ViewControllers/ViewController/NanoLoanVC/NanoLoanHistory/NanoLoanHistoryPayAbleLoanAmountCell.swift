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
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelAvailedLoanAmount: UILabel!
    @IBOutlet weak var labelAvailedLoanTitle: UILabel!
    @IBOutlet weak var labelDueDateTitle: UILabel!
    @IBOutlet weak var labelDueDate: UILabel!
    
    
    @IBOutlet weak var buttonViewDetails: UIButton!

    
    var modelCurrentLoan: NanoLoanApplyViewController.ModelCurrentLoan? {
        didSet {
            labelAmount.text =
            "RS. \(Double(modelCurrentLoan?.principalAmountOS ?? 0) + (modelCurrentLoan?.markupAmountOS ?? 0))"
            labelDueDate.text =
            "\(modelCurrentLoan?.dueDate ?? "")"
            labelAvailedLoanAmount.text = "RS. \(modelCurrentLoan?.loanAvailedAmount ?? 0)"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBackGround.radius()
        DispatchQueue.main.async {
            self.viewBackGround.radiusLineDashedStroke(color: .clrGreen)
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
