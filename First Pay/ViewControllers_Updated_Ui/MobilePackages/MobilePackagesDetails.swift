//
//  MobilePackagesDetails.swift
//  First Pay
//
//  Created by Shakeel Ahmed on 19/09/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ContactsUI
import libPhoneNumber_iOS

class MobilePackagesDetails: UIViewController {

    @IBOutlet weak var buttonBack: UIButton!
   
    @IBOutlet weak var imageViewOperator: UIImageView!
    @IBOutlet weak var imageViewButtonContinue: UIImageView!
    @IBOutlet weak var viewBackGroundContinueButton: UIView!
    @IBOutlet weak var buttonContinue: UIButton!
    
    @IBOutlet weak var textFieldMobileNumber: UITextField!
    @IBOutlet weak var labelPackage: UILabel!
    @IBOutlet weak var labelCarrier: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var buttonContact: UIButton!

    var companyIcon: UIImage!
    var companyName: String!
    var bundleDetail: MobilePackages.BundleDetail!
    var stringName = ""

    private let contactPicker = CNContactPickerViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBackGroundContinueButton.circle()
        // Do any additional setup after loading the view.
        setData()
        
        textFieldMobileNumber.addTarget(self, action: #selector(changeNumberInTextField), for: .editingChanged)
        textFieldMobileNumber.delegate = self
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonContinue(_ sender: Any) {
        bundleSubscription()
    }
    @IBAction func buttonContact(_ sender: Any) {
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    func setData() {
        if bundleDetail == nil {
            return()
        }
        labelPackage.text = bundleDetail.bundleName
        labelCarrier.text =  companyName
        labelPrice.text = "\(bundleDetail.bundleDefaultPrice)"
        labelAmount.text = "\(bundleDetail.bundleDefaultPrice)"
        imageViewOperator.image = companyIcon
    }
    
    var modelBundleSubscription: ModelBundleSubscription! {
        didSet {
            if modelBundleSubscription.responsecode == 1 {
                navigationToMobilePackagesSuccess()
            }
            else {
                self.showAlertCustomPopup(message: modelBundleSubscription.messages, iconName: .iconError)
            }
        }
    }
    
    func navigationToMobilePackagesSuccess() {
        let vc = UIStoryboard(name: "Mobile Bunldles", bundle: nil).instantiateViewController(withIdentifier: "MobilePackagesSuccess") as! MobilePackagesSuccess
        vc.modelBundleSubscription = modelBundleSubscription
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func bundleSubscription() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
            "lat" : "\(DataManager.instance.Latitude ?? 0)",
            "lng" : "\(DataManager.instance.Longitude ?? 0)",
//            "mobileNo" : textFieldMobileNumber.text!, //"03445823336",
            "mobileNo" : textFieldMobileNumber.text!.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "+92", with: "0"),
            "bundleKey" : "\(bundleDetail.bundleKey)",
            "bundleId" : "\(bundleDetail.ubpBundleID)"
        ]
        
        APIs.postAPI(apiName: .bundleSubscription, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            print(responseData)
            print(success)
            print(errorMsg)
            let model: ModelBundleSubscription? = APIs.decodeDataToObject(data: responseData)
            self.modelBundleSubscription = model
        }
    }
    
    @objc func changeNumberInTextField() {
        let text = textFieldMobileNumber.text!.replacingOccurrences(of: "+92-", with: "")
        if textFieldMobileNumber.text?.count == 1 && text == "0" {
            textFieldMobileNumber.text = nil
            return
        }
        textFieldMobileNumber.text = format(with: "+92-XXX-XXXXXXX", phone: text)
    }

}
extension MobilePackagesDetails: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
extension MobilePackagesDetails: CNContactPickerDelegate {

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        let phoneNumberCount = contact.phoneNumbers.count
      //  let name = "\(contact.givenName + contact.familyName)"
        let name = "\(contact.givenName) \(contact.familyName)"
        
        self.stringName = name
        guard phoneNumberCount > 0 else {
            dismiss(animated: true)
            //show pop up: "Selected contact does not have a number"
            return
        }

        if phoneNumberCount == 1 {
            setNumberFromContact(contactNumber: contact.phoneNumbers[0].value.stringValue)

        } else {
            let alertController = UIAlertController(title: "Select one of the numbers", message: nil, preferredStyle: .alert)

            for i in 0...phoneNumberCount-1 {
                let phoneAction = UIAlertAction(title: contact.phoneNumbers[i].value.stringValue, style: .default, handler: {
                alert -> Void in
                    self.setNumberFromContact(contactNumber: contact.phoneNumbers[i].value.stringValue)
                })
                alertController.addAction(phoneAction)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {
            alert -> Void in

            })
            alertController.addAction(cancelAction)

            dismiss(animated: true)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func setNumberFromContact(contactNumber: String) {

        //UPDATE YOUR NUMBER SELECTION LOGIC AND PERFORM ACTION WITH THE SELECTED NUMBER

        var contactNumber = contactNumber.replacingOccurrences(of: "-", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: "(", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: ")", with: "")
        
        let phoneUtil = NBPhoneNumberUtil()

          do {
            
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(contactNumber, defaultRegion: "PK")
            let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .NATIONAL)

            print("Formatted String : \(formattedString)")
              var tempPhoneNumber = "\(formattedString.allNumbers)".replace(string: "+92", replacement: "")
              if tempPhoneNumber.first == "0" {
                  tempPhoneNumber.removeFirst()
              }
              self.textFieldMobileNumber.text = format(with: "+92-XXX-XXXXXXX", phone: "\(tempPhoneNumber)")
          }
          catch let error as NSError {
              print(error.localizedDescription)
          }
    }

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
      
    }
}

extension MobilePackagesDetails {
    // MARK: - Welcome
    struct ModelBundleSubscription: Codable {
        let responsecode: Int
        let data: ModelBundleSubscriptionData
        let responseblock: JSONNull?
        let messages: String
    }

    // MARK: - DataClass
    struct ModelBundleSubscriptionData: Codable {
        let receivedBy: String
        let offerDiscount, amount: Int
        let fee, packageName, dataOperator, sentBy: String

        enum CodingKeys: String, CodingKey {
            case receivedBy, offerDiscount, amount, fee, packageName
            case dataOperator = "operator"
            case sentBy
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
