//
//  MessagesChatInCommingCell.swift
//  talkPHR
//
//  Created by Shakeel Ahmed on 4/7/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import GrowingTextView
import SwiftKeychainWrapper
import AlamofireObjectMapper
import Nuke
import Kingfisher
struct ChatModel: Decodable {
    
}
struct ChatModelData: Decodable {
    //let responsecode: Int
    let data: [ChatModelResponse]
    //let messages: String
}

// MARK: - Datum
struct ChatModelResponse: Decodable {
    let recipientID, text: String
    let buttons: [ChatModelButtons]
    
    enum CodingKeys: String, CodingKey {
        case recipientID = "recipient_id"
        case text, buttons
    }
}

// MARK: - Button
struct ChatModelButtons: Decodable {
    var payload, title: String
    
    init(payload: String, title: String) {
        self.payload = payload
        self.title = title
    }
}

class MessagesChatInCommingCell : UITableViewCell{

    var tempChatRecords = [ChatModelButtons]()
    var textuserchat :[String]?
       var arrIsMyMessage :[String]?
    var getButtonsArr :[String]?
    var textdata : String?
    @IBOutlet weak var bgvBubbleColor: UIView!
    @IBOutlet weak var bgvTextMessage: UIView!
    @IBOutlet weak var bgvName: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!

    @IBOutlet weak var collectionvieww: UICollectionView!
    @IBOutlet weak var img2: UIImageView!
    
    @IBOutlet weak var btntitle: UIButton!
    @IBOutlet weak var buttonsView: UIView!
    
    override func awakeFromNib() {
       
//        bgvBubbleColor.backgroundColor = .clrChatInComing
//        bgvName.backgroundColor = .clrChatInComing
//        bgvName.setCircle()
//        bgvBubbleColor.setRadiusViewChat()
//        super.awakeFromNib()
//        // Initialization code
        bgvBubbleColor.backgroundColor = UIColor(red:210/255.0, green:210/255.0, blue:210/255.0, alpha: 2.0)
//        bgvName.backgroundColor = UIColor(red: 68/255.0, green: 141/255.0, blue: 141/255.0, alpha: 2.0)
        bgvBubbleColor.layer.cornerRadius = 8
//        lblMessage.numberOfLines = 10
       
       
        // Initialization code
        
    }
    
    func design()
    {
        collectionvieww.register(UINib(nibName: "btnCell", bundle: nil), forCellWithReuseIdentifier: "btnCell")
        btnCell.registerr(CollectionView: collectionvieww)
    }
    
}
extension UICollectionViewCell
{
    static func nibNames() -> String {
    return String(describing: self.self)
}
    static func registerr(CollectionView :UICollectionView)
    {
        let nibName = String(describing: self.self)
        CollectionView.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
    }
    
}
//    var strUserName = "Andy Suzzane"
//    //ChatModel
//    var chatRecords: [ChatModelButtons]? {
//        didSet {
//            print(chatRecords)
//            //print(chatRecords)
//            if chatRecords?.count ?? 0 > 0 {
//                collectionvieww.reloadData()
////                colButton2.reloadData()
//
//            }
//            else {
//
//                //MARK: - Hide or remove size for collection view
//            }
//        }
//    }
//    var chatRecordsOnButtons: [ChatModelButtons]? {
//        didSet {
//            print(chatRecordsOnButtons)
//            //print(chatRecords)
//            if chatRecordsOnButtons?.count ?? 0 > 0 {
//
//            }
//            else {
//
//                //MARK: - Hide or remove size for collection view
//            }
//        }
//    }
//
   

//    func funSetting() {
//
////        txtvMessageText.delegate = self
////        // *** Listen to keyboard show / hide ***
////        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
////
////        // *** Hide keyboard when tapping outside ***
////        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
////        view.addGestureRecognizer(tapGesture)
//        if GlobalData.IsCheckChat == "True"
//        {
//            self.fetchButtons(message: "/greet")
//        }
//        if GlobalData.IsCheckChat != "True"
//        {
//
//
//            tempChatRecords.removeAll()
//            self.fetchButtons(message: GlobalData.ClickedChatButtonValue)
//
////            self.textuserchat?.append(GlobalData.ChatTextButtonClick as? String ?? "")
////
//
//            if textuserchat?.count ?? 0 > 0
//            {
//
//            }
//
//        }
//
//        collectionvieww.delegate  = self
//        collectionvieww.dataSource = self
//        //inter_bank_fund_transfer_process_steps
//    }
//    @objc func btnClicked(_sender: UIButton)
//    {
//        print("value is ", GlobalData.IsCheckChat)
//        let tag = _sender.tag
//        GlobalData.IsCheckChat = "False"
//        let buttonMessage = chatRecords?[tag].payload ?? ""
//                    print("btnmsg is ",buttonMessage)
//
//        GlobalData.ClickedChatButtonValue = buttonMessage
//        print("btn is", GlobalData.ClickedChatButtonValue)
//
//        print(" False value is ", GlobalData.IsCheckChat)
//        print("count is ", chatRecords?.count)
//        funSetting()
//
//        collectionvieww.reloadData()
//
//            print("done")
////
//       self.collectionvieww.reloadData()
//
//    }
//func fetchButtons(message: String) {
//
//    let compelteUrl = GlobalConstants.BASE_URL + "liveChat"
//    var userCnic : String?
//
//    if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
//        userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
//    }
//    else{
//        userCnic = ""
//    }
//
//    self.showActivityIndicator()
//
//    let parameters2 = ["imei":"\(DataManager.instance.imei!)","cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)", "message": message]
//    print(parameters2)
//    let result = (splitString(stringToSplit: base64EncodedString(params: parameters2)))
//
//    print(result.apiAttribute1)
//    print(result.apiAttribute2)
//
//    let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
//    print(params)
//    print(compelteUrl)
//    APIs.postAPI(url: compelteUrl, parameters: params, headers: nil, completion: { [self]
//        response, success, errorMsg  in
//        self.hideActivityIndicator()
//
//
//        if success {
//            let data = Data((response?.rawString()?.utf8)!)
//            do {
//                // make sure this JSON is in the format we expect
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                    // try to read out a string array
//                    if json["responsecode"] as! Int == 1 {
//                        let jsonDictionary = kfunGetDicFromJSONString(jsonString: response!.rawString()!)
//                        print(jsonDictionary)
//                        let dataString = jsonDictionary["data"] as! String // kfunGetDicFromJSONString(jsonString: (jsonDictionary as! [String:AnyObject])["data"] as! String)
//
//                        let stringData = Data((dataString.utf8))
//                        do {
//                            if let jsonArray = try JSONSerialization.jsonObject(with: stringData, options : .allowFragments) as? [Dictionary<String,Any>]
//                            {
//                                if jsonArray.count > 0 {
//                                    print(jsonArray) // use the json here
//                                    let recipietID = (jsonArray[0] as NSDictionary).value(forKey: "recipient_id")
//
//                                    let textDic = (jsonArray[0] as NSDictionary).value(forKey: "text")
//                                    GlobalData.ChatTextButtonClick = textDic as! String
//                                    print("chat text is",  GlobalData.ChatTextButtonClick)
//                                    if self.textuserchat == nil {
//                                        self.textuserchat = [String]()
//                                    }
//
//                                    if self.arrIsMyMessage == nil {
//                                        self.arrIsMyMessage = [String]()
//                                    }
////                                        self.txtvMessageText.text = nil
//                                    if self.textuserchat?.count ?? 0 > 0 {
//                                        self.textuserchat?.append(message)
//                                        self.arrIsMyMessage?.append("1")
//                                    }
//                                    self.arrIsMyMessage?.append("0")
//                                    self.textuserchat?.append(textDic as? String ?? "")
//
//
//
//                                    // self.textdata  = textDic as! String
//                                    let buttonsData = (jsonArray[0] as NSDictionary).value(forKey: "buttons") as? NSArray
//                                    print("recipietID: \(recipietID)" )
//                                    print("textDic: \(textDic)")
//                                    print("buttonsData: \(buttonsData)")
//
//                                    if buttonsData?.count ?? 0 > 0 {
//
////                                            tableview.scrollToBottom()
//                                        for button in buttonsData! {
//                                            let tempPayload = (button as! NSDictionary).value(forKey: "payload") as? String ?? ""
//                                            let tempTitle = (button as! NSDictionary).value(forKey: "title") as? String ?? ""
//
//                                            let tempButton = ChatModelButtons(payload: tempPayload, title: tempTitle)
//                                            tempChatRecords.append(tempButton)
//
//                                        }
//                                        if tempChatRecords.count > 0 {
//                                            self.chatRecords = tempChatRecords
//
////                                                tableview.scrollToBottom()
//
//                                        }
//                                        //                                        self.colvBtnHeight.constant = 80
//
//                                    }
//                                    else {
//                                        self.collectionvieww.isHidden = true
////                                            self.colvBtnHeight.constant = 0
//                                    }
//                                }
//
//                            } else {
//                                print("bad json")
//                            }
//                        } catch let error as NSError {
//                            print(error)
//                        }
//                    }
//                }
//            } catch let error as NSError {
//                print("Failed to load: \(error.localizedDescription)")
//            }
//
//        }
//        else {
//            print("no buttons data")
//
//        }
//    })
//}
//
//func fetchChatOnButton(message: String) {
//
//    let compelteUrl = GlobalConstants.BASE_URL + "liveChat"
//    var userCnic : String?
//
//    if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
//        userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
//    }
//    else{
//        userCnic = ""
//    }
//
//    showActivityIndicator()
//
//    let parameters2 = ["imei":"\(DataManager.instance.imei!)","cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)", "message": message]
//    print(parameters2)
//    let result = (splitString(stringToSplit: base64EncodedString(params: parameters2)))
//
//    print(result.apiAttribute1)
//    print(result.apiAttribute2)
//
//    let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
//    print(params)
//    print(compelteUrl)
//    APIs.postAPI(url: compelteUrl, parameters: params, headers: nil, completion: {
//
//        response, success, errorMsg  in
//        self.hideActivityIndicator()
//
////            self.tableview.scrollToBottom()
//        if success {
//            let data = Data((response?.rawString()?.utf8)!)
//            do {
//                // make sure this JSON is in the format we expect
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                    // try to read out a string array
//                    if json["responsecode"] as! Int == 1 {
//                        let jsonDictionary = kfunGetDicFromJSONString(jsonString: response!.rawString()!)
//                        print(jsonDictionary)
//                        let dataString = jsonDictionary["data"] as! String // kfunGetDicFromJSONString(jsonString: (jsonDictionary as! [String:AnyObject])["data"] as! String)
//
//                        let stringData = Data((dataString.utf8))
//                        do {
//                            if let jsonArray = try JSONSerialization.jsonObject(with: stringData, options : .allowFragments) as? [Dictionary<String,Any>]
//                            {
//                                print(jsonArray) // use the json here
//                                let recipietID = (jsonArray[0] as NSDictionary).value(forKey: "recipient_id")
//
//                                let textDic = (jsonArray[0] as NSDictionary).value(forKey: "text")
//                                self.textdata  = textDic as! String
//
//
//                                self.collectionvieww.reloadData()
////                                    self.tableview.scrollToBottom()
//                                return()
//
//                                let buttonsData = (jsonArray[0] as NSDictionary).value(forKey: "buttons") as? NSArray
//
//                                print("recipietID: \(recipietID)" )
//                                print("textDic: \(textDic)")
//                                print("buttonsData: \(buttonsData)")
//
//                                var tempChatRecords = [ChatModelButtons]()
//
//                                if buttonsData?.count ?? 0 > 0 {
//                                    for button in buttonsData! {
//                                        let tempPayload = (button as! NSDictionary).value(forKey: "payload") as? String ?? ""
//                                        let tempTitle = (button as! NSDictionary).value(forKey: "title") as? String ?? ""
//
//                                        let tempButton = ChatModelButtons(payload: tempPayload, title: tempTitle)
//                                        tempChatRecords.append(tempButton)
//                                        self.collectionvieww.reloadData()
//                                    }
//
//                                    if tempChatRecords.count > 0 {
//                                        self.chatRecordsOnButtons = tempChatRecords
//                                        self.collectionvieww.reloadData()
//                                    }
//                                }
//                                else {
//
//                                }
//                            } else {
//                                print("bad json")
//                            }
//                        } catch let error as NSError {
//                            print(error)
//                        }
//                    }
//                }
//            } catch let error as NSError {
//                print("Failed to load: \(error.localizedDescription)")
//            }
//
//        }
//        else {
//
//        }
//    })
//    collectionvieww.reloadData()
//}
//
//}
//
//
//extension UICollectionViewCell
//{
//static func nibName() -> String {
//return String(describing: self.self)
//}
//static func register(CollectionView :UICollectionView)
//{
//    let nibName = String(describing: self.self)
//    CollectionView.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
//}
//
//}
//
extension MessagesChatInCommingCell: UICollectionViewDelegate, UICollectionViewDataSource {


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("count is", chatRecords?.count)
//            return chatRecords?.count ?? 0
//        print("count is", chatRecords?.count)
        print("btn array is ", GlobalData.ClickedChatButtonValue.count)
        return 100
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let cell = collectionvieww.dequeueReusableCell(withReuseIdentifier: "btnCell", for: indexPath) as! btnCell
        cell.title.setTitle("test", for: .normal)
//            cell.lblTitle.text = chatRecords?[indexPath.row].title
        collectionvieww.isScrollEnabled = true
            cell.contentView.dropShadow1()
//             cell.btntitle.tag = indexPath.row
//        print("tag is",cell.btntitle.tag)

//            cell.btntitle.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)

            return cell

            }


}

