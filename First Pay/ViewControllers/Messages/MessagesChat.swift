//
//  MessagesChat.swift
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
//import Lottie
var chatbtnarray :[String]?


//var textuserchat :[String]?
//   var arrIsMyMessage :[String]?
class MessagesChat: BaseClassVC {
    var storedOffsets = [Int: CGFloat]()
    var tempChatRecords = [ChatModelButtons]()
    var textuserchat :[NSDictionary]?
    var arrIsMyMessage :[String]?
    var arrChatButtons = [NSArray]()

    var getButtonsArr :[String]?
    var urll = ""
   var arr = [ChatModelResponse]()
    var str2  = ""
    var TermsAndCondition = ""
    var appload = ""
    var ConcateTextDic = ""
    @IBOutlet weak var txtvMessageText: GrowingTextView!
    @IBOutlet weak var tablev: UITableView!
    @IBOutlet weak var
    btnBack : UIButton!
    @IBOutlet weak var colvBtnHeight: NSLayoutConstraint!
   

    var textdata : String?
    @IBOutlet weak var bgvTxtMessageText: UIView!
    @IBOutlet weak var txtvBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var bgvSendButton: UIView!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var btnAttachment: UIButton!
    @IBOutlet weak var btnSend: UIButton!
//    @IBOutlet weak var colvButtons: UICollectionView!
    @IBOutlet weak var colButton2: UICollectionView!
    @IBAction func btnAttachment(_ sender: Any) {
    }
    
    
    @IBAction func btnSend(_ sender: UIButton) {
//        tablev.beginUpdates()
        
        tablev.reloadData()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1, execute: {
            let indexPath = IndexPath(row: self.textuserchat!.count-1, section: 0)
            self.tablev.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
        })
        tablev.endUpdates()
        tableview.delegate = self
        tablev.dataSource = self
        tableview.dataSource = self
        tablev.delegate = self
        tableview.reloadData()
        
        if (txtvMessageText.text == "Type a message" ) || (txtvMessageText.text == ""){
           
        }
        else{
            self.fetchButtons(message: txtvMessageText.text)
            self.txtvMessageText.text = nil
        }
       
       
    }
  
    var strUserName = "Andy Suzzane"
    //ChatModel
    var chatRecords: [[ChatModelButtons]]? {
        didSet {
            print(chatRecords)
   
            if chatRecords?.count ?? 0 > 0 {

               
            }
            else {
                
                //MARK: - Hide or remove size for collection view
            }
        }
    }
    
    
    var chatRecordsOnButtons: [ChatModelButtons]? {
        didSet {
            print(chatRecordsOnButtons)
            //print(chatRecords)
            if chatRecordsOnButtons?.count ?? 0 > 0 {
                tablev.reloadData()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1, execute: {
                    let indexPath = IndexPath(row: self.textuserchat!.count-1, section: 0)
                    self.tablev.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
                })
            }
            else {
                
                //MARK: - Hide or remove size for collection view
            }
        }
    }
   
    
    
    @IBAction func logout(_ sender: UIButton) {
        popUpLogout()
        
    }
    
    override func viewDidLoad() {
        if chatRecords == nil {
            self.chatRecords = [[ChatModelButtons]]()
        }
        tablev.reloadData()
        setUIDesign()
        funSetting()
        tableview.delegate = self
        tablev.dataSource = self
        tableview.dataSource = self
        tablev.delegate = self
        tableview.reloadData()
        self.tablev.reloadData()
      
        super.viewDidLoad()
        tablev.rowHeight = UITableViewAutomaticDimension
        tablev.estimatedRowHeight = UITableViewAutomaticDimension
        print("chatRecords is", tempChatRecords)
//        let index = NSIndexPath(item: 0, section: 0)
//
//        let refCell = tablev.cellForRow(at: index as IndexPath) as! MessagesChatOutGoingCell
//        if refCell.lblMessage.text == "/greet"
//        {
//            refCell.bgvBubbleColor.backgroundColor = UIColor.clear
//            refCell.lblMessage.text = ""
//            refCell.lblMessage.text = ""
//            refCell.img.isHidden = true
//        }
        txtvMessageText.text = "Type a message"

    }
    
    
    @IBAction func againsendbtn(_ sender: UIButton) {
        tablev.reloadData()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1, execute: {
            let indexPath = IndexPath(row: self.textuserchat!.count-1, section: 0)
            self.tablev.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
        })
        tableview.delegate = self
        tablev.dataSource = self
        tableview.dataSource = self
        tablev.delegate = self
        tableview.reloadData()
//        tableview.scrollToBottom()
//        self.fetchButtons(message: txtvMessageText.text)
        
    }
    @IBAction func btnBack(_ sender: Any) {
//        GlobalData.IsCheckChat = "True"
        self.navigationController?.popViewController(animated: true)
    }
    func setUIDesign() {
        title = strUserName
        MessagesChatInCommingCell.register(tableView: tablev)
        MessagesChatOutGoingCell.register(tableView: tablev)
        MessagesChatImageCell.register(tableView: tablev)
        MessageChatInCommingWithButtonsCell.register(tableView: tablev)
        MessagesChatDocumentCell.register(tableView: tablev)
        tablev.tableFooterView = UIView()
        tableview.reloadData()
        tablev.reloadData()
        txtvMessageText.text = "Type a message"
        txtvMessageText.textColor = UIColor(red: 149/255.0, green: 154/255.0, blue: 150/255.0, alpha: 1.0)
    }
    
    func funSetting() {
        showActivityIndicator()
        txtvMessageText.delegate = self
        // *** Listen to keyboard show / hide ***
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // *** Hide keyboard when tapping outside ***
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        view.addGestureRecognizer(tapGesture)
//        if GlobalData.IsCheckChat == "True"
//        {
//            hideActivityIndicator()
//
//
            self.fetchButtons(message: "/greet")
            tablev.reloadData {

            }
//        }
//        if GlobalData.IsCheckChat != "True"
//        {
            
//            hideActivityIndicator()
//
//            print("value ", GlobalData.ClickedChatButtonValue)
//            self.fetchButtons(message: GlobalData.ClickedChatButtonValue)
//            tablev.reloadData()
//            self.tablev.reloadData()
//            if textuserchat?.count ?? 0 > 0
//            {
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1, execute: {
//                    let indexPath = IndexPath(row: self.textuserchat!.count-1, section: 0)
//                    self.tablev.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
//                })
//            }
//            tablev.delegate  = self
//            tablev.dataSource = self
          
//        }
    
    }
 
    
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                }
            }
            txtvBottomConstraints.constant = keyboardHeight + 8
            view.layoutIfNeeded()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        appload = "true"
        funSetting()
    }
    @objc private func tapGestureHandler() {
        view.endEditing(true)
    }
    @objc func btnClicked(_sender: UIButton) {
        
//        access collectionview
        appload = "false"
        print("value is ", GlobalData.IsCheckChat)
        let tag = _sender.tag
        print("button tag is", tag)
        GlobalData.IsCheckChat = "False"
        let chatdata = chatRecords
        if chatdata?.count ?? 0 > 0
        {
            let senderCollectionViewTag = _sender.imageView?.tag
            let tablevCell = tablev.cellForRow(at: IndexPath(row: senderCollectionViewTag!, section: 0)) as? MessageChatInCommingWithButtonsCell
            let dicTextData = textuserchat?[senderCollectionViewTag!] ?? NSDictionary()
            let buttons = dicTextData.value(forKey: "buttons") as? NSArray ?? NSArray()
            let buttonMessage = (buttons[_sender.tag] as! NSDictionary).value(forKey: "title") as? String ?? ""
            
//            print("btnmsg is ",buttonMessage)
            GlobalData.ClickedChatButtonValue = buttonMessage
//            print("btn is", GlobalData.ClickedChatButtonValue)
//            print(" On button click is CheckChat value is  ", GlobalData.IsCheckChat)
//            print("count is ", chatRecords?.count)
//            hideActivityIndicator()
          
//            print("value ", GlobalData.ClickedChatButtonValue)
           
            tablevCell?.colv.reloadData()
            
            self.fetchButtons(message: GlobalData.ClickedChatButtonValue)
            tablev.reloadData()
            self.tablev.reloadData()
            if textuserchat?.count ?? 0 > 0 {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1, execute: {
                    let indexPath = IndexPath(row: self.textuserchat!.count-1, section: 0)
                    self.tablev.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
                })
            }
            tablev.delegate  = self
            tablev.dataSource = self
//            funSetting()
//
        }
//else
//{
//    funSetting()
//}
        
        
    }
    func findurl(geturl : String)
        {
          let text = str2
          let types: NSTextCheckingResult.CheckingType = .link
          let detector = try? NSDataDetector(types: types.rawValue)

          guard let detect = detector else {
              return
          }

          let matches = detect.matches(in: text, options: .reportCompletion, range: NSMakeRange(0, text.count))
            print("my url is", matches)
          for match in matches {
            let range = match.range
            let str = (str2 as NSString).substring(with: range)
            print("str is ", str)
            GlobalData.GetLinkChat =  str
            let ranges = (str2 as NSString).range(of: str)
              print("my url is", match)
              print(match.url!)
          }
        }
    
    
    
}

extension MessagesChat: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(1.0))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(1.0))
        return CGSize(width: size, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("count is", chatRecords?.count)
        let dicTextData = textuserchat?[collectionView.tag] ?? NSDictionary()
        let buttons = dicTextData.value(forKey: "buttons") as? NSArray ?? NSArray()
        if chatRecords?.count ?? 0 > 0 {
            return buttons.count
        }
        else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageChatButtonsCell", for: indexPath) as! MessageChatButtonsCell
       
        let dicTextData = textuserchat?[collectionView.tag] ?? NSDictionary()
        let buttons = dicTextData.value(forKey: "buttons") as? NSArray ?? NSArray()
        if indexPath.row >= buttons.count {
        }
        else {
            cell.lblTitle.text = (buttons[indexPath.row] as! NSDictionary).value(forKey: "title") as? String ?? ""
        }
        cell.contentView.dropShadow1()
        cell.btntitle.tag = indexPath.row
        cell.btntitle.imageView?.tag = collectionView.tag
        print("tag is",cell.btntitle.tag)
        cell.btntitle.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
        //            let buttonMessage = chatRecords?[indexPath.row].payload ?? ""
        
        
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//start
//        let buttonMessage = chatRecords?[indexPath.row].payload ?? ""
//        fetchChatOnButton(message: buttonMessage)
//        tableview.reloadData()
//
//        print("your button is \(buttonMessage)")
//        let cell = colvButtons.dequeueReusableCell(withReuseIdentifier: "MessageChatButtonsCell", for: indexPath) as! MessageChatButtonsCell
//        cell.btntitle.backgroundColor = UIColor.gray
//        stop
    }
}

extension MessagesChat: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if textuserchat != nil {
            return textuserchat?.count ?? 0
        }
        return 0
    }
   

    // function to check if URL is taped
     
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
    

        if let url = URL(string: GlobalData.GetLinkChat) {
            print("successfully work done")
                UIApplication.shared.open(url)
            }
  
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        
        return UITableViewAutomaticDimension
    }
//    func a(_sender: UIButton)
//    {
//
//        let tagg = _sender.tag
////        let tag = _sender.tag
//        let cell = tablev.cellForRow(at:  tagg) as! MessagesChatOutGoingCell
//        guard let tablevCell = cell as? MessageChatInCommingWithButtonsCell else { return }
//
//        tablevCell.colv.reloadData()
//
//    }
   
    
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tablevCell = cell as? MessageChatInCommingWithButtonsCell else { return }
        tablevCell.colv.register(UINib(nibName: "MessageChatButtonsCell", bundle: nil), forCellWithReuseIdentifier: "MessageChatButtonsCell")
        
        tablevCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tablevCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        
        let indexPath = IndexPath(row: indexPath.row, section: 0)
//        let cell = tablevCell.colv.cellForItem(at: indexPath)
        tablevCell.colv.reloadData()
        
        
        
        
//        { [self] in
//            let tablevCell = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as? MessageChatInCommingWithButtonsCell
//            let height = tablevCell?.colv.collectionViewLayout.collectionViewContentSize.height
//            tablevCell?.colvHeight.constant = height!
////            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
////            self.tablev.layoutIfNeeded()
//
//            DispatchQueue.main.async {
//                tablevCell?.contentView.layoutIfNeeded()
//                self.tablev.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: UITableViewRowAnimation.none)
//
//
           
//
//        }
    }

//    collectionview ni aya
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MessagesChatOutGoingCell.self)) as! MessagesChatOutGoingCell
      
        if arrIsMyMessage?[indexPath.row] == "1" {
           
            print("textdata is", textdata)
            print("textuserchat is", textuserchat?[indexPath.row])
            cell.lblMessage.numberOfLines = 0
            cell.img.image = UIImage(named: "icons8-male-user-100-3")
//            irum
            if cell.lblMessage.text == "/greet"
            {
//                cell.bgvBubbleColor.backgroundColor = UIColor.clear
//                                   cell.lblMessage.text = ""
//                                   cell.lblMessage.text = ""
//                                   cell.img.isHidden = true
            }

//
////
                else
                {
                    cell.lblMessage.text = self.textuserchat?[indexPath.row].value(forKey: "text") as! String
                    if cell.lblMessage.text == "/greet"
                    {
                        cell.bgvBubbleColor.backgroundColor = UIColor.clear
                                           cell.lblMessage.text = ""
                                           cell.lblMessage.text = ""
                                           cell.img.isHidden = true
                    }
                            print("datatext is ", cell.lblMessage.text)
                }
        
//    }
            return cell
        }
        else {
           let dicTextData = textuserchat?[indexPath.row] as! NSDictionary
            let buttons = dicTextData.value(forKey: "buttons") as! NSArray
            
            var title =  "Laon Terms and Conditions"

            if buttons.count > 0 {
                
               
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MessageChatInCommingWithButtonsCell.self)) as! MessageChatInCommingWithButtonsCell
                if ( title  == "Laon Terms and Conditions")
            {
                print("success Laon Terms and Conditions")
                cell.lblMessage.text = TermsAndCondition
            }
                if buttons.count > 3
                {
                    cell.colv.backgroundColor = UIColor.white
                }
                cell.colv.tag = indexPath.row
                cell.lblMessage.text = textuserchat?[indexPath.row].value(forKey: "text") as? String ?? ""
//                dicTextData.value(forKey: "text") as! String
                findurl(geturl: str2)
                if str2.contains(GlobalData.GetLinkChat)
                {
                                           cell.lblMessage.isUserInteractionEnabled = true
                                               let ranges = (str2 as NSString).range(of: GlobalData.GetLinkChat)
                                               let mutableAttributedString = NSMutableAttributedString.init(string: str2)
                                               mutableAttributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.blue, range: ranges)
                                               cell.lblMessage.attributedText = mutableAttributedString
                       
                                        
                                           cell.lblMessage.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
                               }
               
                               else
                               {
                                
                                   cell.colv.backgroundColor = UIColor.clear
                                   cell.lblMessage.isUserInteractionEnabled = false
                               }
                return cell
            }
            else {
//                no buttons data
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MessagesChatInCommingCell.self)) as! MessagesChatInCommingCell
                findurl(geturl: str2)
                if str2.contains(GlobalData.GetLinkChat)
                {
                                           cell.lblMessage.isUserInteractionEnabled = true
                                               let ranges = (str2 as NSString).range(of: GlobalData.GetLinkChat)
                                               let mutableAttributedString = NSMutableAttributedString.init(string: str2)
                                               mutableAttributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.blue, range: ranges)
                                               cell.lblMessage.attributedText = mutableAttributedString
                                              cell.lblMessage.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
                               }
               
//                cell.lblMessage.text = ""
//                cell.bgvBubbleColor.backgroundColor = UIColor.clear
//                cell.img2.isHidden = true
                if cell.lblMessage.text == "/greet"
                {
                    cell.lblMessage.text = ""
                                cell.bgvBubbleColor.backgroundColor = UIColor.clear
                                cell.img2.isHidden = true
                }
                else{
                    cell.lblMessage.text = textuserchat?[indexPath.row].value(forKey: "text") as! String
                }
               
//                dicTextData.value(forKey: "text") as! String
                return cell
            }
        }
    }
    
   
    func fetchButtons(message: String) {
        
        let compelteUrl = GlobalConstants.BASE_URL + "liveChat"
        var userCnic : String?
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        showActivityIndicator()
        self.tableview.reloadData()
//        tablev.scrollsToTop
        
        self.tablev.reloadData()
        let parameters2 = ["imei":"\(DataManager.instance.imei!)","cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)", "message": message]
        print(parameters2)
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters2)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        print(params)
        print(compelteUrl)
        APIs.postAPI(url: compelteUrl, parameters: params, headers: nil, completion: { [self]
            response, success, errorMsg  in
            self.hideActivityIndicator()
           
            self.tableview.delegate = self
            self.tableview.dataSource = self
            self.tableview.reloadData()
//            tableview.scrollToBottom()
//
            self.tablev.delegate = self
            self.tablev.dataSource = self
            self.tablev.reloadData()
            
            if success {
                let data = Data((response?.rawString()?.utf8)!)
                do {
                    // make sure this JSON is in the format we expect
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // try to read out a string array
                        if json["responsecode"] as! Int == 1 {
                            tablev.reloadData()
     
                            let jsonDictionary = kfunGetDicFromJSONString(jsonString: response!.rawString()!)
                            print(jsonDictionary)
                            let dataString = jsonDictionary["data"] as! String // kfunGetDicFromJSONString(jsonString: (jsonDictionary as! [String:AnyObject])["data"] as! String)
                            
                            let stringData = Data((dataString.utf8))
                            do {
                                if let jsonArray = try JSONSerialization.jsonObject(with: stringData, options : .allowFragments) as? [Dictionary<String,Any>]
                                {
                                    if jsonArray.count > 0 {
                                        print("json array count ", jsonArray.count)
                                        print(jsonArray)
                                        if jsonArray.count == 4
                                        {
                                            
                                            let recipietID = (jsonArray[0] as NSDictionary).value(forKey: "recipient_id")
                                            
                                            var textDic = (jsonArray[0] as NSDictionary).value(forKey: "text")
                                            let text3 = (jsonArray[1] as NSDictionary).value(forKey: "text")
//                                            print("text3", text3)
                                            let text2 = (jsonArray[2] as NSDictionary).value(forKey: "text")
//                                            print("text2", text2)
                                            let text4 = (jsonArray[3] as NSDictionary).value(forKey: "text")
//                                            print("text4", text4)
//                                            var buttons = (jsonArray[0] as NSDictionary).value(forKey: "buttons")
                                            ConcateTextDic = " \(textDic!)\(text2!) \(text3!) \(text4!)"
                                            if ConcateTextDic.contains("\n`\n`\n")
                                            {
                                                let LoanTerm =   ConcateTextDic
                                                TermsAndCondition = LoanTerm.replacingOccurrences(of: "\n`\n`\n", with: "", options: NSString.CompareOptions.literal, range: nil)
                                                print("TermsAndCondition", TermsAndCondition)
//                                                textDic = TermsAndCondition
                                            }
                                            print("Concate string is ", ConcateTextDic)
                                            GlobalData.ChatTextButtonClick = textDic as! String
                                            print("chat text is",  GlobalData.ChatTextButtonClick)
                                        }
                                        // use the json here
                                        let recipietID = (jsonArray[0] as NSDictionary).value(forKey: "recipient_id")
//                                        if get indexpath
                                        
                                        var textDic = (jsonArray[0] as NSDictionary).value(forKey: "text")
//                                        let buttons = (jsonArray[0] as NSDictionary).value(forKey: "buttons")
                                        let buttonsData = (jsonArray[0] as NSDictionary).value(forKey: "buttons") as? NSArray
                                        
                                        
                                        GlobalData.ChatTextButtonClick = textDic as! String
                                        print("chat text is",  GlobalData.ChatTextButtonClick)
                                        if self.textuserchat == nil {
                                            self.textuserchat = [NSDictionary]()
//                                            print("text data ", textuserchat)
                                        }
//                                        print("json data is ", self.textdata)
                                        if ((textDic as AnyObject).contains("\n`\n`\n") != nil) // check
                                        {
                                
                                            let str = textDic as! String
                                            str2 = str.replacingOccurrences(of: "\n`\n`\n", with: "", options: NSString.CompareOptions.literal, range: nil)
                                            print(str2)
                                            textDic = str2
                                            
                                            print("json data  after remove is ", textDic
                                            )
                                            
                                        }
                                        else {
                                            
                                        }
                                    
                                        if self.arrIsMyMessage == nil {
                                            self.arrIsMyMessage = [String]()
                                        }
//                                        self.txtvMessageText.text = nil
                                        var tempDic = NSDictionary()
                                        if self.textuserchat?.count ?? 0 > 0 {
                                            let tempDic2 = ["text": message, "buttons": nil] as NSDictionary
                                            textuserchat?.append(tempDic2)
                                            self.arrIsMyMessage?.append("1")
                                        }
                                        
                                        if buttonsData != nil {
                                            tempDic = ["text": textDic as Any, "buttons": buttonsData!]
                                        }
                                        else {
                                            tempDic = ["text": textDic as Any, "buttons": NSArray()]
                                        }
                                        self.arrIsMyMessage?.append("0")
                                        self.textuserchat?.append(tempDic)
                                        
                                        self.tablev.reloadData {
                                            let indexPath = IndexPath(row: self.textuserchat!.count-1, section: 0)
                                            self.tablev.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
                                        }
                                        // self.textdata  = textDic as! String
                                        
//                                        print("recipietID: \(recipietID)" )
//                                        print("textDic: \(textDic)")
//                                        print("buttonsData: \(buttonsData)")
                                        
                                        if buttonsData?.count ?? 0 > 0 {
                                            self.tablev.reloadData()
//                                            tableview.scrollToBottom()
                                            for button in buttonsData! {
                                                let tempPayload = (button as! NSDictionary).value(forKey: "payload") as? String ?? ""
                                                let tempTitle = (button as! NSDictionary).value(forKey: "title") as? String ?? ""
                                             
                                                let tempButton = ChatModelButtons(payload: tempPayload, title: tempTitle)
                                                tempChatRecords.append(tempButton)
                                                
                                            }
                                            
                                            if tempChatRecords.count > 0 {
                                                self.chatRecords?.append(tempChatRecords)
                                                self.tableview.reloadData()
                                                self.tablev.reloadData()
                                            }
                                            else {
                                                self.chatRecords?.append(tempChatRecords)
                                            }
                                        }
                                        else {
                                            self.chatRecords?.append(tempChatRecords)
                                        }
                                    }
                                     
                                } else {
                                    print("bad json")
                                }
                            } catch let error as NSError {
                                print(error)
                            }
                        }
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
                
            }
            else {
                print("no buttons data")
                
            }
        })
    }
    
//    func fetchChatOnButton(message: String) {
//
//        let compelteUrl = GlobalConstants.BASE_URL + "liveChat"
//        var userCnic : String?
//
//        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
//            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
//        }
//        else{
//            userCnic = ""
//        }
//
//        showActivityIndicator()
//
//        let parameters2 = ["imei":"\(DataManager.instance.imei!)","cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)", "message": message]
//        print(parameters2)
//        let result = (splitString(stringToSplit: base64EncodedString(params: parameters2)))
//
//        print(result.apiAttribute1)
//        print(result.apiAttribute2)
//
//        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
//        print(params)
//        print(compelteUrl)
//        APIs.postAPI(url: compelteUrl, parameters: params, headers: nil, completion: { [self]
//
//            response, success, errorMsg  in
//            self.hideActivityIndicator()
//            self.tableview.reloadData()
////            self.tableview.scrollToBottom()
//            if success {
//                let data = Data((response?.rawString()?.utf8)!)
//                do {
//                    // make sure this JSON is in the format we expect
//                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                        // try to read out a string array
//                        if json["responsecode"] as! Int == 1 {
//                            let jsonDictionary = kfunGetDicFromJSONString(jsonString: response!.rawString()!)
//                            print(jsonDictionary)
//                            let dataString = jsonDictionary["data"] as! String // kfunGetDicFromJSONString(jsonString: (jsonDictionary as! [String:AnyObject])["data"] as! String)
//
//                            let stringData = Data((dataString.utf8))
//                            do {
//                                if let jsonArray = try JSONSerialization.jsonObject(with: stringData, options : .allowFragments) as? [Dictionary<String,Any>]
//                                {
//                                    print(jsonArray) // use the json here
//                                    let recipietID = (jsonArray[0] as NSDictionary).value(forKey: "recipient_id")
//
//                                    let textDic = (jsonArray[0] as NSDictionary).value(forKey: "text")
//                                    self.textdata  = textDic as? String ?? ""
//
//                                    print("json data is ", self.textdata!)
//
//                                    if ((textDic as AnyObject).contains("\n`\n`\n") != nil) {
//                                        var str = textDic as! String
//                                        var str2 = str.replacingOccurrences(of: "\n`\n`\n", with: "", options: NSString.CompareOptions.literal, range: nil)
//                                        print(str2)
//
//                                        print("json data  after remove is ", self.textuserchat)
//                                    }
//
//                                    self.tablev.reloadData()
////                                    self.colvButtons.reloadData()
////                                    self.tableview.scrollToBottom()
//                                    return()
//                                }
//                                else {
//                                    print("bad json")
//                                }
//                            } catch let error as NSError {
//                                print(error)
//                            }
//                        }
//                    }
//                } catch let error as NSError {
//                    print("Failed to load: \(error.localizedDescription)")
//                }
//
//            }
//            else {
//
//            }
//        })
////        colvButtons.reloadData()
//    }
    
    
}

extension MessagesChat: GrowingTextViewDelegate {
    // *** Call layoutIfNeeded on superview for animation when changing height ***
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(red: 149/255.0, green: 154/255.0, blue: 150/255.0, alpha: 1.0){
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type a message"
            textView.textColor =  UIColor(red: 149/255.0, green: 154/255.0, blue: 150/255.0, alpha: 1.0)
        }
    }
}

extension UITableViewCell {
    static func nibName() -> String {
        return String(describing: self.self)
    }
    static func register(tableView: UITableView)  {
        let nibName = String(describing: self.self)
        tableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
    
    
}
extension UICollectionViewCell
{
    static func nibName() -> String {
    return String(describing: self.self)
}
    static func register(CollectionView :UICollectionView)
    {
        let nibName = String(describing: self.self)
        CollectionView.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
    }
    
}

extension MessagesChat {
    
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
}

func kfunGetDicFromJSONString(jsonString: String) -> [String: AnyObject] {
    var jsonData = [String:AnyObject]()
    do{
        if let json = jsonString.data(using: .utf8){
            if let tempJsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject]{
                print(tempJsonData)
                jsonData = tempJsonData
            }
        }
    }catch {
        print(error.localizedDescription)
        
    }
    return jsonData
}

extension UITableView {

    func isLast(for indexPath: IndexPath) -> Bool {

        let indexOfLastSection = numberOfSections > 0 ? numberOfSections - 1 : 0
        let indexOfLastRowInLastSection = numberOfRows(inSection: indexOfLastSection) - 1

        return indexPath.section == indexOfLastSection && indexPath.row == indexOfLastRowInLastSection
    }
}
extension UITableView {
    func scrollTableViewToBottom(animated: Bool) {
        guard let dataSource = dataSource else { return }

        var lastSectionWithAtLeasOneElements = (dataSource.numberOfSections?(in: self) ?? 1) - 1

        while dataSource.tableView(self, numberOfRowsInSection: lastSectionWithAtLeasOneElements) < 1 {
            lastSectionWithAtLeasOneElements -= 1
        }

        let lastRow = dataSource.tableView(self, numberOfRowsInSection: lastSectionWithAtLeasOneElements) - 1

        guard lastSectionWithAtLeasOneElements > -1 && lastRow > -1 else { return }

        let bottomIndex = IndexPath(item: lastRow, section: lastSectionWithAtLeasOneElements)
        scrollToRow(at: bottomIndex, at: .bottom, animated: animated)
    }
}

extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)

        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}
class DataDetector {

    private class func _find(all type: NSTextCheckingResult.CheckingType,
                             in string: String, iterationClosure: (String) -> Bool) {
        guard let detector = try? NSDataDetector(types: type.rawValue) else { return }
        let range = NSRange(string.startIndex ..< string.endIndex, in: string)
        let matches = detector.matches(in: string, options: [], range: range)
        loop: for match in matches {
            for i in 0 ..< match.numberOfRanges {
                let nsrange = match.range(at: i)
                let startIndex = string.index(string.startIndex, offsetBy: nsrange.lowerBound)
                let endIndex = string.index(string.startIndex, offsetBy: nsrange.upperBound)
                let range = startIndex..<endIndex
                guard iterationClosure(String(string[range])) else { break loop }
            }
        }
    }

    class func find(all type: NSTextCheckingResult.CheckingType, in string: String) -> [String] {
        var results = [String]()
        _find(all: type, in: string) {
            results.append($0)
            return true
        }
        return results
    }

    class func first(type: NSTextCheckingResult.CheckingType, in string: String) -> String? {
        var result: String?
        _find(all: type, in: string) {
            result = $0
            return false
        }
        return result
    }
}

// MARK: String extension

extension String {
    var detectedLinks: [String] { DataDetector.find(all: .link, in: self) }
    var detectedFirstLink: String? { DataDetector.first(type: .link, in: self) }
    var detectedURLs: [URL] { detectedLinks.compactMap { URL(string: $0) } }
    var detectedFirstURL: URL? {
        guard let urlString = detectedFirstLink else { return nil }
        return URL(string: urlString)
    }
}
extension String{
//    func isValidUrl() -> Bool {
//        let regex = "(http|https|ftp)://)+"
//        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
//        return predicate.evaluate(with: self)
//    }
    func isValidUrl(url: String) -> Bool {
        let urlRegEx = "^(http|https|ftp)\\://([a-zA-Z0-9\\.\\-]+(\\:[a-zA-Z0-9\\.&amp;%\\$\\-]+)*@)*((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|localhost|([a-zA-Z0-9\\-]+\\.)*[a-zA-Z0-9\\-]+\\.(com|edu|gov|int|mil|net|org|biz|arpa|info|name|pro|aero|coop|museum|[a-zA-Z]{2}))(\\:[0-9]+)*(/($|[a-zA-Z0-9\\.\\,\\?\\'\\\\\\+&amp;%\\$#\\=~_\\-]+))*$"
            print("urlRegEx is", urlRegEx)
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: url)
        return result
    }
}


extension UICollectionViewCell {

    static func register(for collectionView: UICollectionView)  {
        let cellName = String(describing: self)
        let cellIdentifier = cellName + "MessageChatButtonsCell"
        let cellNib = UINib(nibName: String(describing: self), bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellIdentifier)
    }
}
