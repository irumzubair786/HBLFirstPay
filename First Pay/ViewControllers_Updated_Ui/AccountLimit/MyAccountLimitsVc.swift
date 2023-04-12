//
//  MyAccountLimitsVc.swift
//  First Pay
//
//  Created by Irum Butt on 11/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class MyAccountLimitsVc: UIViewController {
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
    override func viewDidLoad() {
        super.viewDidLoad()
        appendVlaluesToArray()
        buttonBack.setTitle("", for: .normal)
        tableView.delegate = self
        tableView.dataSource = self
        buttonUpgrade.setTitle("UPGRADE", for: .normal)
        buttonUpgrade.setTitleColor(.white, for: .normal)
        tableView.rowHeight = 100
        
        // Do any additional setup after loading the view.
    }
    func appendVlaluesToArray(){
       
        myCustomArray.append(a(name: "Daily ", limit: "20,000", colour: UIColor(hexString: "#F8CC59", alpha: 1)))
        myCustomArray.append(a(name: "Monthly ", limit: "30,000", colour: UIColor(hexString: "#1EC884", alpha: 1)))
        myCustomArray.append(a(name: "Yearly ", limit: "40,000", colour: UIColor(hexString: "#F19434", alpha: 1)))
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
    
    func calculateValue(total:Double , userValue:Double)->Double{
            return (userValue/total)
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
              let percent = calculateValue(total: 10000, userValue: 2000)
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
