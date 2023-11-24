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
                FBEvents.logEvent(title: .Loans_repayconfirm_success)
                FaceBookEvents.logEvent(title: .Loans_repayconfirm_success)
                self.openNanoLoanRepaySucessfullVC()
            }
        }
    }
    
    var modelGetActiveLoanToPay: NanoLoanRepayViewController.ModelGetActiveLoanToPay?
    
   
    
    var modelGetActiveLoan: NanoLoanApplyViewController.ModelGetActiveLoan? {
        didSet {
            if let currentLoan = modelGetActiveLoan?.data?.currentLoan.first {
                
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewBackGroundTotalAmount.radius()
        self.viewBackGroundTotalAmount.radiusLineDashedStroke()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        FBEvents.logEvent(title: .Loans_repayconfirm_landing)
        FaceBookEvents.logEvent(title: .Loans_repayconfirm_landing)
        
        viewBackGroundRepayNowButton.circle()
        setData()
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonRepayNow(_ sender: Any) {
        payActiveLoan()
    }
    
    func setData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { }
        if let getActiveLoanToPay = self.modelGetActiveLoanToPay?.data {
            //                labelLoanNumber.text = "\(currentLoan.loanNo)"
            
            self.labelAmount.text = "Rs. \((getActiveLoanToPay.payableTotalAmount ?? 0).twoDecimal())"
            self.labelLoanNumber.text = "\(getActiveLoanToPay.loanNumber ?? "")"
            self.labelLoanAvailedAmount.text = "Rs. \((getActiveLoanToPay.loanAvailedAmount ?? 0).twoDecimal())"
            self.labelDueDate.text = getActiveLoanToPay.dueDate
            self.labelProcessingFee.text = "\((getActiveLoanToPay.processingFee ?? 0).twoDecimal())"
            self.labelMarkupCharged.text = "Rs. \((getActiveLoanToPay.outstandingMarkupAmount ?? 0).twoDecimal())"
        }
    }
    func payActiveLoan() {
        
        let currentLoan = modelGetActiveLoan?.data?.currentLoan.first
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
            "nlDisbursementId" : "\(currentLoan?.nlDisbursementID ?? 0)"
        ]
        
        APIs.postAPI(apiName: .payActiveLoan, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: ModelPayActiveLoan? = APIs.decodeDataToObject(data: responseData)
            self.modelPayActiveLoan = model
        }
    }
    
    func openNanoLoanRepaySucessfullVC() {
        let vc = UIStoryboard.init(name: "NanoLoan", bundle: nil).instantiateViewController(withIdentifier: "NanoLoanRepaySucessfullVC") as! NanoLoanRepaySucessfullVC
        vc.modelPayActiveLoan = self.modelPayActiveLoan
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension NanoLoanRepayConfirmationVC {
    // MARK: - ModelPayActiveLoan
    struct ModelPayActiveLoan: Codable {
        let responsecode: Int?
        let data: ModelPayActiveLoanData?
        let responseblock: JSONNull?
        let messages: String?
    }

    // MARK: - DataClass
    struct ModelPayActiveLoanData: Codable {
        let loanAvailedAmount: Int?
        let statusDescr: String?
        let processingFee: Int?
        let payableTotalAmount: Double?
        let loanNumber: JSONNull?
        let outstandingMarkupAmount: Double?
        let status, daysTillDueDate, nlDisbursementID: Int?
        let dateTime: String?
        let dueDate: JSONNull?
        let transRefNum: Int?
        
        enum CodingKeys: String, CodingKey {
            case loanAvailedAmount, statusDescr, processingFee, payableTotalAmount, loanNumber, outstandingMarkupAmount, status, daysTillDueDate
            case nlDisbursementID = "nlDisbursementId"
            case dateTime, dueDate, transRefNum
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
