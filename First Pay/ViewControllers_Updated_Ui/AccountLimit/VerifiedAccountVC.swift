//
//  VerifiedAccountVC.swift
//  First Pay
//
//  Created by Irum Butt on 08/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class VerifiedAccountVC: UIViewController {
    var levelCode :String?
   
    var totalMonthlyLimitDr : Int?
    var totalYearlyLimitDr : Int?
    var totalDailyLimitCr : Int?
    var totalMonthlyLimitCr : Int?
    var totalYearlyLimitCr : Int?
    var balanceLimit : Int?
    var  totalDailyLimitDr: Int?
    var totalDailyLimitDr1 : Int?
    var totalMonthlyLimitDr1 : Int?
    var totalYearlyLimitDr1 : Int?
    var totalDailyLimitCr1 : Int?
    var totalMonthlyLimitCr1 : Int?
    var totalYearlyLimitCr1 : Int?
    var balanceLimit1 : Int?
    
    var comabalanceLimit : String?
    var comabalanceLimit1 : String?
    var comatotalDailyLimitDr : String?
    var comatotalMonthlyLimitDr : String?
    var comatotalYearlyLimitDr : String?
    var comatotalDailyLimitCr : String?
    var comatotalMonthlyLimitCr : String?
    var comatotalYearlyLimitCr : String?
   
    
    var comatotalDailyLimitDr1 : String?
    var comatotalMonthlyLimitDr1 : String?
    var comatotalYearlyLimitDr1 : String?
    var comatotalDailyLimitCr1 : String?
    var comatotalMonthlyLimitCr1 : String?
    var comatotalYearlyLimitCr1 : String?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonBack.setTitle("", for: .normal)
        
        CommaSepration()
       
        
        fetchDataFromApi()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var buttonBack: UIButton!
    @IBAction func buttonBack(_ sender: UIButton) {
        self.dismiss(animated: true)
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
        labelBalnaceLimitLevel0.text = "\(comabalanceLimit!)"
        labelBalnaceLimitLevel1.text =  "\(comabalanceLimit1!)"
        
        labelDailyLimitCrlevel0.text = "\(comatotalDailyLimitCr!)"
        labelDailyLimitCrlevel1.text = "\(comatotalDailyLimitCr1!)"
        
        labelMonthlyLimitCrlevel0.text = "\(comatotalMonthlyLimitCr!)"
        labelMonthlyLimitCrlevel1.text = "\(comatotalMonthlyLimitCr1!)"
        
        labelYearlyLimitCrlevel0.text = "\(comatotalYearlyLimitCr!)"
        labelYearlyLimitCrlevel1.text = "\(comatotalYearlyLimitCr1!)"
        
        
        labelDailyLimitDrlevel0.text = "\(comatotalDailyLimitDr!)"
        labelDailyLimitDrlevel1.text = "\(comatotalDailyLimitDr1!)"
        
        labelMonthlyLimitDrlevel0.text = "\(comatotalMonthlyLimitDr!)"
        labelMonthlyLimitDrlevel1.text = "\(comatotalMonthlyLimitDr1!)"
        
        labelYearlyLimitDrlevel0.text = "\(comatotalYearlyLimitDr!)"
        labelYearlyLimitDrlevel1.text = "\(comatotalYearlyLimitDr1!)"
        
    }
  func CommaSepration()
    {
        let number = balanceLimit
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
//        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_US")
        comabalanceLimit = (formatter.string(from: NSNumber(value: number!)))!
        
        
        let number1 = balanceLimit1
        let formatters = NumberFormatter()
        formatters.numberStyle = .decimal
//        formatter.maximumFractionDigits = 2
        formatters.locale = Locale(identifier: "en_US")
        comabalanceLimit1 = (formatters.string(from: NSNumber(value: number1!)))

        
        let number2 = totalDailyLimitCr
        let formatterr = NumberFormatter()
        formatterr.numberStyle = .decimal
//        formatter.maximumFractionDigits = 2
        formatterr.locale = Locale(identifier: "en_US")
        comatotalDailyLimitCr = (formatterr.string(from: NSNumber(value: number2!)))
        let number3 = totalDailyLimitCr1
        let a = NumberFormatter()
        a.numberStyle = .decimal
//        formatter.maximumFractionDigits = 2
        a.locale = Locale(identifier: "en_US")
        comatotalDailyLimitCr1 = (a.string(from: NSNumber(value: number3!)))
                                  
                                  
        let number4 = totalMonthlyLimitCr
        let b = NumberFormatter()
        b.numberStyle = .decimal
//        formatter.maximumFractionDigits = 2
        b.locale = Locale(identifier: "en_US")
      comatotalMonthlyLimitCr = (b.string(from: NSNumber(value: number4!)))
        
        let number5 = totalMonthlyLimitCr1
        let c = NumberFormatter()
        c.numberStyle = .decimal
//        formatter.maximumFractionDigits = 2
        c.locale = Locale(identifier: "en_US")
        comatotalMonthlyLimitCr1 = (c.string(from: NSNumber(value: number5!)))
        
        let number6 = totalYearlyLimitCr
        let d = NumberFormatter()
        d.numberStyle = .decimal
//        formatter.maximumFractionDigits = 2
        d.locale = Locale(identifier: "en_US")
        comatotalYearlyLimitCr = (d.string(from: NSNumber(value: number6!)))
        
        let number7 = totalYearlyLimitCr1
        let e = NumberFormatter()
        e.numberStyle = .decimal
//        formatter.maximumFractionDigits = 2
        e.locale = Locale(identifier: "en_US")
        comatotalYearlyLimitCr1 = (e.string(from: NSNumber(value: number7!)))
        
        
        
        
        let number8 = totalDailyLimitDr
        let x = NumberFormatter()
        x.numberStyle = .decimal
//        formatter.maximumFractionDigits = 2
        x.locale = Locale(identifier: "en_US")
        comatotalDailyLimitDr = (x.string(from: NSNumber(value: number8!)))
        let number9 = totalDailyLimitDr1
        let y = NumberFormatter()
        y.numberStyle = .decimal
//        formatter.maximumFractionDigits = 2
        y.locale = Locale(identifier: "en_US")
         comatotalDailyLimitDr1 = (y.string(from: NSNumber(value: number9!)))
        let number10 = totalMonthlyLimitDr
        let z = NumberFormatter()
        z.numberStyle = .decimal
//        formatter.maximumFractionDigits = 2
        z.locale = Locale(identifier: "en_US")
        comatotalMonthlyLimitDr = (z.string(from: NSNumber(value: number10!)))
        
        
        let num = totalMonthlyLimitDr1
        let f = NumberFormatter()
        f.numberStyle = .decimal
//        formatter.maximumFractionDigits = 2
        f.locale = Locale(identifier: "en_US")
        comatotalMonthlyLimitDr1 = (f.string(from: NSNumber(value: num!)))
        
        
        
        let numbe = totalYearlyLimitDr
        let h = NumberFormatter()
        h.numberStyle = .decimal
//        formatter.maximumFractionDigits = 2
        h.locale = Locale(identifier: "en_US")
    comatotalYearlyLimitDr = (h.string(from: NSNumber(value: numbe!)))
        
        
        
        let no = totalYearlyLimitDr1
        let k = NumberFormatter()
        k.numberStyle = .decimal
//        formatter.maximumFractionDigits = 2
        k.locale = Locale(identifier: "en_US")
        comatotalYearlyLimitDr1 = (k.string(from: NSNumber(value: no!)))
        
        
        
        
        
    }
}
