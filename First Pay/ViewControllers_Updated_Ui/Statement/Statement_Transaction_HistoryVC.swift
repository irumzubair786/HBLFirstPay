//
//  Statement_Transaction_HistoryVC.swift
//  First Pay
//
//  Created by Irum Butt on 06/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import PDFKit
class Statement_Transaction_HistoryVC: BaseClassVC , UITableViewDelegate , UITableViewDataSource , UITextFieldDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.myStatementObj?.ministatement?.count{
            return count
        }
        return 0
    }
    
    @IBOutlet weak var buttonFrom: UIButton!
    @IBAction func buttonFrom(_ sender: Any) {
        fromDateTextfield.becomeFirstResponder()
    }
    
    @IBOutlet weak var buttonTo: UIButton!
    @IBAction func buttonTo(_ sender: Any) {
        DispatchQueue.main.async {
            self.ToDateTextfiled.becomeFirstResponder()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "cellTransation_Statement_HistoryVc") as! cellTransation_Statement_HistoryVc
        aCell.img.image = #imageLiteral(resourceName: "Arrow Icon")
        aCell.selectionStyle = .none
        aCell.btn.setTitle("", for: .normal)
        let aStatement = self.myStatementObj?.ministatement![indexPath.row]
        //        getDataStatemnt = self.myStatementObj?.ministatement![indexPath.row]
        aCell.lblbankName.text = aStatement?.transDocsDescr
        aCell.lbldate.text = aStatement?.transDate
        
        aCell.lblAmount.text = " Rs.\(aStatement?.txnAmt! ?? 0)"
        if aStatement?.amountType == "C"{
            //            aCell.lblType.text = "Credit"
            aCell.lblAmount.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            aCell.img.image = #imageLiteral(resourceName: "Arrow Icon-1")
            aCell.lblbankName.text = aStatement?.sourceBank
            //            self.miniStatementObj?.ministatement?[0].sourceBank
            //
        }
        else if aStatement?.amountType == "D" {
            //            aCell.lblType.text = "Debit"
            aCell.lblAmount.textColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            aCell.img.image = #imageLiteral(resourceName: "Arrow Icon")
            aCell.lblbankName.text = aStatement?.sourceBank
            
            //
        }
        
        aCell.btnDetail.setTitle("", for: .normal)
        aCell.btnDetail.tag = indexPath.row
        
        aCell.btnDetail.addTarget(self, action: #selector(buttontaped), for: .touchUpInside)
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
        let aStatement = self.myStatementObj?.ministatement![indexPath.row]
        let detailsVC = self.storyboard!.instantiateViewController(withIdentifier: "Statement_History_Detail_VC") as! Statement_History_Detail_VC
        detailsVC.strAmount = "PKR. \(aStatement?.txnAmt ?? 0)"
        if aStatement?.amountType == "C"{
            detailsVC.strCreditDebit = ""
        }
        else if aStatement?.amountType == "D" {
            detailsVC.strCreditDebit = ""
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
        self.navigationController!.pushViewController(detailsVC, animated: false)
        self.tableView.reloadData()
    }
    @objc func buttontaped(_sender:UIButton)
    {
        let tag = _sender.tag
        //
        let cell = tableView.cellForRow(at: IndexPath(row: tag, section: 0)) as! cellTransation_Statement_HistoryVc
        let detailsVC = self.storyboard!.instantiateViewController(withIdentifier: "Statement_History_Detail_VC") as! Statement_History_Detail_VC
        let aStatement = self.myStatementObj?.ministatement![tag]
        detailsVC.strAmount = "PKR. \(aStatement?.txnAmt ?? 0)"
        
        if aStatement?.amountType == "C"{
            detailsVC.strCreditDebit = ""
        }
        else if aStatement?.amountType == "D" {
            detailsVC.strCreditDebit = ""
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
        self.navigationController!.pushViewController(detailsVC, animated: false)
    }
    let pdf = PDFDocument()
    let pageBounds = CGRect(x: 0, y: 0, width: 612, height: 792) // standard US Letter size
    
    var dateFrom = NSDate()
    var dateTo = NSDate()
    var isFrom:String?
    var myStatementObj:MiniStatementModel?
    var geturl : URL!
    var transRefNum : String?
    var fromNewDateVar : Date?
    var withoutholdingtax : Int?
    static let networkManager = NetworkManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        btnDownLoad.setTitle("", for: .normal)
        btnBack.setTitle("", for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("disputeButtonPressed"), object: nil)
        tableView.rowHeight = 109
        getMiniStatementwithoutDates()
        btnShow.setTitle("", for: .normal)
        //        ToDateTextfiled.isUserInteractionEnabled = false
        //        datePicker.date = NSDate() as Date
        //        datePicker.datePickerMode = .date
        //       fromDateTextfield.inputView = datePicker
        ToDateTextfiled.placeholder = "  DD/MM/YYYY"
        fromDateTextfield.placeholder = "  DD/MM/YYYY"
        
        
        toDate = ToDateTextfiled.setPickerDate()
        fromDate = fromDateTextfield.setPickerDate()
        
        toDate.addTarget(self, action: #selector(self.tappedOnDate), for: .valueChanged)
        fromDate.addTarget(self, action: #selector(self.tappedOnDate), for: .valueChanged)
        
    }
    
    @objc func tappedOnDate(sender: UIDatePicker) {
        print(sender)
        let stringDate = sender.date.dateString()
        
        if sender == toDate {
            ToDateTextfiled.text = stringDate
        }
        else if sender == fromDate {
            fromDateTextfield.text = stringDate
        }
    }
    
   
    @objc func methodOfReceivedNotification(notification: Notification) {
        
        let disputeVC = self.storyboard!.instantiateViewController(withIdentifier: "Statement_History_Detail_VC") as! Statement_History_Detail_VC
        //        disputeVC.transRefnum = self.transRefNum
        self.navigationController!.pushViewController(disputeVC, animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    let datePicker = UIDatePicker()
    
    
    
    
    @IBOutlet weak var btnShow: UIButton!
    @IBOutlet weak var ToDateTextfiled: UITextField!
    @IBOutlet weak var fromDateTextfield: UITextField!
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var btnDownLoad: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    
    var didload = UIDatePicker()
    var toDate = UIDatePicker()
    var fromDate = UIDatePicker()
    
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if isFrom == "dateFrom"{
            //         var getFromDate = dateFormatter.string(from: sender.date)
            //            getFromDate = getFromDate.substring(to: 10)
            fromDateTextfield.text = dateFormatter.string(from: sender.date)
            dateFrom =  sender.date as NSDate
            self.fromNewDateVar = sender.date
        }
        else if isFrom == "dateTo"{
            var  gettodatevalue =  dateFormatter.string(from: sender.date)
            gettodatevalue = gettodatevalue.substring(to: 10)
            //            ToDateTextfiled.text = dateFormatter.string(from: sender.date)
            dateTo = sender.date as NSDate
        }
        
    }
    //    @IBAction func buttonFromdate(_ sender: UITextField) {
    //        fromDateTextfield.becomeFirstResponder()
    //
    //
    //    }
    //
    
    
    @IBAction func todatePicker(_ sender: UIDatePicker) {
        let currentDate = self.fromNewDateVar
        print("sender", sender)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let selectedDate = dateFormatter.string(from: sender.date)
        print("Selected date: \(selectedDate)")
        ToDateTextfiled.text =  selectedDate
        ToDateTextfiled.textColor = UIColor.clear
    }
    @IBAction func fromdatePicker(_ sender: UIDatePicker) {
        print("sender", sender)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let selectedDate = dateFormatter.string(from: sender.date)
        print("Selected date: \(selectedDate)")
        fromDateTextfield.text =  selectedDate
        fromDateTextfield.textColor = UIColor.clear
    }
    @IBOutlet weak var buttonFromdate: UIButton!
    @IBAction func fromDate(_ sender: UITextField) {
        let datePickerObj: UIDatePicker = UIDatePicker()
        datePickerObj.datePickerMode = UIDatePickerMode.date
        fromDateTextfield.inputView = datePickerObj
        sender.inputView = UIDatePicker()
        isFrom = "dateFrom"
        datePickerObj.maximumDate = datePickerObj.date
        datePickerObj.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy/HH:mm"
        let fromNewDate = dateFormatter.string(from: datePickerObj.date)
        self.fromNewDateVar = datePickerObj.date
        //        self.fromDateTextfield.text = fromNewDate
        if #available(ios 13.4, *)
        {
            if #available(iOS 13.4, *) {
                datePickerObj.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
        }
        self.ToDateTextfiled.isUserInteractionEnabled = true
    }
    
    //    @objc func datePickerValueChanged(sender: UIDatePicker) {
    //
    //
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = "dd-MM-yyyy"
    //        if isFrom == "dateFrom"{
    ////         var getFromDate = dateFormatter.string(from: sender.date)
    ////            getFromDate = getFromDate.substring(to: 10)
    //            fromDateTextfield.text = dateFormatter.string(from: sender.date)
    //            dateFrom =  sender.date as NSDate
    //            self.fromNewDateVar = sender.date
    //        }
    //        else if isFrom == "dateTo"{
    //            var  gettodatevalue =  dateFormatter.string(from: sender.date)
    //            gettodatevalue = gettodatevalue.substring(to: 10)
    ////            ToDateTextfiled.text = dateFormatter.string(from: sender.date)
    //            dateTo = sender.date as NSDate
    //        }
    //    }
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MM-yyyy"
        
        if let date = inputFormatter.date(from: dateString) {
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
    
    
    @objc func toDate(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let currentDate = self.fromNewDateVar
        var dateComponents = DateComponents()
        dateComponents.month = +1
        let oneMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate!)
        
        let datePickerObj: UIDatePicker = UIDatePicker()
        datePickerObj.datePickerMode = UIDatePickerMode.date
        //        sender.inputView = datePickerObj
        isFrom = "dateTo"
        
        //        datePickerObj.minimumDate = oneMonthAgo
        //        datePickerObj.maximumDate = currentDate
        
        datePickerObj.minimumDate = currentDate
        datePickerObj.maximumDate = oneMonthAgo
        
        datePickerObj.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let newDate = dateFormatter.string(from: datePickerObj.date)
        self.ToDateTextfiled.text = newDate
        btnShow.isHidden = false
        if #available(ios 13.4, *)
        {
            if #available(iOS 13.4, *) {
                datePickerObj.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    
    
    
    
    @IBAction func toDate(_ sender: UITextField) {
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
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let newDate = dateFormatter.string(from: datePickerObj.date)
        self.ToDateTextfiled.text = newDate
        btnShow.isHidden = false
        if #available(ios 13.4, *)
        {
            if #available(iOS 13.4, *) {
                datePickerObj.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
        }
        
        
    }
    
    
    
    @IBAction func Show(_ sender: UIButton) {
        
        getMiniStatement()
        
    }
    
    
    
    
    
    @IBAction func back(_ sender: UIButton) {
        if isfromSideMenu == true
        {
            self.dismiss(animated: true)
        }
        else
        {
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
            self.present(vc, animated: true)
        }
        
        //        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Action_download(_ sender: UIButton) {
        screenshot()
    }
    // MARK: - API Call
    public func getMiniStatementwithoutDates() {
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/miniStatement"
        //     let parameters = ["channelId":"\(DataManager.instance.channelID)","acountId":"\(DataManager.instance.accountId!)"],
        var userCnic : String?
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["channelId":"\(DataManager.instance.channelID)","fromDate":"","toDate":"", "accountType": DataManager.instance.accountType!,"cnic":userCnic!, "imeiNo":DataManager.instance.imei!]
        print(parameters)
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
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
                    
                    GlobalData.transRefnum = (self.myStatementObj?.ministatement?[0].transRefnum)!
                    print("fetch transation refference Number",  GlobalData.transRefnum)
                    
                    
                    
                    
                    self.tableView.reloadData()
                }
                else {
                    if let message = self.myStatementObj?.messages{
                        self.showAlertCustomPopup(title: "",message: message, iconName: .iconError)
                    }
                }
            }
            else {
                if let message = self.myStatementObj?.messages{
                    self.showAlertCustomPopup(title: "",message: message, iconName: .iconError)
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
        
        let a = fromDateTextfield.text?.replacingOccurrences(of: "/", with: "-")
        let stringFrom = self.formattedDateFromString(dateString: a!, withFormat: "yyyy-MM-dd")
        let b = ToDateTextfiled?.text?.replacingOccurrences(of: "/", with: "-")
        let stringTo = self.formattedDateFromString(dateString: b!, withFormat: "yyyy-MM-dd")
        print("fromdate ", stringFrom)
        print("fromto ", stringTo)
        showActivityIndicator()
        var userCnic : String?
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/miniStatement"
        //        2020-05-10 23:59:59
        let parameters = ["channelId":"\(DataManager.instance.channelID)","fromDate": stringFrom ?? "" + " 00:00:01","toDate": stringTo ?? ""  + " 23:59:59","accountType": DataManager.instance.accountType!,"cnic":userCnic!, "imeiNo":DataManager.instance.imei!]
        //        let parameters = ["" : ""]
        print(parameters)
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
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
                    GlobalData.transRefnum = (self.myStatementObj?.ministatement?[0].transRefnum)!
                    print("fetch transation refference Number",  GlobalData.transRefnum)
                    //                    if self.miniStatementObj != nil {
                    //                        completionHandler(self.miniStatementObj!)
                    //                    }
                    self.tableView.reloadData()
                }
                else {
                    
                    if let message = self.myStatementObj?.messages{
                        self.showAlertCustomPopup(title: "",message: message, iconName: .iconError)
                    }
                    self.tableView.reloadData()
                }
            }
            else {
                if let message = self.myStatementObj?.messages{
                    self.showAlertCustomPopup(title: "",message: message, iconName: .iconError)
                }
                //                print(response.result.value)
                //                print(response.response?.statusCode)
            }
        }
    }
}
extension Statement_Transaction_HistoryVC {
    func screenshot() -> UIImage{
        
        var image = UIImage();
        UIGraphicsBeginImageContextWithOptions(self.tableView.contentSize, false, UIScreen.main.scale)
        // save initial values
        let savedContentOffset = self.tableView.contentOffset;
        let savedFrame = self.tableView.frame;
        let savedBackgroundColor = self.tableView.backgroundColor
        
        // reset offset to top left point
        self.tableView.contentOffset = CGPoint(x: 0, y: 0);
        // set frame to content size
        self.tableView.frame = CGRect(x: 0, y: 0, width: self.tableView.contentSize.width, height: self.tableView.contentSize.height);
        // remove background
        self.tableView.backgroundColor = self.tableView.backgroundColor;
        
        // make temp view with scroll view content size
        // a workaround for issue when image on ipad was drawn incorrectly
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.contentSize.width, height: self.tableView.contentSize.height));
        
        // save superview
        let tempSuperView = self.tableView.superview
        
        // Save constraints
        guard let superView = self.tableView.superview else {
            return UIImage();
        }
        //get old constraints from table
        var oldConstraints: [NSLayoutConstraint] = []
        for constraint in superView.constraints {
            if constraint.firstItem as? NSObject == self.tableView || constraint.secondItem as? NSObject == self.tableView{
                oldConstraints.append(constraint)
            }
        }
        // remove scrollView from old superview
        self.tableView.removeFromSuperview()
        // and add to tempView
        tempView.addSubview(self.tableView)
        
        // render view
        // drawViewHierarchyInRect not working correctly
        tempView.layer.render(in: UIGraphicsGetCurrentContext()!)
        // and get image
        image = UIGraphicsGetImageFromCurrentImageContext()!;
        // and return everything back
        tempView.subviews[0].removeFromSuperview()
        tempSuperView?.addSubview(self.tableView)
        //activate table's old constraints
        NSLayoutConstraint.activate(oldConstraints)
        // restore saved settings
        self.tableView.contentOffset = savedContentOffset;
        self.tableView.frame = savedFrame;
        self.tableView.backgroundColor = savedBackgroundColor
        
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        showToast(title: "Photo Saved Successfully!")
        return image
    }
    
    
}

extension Date {
    func dateString() -> String {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        if let day = components.day, let month = components.month, let year = components.year {
            print("\(day) \(month) \(year)")
            
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "dd/MM/yyyy"
            var tempDate = inputFormatter.date(from: "\(day)/\(month)/\(year)")!
            print(tempDate)
            //            inputFormatter.dateFormat = "DD/MM/yyyy"
            let tempDateFromString = inputFormatter.string(from: tempDate)
            print(tempDateFromString)
            //            let selectedDate = "\(month)/\(day)/\(year)"
            //            return selectedDate
            return tempDateFromString
        }
        return ""
    }
}
extension UITextField {
    @IBInspectable var placeHolderColor2: UIColor? {
        get {
            return self.placeHolderColor2
        }
        set {
            //Different colors in placeholder UITextField
            guard var placeHolderText = self.placeholder?.count ?? 0 > 0 ? self.placeholder : "" else { return}
            if placeHolderText.contains("*") {
                placeHolderText = placeHolderText.replacingOccurrences(of: "*", with: "", options: .literal, range: nil)
                // let attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.lightGray]
                // let attrs2 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.red]
                let attrs1 = [NSAttributedString.Key.foregroundColor : UIColor.lightGray]
                let attrs2 = [NSAttributedString.Key.foregroundColor : UIColor.red]
                let attributedString1 = NSMutableAttributedString(string: "   " + placeHolderText, attributes:attrs1)
                let attributedString2 = NSMutableAttributedString(string:"*", attributes:attrs2)
                attributedString1.append(attributedString2)
                self.attributedPlaceholder = attributedString1
            }
            else {
                let attrs1 = [NSAttributedString.Key.foregroundColor : UIColor.lightGray]
                let attributedString = NSMutableAttributedString(string: "   " + placeHolderText, attributes:attrs1)
                self.attributedPlaceholder = attributedString
            }
        }
    }
    
    @IBInspectable var doneToolbar: UIToolbar {
        //        set{
        //            let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        //
        //            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
        //
        //            let items = [flexSpace, doneButton]
        //            toolbar.items = items
        //            toolbar.sizeToFit()
        //        }
        get {
            let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped2))
            
            let items = [flexSpace, doneButton]
            toolbar.items = items
            
            toolbar.sizeToFit()
            return toolbar
        }
    }
    
    @objc func doneButtonTapped2() {
        resignFirstResponder()
    }
    
    func setPickerCustom() -> UIPickerView {
        let picker = UIPickerView()
        //Need assign delegates in UIViewController
        //picker.dataSource = self
        //picker.delegate = self
        self.frame = .zero
        self.inputView = picker
        inputAccessoryView = doneToolbar
        return picker
    }
    
    func setPickerDate() -> UIDatePicker {
        let picker = UIDatePicker()
        //        if #available(iOS 15, *) {
        //            picker.minimumDate = Date.now
        //        } else {
        //            picker.minimumDate = Date()
        //        }
        //Need assign delegates in UIViewController
        //picker.dataSource = self
        //picker.delegate = self
        frame = .zero
        inputView = picker
        inputAccessoryView = doneToolbar
        //Formate Date
        picker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        return picker
    }
    
    func setPickerTime() -> UIDatePicker {
        let picker = UIDatePicker()
        //Need assign delegates in UIViewController
        //picker.dataSource = self
        //picker.delegate = self
        frame = .zero
        inputView = picker
        inputAccessoryView = doneToolbar
        //Formate Date
        picker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        return picker
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) || action == #selector(cut(_:)){
            return false
        }
        else if action == #selector(select(_:)) || action == #selector(selectAll(_:)){
            return true
        }
        
        //return super.canPerformAction(action, withSender: sender)
        
        return false
    }
    
    func setPadding() {
        let padding = CGFloat(8.0)
        let defaultRect = CGRect(x: 0, y: 0, width: padding, height: self.frame.height)
        
        //MARK:- Padding Left
        let paddingViewLeft = UIView(frame: self.leftView?.frame ?? defaultRect)
        
        if let leftView = self.leftView {
            for temp in leftView.subviews {
                paddingViewLeft.addSubview(temp)
                paddingViewLeft.frame.size.width += padding
                break
            }
        }
        else {
            //MARK:- if leftView is nill this will use for add padding
            paddingViewLeft.frame = defaultRect
        }
        self.leftView = paddingViewLeft
        paddingViewLeft.backgroundColor = .clear
        self.leftViewMode = .always
        
        //MARK:- Padding Right
        let paddingViewRight = UIView(frame: self.rightView?.frame ?? defaultRect)
        
        if let rightView = self.rightView {
            for temp in rightView.subviews {
                paddingViewRight.addSubview(temp)
                paddingViewRight.frame.size.width += padding
                temp.frame.origin.x = padding
                break
            }
        }
        else {
            //MARK:- if rightView is nill this will use for add padding
            paddingViewRight.frame = defaultRect
        }
        
        self.rightView = paddingViewRight
        paddingViewRight.backgroundColor = .clear
        self.rightViewMode = .always
    }
    
    func setPaddingLeft() {
        let padding = CGFloat(8.0)
        let defaultRect = CGRect(x: 0, y: 0, width: padding, height: self.frame.height)
        
        //MARK:- Padding Left
        let paddingViewLeft = UIView(frame: self.leftView?.frame ?? defaultRect)
        
        if let leftView = self.leftView {
            for temp in leftView.subviews {
                paddingViewLeft.addSubview(temp)
                paddingViewLeft.frame.size.width += padding
                break
            }
        }
        else {
            //MARK:- if leftView is nill this will use for add padding
            paddingViewLeft.frame = defaultRect
        }
        self.leftView = paddingViewLeft
        paddingViewLeft.backgroundColor = .clear
        self.leftViewMode = .always
    }
    
    func setPaddingRight() {
        let padding = CGFloat(8.0)
        let defaultRect = CGRect(x: 0, y: 0, width: padding, height: self.frame.height)
        
        //MARK:- Padding Right
        let paddingViewRight = UIView(frame: self.rightView?.frame ?? defaultRect)
        
        if let rightView = self.rightView {
            for temp in rightView.subviews {
                paddingViewRight.addSubview(temp)
                paddingViewRight.frame.size.width += padding
                temp.frame.origin.x = padding
                break
            }
        }
        else {
            //MARK:- if rightView is nill this will use for add padding
            paddingViewRight.frame = defaultRect
        }
        
        self.rightView = paddingViewRight
        paddingViewRight.backgroundColor = .clear
        self.rightViewMode = .always
    }
    
    func setLeftIcon(icon: String, backGroudColor: UIColor) {
        let iconImageSizePercentage = CGFloat(0.30)
        
        let frameView = UIView(frame: CGRect(x: 0, y: 0, width: ((self.frame.height) ), height: ((self.frame.height))))
        let iconImage = UIImage(named: icon)
        frameView.backgroundColor = backGroudColor
        
        let iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: ((self.frame.height) * iconImageSizePercentage ), height: ((self.frame.height) * iconImageSizePercentage))) // set your Own size
        iconImageView.image = iconImage
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.backgroundColor = .clear
        
        frameView.addSubview(iconImageView)
        iconImageView.center = frameView.center
        
        leftView = frameView
        leftViewMode = .always
        tintColor = .lightGray
    }
    
    func setRightIcon(icon: String) {
        let iconImageSizePercentage = CGFloat(0.30)
        
        let frameView = UIView(frame: CGRect(x: 0, y: 0, width: ((self.frame.height) ), height: ((self.frame.height))))
        let iconImage = UIImage(named: icon)
        frameView.backgroundColor = .clear
        
        let iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: ((self.frame.height) * iconImageSizePercentage), height: ((self.frame.height) * iconImageSizePercentage))) // set your Own size
        iconImageView.image = iconImage
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.backgroundColor = .clear
        
        frameView.addSubview(iconImageView)
        iconImageView.center = frameView.center
        
        rightView = frameView
        rightViewMode = .always
        tintColor = .lightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(funBecomeFirstResponder))
        rightView?.addGestureRecognizer(tap)
    }
    
    func setRightIcon(icon: String, padding: Float?) {
        let padding = CGFloat(padding ?? 0.0)
        let iconImageSizePercentage = CGFloat(0.30)
        
        let frameView = UIView(frame: CGRect(x: 0, y: 0, width: ((self.frame.height) ), height: ((self.frame.height))))
        let iconImage = UIImage(named: icon)
        frameView.backgroundColor = .clear
        
        let iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: ((self.frame.height) * iconImageSizePercentage), height: ((self.frame.height) * iconImageSizePercentage))) // set your Own size
        iconImageView.image = iconImage
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.backgroundColor = .clear
        
        frameView.addSubview(iconImageView)
        iconImageView.center = frameView.center
        
        //MARK:- Padding Right
        let paddingView = UIView(frame: frameView.frame)
        paddingView.frame.size.width = paddingView.frame.width + padding
        paddingView.addSubview(frameView)
        frameView.frame.origin.x = padding
        paddingView.backgroundColor = self.backgroundColor
        
        rightView = paddingView
        rightViewMode = .always
        tintColor = .lightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(funBecomeFirstResponder))
        rightView?.addGestureRecognizer(tap)
    }
    func setRightIcon(icon: String, backGroudColor: UIColor) {
        let iconImageSizePercentage = CGFloat(0.30)
        
        let frameView = UIView(frame: CGRect(x: 0, y: 0, width: ((self.frame.height)), height: ((self.frame.height))))
        let iconImage = UIImage(named: icon)
        frameView.backgroundColor = backGroudColor
        
        let iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: ((self.frame.height) * iconImageSizePercentage ), height: ((self.frame.height) * iconImageSizePercentage))) // set your Own size
        iconImageView.image = iconImage
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.backgroundColor = .clear
        
        frameView.addSubview(iconImageView)
        iconImageView.center = frameView.center
        
        self.leftView = frameView
        self.leftViewMode = .always
        self.tintColor = .lightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(funBecomeFirstResponder))
        rightView?.addGestureRecognizer(tap)
    }
    
    func setRightIconButton(icon: String) -> UIButton {
        let iconImageSizePercentage = CGFloat(0.35)
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: ((self.frame.height)), height: ((self.frame.height))))
        button.backgroundColor = .clear
        let iconImage = UIImage(named: icon)
        
        let iconImageView =  UIImageView(frame: CGRect(x: 0, y: 0, width: ((self.frame.height) * iconImageSizePercentage ), height: ((self.frame.height) * iconImageSizePercentage))) // set your Own size
        iconImageView.image = iconImage
        iconImageView.contentMode = .scaleAspectFit
        
        let frameView: UIView = UIView(frame: button.frame)
        frameView.backgroundColor = .clear
        frameView.addSubview(iconImageView)
        frameView.addSubview(button)
        
        iconImageView.center = frameView.center
        
        self.rightView = frameView
        self.rightViewMode = .always
        self.tintColor = .red
        
        return button
    }
    
    @objc func funBecomeFirstResponder(sender: Any) {
        self.becomeFirstResponder()
    }
}
