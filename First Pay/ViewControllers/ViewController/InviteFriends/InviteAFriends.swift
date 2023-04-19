//
//  InviteAFriends.swift
//  HBLFMB
//
//  Created by Apple on 18/04/2023.
//

import UIKit
import Alamofire

class InviteAFriends: UIViewController {

    
    @IBOutlet weak var viewPendingStatus: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: TableViewContentSized!
    
    
    @IBOutlet weak var viewInviteFriendBackGround: UIView!
    @IBOutlet weak var viewInviteFriendBackButtonGround: UIView!

    @IBOutlet weak var labelInviteFriendButton: UILabel!
    
    @IBOutlet weak var buttonInviteFriend: UIButton!
    
    @IBOutlet weak var buttonViewTerms: UIButton!
    @IBAction func buttonViewTerms(_ sender: Any) {
    }
    @IBAction func buttonInviteFriend(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "InviteFriends", bundle: nil).instantiateViewController(withIdentifier: "InviteFriendsAddNumber") as! InviteFriendsAddNumber
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet weak var buttonSendInvite: UIButton!
    @IBAction func buttonSendInvite(_ sender: Any) {
    }
    
    @IBOutlet weak var viewButtonSendInvite: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        InviteSentCell.register(tableView: tableView)
        InvitePendingCell.register(tableView: tableView)
        InviteCompletedCell.register(tableView: tableView)
        segmentControl.textColor(selectedColor: .white, normalColor: .clrTextNormal)
        viewInviteFriendBackButtonGround.radius(color: .clrOrange)
        viewInviteFriendBackButtonGround.circle()
        
        viewButtonSendInvite.circle()
        invitedFriendsList()
    }
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        tableView.reloadData()
        if sender.selectedSegmentIndex == 1 {
            viewPendingStatus.isHidden = false
            viewPendingStatus.backgroundColor = .white
            viewPendingStatus.frame.size.height = 50
        }
        else {
            viewPendingStatus.isHidden = true
            viewPendingStatus.backgroundColor = .clear
            viewPendingStatus.frame.size.height = 0
        }
    }
    
    func invitedFriendsList() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "“cnic”": userCnic,
            "channelId": "\(DataManager.instance.channelID)",
            "imei": DataManager.instance.imei!
        ]
        
        APIs.postAPI(apiName: .invitedFriendsList, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: NanoLoanApplyViewController.ModelGetActiveLoan? = APIs.decodeDataToObject(data: responseData)
            //            self.modelGetActiveLoan = model
            
        }
    }
}

// MARK: TableView Delegates
extension InviteAFriends: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentControl.selectedSegmentIndex == 0 {
            return 4
        }
        else if segmentControl.selectedSegmentIndex == 1 {
            return 8
        }
        else {
            return 2
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentControl.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InviteSentCell") as! InviteSentCell
            // if change internet package is true then we dont need to show subscribed package
            return cell
        }
        else if segmentControl.selectedSegmentIndex == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvitePendingCell") as! InvitePendingCell
            // if change internet package is true then we dont need to show subscribed package
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InviteCompletedCell") as! InviteCompletedCell
            // if change internet package is true then we dont need to show subscribed package
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
   
}

extension InviteAFriends {
    
    func getInvitorFriendsList() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "osVersion": systemVersion,
            "appVersion": DataManager.instance.appversion,
            "ipAddressP": "192.168.8.100",
            "deviceModel": devicemodel,
            "channelId": "\(DataManager.instance.channelID)",
            "mobileNo": "03406401050",
            "imeiNo": DataManager.instance.imei!,
            "ipAddressA": "192.168.8.100",
            "cnic": userCnic!,
        ]
        APIs.postAPI(apiName: .getInvitorFriendsList, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: NanoLoanApplyViewController.ModelGetActiveLoan? = APIs.decodeDataToObject(data: responseData)
            //            self.modelGetActiveLoan = model
            
        }
    }
    func acceptFriendInvite() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        
        let parameters: Parameters = [
            "osVersion": systemVersion,
            "appVersion": DataManager.instance.appversion,
            "ipAddressP": "192.168.8.100",
            "deviceModel": devicemodel,
            "channelId": "\(DataManager.instance.channelID)",
            "mobileNo": "03406401050",
            "imeiNo": DataManager.instance.imei!,
            "ipAddressA": "192.168.8.100",
            "cnic": userCnic!,
            "friendInviteeId": "1"
        ]
        APIs.postAPI(apiName: .acceptFriendInvite, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: NanoLoanApplyViewController.ModelGetActiveLoan? = APIs.decodeDataToObject(data: responseData)
            //            self.modelGetActiveLoan = model
            
        }
    }
}
