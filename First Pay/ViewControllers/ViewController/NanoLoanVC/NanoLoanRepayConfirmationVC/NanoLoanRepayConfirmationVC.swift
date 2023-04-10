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
                self.showAlertCustomPopup(title: "Alert", message: modelPayActiveLoan?.messages ?? "Empty Message", iconName: "ss", buttonNames: ["OK", "CANCEL"])
            }
            else {
                self.openNanoLoanRepaySucessfullVC()
            }
        }
    }
    
    
    
    var modelGetActiveLoanToPay: NanoLoanRepayViewController.ModelGetActiveLoanToPay? {
        didSet {
            if let getActiveLoanToPay = modelGetActiveLoanToPay?.data {
                
                
            }
        }
    }
    
    var modelGetActiveLoan: NanoLoanApplyViewController.ModelGetActiveLoan? {
        didSet {
            if let currentLoan = modelGetActiveLoan?.data.currentLoan.first {
                labelLoanNumber.text = "\(currentLoan.loanNo)"
                labelAmount.text = "RS. \(currentLoan.installmentAmount)"
                labelLoanAvailedAmount.text = "RS. \(currentLoan.loanAmount)"
                labelDueDate.text = currentLoan.endDate
                labelProcessingFee.text = "0.00"
                labelMarkupCharged.text = "RS. \(currentLoan.totalMarkupAmount)"
                viewBackGroundTotalAmount.radiusLineDashedStroke()
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
            "nlDisbursementId" : "\(currentLoan?.nlDisbursementID ?? 0)"
        ]
        
        APIs.postAPI(apiName: .payActiveLoan, parameters: parameters, viewController: self) { responseData, success, errorMsg in
//            if success {
//                let model: ModelPayActiveLoan? = APIs.decodeDataToObject(data: responseData)
//                print(model)
//                print(model)
//                self.modelPayActiveLoan = model
//            }
            let model: ModelPayActiveLoan? = APIs.decodeDataToObject(data: responseData)
            print(model)
            print(model)
            self.modelPayActiveLoan = model
        }
    }
    
    func openNanoLoanRepaySucessfullVC() {
        let vc = UIStoryboard.init(name: "NanoLoan", bundle: nil).instantiateViewController(withIdentifier: "NanoLoanRepaySucessfullVC") as! NanoLoanRepaySucessfullVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension NanoLoanRepayConfirmationVC {
    // MARK: - ModelPayActiveLoan
    struct ModelPayActiveLoan: Codable {
        let responsecode: Int
        let messages: String
        let data: ModelPayActiveLoanData
        let responseblock: JSONNull?
    }

    // MARK: - ModelPayActiveLoanData
    struct ModelPayActiveLoanData: Codable {
        let statusDescr: String
        let status, principalAmount: Int
        let markupAmount: Double
        let chargesAmount: Int
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
