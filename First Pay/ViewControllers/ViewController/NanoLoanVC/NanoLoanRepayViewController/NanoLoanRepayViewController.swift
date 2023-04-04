//
//  NanoLoanRepayViewController.swift
//  HBLFMB
//
//  Created by Apple on 24/03/2023.
//

import UIKit
import Alamofire

class NanoLoanRepayViewController: UIViewController {
    
    @IBOutlet weak var viewApplyButton: UIView!
    @IBOutlet weak var viewBenifitRepaying: UIView!
    
    @IBOutlet weak var buttonRepayNow: UIButton!
    @IBOutlet weak var buttonBenifits: UIButton!
    @IBOutlet weak var buttonMarkupCalendar: UIButton!

    var modelGetActiveLoanToPay: ModelGetActiveLoanToPay? {
        didSet {
            self.openNanoLoanRepayConfirmationVC()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewBenifitRepaying.circle()
        viewApplyButton.circle()

    }
    @IBAction func buttonMarkupCalendar(_ sender: Any) {
    }
    @IBAction func buttonBenifits(_ sender: Any) {
        openNanoLoanBenifitVC()
    }
    @IBAction func buttonRepayNow(_ sender: Any) {
        getActiveLoanToPay()
    }
    
    func getActiveLoanToPay() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
            "nlDisbursementId" : "\(DataManager.instance.nano_loanDisbursementId ?? "1")"
        ]
        
        APIs.postAPI(apiName: .getActiveLoanToPay, parameters: parameters) { responseData, success, errorMsg in
            if success {
                let model: ModelGetActiveLoanToPay? = APIs.decodeDataToObject(data: responseData)
                print(model)
                print(model)
                self.modelGetActiveLoanToPay = model
            }
        }
    }
    
    func openNanoLoanRepayConfirmationVC() {
        let vc = UIStoryboard.init(name: "NanoLoan", bundle: nil).instantiateViewController(withIdentifier: "NanoLoanRepayConfirmationVC") as! NanoLoanRepayConfirmationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openNanoLoanBenifitVC() {
        let vc = UIStoryboard.init(name: "NanoLoan", bundle: nil).instantiateViewController(withIdentifier: "NanoLoanBenifitVC") as! NanoLoanBenifitVC
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
}

extension NanoLoanRepayViewController {
    // MARK: - ModelGetActiveLoanToPay
    struct ModelGetActiveLoanToPay: Codable {
        let responsecode: Int
        let responseblock: JSONNull?
        let messages: String
        let data: DataClass
    }

    // MARK: - DataClass
    struct DataClass: Codable {
        let chargesAmount, principalAmount, markupAmount: Int
        let statusDescr: JSONNull?
        let status: Int
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
