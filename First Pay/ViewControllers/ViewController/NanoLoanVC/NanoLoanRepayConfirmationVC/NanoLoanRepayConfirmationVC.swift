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
    
    var modelPayActiveLoan: ModelPayActiveLoan? {
        didSet {
            self.openNanoLoanRepaySucessfullVC()
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
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
            "nlDisbursementId" : "\(DataManager.instance.nano_loanDisbursementId ?? "1")"
        ]
        
        APIs.postAPI(apiName: .payActiveLoan, parameters: parameters) { responseData, success, errorMsg in
            self.openNanoLoanRepaySucessfullVC()
            if success {
                let model: ModelPayActiveLoan? = APIs.decodeDataToObject(data: responseData)
                print(model)
                print(model)
                self.modelPayActiveLoan = model
            }
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
        let messages: String
        let responseblock, data: JSONNull?
        let responsecode: Int
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
