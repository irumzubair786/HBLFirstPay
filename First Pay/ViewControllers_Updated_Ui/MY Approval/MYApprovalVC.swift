//
//  MYApprovalVC.swift
//  First Pay
//
//  Created by Irum Zubair on 08/11/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import Foundation
import Alamofire
var requesterMoneyId : Int?
var accountNo : String?
var Amount : Int?
var accountName: String?
class MYApprovalVC: BaseClassVC , UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let count = self.myStatementObj?.ministatement?.count{
//            return count
//        }
        return (modelReceivedRequest?.data.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellMYApprovalVC") as! CellMYApprovalVC
        cell.btnCancel.tag = indexPath.row
        cell.btnSent.tag = indexPath.row
        cell.btnCancel.setTitle("", for: .normal)
        cell.btnSent.setTitle("", for: .normal)
         
        cell.btnCancel.addTarget(self, action: #selector(buttontaped), for: .touchUpInside)
        cell.lblName.text = modelReceivedRequest?.data[indexPath.row].accountTitle
        cell.lblAmount.text = "\(modelReceivedRequest?.data[indexPath.row].amount ?? 0)"
        cell.lblMessage.text = modelReceivedRequest?.data[indexPath.row].comments
//        requesterMoneyId = modelReceivedRequest?.data[indexPath.row].requesterMoneyID
        cell.btnSent.addTarget(self, action: #selector(buttontapedSent), for: .touchUpInside)
        
        
        return cell
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        emptyReceivedView.isHidden = true
        emptySentView.isHidden = true
        
//        tableView.reloadData()
//
        imgSent.isHidden = true
        getReceivedReq()
        
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .darkContent // You can choose .default for dark text/icons or .lightContent for light text/icons
        }
    
    @IBOutlet weak var backBUtton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func backBUtton(_ sender: UIButton) {
        self.dismiss(animated:true)
    }
    
    
    @IBOutlet weak var emptyReceivedView: UIView!
    @IBOutlet weak var imgReceived: UIImageView!
    
  
    @IBOutlet weak var emptySentView: UIView!
    @IBOutlet weak var imgSent: UIImageView!
    @IBOutlet weak var buttonSent: UIButton!
    @IBOutlet weak var buttonReceived: UIButton!
    @IBAction func buttonReceived(_ sender: UIButton) {
        tableView.reloadData()
        imgSent.isHidden = true
        imgReceived.isHidden = false
    }
    
    @IBAction func buttonSent(_ sender: UIButton) {
        tableView.reloadData()
        imgReceived.isHidden = true
        imgSent.isHidden = false
    }
    
    
    
    
    @IBAction func buttonCellCancel(_ sender: UIButton) {
        
    }
   
    @objc func buttontaped(_sender:UIButton)
    {
        let tag = _sender.tag
        let cell = tableView.cellForRow(at: IndexPath(row: tag, section: 0)) as! CellMYApprovalVC
        
//        cell.btnSent.isHidden = true
//        cell.btnCancel.isHidden = true
        
        requesterMoneyId = modelReceivedRequest?.data[tag].requesterMoneyID
        print("requesterMoneyId", requesterMoneyId)
         updateRequestStatus()
//        tableView.reloadData()
        
    }
    
    @objc func buttontapedSent(_sender:UIButton)
    {
        let tag = _sender.tag
        let cell = tableView.cellForRow(at: IndexPath(row: tag, section: 0)) as! CellMYApprovalVC
       
        accountNo = modelReceivedRequest?.data[tag].accountNo ?? ""
        Amount = modelReceivedRequest?.data[tag].amount ?? 0
        accountName = modelReceivedRequest?.data[tag].accountTitle ?? ""
        print("accountNo", accountNo, Amount , accountName)
//        move to next vc
        
    }
    
    
    
    
    
    @IBAction func buttonCellSent(_ sender: UIButton) {
    }
//    -------------------getReceivedRequest API
    func getReceivedReq() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic": userCnic!,
            "channelId": "\(DataManager.instance.channelID)",
            "imei": DataManager.instance.imei!
        ]

        APIs.postAPI(apiName: .getReceivedRequest, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            
            let model: GetReceivedRequest? = APIs.decodeDataToObject(data: responseData)
            self.modelReceivedRequest = model
        }
    }
    var modelReceivedRequest: GetReceivedRequest? {
        didSet {
            if modelReceivedRequest?.responsecode == 1 {
               
                tableView.delegate = self
                tableView.dataSource = self
                tableView.reloadData()
            }
            else {
                self.showAlertCustomPopup(title: "Error", message: modelReceivedRequest?.messages, iconName: .iconError)
            }
        }
    }
    
//    ------------------------end
    
//    ------------------updateRequestStatus
    
    func updateRequestStatus() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic": userCnic!,
            "channelId": "\(DataManager.instance.channelID)",
            "imei": DataManager.instance.imei!,
//            "tempStatus": "R",
            "status" : "A",
            "requestId" : requesterMoneyId!
        ]
        print(parameters)
        APIs.postAPI(apiName: .updateRequestStatus, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            
            let model: UpdateRequestStatus? = APIs.decodeDataToObject(data: responseData)
            self.modelupdateRequestStatus = model
        }
    }
    var modelupdateRequestStatus: UpdateRequestStatus? {
        didSet {
            if modelupdateRequestStatus?.responsecode == 1 {
               
                tableView.reloadData()
            }
            else {
                self.showAlertCustomPopup(title: "Error", message: modelupdateRequestStatus?.messages, iconName: .iconError)
            }
        }
    }
//    end API
    
    
}
extension MYApprovalVC{
    struct GetReceivedRequest: Codable {
        let responsecode: Int
        let data: [Datum]
        let messages: String
    }

    // MARK: - Datum
    struct Datum: Codable {
        let amount: Int
        let comments, status, statusDescr, accountTitle: String
        let requesterMoneyID: Int
        let requestDate, accountNo: String

        enum CodingKeys: String, CodingKey {
            case amount, comments, status, statusDescr, accountTitle
            case requesterMoneyID = "requesterMoneyId"
            case requestDate, accountNo
        }
    }
}
extension MYApprovalVC{
    struct UpdateRequestStatus: Codable {
        let responsecode: Int
        let data: JSONNull?
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
