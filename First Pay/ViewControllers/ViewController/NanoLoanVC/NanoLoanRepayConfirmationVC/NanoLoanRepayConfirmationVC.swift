//
//  NanoLoanRepayConfirmationVC.swift
//  First Pay
//
//  Created by Apple on 03/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire

class NanoLoanRepayConfirmationVC: UIViewController {

    @IBOutlet weak var viewBackGroundRepayNowButton: UIView!
    @IBOutlet weak var viewBackGroundTotalAmount: UIView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonRepayNow: UIButton!
    
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelLoanNumberTitle: UILabel!
    @IBOutlet weak var labelLoanNumber: UILabel!

    @IBOutlet weak var labelLoanAvailedAmountTitle: UILabel!
    @IBOutlet weak var labelLoanAvailedAmount: UILabel!
    
    @IBOutlet weak var labelDueDateTitle: UILabel!
    @IBOutlet weak var labelDueDate: UILabel!
    
    @IBOutlet weak var labelProcessingFeeTitle: UILabel!
    @IBOutlet weak var labelProcessingFee: UILabel!
    
    @IBOutlet weak var labelMarkupChargedTitle: UILabel!
    @IBOutlet weak var labelMarkupCharged: UILabel!
    
    var modelPayActiveLoan: ModelPayActiveLoan? {
        didSet {
            if modelPayActiveLoan?.responsecode == 0 {
                let buttonFirst = [
                        "buttonName": "OK",
                        "buttonBackGroundColor": UIColor.clrOrange,
                        "buttonTextColor": UIColor.white] as [String : AnyObject]
                
                self.showAlertCustomPopup(title: "Alert", message: modelPayActiveLoan?.messages ?? "Empty Message", iconName: .iconError, buttonNames:  [buttonFirst] as? [[String: AnyObject]])
            }
            else {
                self.openNanoLoanRepaySucessfullVC()
            }
        }
    }
    
    var modelGetActiveLoanToPay: NanoLoanRepayViewController.ModelGetActiveLoanToPay? {
        didSet {
            if let getActiveLoanToPay = modelGetActiveLoanToPay?.data {
                //                labelLoanNumber.text = "\(currentLoan.loanNo)"
                labelAmount.text = "Rs. \((getActiveLoanToPay.payableTotalAmount ?? 0).twoDecimal())"
                labelLoanNumber.text = "\(getActiveLoanToPay.loanNumber ?? "")"
                labelLoanAvailedAmount.text = "Rs. \((getActiveLoanToPay.loanAvailedAmount ?? 0).twoDecimal())"
                labelDueDate.text = getActiveLoanToPay.dueDate
                labelProcessingFee.text = "\((getActiveLoanToPay.processingFee ?? 0).twoDecimal())"
                labelMarkupCharged.text = "Rs. \((getActiveLoanToPay.outstandingMarkupAmount ?? 0).twoDecimal())"
                viewBackGroundTotalAmount.radiusLineDashedStroke()
            }
        }
    }
    
    var modelGetActiveLoan: NanoLoanApplyViewController.ModelGetActiveLoan? {
        didSet {
            if let currentLoan = modelGetActiveLoan?.data.currentLoan.first {
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBackGroundTotalAmount.radius()
        viewBackGroundRepayNowButton.circle()
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonRepayNow(_ sender: Any) {
        payActiveLoan()
    }
    func payActiveLoan() {
        let currentLoan = modelGetActiveLoan?.data.currentLoan.first
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
            "nlDisbursementId" : "\(modelGetActiveLoanToPay?.data?.nlDisbursementID ?? 0)"
        ]
        
        APIs.postAPI(apiName: .payActiveLoan, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: ModelPayActiveLoan? = APIs.decodeDataToObject(data: responseData)
            self.modelPayActiveLoan = model
        }
    }
    
    func openNanoLoanRepaySucessfullVC() {
        let vc = UIStoryboard.init(name: "NanoLoan", bundle: nil).instantiateViewController(withIdentifier: "NanoLoanRepaySucessfullVC") as! NanoLoanRepaySucessfullVC
        vc.modelPayActiveLoan = modelPayActiveLoan
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension NanoLoanRepayConfirmationVC {
    // MARK: - ModelPayActiveLoan
    struct ModelPayActiveLoan: Codable {
        let responsecode: Int
        let data: ModelPayActiveLoanData?
        let responseblock: JSONNull?
        let messages: String
    }

    // MARK: - DataClass
    struct ModelPayActiveLoanData: Codable {
        let payableTotalAmount: Double
            let loanAvailedAmount: Int
            let dueDate: JSONNull?
            let outstandingMarkupAmount: Double
            let daysTillDueDate, status: Int
            let statusDescr: String
            let nlDisbursementID: Int
            let loanNumber: JSONNull?
            let processingFee, transRefNum: Int
            let dateTime: String

            enum CodingKeys: String, CodingKey {
                case payableTotalAmount, loanAvailedAmount, dueDate, outstandingMarkupAmount, daysTillDueDate, status, statusDescr
                case nlDisbursementID = "nlDisbursementId"
                case loanNumber, processingFee, transRefNum, dateTime
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
