//
//  InviteFriendsAddNumber.swift
//  HBLFMB
//
//  Created by Apple on 18/04/2023.
//

import UIKit
import Alamofire

class InviteFriendsAddNumber: UIViewController {

    @IBOutlet weak var buttonSendInvite: UIButton!
    @IBAction func buttonSendInvite(_ sender: Any) {
        inviteFriends()
    }
    
    @IBOutlet weak var buttonContact: UIButton!
    @IBAction func buttonContact(_ sender: Any) {
    }
    @IBOutlet weak var textFieldNumber: UITextField!
    @IBOutlet weak var viewButtonSendInvite: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewButtonSendInvite.circle()
        // Do any additional setup after loading the view.
    }
    
    func inviteFriends() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "“cnic”": userCnic,
            "name": "Shakeel",
            "channelId": "\(DataManager.instance.channelID)",
            "mobNo": textFieldNumber.text!,
            "imei": DataManager.instance.imei!
        ]

        APIs.postAPI(apiName: .inviteFriends, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: NanoLoanApplyViewController.ModelGetActiveLoan? = APIs.decodeDataToObject(data: responseData)
            //            self.modelGetActiveLoan = model
            
        }
    }

}
