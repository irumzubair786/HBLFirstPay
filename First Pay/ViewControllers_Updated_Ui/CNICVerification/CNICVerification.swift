//
//  CNICVerification.swift
//  First Pay
//
//  Created by Apple on 30/05/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire

class CNICVerification: UIViewController {

    @IBOutlet weak var cnicErrorLabel: UILabel!
    @IBOutlet weak var cniclabel: UILabel!
    @IBOutlet weak var tfSelectExpiryDate: UITextField!
    @IBOutlet weak var imageContinue: UIImageView!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var selectDate: UIButton!

    var successFullNICVerification: ((Bool) -> ())!
    var userCnic = ""
    var maskingCNic = ""

    var expireyDate = UIDatePicker()

    var modelExpiredCnicVerification: ModelExpiredCnicVerification? {
        didSet {
            cnicErrorLabel.isHidden = true
            if modelExpiredCnicVerification?.responsecode == 1 {
                self.showAlertCustomPopup(title: "Congratulations!\nVerification Successfull", message: modelExpiredCnicVerification?.messages, iconName: .iconSucess) {_ in
                    self.dismiss(animated: true)
                    self.successFullNICVerification?(true)
                }
            }
            else {
                cnicErrorLabel.text = modelExpiredCnicVerification?.messages
                cnicErrorLabel.textColor = .red
                cnicErrorLabel.isHidden = false
//                self.showAlertCustomPopup(title: "Error", message: modelExpiredCnicVerification?.messages, iconName: .iconError)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cnicErrorLabel.isHidden = true
        buttonContinue.isUserInteractionEnabled = false

        maskingCNIC()
        cniclabel.text = maskingCNic
        expireyDate = tfSelectExpiryDate.setPickerDate()

        expireyDate.addTarget(self, action: #selector(self.tappedOnDate), for: .valueChanged)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectDate(_ sender: Any) {
        tfSelectExpiryDate.becomeFirstResponder()
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.successFullNICVerification?(false)
        self.dismiss(animated: true)
    }
    @IBAction func buttonContinue(_ sender: Any) {
        expiredCnicVerification()
    }
    
    @objc func tappedOnDate(sender: UIDatePicker) {
        print(sender)
        let stringDate = sender.date.dateString()
        
        if sender == expireyDate {
            tfSelectExpiryDate.text = stringDate
            
            let image = UIImage(named:"]greenarrow")
            imageContinue.image = image
            buttonContinue.isUserInteractionEnabled = true
//            let image = UIImage(named:"grayArrow")
        }
        
    }
    
    func maskingCNIC() {
        userCnic = UserDefaults.standard.string(forKey: "userCnic") ?? ""
        var a = userCnic
        maskingCNic = a.substring(to: 2)
        var concate = maskingCNic
        var x = a.substring(with: 2..<3)
        //x = x.replacingOccurrences(of: "\(x)", with: "X")
        concate = "\(concate)\(x)"
        var d = a.substring(with: 3..<5)
        concate = "\(concate)\(x)\(d)"
        var x1 = a.substring(with: 5..<8)
        x1 = x1.replacingOccurrences(of: "\(x1)", with: "XXX")
        concate = "\(maskingCNic)\(x)\(d)\(x1)"
        var x2 = a.substring(with: 8..<10)
        concate = "\(maskingCNic)\(x)\(d)\(x1)\(x2)"
        var x3 = a.substring(with: 10..<12)
        x3 = x3.replacingOccurrences(of: "\(x3)", with: "XX")
        concate = "\(maskingCNic)\(x)\(d)\(x1)\(x2)\(x3)"
        var x4 = a.substring(with: 12..<13)
        concate = "\(maskingCNic)\(x)\(d)\(x1)\(x2)\(x3)\(x4)"
        print("concate",concate)
        maskingCNic = concate
    }
    
   
    func expiredCnicVerification() {
        
//    Request:
//    {
//    "cnic":"7140282632607",
//    "channelId":"3",
//    "imei":"973e59e1cfe03cfc",
//    "issueDate":"2023-02-08"
//    }
//
//    Response:
//    {
//      "responsecode": 1,
//      "data": null,
//      "responseblock": null,
//      "messages": "Your account has been re-activated Successfully."
//    }
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        
        let issueDateArray = tfSelectExpiryDate.text!.components(separatedBy: "/")
        let issueDate = "\(issueDateArray[2])-\(issueDateArray[1])-\(issueDateArray[0])"
        print(issueDate)
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
            "issueDate":issueDate
        ]
        
        APIs.postAPI(apiName: .expiredCnicVerification, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: ModelExpiredCnicVerification? = APIs.decodeDataToObject(data: responseData)
            self.modelExpiredCnicVerification = model
        }
    }

}
extension CNICVerification {
    // This file was generated from JSON Schema using quicktype, do not modify it directly.
    // To parse the JSON, add this file to your project and do:
    
    // MARK: - ModelGetActiveLoan
    struct ModelExpiredCnicVerification: Codable {
        let messages: String
        let responseblock: Responseblock?
        let responsecode: Int
        let data: JSONNull?
    }
    
    // MARK: - Responseblock
    struct Responseblock: Codable {
        let responseDescr, heading, responseType, responseCode: String
        let field: String
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
