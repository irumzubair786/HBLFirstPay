//
//  InviteAFriends.swift
//  HBLFMB
//
//  Created by Apple on 18/04/2023.
//

import UIKit
import Alamofire
import XLPagerTabStrip

class InviteAFriends: UIViewController {

    @IBOutlet weak var viewBackGroundContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var viewBackGroundTableView: UIView!
    @IBOutlet weak var viewPendingStatus: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: TableViewContentSized!
    
    @IBOutlet weak var constatHeightBackGroundTableView: NSLayoutConstraint!
    @IBOutlet weak var labelTotalEarning: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var viewInviteFriendBackGround: UIView!
    @IBOutlet weak var viewInviteFriendBackButtonGround: UIView!

    @IBOutlet weak var constantContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var labelInviteFriendButton: UILabel!
    
    @IBOutlet weak var buttonInviteFriend: UIButton!
    
    @IBOutlet weak var buttonViewTerms: UIButton!
    
    @IBOutlet weak var buttonSendInvite: UIButton!
    
    
    @IBOutlet weak var labelCompaignText: UILabel!
    @IBOutlet weak var viewPendingHint: UIView!
    @IBOutlet weak var viewButtonSendInvite: UIView!
    
    var modelinvitedFriendsList: ModelinvitedFriendsList? {
        didSet {
            print(modelinvitedFriendsList)
            labelCompaignText.text = modelinvitedFriendsList?.data?.campaignText ?? ""
            labelTotalEarning.text = "\(Int(modelinvitedFriendsList?.data?.totalEarnings ?? "0")?.twoDecimal() ?? "0.00")"
            tableView.reloadData()
        }
    }
    
    
    var segmentConrtolFinishAnimating = false
    
    @objc func setHeightOfInviteFriendUsersContainerView(_ notification: Notification) {
        print((notification.object as? NSDictionary)?.value(forKey: "height") ?? "")
        let height = ((notification.object as? NSDictionary)?.value(forKey: "height") ?? 0)
        var heightInt = 0.0
        heightInt = height as! Double
        self.constantContainerHeight.constant = heightInt
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector:#selector(setHeightOfInviteFriendUsersContainerView(_:)), name: Notification.Name("setHeightOfInviteFriendUsersContainerView"),object: nil)

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        viewPendingHint.isHidden = true
        InviteSentCell.register(tableView: tableView)
        InvitePendingCell.register(tableView: tableView)
        InviteCompletedCell.register(tableView: tableView)
        segmentControl.textColor(selectedColor: .white, normalColor: .clrTextNormal)
        viewInviteFriendBackButtonGround.radius(color: .clrOrange)
        viewInviteFriendBackButtonGround.circle()
        
        viewButtonSendInvite.circle()
        invitedFriendsList()
    }
    
    func addInviteFriendPageControl() {
//        var pageController = UIStoryboard(name: "InviteFriends", bundle: nil).instantiateViewController(withIdentifier: "InviteAFriendsUsersPageControl") as! InviteAFriendsUsersPageControl
//
//        pageController.view.frame = CGRect.init(x: 0, y: 0, width: viewBackGroundTableView.frame.width, height: 740)
//
////        viewBackGroundTableView.addSubview(pageController.view)
//        self.present(pageController, animated: true)
        
        ViewEmbedder.embed(
            withIdentifier: "InviteAFriendsUsersPageControl", // Storyboard ID
            parent: self,
            container: self.containerView){ vc in
            // do things when embed complete
        }
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func buttonViewTerms(_ sender: Any) {
    }
    @IBAction func buttonInviteFriend(_ sender: Any) {
        let vc = UIStoryboard.init(name: "InviteFriends", bundle: nil).instantiateViewController(withIdentifier: "InviteFriendsAddNumber") as! InviteFriendsAddNumber
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func buttonSendInvite(_ sender: Any) {
    }
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        tableView.reloadData()
        viewPendingStatus.isHidden = true
        viewPendingStatus.backgroundColor = .clear
        viewPendingStatus.frame.size.height = 0
        viewPendingHint.isHidden = true
        if sender.selectedSegmentIndex == 1 {
            viewPendingStatus.isHidden = false
            viewPendingStatus.backgroundColor = .white
            viewPendingStatus.frame.size.height = 50
            viewPendingHint.isHidden = false
        }
    }
    
    func invitedFriendsList() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic") ?? ""
        let parameters: Parameters = [
            "cnic": userCnic,
            "channelId": "\(DataManager.instance.channelID)",
            "imei": DataManager.instance.imei ?? ""
        ]
        
        APIs.postAPI(apiName: .invitedFriendsList, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: ModelinvitedFriendsList? = APIs.decodeDataToObject(data: responseData)
            self.modelinvitedFriendsList = model
            
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
            return modelinvitedFriendsList?.data?.sentInviteFriendList?.count ?? 0
        }
        else if segmentControl.selectedSegmentIndex == 1 {
            return modelinvitedFriendsList?.data?.pendingInviteFriendList?.count ?? 0
        }
        else {
            return modelinvitedFriendsList?.data?.completedInviteFriendList?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        addInviteFriendPageControl()
        if segmentControl.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InviteSentCell") as! InviteSentCell
            // if change internet package is true then we dont need to show subscribed package
            
            cell.sentInviteFriendList = modelinvitedFriendsList?.data?.sentInviteFriendList?[indexPath.row]
            return cell
        }
        else if segmentControl.selectedSegmentIndex == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvitePendingCell") as! InvitePendingCell
            // if change internet package is true then we dont need to show subscribed package
            cell.sentInviteFriendList = modelinvitedFriendsList?.data?.pendingInviteFriendList?[indexPath.row]
            cell.compaignText = modelinvitedFriendsList?.data?.campaignText ?? ""
            cell.transactionText = modelinvitedFriendsList?.data?.transactionText ?? ""
            

            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InviteCompletedCell") as! InviteCompletedCell
            // if change internet package is true then we dont need to show subscribed package
            cell.sentInviteFriendList = modelinvitedFriendsList?.data?.completedInviteFriendList?[indexPath.row]
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

extension InviteAFriends {
    // MARK: - ModelinvitedFriendsList
    struct ModelinvitedFriendsList: Codable {
        let responsecode: Int
        let responseblock: JSONNull?
        let messages: String
        let data: ModelinvitedFriendsListData?
    }

    // MARK: - DataClass
    struct ModelinvitedFriendsListData: Codable {
        let campaignText: String?
        let sentInviteFriendList: [SentInviteFriendList]?
        let transactionText: String?
        let pendingInviteFriendList: [SentInviteFriendList]?
        let totalEarnings: String
        let completedInviteFriendList: [SentInviteFriendList]?
    }

    // MARK: - SentInviteFriendList
    struct SentInviteFriendList: Codable {
        let mobileNo: String
        let inviteeName: String?
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

    class JSONCodingKey: CodingKey {
        let key: String

        required init?(intValue: Int) {
            return nil
        }

        required init?(stringValue: String) {
            key = stringValue
        }

        var intValue: Int? {
            return nil
        }

        var stringValue: String {
            return key
        }
    }

    class JSONAny: Codable {

        let value: Any

        static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
            return DecodingError.typeMismatch(JSONAny.self, context)
        }

        static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
            let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
            return EncodingError.invalidValue(value, context)
        }

        static func decode(from container: SingleValueDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                return value
            }
            if let value = try? container.decode(Int64.self) {
                return value
            }
            if let value = try? container.decode(Double.self) {
                return value
            }
            if let value = try? container.decode(String.self) {
                return value
            }
            if container.decodeNil() {
                return JSONNull()
            }
            throw decodingError(forCodingPath: container.codingPath)
        }

        static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                return value
            }
            if let value = try? container.decode(Int64.self) {
                return value
            }
            if let value = try? container.decode(Double.self) {
                return value
            }
            if let value = try? container.decode(String.self) {
                return value
            }
            if let value = try? container.decodeNil() {
                if value {
                    return JSONNull()
                }
            }
            if var container = try? container.nestedUnkeyedContainer() {
                return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
                return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
        }

        static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
            if let value = try? container.decode(Bool.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(Int64.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(Double.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(String.self, forKey: key) {
                return value
            }
            if let value = try? container.decodeNil(forKey: key) {
                if value {
                    return JSONNull()
                }
            }
            if var container = try? container.nestedUnkeyedContainer(forKey: key) {
                return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
                return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
        }

        static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
            var arr: [Any] = []
            while !container.isAtEnd {
                let value = try decode(from: &container)
                arr.append(value)
            }
            return arr
        }

        static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
            var dict = [String: Any]()
            for key in container.allKeys {
                let value = try decode(from: &container, forKey: key)
                dict[key.stringValue] = value
            }
            return dict
        }

        static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
            for value in array {
                if let value = value as? Bool {
                    try container.encode(value)
                } else if let value = value as? Int64 {
                    try container.encode(value)
                } else if let value = value as? Double {
                    try container.encode(value)
                } else if let value = value as? String {
                    try container.encode(value)
                } else if value is JSONNull {
                    try container.encodeNil()
                } else if let value = value as? [Any] {
                    var container = container.nestedUnkeyedContainer()
                    try encode(to: &container, array: value)
                } else if let value = value as? [String: Any] {
                    var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                    try encode(to: &container, dictionary: value)
                } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
                }
            }
        }

        static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
            for (key, value) in dictionary {
                let key = JSONCodingKey(stringValue: key)!
                if let value = value as? Bool {
                    try container.encode(value, forKey: key)
                } else if let value = value as? Int64 {
                    try container.encode(value, forKey: key)
                } else if let value = value as? Double {
                    try container.encode(value, forKey: key)
                } else if let value = value as? String {
                    try container.encode(value, forKey: key)
                } else if value is JSONNull {
                    try container.encodeNil(forKey: key)
                } else if let value = value as? [Any] {
                    var container = container.nestedUnkeyedContainer(forKey: key)
                    try encode(to: &container, array: value)
                } else if let value = value as? [String: Any] {
                    var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                    try encode(to: &container, dictionary: value)
                } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
                }
            }
        }

        static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }

        public required init(from decoder: Decoder) throws {
            if var arrayContainer = try? decoder.unkeyedContainer() {
                self.value = try JSONAny.decodeArray(from: &arrayContainer)
            } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
                self.value = try JSONAny.decodeDictionary(from: &container)
            } else {
                let container = try decoder.singleValueContainer()
                self.value = try JSONAny.decode(from: container)
            }
        }

        public func encode(to encoder: Encoder) throws {
            if let arr = self.value as? [Any] {
                var container = encoder.unkeyedContainer()
                try JSONAny.encode(to: &container, array: arr)
            } else if let dict = self.value as? [String: Any] {
                var container = encoder.container(keyedBy: JSONCodingKey.self)
                try JSONAny.encode(to: &container, dictionary: dict)
            } else {
                var container = encoder.singleValueContainer()
                try JSONAny.encode(to: &container, value: self.value)
            }
        }
    }

}

