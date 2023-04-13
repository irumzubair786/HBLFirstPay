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
import AlamofireObjectMapper
class MyAccountLimitsVc: BaseClassVC {
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
    var availableLimitObj : GetAccLimits2?
    override func viewDidLoad() {
        super.viewDidLoad()
//        getAvailableLimits()
        apicall()
        buttonBack.setTitle("", for: .normal)
        
        buttonUpgrade.setTitle("UPGRADE", for: .normal)
        buttonUpgrade.setTitleColor(.white, for: .normal)
        tableView.rowHeight = 100
        
        // Do any additional setup after loading the view.
    }
    func appendVlaluesToArray(){
        
        myCustomArray.append(a(name: "Daily ", limit: "Consumed Rs. \(availableLimitObj?.data?.dailyConsumed)", colour: UIColor(hexString: "#F8CC59", alpha: 1)))
        myCustomArray.append(a(name: "Monthly ", limit: "Consumed Rs.\(availableLimitObj?.data?.monthlyConsumed)", colour: UIColor(hexString: "#1EC884", alpha: 1)))
        myCustomArray.append(a(name: "Yearly ", limit: "Consumed Rs.\(availableLimitObj?.data?.monthlyConsumed)", colour: UIColor(hexString: "#F19434", alpha: 1)))
    }
    @IBOutlet weak var buttonBack: UIButton!
    @IBAction func buttonBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func buttonUpgrade(_ sender: UIButton) {
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
    
    
    @IBOutlet weak var buttonUpgrade: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonVeiwDetail: UIButton!
    @IBAction func buttonVeiwDetail(_ sender: UIButton) {
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
    
    func calculateValue(total:Int , userValue:Int)->Double{
        return Double((userValue/total))
    }
    
    @objc func buttonpress(_ sender:UIButton)
    {
        let tag = sender.tag
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0))
        as! cellMyAccountVc
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "changeLimitVC") as!   changeLimitVC
        vc.daily =  (myCustomArray[tag].name)
        //        vc.monthly = myCustomArray[tag].name
        //        vc.yearly = myCustomArray[tag].name
        //        vc.dailyReceiving = myCustomArray[tag].name
        //        vc.monthlyReceiving = myCustomArray[tag].name
        //        vc.yearlyReceiving = myCustomArray[tag].name
        self.present(vc, animated: true)
        //        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    ////    ----------getaccountlimits
    
    var modelGetAccount : GetAccLimits2?
    {
        didSet{
            if self.availableLimitObj?.responsecode == 2 || self.availableLimitObj?.responsecode == 1 {
                
                self.tableView.reloadData()
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.appendVlaluesToArray()
            }
            else {
                if let message = self.availableLimitObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
            }
            
            //        else {
            //            if let message = self.availableLimitObj?.messages{
            //                self.showDefaultAlert(title: "", message: message)
            //            }
            //            //                  print(response.result.value)
            //            //                  print(response.response?.statusCode)
            //        }
            
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
}
//        private func getAvailableLimits() {
//      //
//              if !NetworkConnectivity.isConnectedToInternet(){
//                  self.showToast(title: "No Internet Available")
//                  return
//              }
//
//              showActivityIndicator()
//              var userCnic : String?
//              if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
//                  userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
//              }
//              else{
//                  userCnic = ""
//              }
//            userCnic = UserDefaults.standard.string(forKey: "userCnic")
//
//      //        let compelteUrl = GlobalConstants.BASE_URL + "getAccLimits"
//              let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/getLevelLimits"
//
//              let parameters : Parameters = ["cnic":userCnic!, "accountType" : DataManager.instance.accountType ?? "20", "imeiNo": DataManager.instance.imei!,"channelId": DataManager.instance.channelID ]
//
//              print(parameters)
//
//
//              let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
//
//              let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
//
//
//              let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
//
//              print(params)
//              print(compelteUrl)
//
//
//              NetworkManager.sharedInstance.enableCertificatePinning()
//
//
//              NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<AccLimitModel>) in
//
//                  self.hideActivityIndicator()
//
//                  self.availableLimitObj = response.result.value
//
//                  if response.response?.statusCode == 200 {
//                      if self.availableLimitObj?.responsecode == 2 || self.availableLimitObj?.responsecode == 1 {
//
//                          self.tableView.reloadData()
//                          self.tableView.delegate = self
//                          self.tableView.dataSource = self
//                          self.appendVlaluesToArray()
//                      }
//                      else {
//                          if let message = self.availableLimitObj?.messages{
//                              self.showDefaultAlert(title: "", message: message)
//                          }
//                      }
//                  }
//                  else {
//                      if let message = self.availableLimitObj?.messages{
//                          self.showDefaultAlert(title: "", message: message)
//                      }
//    //                  print(response.result.value)
//    //                  print(response.response?.statusCode)
//                  }
//              }
//          }
//
//
//    func updateUI()
//    {
//
//
//    }

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
            return myCustomArray.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMyAccountVc", for: indexPath) as! cellMyAccountVc
        // Configure the cell
          switch indexPath.section {
          case 0:
             // cell.textLabel?.text = "Sending Limits, Row \(indexPath.row)"
//              cell.labelDailyName.text = "Daily"
              cell.labelDailyName.text = myCustomArray[indexPath.row].name
              cell.labelConsumed.text = myCustomArray[indexPath.row].limit
              cell.progressbar.progressTintColor = myCustomArray[indexPath.row].colour
              cell.progressbar.progressViewStyle = .bar
              cell.progressbar.trackTintColor = UIColor(hexString: "#F2F6F9", alpha: 1)
              cell.labelRemaining.text = "3000000"
              var totaldailyLimit = availableLimitObj?.data?.totalDailyLimit
              var ConsumedDailyLimit = availableLimitObj?.data?.dailyConsumed
              let percent = calculateValue(total: (totaldailyLimit!),userValue: ConsumedDailyLimit!)
                     print(percent)
              cell.progressbar.cornerRadius = 5
              cell.progressbar.progress = Float(percent)
              cell.buttonEdit.tag = indexPath.row
              cell.buttonEdit.addTarget(self, action:  #selector(buttonpress(_:)), for: .touchUpInside)
          case 1:
             // cell.textLabel?.text = "Receiving Limits, Row \(indexPath.row)"
              cell.labelDailyName.text = myCustomArray[indexPath.row].name
              
              cell.labelConsumed.text = myCustomArray[indexPath.row].limit
              cell.progressbar.progressTintColor = myCustomArray[indexPath.row].colour
              cell.progressbar.progressViewStyle = .bar
              cell.progressbar.trackTintColor = UIColor(hexString: "#F2F6F9", alpha: 1)
              cell.progressbar.cornerRadius = 5
              cell.labelRemaining.text = "3000000"
              cell.buttonEdit.tag = indexPath.row
              cell.buttonEdit.addTarget(self, action:  #selector(buttonpress(_:)), for: .touchUpInside)
          default:
              break
          }
        return cell
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
    init(name : String , limit : String  ,colour :UIColor ){
        self.limit = limit
        self.name = name
        self.colour = colour
    }
}
