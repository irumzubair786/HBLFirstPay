//
//  DisputeTransactionsListVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 05/05/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class DisputeTransactionsListVC: BaseClassVC , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet var disputeListTableView: UITableView!
    @IBOutlet  var fromDateTextField: UITextField!
    @IBOutlet  var toDateTextField: UITextField!
    var myDisputeObj:MiniStatementModel?
    
    var dateFrom = NSDate()
    var dateTo = NSDate()
    var isFrom:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblmain.text = "Dispute List".addLocalizableString(languageCode: languageCode)
        btnshow.setTitle("SHOW".addLocalizableString(languageCode: languageCode), for: .normal)
        
        
    }
    
    //MARK: - Utility Methods
    
    @IBOutlet weak var btnshow: UIButton!
    @IBOutlet weak var lblmain: UILabel!
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd" // MMM d, yyyy
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
        let newDate = dateFormatter.string(from: datePickerObj.date)
        self.fromDateTextField.text = newDate
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
        
        let datePickerObj: UIDatePicker = UIDatePicker()
        datePickerObj.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerObj
        isFrom = "dateTo"
        
        datePickerObj.maximumDate = datePickerObj.date
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
        
        self.getDisputeData()
        
    }
    
    // MARK: - Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = self.myDisputeObj?.ministatement?.count{
            return count
        }
        return 0
        
        //return (self.notificationsObj?.notifications?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "MiniStatementTableViewCell") as! MiniStatementTableViewCell
        aCell.selectionStyle = .none
        
        //            let aStatement = miniStatementObj?.ministatement[indexpath]
        //            if let lastTrans = aStatement.lcy_amount{
        //            }
        
        let aStatement = self.myDisputeObj?.ministatement![indexPath.row]
        
        
        aCell.lblTitle.text = aStatement?.transDocsDescr
        aCell.lblDate.text = aStatement?.transDate
        
        if aStatement?.amountType == "C"{
            aCell.lblType.text = "Credit"
            aCell.lblAmount.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            if let fromAccountNo = aStatement?.fromAccountNo{
                aCell.lblFromAccountNo.text = fromAccountNo
            }
            else{
                aCell.lblFromAccountNo.text = "."
            }
            if let fromAccountTitle = aStatement?.fromAccountTitle{
                aCell.lblFromAccountTitle.text = fromAccountTitle
            }
        }
        else if aStatement?.amountType == "D" {
            aCell.lblType.text = "Debit"
            aCell.lblAmount.textColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            if let toAccountNo = aStatement?.toAccountNo{
                aCell.lblFromAccountNo.text = toAccountNo
            }
            else{
                aCell.lblFromAccountNo.text = "."
            }
            if let toAccountTitle = aStatement?.toAccountTitle{
                aCell.lblFromAccountTitle.text = toAccountTitle
            }
        }
        
        if let amount = aStatement?.txnAmt{
            aCell.lblAmount.text = "PKR \(amount)"
        }
        
        return aCell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NSLog ("You selected row: %@ \(indexPath)")
        
        let aStatement = self.myDisputeObj?.ministatement![indexPath.row]
        
        
        let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "MiniStatementDetailsVC") as! MiniStatementDetailsVC
        detailsVC.strAmount = "PKR. \(aStatement?.txnAmt ?? 0)"
        
        if aStatement?.amountType == "C"{
            detailsVC.strCreditDebit = "CREDIT"
        }
        else if aStatement?.amountType == "D" {
            detailsVC.strCreditDebit = "DEBIT"
        }
        
        detailsVC.strReceiverWallet = ("\(aStatement?.toAccountNo ?? "") \n\(aStatement?.toAccountTitle ?? "")")
        detailsVC.strSourceWallet = ("\(aStatement?.fromAccountNo ?? "") \n\(aStatement?.fromAccountTitle ?? "")")
        detailsVC.strDateTime = aStatement?.transDate
        detailsVC.strTransactionType = aStatement?.transDocsDescr
        detailsVC.strPurpose = aStatement?.transRefnum
        
        
        detailsVC.modalPresentationStyle = .overCurrentContext;
        self.rootVC?.present(detailsVC, animated: true, completion: nil)
    }
    
    
    // MARK: - Get Mini Statement
    
    public func getDisputeData() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "getDisputeData"
        
        let parameters = ["channelId":"\(DataManager.instance.channelID)","fromDate":convertDateFormater(fromDateTextField.text!)  + " 00:00:01" ,"toDate":convertDateFormater(toDateTextField.text!)  + " 23:59:59"]
    
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
            
            self.myDisputeObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.myDisputeObj?.responsecode == 2 || self.myDisputeObj?.responsecode == 1 {
                    
                    self.disputeListTableView.reloadData()
                }
                else {
                    if let message = self.myDisputeObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.myDisputeObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    
    
}
