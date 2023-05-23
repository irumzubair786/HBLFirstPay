//
//  NanoLoanSuccessfullVC.swift
//  First Pay
//
//  Created by Apple on 03/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class NanoLoanSuccessfullVC: UIViewController {
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonGetNewLoan: UIButton!

    @IBOutlet weak var labelAmountTitle: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelAmountDescription: UILabel!
    @IBOutlet weak var labelTransactionIdTitle: UILabel!
    @IBOutlet weak var labelTransactionId: UILabel!
    @IBOutlet weak var labelDateTimeTitle: UILabel!
    @IBOutlet weak var labelDateTime: UILabel!
    @IBOutlet weak var labelLoanNumberTitle: UILabel!
    @IBOutlet weak var labelLoanNumber: UILabel!
    
    @IBOutlet weak var labelLoanAvailedAmountTitle: UILabel!
    @IBOutlet weak var labelLoanAvailedAmount: UILabel!
    @IBOutlet weak var labelRepaymentDueDateTitle: UILabel!
    @IBOutlet weak var labelRepaymentDueDate: UILabel!
    @IBOutlet weak var labelAmountRapidDueDateTitle: UILabel!
    @IBOutlet weak var labelAmountRapidDueDate: UILabel!
    
    @IBOutlet weak var buttonDownLoad: UIButton!
    
    @IBOutlet weak var buttonShare: UIButton!
    @IBOutlet weak var viewBackGroundHint: UIView!

    
    var modelApplyLoan: NanoLoanConfirmationVC.ModelApplyLoan? {
        didSet {
            labelAmount.text = "Rs. \(modelApplyLoan?.data.disbursedAmount ?? 0)"
            labelAmountDescription.text = "Processing fee of Rs. \((modelApplyLoan?.data.processingFee ?? 0).twoDecimal()) and FED of Rs. \((modelApplyLoan?.data.fed ?? 0).twoDecimal()) has been charged."
            labelTransactionId.text = "\(modelApplyLoan?.data.transactionID ?? 0)"
            labelDateTime.text = "\(modelApplyLoan?.data.dateTime ?? "")"
            labelLoanNumber.text = "\(modelApplyLoan?.data.loanNo ?? "")"
            labelLoanAvailedAmount.text = "Rs. \((modelApplyLoan?.data.loanAmount ?? 0).twoDecimal())"
            labelRepaymentDueDate.text = "\(modelApplyLoan?.data.dueDate ?? "")"
            labelAmountRapidDueDate.text = "Rs. \((modelApplyLoan?.data.repaidAmount ?? 0).twoDecimal())"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        viewBackGroundHint.radius()
    }
    @IBAction func buttonCancel(_ sender: Any) {
        dismissToViewController(viewController: AddCashMainVc.self)
    }
    @IBAction func buttonGetNewLoan(_ sender: Any) {
        dismissToViewController(viewController: AddCashMainVc.self)
    }
    @IBAction func buttonDownLoad(_ sender: Any) {
        let myImageScreenShot: UIImage? = self.view.getScreenshot()
        let imageArray = [myImageScreenShot!]
        if let yourPDF = imageArray.makePDF() {
            if saveFile(pdfDocument: yourPDF) {
                self.showAlertCustomPopup(title: "Sucess!", message: "File Download sucessfully", iconName: .iconError)
            }
            else {
                self.showAlertCustomPopup(title: "Error!", message: "Error occured during saving PDF File", iconName: .iconError)
            }
        }
        else {
            self.showAlertCustomPopup(title: "Error!", message: "Error occured during created PDF File", iconName: .iconError)
        }
    }
    @IBAction func buttonShare(_ sender: Any) {
        let myImageScreenShot: UIImage? = self.view.getScreenshot()
        print(myImageScreenShot)
        myImageScreenShot?.shareScreenShot(viewController: self)
    }
    
    
}
