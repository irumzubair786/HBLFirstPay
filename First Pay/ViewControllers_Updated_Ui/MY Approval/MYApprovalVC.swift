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
var requesterMoneyId : Int?
var accountNo : String?
var Amount : Int?
var accountName: String?
class MYApprovalVC: BaseClassVC , UITableViewDelegate , UITableViewDataSource {
    var amount : Double?
    var ComaSepAmount :String?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if tableView == tableViewReceived
        {
          return (modelReceivedRequest?.data.count)!
      }
        else
        {
            return (modelSentRequest?.data.count)!
        }
        
    }
    var window: UIWindow?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewReceived
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellMYApprovalVC") as! CellMYApprovalVC
            
            cell.btnCancel.isHidden = true
            cell.btnSent.isHidden = true
            cell.buttonDeclined.isHidden = true
            let status = modelReceivedRequest?.data[indexPath.row].status
            if status == "P"
            {
                cell.btnCancel.isHidden = false
                cell.btnSent.isHidden = false
            }
            else if status == "R"
            {
                cell.btnCancel.isHidden = true
                cell.btnSent.isHidden = true
                cell.buttonDeclined.isHidden = false
                cell.buttonDeclined.setTitle("Declined", for: .normal)
                cell.buttonDeclined.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 246/255, alpha: 1)
                cell.buttonDeclined.setTitleColor(UIColor(hexString: "#8F92A1"),  for: .normal)
                
                
                
            }
            else if status == "A"
            {
                cell.btnCancel.isHidden = true
                cell.btnSent.isHidden = true
                cell.buttonDeclined.isHidden = false
                cell.buttonDeclined.setTitle("Sent", for: .normal)
                cell.buttonDeclined.backgroundColor = UIColor(red: 233/255, green: 250/255, blue: 245/255, alpha: 1)
                cell.buttonDeclined.setTitleColor(UIColor(hexString: "#00CC96"),  for: .normal)
                
                
            }
            else
            {
                cell.btnCancel.isHidden = true
                cell.btnSent.isHidden = true
                cell.buttonDeclined.isHidden = true
            }
            cell.btnCancel.tag = indexPath.row
            cell.btnSent.tag = indexPath.row
            cell.btnCancel.setTitle("", for: .normal)
            cell.btnSent.setTitle("", for: .normal)
             
            cell.btnCancel.addTarget(self, action: #selector(buttontaped), for: .touchUpInside)
            cell.lblName.text = modelReceivedRequest?.data[indexPath.row].accountTitle
            
          
            amount = Double((modelReceivedRequest?.data[indexPath.row].amount)!)
            CommaSepration()
    //        var a: Double?
    //        a = Double(ComaSepAmount!)
            cell.lblAmount.text = "Rs, \(ComaSepAmount!).00"
            cell.lblMessage.text = modelReceivedRequest?.data[indexPath.row].comments
    //        requesterMoneyId = modelReceivedRequest?.data[indexPath.row].requesterMoneyID
            cell.btnSent.addTarget(self, action: #selector(buttontapedSent), for: .touchUpInside)
            
            
            return cell
        }
       else
        {
           let cell = tableView.dequeueReusableCell(withIdentifier: "CellSentTableView") as! CellSentTableView
           
           let statas = modelSentRequest?.data[indexPath.row].status
            if statas == "R"
           {
                cell.buttonStatus.setTitle(modelSentRequest?.data[indexPath.row].statusDescr, for: .normal)
//                cell.buttonStatus.backgroundColor = .red
                
                cell.buttonStatus.backgroundColor = UIColor(red: 233/255, green: 250/255, blue: 245/255, alpha: 1)
                cell.buttonStatus.setTitleColor(UIColor(hexString: "#00CC96"),  for: .normal)
            }
           
           else if statas == "A"
           {
//               cell.buttonStatus.backgroundColor = .blue
               cell.buttonStatus.setTitle(modelSentRequest?.data[indexPath.row].statusDescr, for: .normal)
               cell.buttonStatus.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 246/255, alpha: 1)
               cell.buttonStatus.setTitleColor(UIColor(hexString: "#8F92A1"),  for: .normal)
              
           }
           else
           {
               cell.buttonStatus.setTitle(modelSentRequest?.data[indexPath.row].statusDescr, for: .normal)
               cell.buttonStatus.backgroundColor = UIColor(red: 252/255, green: 244/255, blue: 236/255, alpha:1)
               
               cell.buttonStatus.setTitleColor(UIColor(hexString: "#F19434"),  for: .normal)
           }
          
           cell.lblName.text = (modelSentRequest?.data[indexPath.row].accountTitle ?? "")
           cell.lblAmount.text = "Rs. \(modelSentRequest?.data[indexPath.row].amount ?? 0).00"
           
           
           return cell
           
       }
        
        
    }
    func CommaSepration()
    {
        var number = (amount!)
        var formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        //        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_US")
        ComaSepAmount = (formatter.string(from: NSNumber(value: number)))!
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        getReceivedReq()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyReceivedView.isHidden = true
        emptySentView.isHidden = true
        sentView.isHidden = true
//        tableView.reloadData()
        tableViewSent.rowHeight = 100
        imgSent.isHidden = true
        isfRomRewuestSent = true
        getReceivedReq()
//        step 1 to move direct dashboard
        
//        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector:#selector(dissmissViewController3), name: Notification.Name("MyApprovalVCDissmiss"),object: nil)
        
//
    }
    @objc func dissmissViewController3() {
       
        self.dismiss(animated: true)
        
        print("move to dashboard")

    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .darkContent // You can choose .default for dark text/icons or .lightContent for light text/icons
        }
    
    @IBOutlet weak var backBUtton: UIButton!
    @IBOutlet weak var tableViewReceived: UITableView!
    @IBAction func backBUtton(_ sender: UIButton) {
        
//        if isfRomRewuestSent == true{
//            goToMainPageVC ()
////            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
////          let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC") as! MainPageVC
////
////
////                 self.present(vc, animated: true, completion: nil)
////            self.navigationController?.popViewController(animated: true)
////            self.dismiss(animated: true)
//        }
//        else
//        {
            self.dismiss(animated:true)
//        }
        
       
    }
    func goToMainPageVC () {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC") as! MainPageVC
            window?.rootViewController = vc
//        self.dismiss(animated:true)
        self.present(vc, animated: true, completion: nil)
        
        

        }
    
    
    @IBOutlet weak var emptyReceivedView: UIView!
    @IBOutlet weak var imgReceived: UIImageView!
    @IBOutlet weak var emptySentView: UIView!
    @IBOutlet weak var imgSent: UIImageView!
    @IBOutlet weak var buttonSent: UIButton!
    @IBOutlet weak var buttonReceived: UIButton!
    @IBOutlet weak var tableViewSent: UITableView!
    @IBOutlet weak var sentView: UIView!
    
    @IBAction func buttonReceived(_ sender: UIButton) {
        startAnimatingReceived()
        getReceivedReq()
//        tableViewReceived.reloadData()
        imgSent.isHidden = true
        imgReceived.isHidden = false
        tableViewReceived.isHidden = false
        sentView.isHidden = true
    }
    func startAnimating() {
//        UIView.animateKeyframes(withDuration: 1, delay: 0.1, options: ., animations: {
//               self.sentView.center.x += self.view.bounds.width
//               self.sentView.center.x += self.view.bounds.width
//
//           }, completion: nil)
        sentView.center.x += view.bounds.width

           // Animate the view from right to left
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveEaseInOut, animations: {
               self.sentView.center.x -= self.view.bounds.width // Move the view back to its original position
           }, completion: nil)
       }
    
    func startAnimatingReceived() {
        UIView.animateKeyframes(withDuration: 0.1, delay: 0.1, options: .beginFromCurrentState, animations: {
               self.tableViewReceived.center.x += self.view.bounds.width
               self.tableViewReceived.center.x += self.view.bounds.width

           }, completion: nil)
       }
    
    @IBAction func buttonSent(_ sender: UIButton) {

//        UIView.animate(withDuration: 0.5, delay: 0.25, options: UIViewAnimationOptions(), animations: { () -> Void in
//                   self.sentView.frame = CGRect(x: self.view.frame.size.width, y: 100,width: self.view.frame.size.width ,height: self.view.frame.size.height)
//               }, completion: { (finished: Bool) -> Void in
//                   self.sentView.backgroundColor = UIColor.clear
//               })
        startAnimating()
//        UIView.transition(with: sentView,
//                                 duration: 0.5,
//                          options: [.curveLinear],
//                                 animations: {
//
//                                   self.sentView.isHidden = true
//               },
//                                 completion: nil)
        
        
        tableViewReceived.isHidden = true
        sentView.isHidden = false
        tableViewSent.reloadData()
        getSentReq()
        imgReceived.isHidden = true
        imgSent.isHidden = false
    }
    
    @IBAction func buttonCellCancel(_ sender: UIButton) {
        
    }
   
    @objc func buttontaped(_sender:UIButton)
    {
        let tag = _sender.tag
        let cell = tableViewReceived.cellForRow(at: IndexPath(row: tag, section: 0)) as! CellMYApprovalVC
        
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
        let cell = tableViewReceived.cellForRow(at: IndexPath(row: tag, section: 0)) as! CellMYApprovalVC
        requesterMoneyId = modelReceivedRequest?.data[tag].requesterMoneyID
        accountNo = modelReceivedRequest?.data[tag].accountNo ?? ""
        Amount = modelReceivedRequest?.data[tag].amount ?? 0
        accountName = modelReceivedRequest?.data[tag].accountTitle ?? ""
        print("accountNo", accountNo, Amount , accountName)
//        move to next vc
        let vc = storyboard?.instantiateViewController(withIdentifier: "RequestMoneyTransferVC") as! RequestMoneyTransferVC
        self.present(vc, animated: true)
       
    }
    
    @IBAction func buttonCellSent(_ sender: UIButton) {
    }
    
    //    -------------------getSentdRequest API
        func getSentReq() {
            let userCnic = UserDefaults.standard.string(forKey: "userCnic")
            let parameters: Parameters = [
                "cnic": userCnic!,
                "channelId": "\(DataManager.instance.channelID)",
                "imei": DataManager.instance.imei!
            ]
              
            APIs.postAPI(apiName: .getSentRequest, parameters: parameters, viewController: self) { responseData, success, errorMsg in
                
                let model: GetSentRequest? = APIs.decodeDataToObject(data: responseData)
                self.modelSentRequest = model
            }
        }
        var modelSentRequest: GetSentRequest? {
            didSet {
                if modelSentRequest?.responsecode == 1 {
                   
                    tableViewSent.delegate = self
                    tableViewSent.dataSource = self
                    tableViewSent.reloadData()
                }
                else {
                    self.showAlertCustomPopup(title: "Error", message: modelSentRequest?.messages, iconName: .iconError)
                }
            }
        }
        
    //    ------------------------end

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
               
                tableViewReceived.delegate = self
                tableViewReceived.dataSource = self

                tableViewReceived.reloadData()
            }
            else {
                self.showAlertCustomPopup(title: "Error", message: modelReceivedRequest?.messages, iconName: .iconError)
            }
        }
    }
    
//    ------------------------end
    
//    ------------------updateRequestStatus
    
    func updateRequestStatus() {
        var userCnic = UserDefaults.standard.string(forKey: "userCnic")
        userCnic = DataManager.instance.userCnic
        let parameters: Parameters = [
            "cnic": UserDefaults.standard.string(forKey: "userCnic")!,
            "channelId": "\(DataManager.instance.channelID)",
            "imei": DataManager.instance.imei!,
//            "tempStatus": "R",
            "status" : "A",
            "requestId" : "\(requesterMoneyId!)"
        ]
       
//        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
//        let paramsencoded = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
//
//        print(paramsencoded)
        APIs.postAPI(apiName: .updateRequestStatus, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            
            let model: UpdateRequestStatus? = APIs.decodeDataToObject(data: responseData)
            self.modelupdateRequestStatus = model
        }
    }
    var modelupdateRequestStatus: UpdateRequestStatus? {
        didSet {
            if modelupdateRequestStatus?.responsecode == 1 {
               
                print("Success")
                self.showAlertCustomPopup(title: "Success", message: modelReceivedRequest?.messages, iconName: .iconSuccess, completion: { _ in
                    //
                    let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                  let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC") as! MainPageVC
                    
        //                 self.present(vc, animated: true)
                    
                    self.dismiss(animated: true)
                })
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
extension MYApprovalVC {
    struct GetSentRequest: Codable {
        let responsecode: Int
        let data: [Datumms]
        let messages: String
    }

    // MARK: - Datum
    struct Datumms: Codable {
        let amount: Int
        let comments, status, statusDescr, accountTitle: String
        let requesterMoneyID: Int
        let requestDate: String
        let accountNo: JSONNulls?

        enum CodingKeys: String, CodingKey {
            case amount, comments, status, statusDescr, accountTitle
            case requesterMoneyID = "requesterMoneyId"
            case requestDate, accountNo
        }
    }

    // MARK: - Encode/decode helpers

    class JSONNulls: Codable, Hashable {
        static func == (lhs: MYApprovalVC.JSONNulls, rhs: MYApprovalVC.JSONNulls) -> Bool {
           return true
        }
        

        public static func == (lhs: JSONNulls, rhs: JSONNull) -> Bool {
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
