//
//  MiniStatementVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 16/11/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class MiniStatementVC: BaseClassVC , UITableViewDelegate , UITableViewDataSource {
   
    @IBOutlet var miniStatementTableView: UITableView!
    @IBOutlet weak var lblBalance: UILabel!
    var balanceAmount:String?
    @IBOutlet  var fromDateTextField: UITextField!
    @IBOutlet  var toDateTextField: UITextField!
    var myStatementObj:MiniStatementModel?
    var geturl : URL!
    var dateFrom = NSDate()
    var dateTo = NSDate()
    var isFrom:String?
    var transRefNum : String?
    var fromNewDateVar : Date?
    var withoutholdingtax : Int?
    static let networkManager = NetworkManager()
    
    @IBOutlet weak var btnshow: UIButton!
    
   
    
    
    @IBOutlet weak var lblamin: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblamin.text = "Statement".addLocalizableString(languageCode: languageCode)
        btnshow.setTitle("SHOW".addLocalizableString(languageCode: languageCode), for: .normal)
//        self.updateUI()
//        self.getMiniStatement(completionHandler: {(result:MiniStatementModel) in
//            self.miniStatementTableView.reloadData()
//        })
        self.getMiniStatementwithoutDates()
    //    self.miniStatementTableView.addSubview(self.refreshControl)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("disputeButtonPressed"), object: nil)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        
         let disputeVC = self.storyboard!.instantiateViewController(withIdentifier: "DisputeTransactionVC") as! DisputeTransactionVC
        disputeVC.transRefnum = self.transRefNum
        self.navigationController!.pushViewController(disputeVC, animated: true)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
        // Dispose of any resources that can be recreated.
    }
  
    private func updateUI(){
        if let balance = balanceAmount{
            self.lblBalance.text = "PKR \(convertToCurrrencyFormat(amount:balance))"
        }
    }
    
    
    
    //MARK: - Utility Methods
    
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
   //     dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // MMM d, yyyy
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.string(from: date!)
        
    }
    
    //MARK: - DatePicker Methods
    
    @IBAction func textFieldFromEditing(sender: UITextField) {
        
        let datePickerObj: UIDatePicker = UIDatePicker()
        datePickerObj.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerObj
        isFrom = "dateFrom"
        datePickerObj.maximumDate = datePickerObj.date
        datePickerObj.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fromNewDate = dateFormatter.string(from: datePickerObj.date)
        self.fromNewDateVar = datePickerObj.date
        self.fromDateTextField.text = fromNewDate
        if #available(ios 13.4, *)
        {
            if #available(iOS 13.4, *) {
                datePickerObj.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
        }
        self.toDateTextField.isUserInteractionEnabled = true
        
    }
    @IBAction func textFieldToEditing(sender: UITextField) {
        
    //    let currentDate = Date()
        let currentDate = self.fromNewDateVar
        var dateComponents = DateComponents()
        dateComponents.month = +1
        let oneMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate!)
        
        let datePickerObj: UIDatePicker = UIDatePicker()
        datePickerObj.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerObj
        isFrom = "dateTo"
        
//        datePickerObj.minimumDate = oneMonthAgo
//        datePickerObj.maximumDate = currentDate
        
        datePickerObj.minimumDate = currentDate
        datePickerObj.maximumDate = oneMonthAgo
        
        datePickerObj.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDate = dateFormatter.string(from: datePickerObj.date)
        self.toDateTextField.text = newDate
        if #available(ios 13.4, *)
        {
            if #available(iOS 13.4, *) {
                datePickerObj.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
        }
            }
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if isFrom == "dateFrom"{
            fromDateTextField.text = dateFormatter.string(from: sender.date)
            dateFrom =  sender.date as NSDate
            self.fromNewDateVar = sender.date
        }
        else if isFrom == "dateTo"{
            toDateTextField.text = dateFormatter.string(from: sender.date)
            dateTo = sender.date as NSDate
        }
    }
    
      
     // MARK: - Action Methods
      
      @IBAction func showButtonPressed(_ sender: UIButton) {
       
       if self.fromDateTextField .text?.count == 0 {
        
           self.showToast(title: "Please select From Date")
           return
       }
       if self.toDateTextField.text?.count == 0 {
           self.showToast(title: "Please select To Date")
           return
       }
          
       self.getMiniStatement()
       
      }
      
      @IBAction func cancelButtonPressed(_ sender: UIButton) {
       self.navigationController!.popViewController(animated: true)
      }
    
    // MARK: -  Pull to Refresh
//
//    lazy var refreshControl: UIRefreshControl = {
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(handleRefresh),for: UIControlEvents.valueChanged)
//        refreshControl.tintColor = UIColor.gray
//        return refreshControl
//    }()
//
//    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
//
//        self.getMiniStatement()
////        self.getMiniStatement(completionHandler: {(result:MiniStatementModel) in
////            self.miniStatementTableView.reloadData()
////        })
//        refreshControl.endRefreshing()
//    }
    
    // MARK: - Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = self.myStatementObj?.ministatement?.count{
            return count
        }
        return 0
        
        //return (self.notificationsObj?.notifications?.count)!
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.3, animations: {
                cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
                },completion: { finished in
                    UIView.animate(withDuration: 0.1, animations: {
                        cell.layer.transform = CATransform3DMakeScale(1,1,1)
                    })
            })
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "MiniStatementTableViewCell") as! MiniStatementTableViewCell
       
        aCell.backview.dropShadow1()
        aCell.selectionStyle = .none
        
        //            let aStatement = miniStatementObj?.ministatement[indexpath]
        //            if let lastTrans = aStatement.lcy_amount{
        //            }
        
        let aStatement = self.myStatementObj?.ministatement![indexPath.row]
                aCell.lblTitle.text = aStatement?.transDocsDescr
        aCell.lblDate.text = aStatement?.transDate
        
        if aStatement?.amountType == "C"{
            aCell.lblType.text = "Credit"
            aCell.lblAmount.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            aCell.imgCreditDebit.image = #imageLiteral(resourceName: "arrow_credit")
            if let fromAccountNo = aStatement?.fromAccountNo {
            
//                aCell.lblFromAccountNo.text = fromAccountNo
                
                if aStatement?.feeAmt == nil && aStatement?.fedAmt == nil{
                    
//                    aCell.lblfedamount.text = "\("FED: 0 | FEE: 0")"
                    aCell.lblfedamount.text = fromAccountNo
                }
                else
                {
//                    aCell.lblFromAccountNo.text = aStatement?.toAccountNo
                    print( aCell.lblFromAccountNo.text ?? 0)
//                    aCell.lblfedamount.text = ("FED: \(aStatement?.fedAmt! ?? 0)| FEE: \(aStatement?.fedAmt! ?? 0)")
                    aCell.lblfedamount.text = fromAccountNo
                    print(aCell.lblfedamount.text as Any)
                }
               
            }
            else{
                aCell.lblFromAccountNo.text = ""
            }
            if let fromAccountTitle = aStatement?.fromAccountTitle{
                aCell.lblFromAccountTitle.text = fromAccountTitle
            }
        }
        else if aStatement?.amountType == "D" {
            aCell.lblType.text = "Debit"
            aCell.lblAmount.textColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            aCell.imgCreditDebit.image = #imageLiteral(resourceName: "arrow_debits")
            if (aStatement?.toAccountNo) != nil{
                
               
                aCell.lblFromAccountNo.text = aStatement?.toAccountNo!
                print(aCell.lblFromAccountNo.text)
            }
            else
            {
                aCell.lblFromAccountNo.text = ""
            }
            
            if aStatement?.feeAmt == nil && aStatement?.fedAmt == nil{
                aCell.lblfedamount.text = "\("FED: 0 | FEE: 0")"
                
            }
        
            else{
                aCell.lblfedamount.text = ("FED:\(aStatement?.fedAmt ?? 0) | FEE: \(aStatement?.fedAmt ?? 0)")
            }
            
            
            if let toAccountTitle = aStatement?.toAccountTitle{
                aCell.lblFromAccountTitle.text = toAccountTitle
            }
        }
       
        if let amount = aStatement?.txnAmt{
            aCell.lblAmount.text = "\(amount)"
        }
        if aStatement?.txnAmt == nil{
            aCell.lblAmount.text = "0"
        }
       
        
        return aCell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NSLog ("You selected row: %@ \(indexPath)")
        
        let aStatement = self.myStatementObj?.ministatement![indexPath.row]
        
        let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "MiniStatementDetailsVC") as! MiniStatementDetailsVC
        detailsVC.strAmount = "PKR. \(aStatement?.txnAmt ?? 0)"
        
        if aStatement?.amountType == "C"{
            detailsVC.strCreditDebit = "CREDIT"
        }
        else if aStatement?.amountType == "D" {
            detailsVC.strCreditDebit = "DEBIT"
        }
        
        detailsVC.strReceiverWallet = ("\(aStatement?.toAccountTitle ?? "") \n\(aStatement?.toAccountNo ?? "")")
        detailsVC.strSourceWallet = ("\(aStatement?.fromAccountTitle ?? "") \n\(aStatement?.fromAccountNo ?? "")")
        detailsVC.strDateTime = aStatement?.transDate
        detailsVC.strTransactionType = aStatement?.transDocsDescr
        detailsVC.strPurpose = aStatement?.transRefnum
        detailsVC.strSourceBank = aStatement?.sourceBank
        detailsVC.strDestinationBank = aStatement?.destinationBank
        detailsVC.strChannel = aStatement?.channel
        detailsVC.strOpenningBalance = "\(aStatement?.openingbalance ?? 00)"
        detailsVC.strClosingBalance = "\(aStatement?.closingBalance ?? 00)"
        detailsVC.status = aStatement?.status
        
        self.transRefNum = aStatement?.transRefnum
        if  withoutholdingtax != nil{
            detailsVC.whtAmt = aStatement?.whtAmt
            
        }
        else
        {
            detailsVC.whtAmt = Int(0.0)
            
        }
        detailsVC.modalPresentationStyle = .overCurrentContext;
        self.rootVC?.present(detailsVC, animated: true, completion: nil)
    }
    

  // MARK: - API Call
    
    public func getMiniStatementwithoutDates() {
            
            if !NetworkConnectivity.isConnectedToInternet(){
                self.showToast(title: "No Internet Available")
                return
            }
        
            showActivityIndicator()
        
            let compelteUrl = GlobalConstants.BASE_URL + "miniStatement"
            
       //     let parameters = ["channelId":"\(DataManager.instance.channelID)","acountId":"\(DataManager.instance.accountId!)"]
           let parameters = ["channelId":"\(DataManager.instance.channelID)","fromDate":"","toDate":""]
            
            print(parameters)
            
            let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
            
            print(result.apiAttribute1)
            print(result.apiAttribute2)
            
            let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
            
            let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
            
            print(params)
            print(compelteUrl)
            print(header)
            
            
            NetworkManager.sharedInstance.enableCertificatePinning()
            
            
            NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<MiniStatementModel>) in
                            
                self.hideActivityIndicator()
                
                self.myStatementObj = response.result.value
                
                if response.response?.statusCode == 200 {
                    if self.myStatementObj?.responsecode == 2 || self.myStatementObj?.responsecode == 1 {
                        self.miniStatementTableView.reloadData()
                    }
                    else {
                        if let message = self.myStatementObj?.messages{
                            self.showDefaultAlert(title: "", message: message)
                        }
                    }
                }
                else {
                    if let message = self.myStatementObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
//                    print(response.result.value)
//                    print(response.response?.statusCode)
                }
            }
        }
    
   
    
    public func getMiniStatement() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "miniStatement"
        
         let parameters = ["channelId":"\(DataManager.instance.channelID)","fromDate":convertDateFormater(fromDateTextField.text!) + " 00:00:01","toDate":convertDateFormater(toDateTextField.text!) + " 23:59:59"]
        
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        print(header)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<MiniStatementModel>) in
                        
            self.hideActivityIndicator()
            
            self.myStatementObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.myStatementObj?.responsecode == 2 || self.myStatementObj?.responsecode == 1 {
//                    if self.miniStatementObj != nil {
//                        completionHandler(self.miniStatementObj!)
//                    }
                    self.miniStatementTableView.reloadData()
                }
                else {
                  
                    if let message = self.myStatementObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                    self.miniStatementTableView.reloadData()
                }
            }
            else {
                if let message = self.myStatementObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    

    
    }

