//
//  ToggleMenuVC.swift
//  First Pay
//
//  Created by Irum Butt on 25/12/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import UIKit
import KYDrawerController
import SwiftyRSA
import MHWebViewController
import GolootloWebViewLibrary
import RNCryptor
import SwiftKeychainWrapper
import WebKit
var CheckLanguage = ""
var ThemeSelection = ""
var  dateString  : String?
class ToggleMenuVC:  BaseClassVC , UITableViewDelegate, UITableViewDataSource , WKNavigationDelegate, UINavigationControllerDelegate{
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        lblAccountTitle.text = DataManager.instance.accountTitle
        lblAccountNumber.text = DataManager.instance.accountNo
        lblEmail.text = ""
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var btnProfileImg: UIButton!
    @IBOutlet var tableView: UITableView!
   
    @IBOutlet weak var lblAccountTitle: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        lblAccountTitle.text = DataManager.instance.accountTitle
        lblAccountNumber.text = DataManager.instance.accountNo
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count is ", sideItemsArr.count)
        print("countimg  is ", sideBarImgsArr.count)
        return sideItemsArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideBarCell", for: indexPath) as! SideBarCell
        cell.lblLevel.isHidden = true
        cell.btnUpgrade.isHidden = true
        cell.delegate = self
        cell.lblLevel.tag = indexPath.row
        
        if indexPath.row == 1
        {
            
            cell.lblLevel.isHidden = false
            cell.btnUpgrade.isHidden = false
            
        }
        else{
            cell.lblLevel.isHidden = true
            cell.btnUpgrade.isHidden = true
        }
        if indexPath.row == 9
            
        {
            cell.buttonSidebar.setTitleColor(UIColor.red, for: .normal)
        }
        let tag  = indexPath.row
        let languageCode = UserDefaults.standard.string(forKey: "language-Code") ?? "en"
        cell.buttonSidebar.setTitle((sideItemsArr[indexPath.row]), for: .normal)
        
        cell.sideBarImgView.image = UIImage(named: sideBarImgsArr[indexPath.row])
        cell.buttonSidebar.tag = indexPath.row
        cell.buttonSidebar.addTarget(self, action: #selector(buttontaped), for: .touchUpInside)
//        self.lblAccountNumber.text = "Account No : \((DataManager.instance.accountNo) ?? "")"

        return cell
    }
    @objc func buttontaped(_sender:UIButton)
    {
        
        let tag = _sender.tag

        let cell = tableView.cellForRow(at: IndexPath(row: tag, section: 0)) as! SideBarCell
         if cell.buttonSidebar.tag ==  9
        {
             popUpLogout()
         }
        else
        {
            UtilManager.showAlertMessage(message: "Coming Soon", viewController: self)
        }
        
    }

    let encryptionkey = "65412399991212FF65412399991212FF65412399991212FF"
  
    var sideMenuOpen = false
    let pickerAccountType = UIPickerView()
    
    let sideItemsArr   :[String] =  ["Login Methods","My Account & Limits","Branch/ATM Locator","My Transactions","My Approvals", "Maintenance Certificate","FAQ's", "Terms & Conditions","Contact Us","Log Out"]
   //Group 427321287.transactions 1
       var sideBarImgsArr: [String] =   ["FingerPrint 1","user 2","BranchLocator","transactions 1","myApproval","Maintenance Certoficate","FAQ","Terms and","Group 427321287","Logout"]
   
       
    
    
    
    private var plainData =  "UserId=TFMB&Password=vrWgqRccDZWTbTxz&FirstName=Golootlo&LastName=User&Phone=00000000348"
    
    
    private var plainDataLive = "UserId=TFMB&Password=YpBTLdMMkfWQdFSM&FirstName=\(DataManager.instance.firstName ?? "")&LastName=\(DataManager.instance.lastName ?? "")&Phone=\(Int( DataManager.AccountNo) ?? 0)"
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

private func batteryLevelChanged()
{
    UserDefaults.standard.synchronize()
    DataManager.accountPic = ""
    UserDefaults.standard.setValue(nil, forKey: "proImage")
    KeychainWrapper.standard.set(true, forKey: "enableTouchID")
}

    
    
    func accesstablviewcell()
    {
//        let tag = _sender.tag
        let indexPath = IndexPath(row: 0, section:0)
        let aCell = tableView.cellForRow(at: indexPath) as!
        SideBarCell

        print("acess cell")

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
      
        let drawer = self.parent as! KYDrawerController
        let navCtrl = drawer.mainViewController as! UINavigationController
        switch indexPath.row {
        case 0:
            showAlert(title: "", message: "Coming Soon", completion: nil)
//            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//
//            navCtrl.pushViewController(homeVC, animated: true)
            break
        case 1:
            showToast(title: "Coming Soon")
//            let enableTouchIDVC = self.storyboard?.instantiateViewController(withIdentifier: "EnableDisableTouchFaceIDVC") as! EnableDisableTouchFaceIDVC
//            navCtrl.pushViewController(enableTouchIDVC, animated: true)
            break
        case 2:
            UtilManager.showAlertMessage(message: "Coming Soon", viewController: self)
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AvailableLimitsVC") as! AvailableLimitsVC
//            navCtrl.pushViewController(vc, animated: true)
            break
        case 3:
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
//            navCtrl.pushViewController(vc, animated: true)
            break
//        case 4:
//            let vc = UIStoryboard(name: "Messages", bundle: Bundle.main).instantiateViewController(withIdentifier: "MessagesChat") as! MessagesChat
//            navCtrl.pushViewController(vc, animated: true)
//            break
        case 4:
//            let webVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
//            webVC.forHTML = true
//            webVC.forFaqs = true
//            navCtrl.pushViewController(webVC, animated: true)
            break
          case 5:
//            let webVC = self.storyboard?.instantiateViewController(withIdentifier:"WebViewVC") as! WebViewVC
//            webVC.forHTML = true
//            webVC.forTerms = true
//            self.navigationController?.pushViewController(webVC, animated: true)
            break
        case 6:
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LimitManagementMainVc") as! LimitManagementMainVc
//            navCtrl.pushViewController(vc, animated: true)
            break
        case 7:
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BranchAtmLocatrMainVC") as! BranchAtmLocatrMainVC
//            navCtrl.pushViewController(vc, animated: true)
            break
        case 8:
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MaintenanceCertificateVC") as! MaintenanceCertificateVC
//            vc.documentData = createPDF()
//            navCtrl.pushViewController(vc, animated: true)
//
            break

        case 9:
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SocialMediaVC") as! SocialMediaVC
//            navCtrl.pushViewController(vc, animated: true)
            break
//        case 11:
//
//
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmailSideDrawerVC") as! EmailSideDrawerVC
//            navCtrl.pushViewController(vc, animated: true)
            
            break
        case 10:
            self.popUpLogout()
            break
        case 11:
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ThemeSelectionVC") as! ThemeSelectionVC
//             navCtrl.pushViewController(vc, animated: true)
            break
        default:
           
            drawer.setDrawerState(.closed, animated: true)
        }
        drawer.setDrawerState(.closed, animated: true)
    }
    
    
    func createPDF() -> Data {
        let html = getHTML()
        let fmt = UIMarkupTextPrintFormatter(markupText: html)

        // 2. Assign print formatter to UIPrintPageRenderer

        let render = UIPrintPageRenderer()
        render.addPrintFormatter(fmt, startingAtPageAt: 0)

        // 3. Assign paperRect and printableRect

        let page = CGRect(x: 0, y: 0, width: 595.2, height: 430.0) // A4, 72 dpi
        let printable = page.insetBy(dx: 0, dy: 0)

        render.setValue(NSValue(cgRect: page), forKey: "paperRect")
        render.setValue(NSValue(cgRect: printable), forKey: "printableRect")
       
        // 4. Create PDF context and draw

        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)

        for i in 1...render.numberOfPages {
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPage(at: i - 1, in: bounds)
        }

        UIGraphicsEndPDFContext();

        return pdfData as Data
    }

    
    var userCnic : String?
    func getcnic()
    {
      
    if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
        userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
    }
    else{
        userCnic = ""
    }
//        <img src="app_logo-1" width="32" height="32">
        
}
    func getHTML() -> String {
        return """
            <p style='margin: 0cm 0cm 0cm 72pt;font-family: "Times New Roman", serif;line-height: 24px;'><span style="font-size:24px;line-height: 36px;font-family: Arial, sans-serif;">
        <img src= "app_logo-1.png"
             width="30"
             height="30" />
               
                The HBL Microfinance Bank Ltd</span></p>
                <div style="border-style: none none solid;border-bottom-width: 1pt;border-bottom-color: windowtext;padding: 0cm 0cm 1pt;">
                    <p style='margin: 0cm;font-size:16px;font-family: "Times New Roman", serif;border: none;padding: 0cm;'>&nbsp; &nbsp;&nbsp;</p>
                </div>
                <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: right;'><span style="font-size:13px;">&nbsp;</span></p>
                <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: right;'><span style="font-size:13px;">&nbsp;</span></p>
                <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: right;'><span style="font-size:13px;">&nbsp;</span></p>
                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">Date: \(dateString! ?? "")</span></p>
                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><strong><u><span style="font-family: Calibri, sans-serif;">ACCOUNT MAINTENANCE CERTIFICATE&nbsp;</span></u></strong></p>
                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><strong><u><span style="font-family: Calibri, sans-serif;"><span style="text-decoration: none;">&nbsp;</span></span></u></strong></p>
                <p style='margin: 0cm;font-family: "Times New Roman", serif;line-height: 24px;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-size:15px;font-family: Calibri, sans-serif;">This is to certify that&nbsp;</span><strong><span style="font-size:13px;font-family: Calibri, sans-serif;"> \(DataManager.instance.accountTitle! ?? "") &nbsp; &nbsp;</span></strong><span style="font-size:13px;font-family: Calibri, sans-serif;">having <strong>CNIC   \(userCnic! ?? "")  </strong>&nbsp;</span><span style="font-size:15px;font-family: Calibri, sans-serif;">is maintaining &nbsp;</span><span style="font-size:15px;font-family: Calibri, sans-serif;">account &nbsp;A/C#</span><strong><span style="font-size:13px;font-family: Calibri, sans-serif;"> \(DataManager.instance.accountNo! ?? ""). &nbsp;</span></strong><span style="font-size:15px;font-family: Calibri, sans-serif;"> <strong></strong></span>
                <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: justify;'><span style="font-size:15px;font-family: Calibri, sans-serif;">&nbsp;</span></p>
                <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: justify;'><span style="font-size:15px;font-family: Calibri, sans-serif;">&nbsp;</span></p>
                <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: justify;line-height: 24px;'><span style="font-size:15px;line-height: 22px;font-family: Calibri, sans-serif;">This certificate is issued on request of the customer without taking any risk and responsibility&nbsp;</span></p>
                <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: justify;line-height: 24px;'><span style="font-size:15px;line-height: 22px;font-family: Calibri, sans-serif;">on undersigned and part of the bank.</span></p>
                <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: justify;line-height: 24px;'><span style="font-size:15px;line-height: 22px;font-family: Calibri, sans-serif;">&nbsp;</span></p>
                <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: justify;line-height: 24px;'><span style="font-size:15px;line-height: 22px;font-family: Calibri, sans-serif;">&nbsp;</span></p>
                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;"> The HBL Microfinance Bank </span></p>
                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">16<sup>th</sup> &amp; 17<sup>th</sup> Floor HBL Tower,</span></p>
                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">Blue Area, Islamabad</span></p>
                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">Toll Free 0800-34778 or 0800-42563</span></p>
                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
                
        """

    }
    
   
}

extension ToggleMenuVC : SideMenuCellDelegate{
    func MenuTap(tag: Int) {
//        ["Fingerprint Login","My Account & Limits","Branch/ATM Locator","My Transactions","My Approvals","Change Password","Maintenance Certificate","FAQ's", "Terms & Conditions", "Log Out"]

         if sideItemsArr[tag] == "Fingerprint Login"
        {
            self.dismiss(animated: true)
        }
        else if(sideItemsArr[tag] == "My Account & Limit" ){
            
            Switcher.presentPrivacyPolicy(viewController: self)
        }
        else if (sideItemsArr[tag]  == "Branch/ATM Locator")
        {
            Switcher.presentAboutus(viewController: self)
        }
                
    }
}
                
                
                
                
                
                
                
                
        
    


