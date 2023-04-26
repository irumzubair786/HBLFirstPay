//
//  InviteFriendsAddNumber.swift
//  HBLFMB
//
//  Created by Apple on 18/04/2023.
//

import UIKit
import Alamofire
import ContactsUI
import libPhoneNumber_iOS

class InviteFriendsAddNumber: UIViewController {

    @IBOutlet weak var buttonSendInvite: UIButton!
    @IBOutlet weak var buttonContact: UIButton!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var textFieldNumber: UITextField!
    @IBOutlet weak var viewButtonSendInvite: UIView!
    
    private let contactPicker = CNContactPickerViewController()

    var stringName = "Shakeel"
    override func viewDidLoad() {
        super.viewDidLoad()
        viewButtonSendInvite.circle()
        textFieldNumber.addTarget(self, action: #selector(changeNumberInTextField), for: .editingChanged)
    }
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonContact(_ sender: Any) {
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
    }
    @IBAction func buttonSendInvite(_ sender: Any) {
        inviteFriends()
    }
    
    var modelInviteFriendsAddNumber: ModelInviteFriendsAddNumber? {
        didSet {
            if modelInviteFriendsAddNumber?.responsecode == 1 {
                openSuccessScreen()
            }
        }
    }
    
    func openSuccessScreen() {
        let vc = UIStoryboard.init(name: "InviteFriends", bundle: nil).instantiateViewController(withIdentifier: "InviteFriendInvitationSent") as! InviteFriendInvitationSent
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func inviteFriends() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic": userCnic!,
            "name": stringName,
            "channelId": "\(DataManager.instance.channelID)",
            "mobNo": textFieldNumber.text!.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "+92", with: "0"),
            "imei": DataManager.instance.imei!
        ]

        APIs.postAPI(apiName: .inviteFriends, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: ModelInviteFriendsAddNumber? = APIs.decodeDataToObject(data: responseData)
            self.modelInviteFriendsAddNumber = model
        }
    }
    
    @objc func changeNumberInTextField() {
        let text = textFieldNumber.text!.replacingOccurrences(of: "+92-", with: "")
        if textFieldNumber.text?.count == 1 && text == "0" {
            textFieldNumber.text = nil
            return
        }
        textFieldNumber.text = format(with: "+92-XXX-XXXXXXX", phone: text)
    }

}

extension InviteFriendsAddNumber: CNContactPickerDelegate {

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
              self.textFieldNumber.text = format(with: "+92-XXX-XXXXXXX", phone: "\(tempPhoneNumber)")
          }
          catch let error as NSError {
              print(error.localizedDescription)
          }
    }

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
      
    }
}

extension InviteFriendsAddNumber {
    // MARK: - ModelinvitedFriendsList
    struct ModelInviteFriendsAddNumber: Codable {
        let responseblock, data: JSONNull?
        let responsecode: Int
        let messages: String
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
