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
    
    var modelGetLoanCharges: NanoLoanApplyViewController.ModelGetLoanCharges? {
        didSet {

        }
    }
    var modelApplyLoan: ModelApplyLoan? {
        didSet {
            self.openNanoLoanConfirmationVC()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewGetLoanButton.circle()
        viewLoanAmountBackGround.radius()
        viewBackGroundHint.radius()

    }
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonTermsAndConditions(_ sender: Any) {
    }
    
    @IBAction func buttonGetLoan(_ sender: Any) {
        applyLoan()
    }

    func applyLoan() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
            "amount" : "1000",
            "productId" : "\(DataManager.instance.NanoloanProductid ?? 2)",
            "loanPurpose" : "2",
        ]
        
        APIs.postAPI(apiName: .applyLoan, parameters: parameters) { responseData, success, errorMsg in
            if success {
                let model: ModelApplyLoan? = APIs.decodeDataToObject(data: responseData)
                print(model)
                print(model)
                self.modelApplyLoan = model
            }
        }
    }
    
    func openNanoLoanConfirmationVC() {
        let vc = UIStoryboard.init(name: "NanoLoan", bundle: nil).instantiateViewController(withIdentifier: "NanoLoanSuccessfullVC") as! NanoLoanSuccessfullVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension NanoLoanConfirmationVC {
    // MARK: - ModelApplyLoan
    struct ModelApplyLoan: Codable {
        let messages: String
        let responsecode: Int
        let responseblock, data: JSONNull?
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
