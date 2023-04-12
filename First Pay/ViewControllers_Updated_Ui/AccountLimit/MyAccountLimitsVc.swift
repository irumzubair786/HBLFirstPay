//
//  MyAccountLimitsVc.swift
//  First Pay
//
//  Created by Irum Butt on 11/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
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
class MyAccountLimitsVc: UIViewController {
    
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
       
        myCustomArray.append(a(name: "Daily limit", limit: "20,000"))
        myCustomArray.append(a(name: "Monthly limit", limit: "30,000"))
        myCustomArray.append(a(name: "Yearly limit", limit: "40,000"))
    }
    @IBOutlet weak var buttonBack: UIButton!
    @IBAction func buttonBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    

    @IBAction func buttonUpgrade(_ sender: UIButton) {
        
    }
    @IBOutlet weak var buttonUpgrade: UIButton!
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonVeiwDetail: UIButton!
    @IBAction func buttonVeiwDetail(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UnVerifiedAccountVC") as! UnVerifiedAccountVC
        self.present(vc, animated: true)
        
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
              
              cell.labelRemaining.text = "3000000"
          case 1:
             // cell.textLabel?.text = "Receiving Limits, Row \(indexPath.row)"
              cell.labelDailyName.text = myCustomArray[indexPath.row].name
              
              cell.labelConsumed.text = myCustomArray[indexPath.row].limit
              cell.labelRemaining.text = "3000000"
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
    init(name : String , limit : String ){
        self.limit = limit
        self.name = name
    }
}
