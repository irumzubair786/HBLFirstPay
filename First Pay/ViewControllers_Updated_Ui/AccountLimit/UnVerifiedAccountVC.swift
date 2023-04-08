//
//  UnVerifiedAccountVC.swift
//  First Pay
//
//  Created by Irum Butt on 08/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class UnVerifiedAccountVC: UIViewController {
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonBack.setTitle("", for: .normal)
        buttonUpgrade.setTitle("UPGRADE", for: .normal)
        buttonUpgrade.setTitleColor(.white, for: .normal)
        
        fetchDataFromApi()
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var buttonUpgrade: UIButton!
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBAction func buttonBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func buttonUpgrade(_ sender: UIButton) {
        UtilManager.showAlertMessage(message: "Coming Soon", viewController: self)
    }
    
    @IBOutlet weak var labelBalnaceLimitLevel0: UILabel!
    @IBOutlet weak var labelBalnaceLimitLevel1: UILabel!
    @IBOutlet weak var labelDailyLimitCrlevel0: UILabel!
    @IBOutlet weak var labelDailyLimitCrlevel1: UILabel!
    @IBOutlet weak var labelMonthlyLimitCrlevel0: UILabel!
    @IBOutlet weak var labelMonthlyLimitCrlevel1: UILabel!
    @IBOutlet weak var labelYearlyLimitCrlevel0: UILabel!
    @IBOutlet weak var labelYearlyLimitCrlevel1: UILabel!
    
    
    @IBOutlet weak var labelDailyLimitDrlevel0: UILabel!
    @IBOutlet weak var labelDailyLimitDrlevel1: UILabel!
    @IBOutlet weak var labelMonthlyLimitDrlevel0: UILabel!
    @IBOutlet weak var labelMonthlyLimitDrlevel1: UILabel!
    @IBOutlet weak var labelYearlyLimitDrlevel0: UILabel!
    @IBOutlet weak var labelYearlyLimitDrlevel1: UILabel!
    
    
    func fetchDataFromApi()
    {
        labelBalnaceLimitLevel0.text = "\(balanceLimit!)"
        labelBalnaceLimitLevel1.text =  "\(balanceLimit1!)"
        
        labelDailyLimitCrlevel0.text = "\(totalDailyLimitCr!)"
        labelDailyLimitCrlevel1.text = "\(totalDailyLimitCr1!)"
        
        labelMonthlyLimitCrlevel0.text = "\(totalMonthlyLimitCr!)"
        labelMonthlyLimitCrlevel1.text = "\(totalMonthlyLimitCr1!)"
        
        labelYearlyLimitCrlevel0.text = "\(totalYearlyLimitCr!)"
        labelYearlyLimitCrlevel1.text = "\(totalYearlyLimitCr1!)"
        
        
        labelDailyLimitDrlevel0.text = "\(totalDailyLimitDr!)"
        labelDailyLimitDrlevel1.text = "\(totalDailyLimitDr1!)"
        
        labelMonthlyLimitDrlevel0.text = "\(totalMonthlyLimitDr!)"
        labelMonthlyLimitDrlevel1.text = "\(totalMonthlyLimitDr1!)"
        
        labelYearlyLimitDrlevel0.text = "\(totalYearlyLimitDr!)"
        labelYearlyLimitDrlevel1.text = "\(totalYearlyLimitDr1!)"
        
    }
    
}
