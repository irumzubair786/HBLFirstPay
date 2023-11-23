//
//  NanoLoanConfirmationVC.swift
//  First Pay
//
//  Created by Apple on 03/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire

class NanoLoanConfirmationVC: UIViewController {

    @IBOutlet weak var viewBackGroundHint: UIView!
    @IBOutlet weak var viewLoanAmountBackGround: UIView!
    @IBOutlet weak var buttonTermsAndConditions: UIButton!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonGetLoan: UIButton!
    @IBOutlet weak var viewGetLoanButton: UIView!
    
    
    @IBOutlet weak var labelOtherDescription: UILabel!
    @IBOutlet weak var labelLoanAmount: UILabel!
    @IBOutlet weak var labelAmountDescription: UILabel!
    
    @IBOutlet weak var labelLoanDurationTitle: UILabel!
    
    @IBOutlet weak var labelLoanDuration: UILabel!
    
    @IBOutlet weak var labelDueDateTitle: UILabel!
    @IBOutlet weak var labelDueDate: UILabel!

    
    @IBOutlet weak var labelDailyMarkupAmountTitle: UILabel!
    @IBOutlet weak var labelDailyMarkupAmount: UILabel!
    
    @IBOutlet weak var labelTotalMonthlyMarkupTitle: UILabel!
    @IBOutlet weak var labelTotalMonthlyMarkup: UILabel!
    
    @IBOutlet weak var labelAmountRapidDueDateTitle: UILabel!
    @IBOutlet weak var labelAmountRapidDueDate: UILabel!

    
    
    var selectedAmount: Int? {
        didSet {

        }
    }
    var modelApplyLoan: ModelApplyLoan? {
        didSet {
            if modelApplyLoan?.responsecode == 1 {
                self.openNanoLoanConfirmationVC()
            }
            else {
                //MARK: - Loan Failed Successfully
                self.showAlertCustomPopup(title: "Error!", message: modelApplyLoan?.messages ?? "", iconName: .iconError)
            }
        }
    }
    var modelNanoLoanEligibilityCheck: NanoLoanApplyViewController.ModelNanoLoanEligibilityCheck? {
        didSet {
            
        }
    }
    
    var modelGetLoanCharges: NanoLoanApplyViewController.ModelGetLoanCharges!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewGetLoanButton.circle()
        viewLoanAmountBackGround.radius()
        viewBackGroundHint.radius()
        setData()
    }
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonTermsAndConditions(_ sender: Any) {
    }
    
    @IBAction func buttonGetLoan(_ sender: Any) {
        applyLoan()
    }
    
    func setData() {
        let totalLoanAmount = (modelGetLoanCharges?.data?.loanAmount ?? 0).twoDecimal()
        let dailyMarkupFee = (modelGetLoanCharges?.data?.markupAmountPerDay ?? 0).twoDecimal()
        let totalMarkupFee = (modelGetLoanCharges?.data?.markupAmountTotal ?? 0).twoDecimal()
        let loanDuration = (modelGetLoanCharges?.data?.loanDuration)
        let dueDate = (modelGetLoanCharges?.data?.dueDate)

        let processingFee = (modelGetLoanCharges?.data?.processingFeeAmount ?? 0).twoDecimal()
        let processingFed = (modelGetLoanCharges?.data?.fed ?? 0).twoDecimal()
        let amountRapidOnDueDate = (modelGetLoanCharges?.data?.amountToBeRepaid ?? 0).twoDecimal()
                               
        labelLoanAmount.text = "Rs. \(totalLoanAmount)"
        labelOtherDescription.text = "Processing Fee of Rs. \(processingFee) and FED of Rs. \(processingFed) will be deducted upfront from the applied loan amount."
        labelLoanDuration.text = loanDuration
        labelDueDate.text = dueDate
        labelDailyMarkupAmount.text = "Rs. \(dailyMarkupFee)"
        labelTotalMonthlyMarkup.text = "Rs. \(totalMarkupFee)"
        labelAmountRapidDueDate.text = "Rs. \(amountRapidOnDueDate)"
    }

    func applyLoan() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
            "amount" : "\(selectedAmount!)",
            "productId" : "\(Int(modelNanoLoanEligibilityCheck?.data?.first?.nlProductID ?? 0))",
            "loanPurpose" : "2",
        ]
        
        APIs.postAPI(apiName: .applyLoan, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: ModelApplyLoan? = APIs.decodeDataToObject(data: responseData)
            self.modelApplyLoan = model
        }
    }
    
    func openNanoLoanConfirmationVC() {
        let vc = UIStoryboard.init(name: "NanoLoan", bundle: nil).instantiateViewController(withIdentifier: "NanoLoanSuccessfullVC") as! NanoLoanSuccessfullVC
        vc.modelApplyLoan = modelApplyLoan
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension NanoLoanConfirmationVC {
    // MARK: - ModelApplyLoan
    struct ModelApplyLoan: Codable {
        let responsecode: Int?
        let data: ModelApplyLoanData?
        let responseblock: JSONNull?
        let messages: String?
    }

    // MARK: - DataClass
    struct ModelApplyLoanData: Codable {
        let transactionID: Int?
        let dateTime, loanNo: String?
        let loanAmount: Int?
        let dueDate: String?
        let repaidAmount, processingFee: Int?
        let fed, disbursedAmount: Double?

        enum CodingKeys: String, CodingKey {
            case transactionID = "transactionId"
            case dateTime, loanNo, loanAmount, dueDate, repaidAmount, processingFee, fed, disbursedAmount
        }
    }

    // MARK: - Encode/decode helpers

    class JSONNull: Codable, Hashable {

        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
        }

        public var hashValue: Int {
            return 0
        }

        public init() {}

        public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }

}
