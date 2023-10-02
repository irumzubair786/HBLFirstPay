//
//  MyAccountLimitsVc.swift
//  First Pay
//
//  Created by Irum Butt on 11/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import ObjectMapper
import FittedSheets
class MyAccountLimitsVc: BaseClassVC, fittedSheets {
    static var name: String { "CategoryPicker" }
  
    var levelCode :String?
    var totalDailyLimitDr : Int?
    var totalMonthlyLimitDr : Int?
    var totalYearlyLimitDr : Int?
    var totalDailyLimitCr : Int?
    var totalMonthlyLimitCr : Int?
    var totalYearlyLimitCr : Int?
    var balanceLimit : Int?
    
    var totalDailyLimitDr1 : Int?
    var totalMonthlyLimitDr1 : Int?
    var totalYearlyLimitDr1 : Int?
    var totalDailyLimitCr1 : Int?
    var totalMonthlyLimitCr1 : Int?
    var totalYearlyLimitCr1 : Int?
    var balanceLimit1 : Int?
    var myCustomArray = [a]()
    var receivingArr = [receiving]()
    var DailyTotalLimit : String?
    var MonthlyLimit : String?
    var YearlyLimit : String?
    
    var DailyTotalLimit1 : String?
    var MonthlyLimit1 : String?
    var ValueDelegate: String?
    var YearlyLimit1 : String?
    var valuecase1delgate : String?
    //    var availableLimitObj : GetAccLimits2?
    override func viewDidLoad() {
        super.viewDidLoad()
        //        getAvailableLimits()
        apicall()
        buttonBack.setTitle("", for: .normal)
        buttonUpgrade.isHidden = true
        buttonUpgrade.setTitle("UPGRADE", for: .normal)
        buttonUpgrade.setTitleColor(.white, for: .normal)
        tableView.rowHeight = 110
        checkLevel()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var imageCheckLevel: UIImageView!
    func checkLevel()
    {
        if  DataManager.instance.accountLevel == "LEVEL 0"
        {
            buttonUpgrade.isHidden = false
            imageCheckLevel.image = UIImage(named: "UnverifiedIcon")
            
        }
        else
        {
            buttonUpgrade.isHidden = true
            imageCheckLevel.image = UIImage(named: "verifiedicon")
        }
        
    }
    func CommaSeprationSection1()
    {
        var number = Double(modelGetAccount?.data?.totalDailyLimitCR ?? 0)
        var formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        //        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_US")
        DailyTotalLimit1 = (formatter.string(from: NSNumber(value: number ?? 0)))!
        print("successfuly DailyTotalLimit1", DailyTotalLimit1)
        var number2 = Double(modelGetAccount?.data?.totalMonthlyLimitCR ?? 0)
        var formatt = NumberFormatter()
        formatt.numberStyle = .decimal
        //        formatter.maximumFractionDigits = 2
        formatt.locale = Locale(identifier: "en_US")
        MonthlyLimit1 = (formatt.string(from: NSNumber(value: number2 ?? 0)))!
        print("successfuly MonthlyLimit", MonthlyLimit1)
        
        
        var number3 = Double(modelGetAccount?.data?.totalYearlyLimitCR ?? 0)
        var form = NumberFormatter()
        form.numberStyle = .decimal
        //        formatter.maximumFractionDigits = 2
        form.locale = Locale(identifier: "en_US")
        YearlyLimit1 = (form.string(from: NSNumber(value: number3 ?? 0)))!
        print("successfuly YearlyLimit", YearlyLimit1)
        
    }
    func appenddata(){
        var totaldailyLimit = modelGetAccount?.data?.totalDailyLimitCR
        var ConsumedDailyLimit = modelGetAccount?.data?.dailyReceived
        var percent = calculateValue(total: (totaldailyLimit ?? 0),userValue: ConsumedDailyLimit ?? 0)
        CommaSeprationSection1()
        receivingArr.append(receiving(name: "Daily", limit: "\(modelGetAccount?.data?.dailyReceived ?? 0)", colour: UIColor(hexString: "#F8CC59", alpha: 1), remaining: "Remaining Rs. \(modelGetAccount?.data?.dailyCRRemaining ?? 0)",totalAmount: "\(DailyTotalLimit1!)", percentage:Float(percent),limitType: "D",amountType: "C", LimitLevelReceiving: Float((modelGetAccount?.data?.dailyLevelCreditLimit) ?? 0)))
        
        
        var totalyMonthlyLimit = modelGetAccount?.data?.totalMonthlyLimitCR
        var  ConsumedMonthlyLimit = modelGetAccount?.data?.monthlyReceived
        var per  = calculateValue(total: Int(totalyMonthlyLimit ?? 0),userValue: Int(ConsumedMonthlyLimit ?? 0))
        
        receivingArr.append(receiving(name: "Monthly",limit: "\(modelGetAccount?.data?.monthlyReceived ?? 0)", colour: UIColor(hexString: "#1EC884", alpha: 1), remaining: "Remaining Rs. \(modelGetAccount?.data?.monthlyCRRemaining ?? 0)",totalAmount: "\(MonthlyLimit1!)", percentage: Float(per),limitType: "M",amountType: "C", LimitLevelReceiving: Float(modelGetAccount?.data?.monthlyLevelCreditLimit ?? 0)))
        
        print("receiving month limit",receivingArr[0].limitType )
        print("receiving month Amount",receivingArr[0].amountType )
        var totalyYearlyLimit = modelGetAccount?.data?.totalYearlyLimitCR
        var  ConsumedYearlyLimit = modelGetAccount?.data?.yearlyReceived
        var pers  = calculateValue(total: Int(totalyYearlyLimit ?? 0),userValue: Int(ConsumedYearlyLimit ?? 0))
        
        receivingArr.append(receiving(name: "Yearly ", limit: "\(modelGetAccount?.data?.yearlyReceived ?? 0)", colour: UIColor(hexString: "#F19434", alpha: 1),remaining: "Remaining Rs. \(modelGetAccount?.data?.yearlyCRRemaining ?? 0)",totalAmount: "\(YearlyLimit1!)", percentage: Float(pers),limitType: "Y",amountType: "C", LimitLevelReceiving: Float(modelGetAccount?.data?.yearlyLevelCreditLimit ?? 0)))
        
    }
    
    func CommaSepration()
    {
        var number = Double(modelGetAccount?.data?.totalDailyLimit ?? 0)
        var formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        //        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_US")
        DailyTotalLimit = (formatter.string(from: NSNumber(value: number ?? 0)))!
        
        var number2 = Double(modelGetAccount?.data?.totalMonthlyLimit ?? 0)
        var formatt = NumberFormatter()
        formatt.numberStyle = .decimal
        //        formatter.maximumFractionDigits = 2
        formatt.locale = Locale(identifier: "en_US")
        MonthlyLimit = (formatt.string(from: NSNumber(value: number2 ?? 0)))!
        print("successfuly MonthlyLimit", MonthlyLimit)
        
        
        var number3 = Double(modelGetAccount?.data?.totalYearlyLimit ?? 0)
        var form = NumberFormatter()
        form.numberStyle = .decimal
        //        formatter.maximumFractionDigits = 2
        form.locale = Locale(identifier: "en_US")
        YearlyLimit = (form.string(from: NSNumber(value: number3 ?? 0)))!
        print("successfuly YearlyLimit", YearlyLimit)
        
    }
    
    func appendVlaluesToArray(){
        
        var totaldailyLimit = modelGetAccount?.data?.totalDailyLimit
        var ConsumedDailyLimit = modelGetAccount?.data?.dailyConsumed
        var percent = calculateValue(total: (totaldailyLimit ?? 0),userValue: ConsumedDailyLimit ?? 0)
        CommaSepration()
        print("total daily", DailyTotalLimit)
        myCustomArray.append(a(name: "Daily ", limit: "\(modelGetAccount?.data?.dailyConsumed ?? 0)", colour: UIColor(hexString: "#F8CC59", alpha: 1), remaining: "Remaining Rs. \(modelGetAccount?.data?.dailyDRRemaining ?? 0)",totalAmount: "\(DailyTotalLimit!)", percentage: Float(percent),limitType: "D",amountType: "D", LimitLevelSending: Float(modelGetAccount?.data?.dailyLevelDebitLimit ?? 0)))
        
        var totalyMonthlyLimit = modelGetAccount?.data?.totalMonthlyLimit
        var  ConsumedMonthlyLimit = modelGetAccount?.data?.monthlyConsumed
        var per  = calculateValue(total: Int(totalyMonthlyLimit ?? 0),userValue: Int(ConsumedMonthlyLimit ?? 0))
        
        myCustomArray.append(a(name: "Monthly ", limit: "\(modelGetAccount?.data?.monthlyConsumed ?? 0)", colour: UIColor(hexString: "#1EC884", alpha: 1),remaining: "Remaining Rs. \(modelGetAccount?.data?.monthlyDRRemaining ?? 0)",totalAmount: "\(MonthlyLimit!)", percentage: Float(per),limitType: "M",amountType: "D", LimitLevelSending: Float(modelGetAccount?.data?.monthlyLevelDebitLimit ?? 0)))
        
        var totalyYearlyLimit = modelGetAccount?.data?.totalYearlyLimit
        var  ConsumedYearlyLimit = modelGetAccount?.data?.yearlyConsumed
        var pers  = calculateValue(total: Int(totalyYearlyLimit ?? 0),userValue: Int(ConsumedYearlyLimit ?? 0))
        
        myCustomArray.append(a(name: "Yearly ", limit: "\(modelGetAccount?.data?.yearlyConsumed! ?? 0)", colour: UIColor(hexString: "#F19434", alpha: 1),remaining: "Remaining Rs. \(modelGetAccount?.data?.yearlyDRRemaining ?? 0)",totalAmount: "\(YearlyLimit!)", percentage: Float(pers),limitType: "Y",amountType: "D", LimitLevelSending: Float(modelGetAccount?.data?.yearlyLevelDebitLimit ?? 0)))
    }
    override func viewWillAppear(_ animated: Bool) {

    }
    @IBOutlet weak var buttonBack: UIButton!
    @IBAction func buttonBack(_ sender: UIButton) {

        self.dismiss(animated: true)
        
    }
    @IBAction func buttonUpgrade(_ sender: UIButton) {
        FBEvents.logEvent(title: .Upgrade_Account_Level_Path2)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UnverifeidAccountMainVc") as! UnverifeidAccountMainVc
        vc.balanceLimit = balanceLimit
        vc.balanceLimit1 = balanceLimit1
        vc.totalDailyLimitCr =  totalDailyLimitCr
        vc.totalDailyLimitCr1 =  totalDailyLimitCr1
        vc.totalMonthlyLimitCr = totalMonthlyLimitCr
        vc.totalMonthlyLimitCr1 = totalMonthlyLimitCr1
        vc.totalYearlyLimitCr =  totalYearlyLimitCr
        vc.totalYearlyLimitCr1 =  totalYearlyLimitCr1
        vc.totalDailyLimitDr = totalDailyLimitDr
        vc.totalDailyLimitDr1 = totalDailyLimitDr1
        vc.totalMonthlyLimitDr =  totalMonthlyLimitDr
        vc.totalMonthlyLimitDr1 =  totalMonthlyLimitDr1
        vc.totalYearlyLimitDr = totalYearlyLimitDr
        vc.totalYearlyLimitDr1 = totalYearlyLimitDr1
        
        vc.accountUpGradeSuccessfull = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                vc.dismiss(animated: false)
                DataManager.instance.accountLevel = "LEVEL 1"
                self.checkLevel()
            }
        }
        self.present(vc, animated: true)
    }
    
    
    @IBOutlet weak var buttonUpgrade: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonVeiwDetail: UIButton!
    @IBAction func buttonVeiwDetail(_ sender: UIButton) {
        if   DataManager.instance.accountLevel == "LEVEL 0"
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UnVerifiedAccountVC") as! UnVerifiedAccountVC
            vc.balanceLimit = balanceLimit
            vc.balanceLimit1 = balanceLimit1
            vc.totalDailyLimitCr =  totalDailyLimitCr
            vc.totalDailyLimitCr1 =  totalDailyLimitCr1
            vc.totalMonthlyLimitCr = totalMonthlyLimitCr
            vc.totalMonthlyLimitCr1 = totalMonthlyLimitCr1
            vc.totalYearlyLimitCr =  totalYearlyLimitCr
            vc.totalYearlyLimitCr1 =  totalYearlyLimitCr1
            vc.totalDailyLimitDr = totalDailyLimitDr
            vc.totalDailyLimitDr1 = totalDailyLimitDr1
            vc.totalMonthlyLimitDr =  totalMonthlyLimitDr
            vc.totalMonthlyLimitDr1 =  totalMonthlyLimitDr1
            vc.totalYearlyLimitDr = totalYearlyLimitDr
            vc.totalYearlyLimitDr1 = totalYearlyLimitDr1
            self.present(vc, animated: true)
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifiedAccountVC") as! VerifiedAccountVC
            vc.balanceLimit = balanceLimit
            vc.balanceLimit1 = balanceLimit1
            vc.totalDailyLimitCr =  totalDailyLimitCr
            vc.totalDailyLimitCr1 =  totalDailyLimitCr1
            vc.totalMonthlyLimitCr = totalMonthlyLimitCr
            vc.totalMonthlyLimitCr1 = totalMonthlyLimitCr1
            vc.totalYearlyLimitCr =  totalYearlyLimitCr
            vc.totalYearlyLimitCr1 =  totalYearlyLimitCr1
            vc.totalDailyLimitDr = totalDailyLimitDr
            vc.totalDailyLimitDr1 = totalDailyLimitDr1
            vc.totalMonthlyLimitDr =  totalMonthlyLimitDr
            vc.totalMonthlyLimitDr1 =  totalMonthlyLimitDr1
            vc.totalYearlyLimitDr = totalYearlyLimitDr
            vc.totalYearlyLimitDr1 = totalYearlyLimitDr1
            self.present(vc, animated: true)
        }
        
        
    }
   
    func calculateValue(total:Int , userValue:Int)->Double{
        return Double((Double(userValue))/(Double(total)))
    }
    func openPicker(from parent: UIViewController, id: String, in view: UIView?,daily : String,dailyAmount: String?, dailyminValue: String? ,dailymaxValue: String?,LimitType: String? ,AmounttType: String?, tag : Int? ,section: Int? ) {
        
        let useInlineMode = view != nil
        let controller = (UIStoryboard.init(name: "AccountLevel", bundle: Bundle.main).instantiateViewController(withIdentifier: "changeLimitVC") as? changeLimitVC)!
        controller.daily = daily
        controller.dailyAmount = dailyAmount
        controller.dailyminValue = dailyminValue
        controller.dailymaxValue = dailymaxValue
        controller.tag  = tag
        controller.delegate = self
        controller.section = section
        controller.refreshScreen = {
            self.apicall()
        }
        controller.LimitType = LimitType
        controller.AmounttType =  AmounttType
        let sheet = SheetViewController(
            controller: controller,
            sizes: [.percent(0.45), .fullscreen],
            options: SheetOptions(useInlineMode: useInlineMode))
        MyAccountLimitsVc.addSheetEventLogging(to: sheet)
        
        if let view = view {
            sheet.animateIn(to: view, in: parent)
        } else {
            
            parent.present(sheet, animated: true, completion: nil)
        }
    }

    @objc func buttonpress(_ sender:UIButton)
    {
        
        
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else {
            return
        }
        let section = indexPath.section
        print("sende", section)
        let tag = sender.tag
        print("tag",tag)
        //        let indexPath = IndexPath(row: tag, section: sender.superview?.tag ?? 0) // assuming you set the tag of the cell view to the index path
        let cell = tableView.cellForRow(at: indexPath) as! cellMyAccountVc
        openPicker(from: self, id:  "changeLimitVC", in: nil, daily: cell.labelDailyName.text!, dailyAmount: cell.labelTotalAmount.text, dailyminValue: cell.labelConsumed.text, dailymaxValue: cell.lblLevelLImit.text!, LimitType: cell.labelLimitType.text, AmounttType: cell.labelAmountType.text, tag: tag, section: section)
        
////        vc.daily = cell.labelDailyName.text
////        vc.dailyAmount = cell.labelTotalAmount.text
////        vc.dailyminValue = cell.labelConsumed.text
////        vc.dailymaxValue = cell.lblLevelLImit.text!
//////        vc.dailymaxValue = cell.labelTotalAmount.text
////        vc.LimitType = cell.labelLimitType.text
////        vc.AmounttType = cell.labelAmountType.text
////        //        vc.ReceivingLimitType = cell.labelReceivingType.text
////        vc.delegate = self
//        vc.tag = tag
////        vc.section = section
////        vc.refreshScreen = {
////            self.apicall()
////        }
//


        
//        let vc = self.storyboard!.instantiateViewController(withIdentifier: "changeLimitVC") as!   changeLimitVC
//        vc.daily = cell.labelDailyName.text
//        vc.dailyAmount = cell.labelTotalAmount.text
//        vc.dailyminValue = cell.labelConsumed.text
//        vc.dailymaxValue = cell.lblLevelLImit.text!
////        vc.dailymaxValue = cell.labelTotalAmount.text
//        vc.LimitType = cell.labelLimitType.text
//        vc.AmounttType = cell.labelAmountType.text
//        //        vc.ReceivingLimitType = cell.labelReceivingType.text
//        vc.delegate = self
//        vc.tag = tag
//        vc.section = section
//        vc.refreshScreen = {
//            self.apicall()
//        }
//        self.present(vc, animated: true)
        
    }
    ////    ----------getaccountlimits
    
    var modelGetAccount : GetAccLimits2?
    {
        didSet{
            if self.modelGetAccount?.responsecode == 1  {
                myCustomArray.removeAll()
                receivingArr.removeAll()
                self.appendVlaluesToArray()
                self.appenddata()
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
            else {
                //MARK: - Loan Failed Successfully
                self.showAlertCustomPopup(title: "Error!", message: modelGetAccount?.messages ?? "", iconName: .iconError)
            }
        }
    }
    
    func apicall()
    {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imeiNo" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
            "accountType": "\(DataManager.instance.accountType ?? "0")"
        ]
        
        APIs.postAPI(apiName: .getAccLimits, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            
            let model : GetAccLimits2? = APIs.decodeDataToObject(data: responseData)
            print("response",model)
            self.modelGetAccount = model
        }
    }
    func comaBreak()
    {
       
    }
   
}

extension MyAccountLimitsVc: DissmissDelegate
{
    func updatescreen(value: String?, tag: Int?,section: Int?) {
        print("delegate call",value,"tag", tag)
        switch section{
        case 0:
            let number = Double(value ?? "")
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            //        formatter.maximumFractionDigits = 2
            formatter.locale = Locale(identifier: "en_US")
            ValueDelegate = (formatter.string(from: NSNumber(value: number ?? 0)))!
            myCustomArray[tag ?? 0].totalAmount = ValueDelegate
            tableView.reloadData()
        case 1:
            
            let number = Double(value ?? "")
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            //        formatter.maximumFractionDigits = 2
            formatter.locale = Locale(identifier: "en_US")
            valuecase1delgate = (formatter.string(from: NSNumber(value: number ?? 0)))!
            receivingArr[tag ?? 0].totalAmount = valuecase1delgate
            tableView.reloadData()
        default:
            break
        }
//           apicall()
    }

    
    
}
extension MyAccountLimitsVc: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in each section
        switch section {
        case 0:
            return myCustomArray.count
        case 1:
            return receivingArr.count
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMyAccountVc", for: indexPath) as! cellMyAccountVc
        
        // Configure the cell
        switch indexPath.section {
        case 0:
            
            cell.labelDailyName.text = myCustomArray[indexPath.row].name
            cell.labelConsumed.text = "Consumed Rs. \(myCustomArray[indexPath.row].limit ?? "0")"
            cell.lblLevelLImit.text = "\(myCustomArray[indexPath.row].LimitLevelSending!)"
            cell.progressbar.progressTintColor = myCustomArray[indexPath.row].colour
            cell.progressbar.progressViewStyle = .bar
            cell.progressbar.trackTintColor = UIColor(hexString: "#F2F6F9", alpha: 1)
            cell.labelRemaining.text = myCustomArray[indexPath.row].remaainig
//            yy
            cell.labelTotalAmount.text = "Total Rs. \(myCustomArray[indexPath.row].totalAmount ?? "0")"
            cell.progressbar.cornerRadius = 5
            cell.buttonEdit.tag = indexPath.row
//            cell.progressbar.progress = myCustomArray[indexPath.row].percentage!
            cell.progressbar.progress = (Float((myCustomArray[indexPath.row].limit ?? "0").getIntegerValue()) ?? 0)/(Float((myCustomArray[indexPath.row].totalAmount ?? "0").getIntegerValue()) ?? 0)
//            cell.progressbar.progress = (Float((myCustomArray[indexPath.row].limit ?? "0").getIntegerValue()) ?? 0) / self.getDivideValue(amount: myCustomArray[indexPath.row].totalAmount ?? "0")
            cell.labelLimitType.text = myCustomArray[indexPath.row].limitType
            cell.labelAmountType.text = myCustomArray[indexPath.row].amountType
            cell.buttonEdit.addTarget(self, action:  #selector(buttonpress(_:)), for: .touchUpInside)
        case 1:
            // cell.textLabel?.text = "Receiving Limits, Row \(indexPath.row)"
            cell.labelDailyName.text = receivingArr[indexPath.row].name
            cell.lblLevelLImit.text = "\(receivingArr[indexPath.row].LimitLevelReceiving!)"
            cell.labelTotalAmount.text = "Total Rs. \(receivingArr[indexPath.row].totalAmount ?? "0")"
            cell.labelConsumed.text = "Consumed Rs. \(receivingArr[indexPath.row].limit ?? "0")"
            cell.progressbar.progressTintColor = receivingArr[indexPath.row].colour
            cell.progressbar.progressViewStyle = .bar
            cell.progressbar.trackTintColor = UIColor(hexString: "#F2F6F9", alpha: 1)
            cell.progressbar.cornerRadius = 5
            cell.labelRemaining.text = receivingArr[indexPath.row].remaainig
            cell.progressbar.cornerRadius = 5
//            cell.progressbar.progress = receivingArr[indexPath.row].percentage!
            cell.progressbar.progress = (Float((receivingArr[indexPath.row].limit ?? "0").getIntegerValue()) ?? 0) / self.getDivideValue(amount: receivingArr[indexPath.row].totalAmount ?? "0")
            cell.labelLimitType.text = receivingArr[indexPath.row].limitType
            cell.labelAmountType.text = receivingArr[indexPath.row].amountType
            cell.buttonEdit.tag = indexPath.row
            //              cell.labelReceivingType.text = receivingArr[indexPath.row].limitType
            cell.buttonEdit.addTarget(self, action:  #selector(buttonpress(_:)), for: .touchUpInside)
        default:
            break
        }
        return cell
    }
    
    func getDivideValue(amount: String) -> Float {
        let totalDigit = amount.getIntegerValue().count
        if totalDigit == 1 {
            return 10
        }
        else if totalDigit == 2 {
            return 100
        }
        else if totalDigit == 3 {
            return 1000
        }
        else if totalDigit == 4 {
            return 10000
        }
        else if totalDigit == 5 {
            return 100000
        }
        else if totalDigit == 6 {
            return 1000000
        }
        else if totalDigit == 6 {
            return 10000000
        }
        else if totalDigit == 7 {
            return 100000000
        }
        else if totalDigit == 8 {
            return 1000000000
        }
        return 0
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Set the title for each section
        switch section {
        case 0:
            return "Sending Limits"
           
            
            
        case 1:
            return "Receiving Limits"
        default:
            return nil
        }
    }
    
}
class a
{
    var name : String?
    var limit : String?
    var colour : UIColor?
    var remaainig : String?
    var totalAmount: String?
    var percentage : Float?
    var limitType :String?
    var amountType : String?
    var LimitLevelSending : Float?
    init(name : String , limit : String  ,colour :UIColor, remaining: String, totalAmount: String  , percentage : Float, limitType : String, amountType:String, LimitLevelSending: Float){
        self.limit = limit
        self.name = name
        self.colour = colour
        self.remaainig = remaining
        self.totalAmount = totalAmount
        self.percentage = percentage
        self.amountType = amountType
        self.limitType = limitType
        self.LimitLevelSending = Float(LimitLevelSending)
    }
}


class receiving
{
    var name : String?
    var limit : String?
    var colour : UIColor?
    var remaainig : String?
    var totalAmount: String?
    var percentage : Float?
    var limitType :String?
    var amountType : String?
    var LimitLevelReceiving : Float?
    init(name : String , limit : String  ,colour :UIColor, remaining: String, totalAmount: String , percentage : Float , limitType : String, amountType:String, LimitLevelReceiving : Float){
        self.limit = limit
        self.name = name
        self.colour = colour
        self.remaainig = remaining
        self.totalAmount = totalAmount
        self.percentage = percentage
        self.amountType = amountType
        self.limitType = limitType
        self.LimitLevelReceiving = Float(LimitLevelReceiving)
    }
}

