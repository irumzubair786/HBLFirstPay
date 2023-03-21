//
//  ScanNLVC.swift
//  First Pay
//
//  Created by Arsalan Amjad on 04/09/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit
import Toaster
import Alamofire
import AlamofireObjectMapper
import GolootloWebViewLibrary
import SwiftyRSA
import SafariServices
import SwiftKeychainWrapper
import Nuke
class ScanNLVC: BaseClassVC, UITextFieldDelegate {
  var flag = "true"
    var scancnic : String?
  
    @IBOutlet weak var lblScanurCnic: UILabel!
    @IBOutlet weak var lblMintitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        ConvertLanguage()
        scantxtfield.delegate = self
        scantxtfield.resignFirstResponder()
        scantxtfield.keyboardType = .namePhonePad
        btnverify.isHidden = true
//          btnscan.isHidden = true
        self.hideKeyboardWhenTappedAround()
       
    }
      @IBOutlet weak var lblhome: UILabel!
       @IBOutlet weak var lblContactus: UILabel!
       @IBOutlet weak var lblBookme: UILabel!
       @IBOutlet weak var lblInviteFriend: UILabel!
    
    
    func ConvertLanguage()
    {
        lblhome.text = "Home".addLocalizableString(languageCode: languageCode)
                lblInviteFriend.text = "Invite Friends".addLocalizableString(languageCode: languageCode)
                lblBookme.text = "Tickets".addLocalizableString(languageCode: languageCode)
                lblContactus.text = "Contact Us".addLocalizableString(languageCode: languageCode)
        lblMintitle.text = "Nano Loan".addLocalizableString(languageCode: languageCode)
        lblScanurCnic.text = "Scan Your Cnic Number".addLocalizableString(languageCode: languageCode)
        scantxtfield.placeholder = "Scan CNIC Number".addLocalizableString(languageCode: languageCode)
        btnverify.setTitle("Verify".addLocalizableString(languageCode: languageCode), for: .normal)
        btnscan.setTitle("Scan".addLocalizableString(languageCode: languageCode), for: .normal)
        
        
    }
    @IBOutlet weak var btnverify: UIButton!
    var userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
   
    @IBAction func logout(_ sender: UIButton) {
        self.popUpLogout()
        
    }
   
    @IBAction func verfiy(_ sender: UIButton) {
        //            changes

        if scantxtfield.text != userCnic
        {
            UtilManager.showAlertMessage(message: "CNIC not Match".addLocalizableString(languageCode: languageCode), viewController: self)
        }
        else{

            
            showAlert(title: "Successfully Verified!", message: "Successfully Verified your cnic number".addLocalizableString(languageCode: languageCode), completion: {
                        let vc = self.storyboard!.instantiateViewController(withIdentifier: "NLApplyVC") as! NLApplyVC
                print(self.scantxtfield.text)
                vc.fetchcnicdata = self.scantxtfield.text
                      self.navigationController!.pushViewController(vc, animated: true)
            
        })
   
   
    }
}
  
    @available(iOS 13.0, *)
    @IBAction func backpressed(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "MainNanoLoanVC") as! MainNanoLoanVC
        self.navigationController!.pushViewController(vc, animated: true)
        
        
    }
   
    
    @IBOutlet weak var scantxtfield: UITextField!
    
    @IBOutlet weak var btnscan: UIButton!
    
    @available(iOS 13.0, *)
    @IBAction func scanbtn(_ sender: UIButton) {
    
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "barCodeVC") as! barCodeVC
        vc.returnScanvalue = {
            response in
//            self.scantxtfield.text = "3310521837437"
            self.scantxtfield.text = response
            self.btnscan.isHidden = true
            self.btnverify.isHidden = false
        }
            self.navigationController!.pushViewController(vc, animated: true)
            
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
       
        if textField == scantxtfield{
            scantxtfield.isUserInteractionEnabled = true
            return newLength <= 13
//
        }
        else {
//
            return newLength <= 13
        }
    }
 
    @IBAction override func bookMePressed(_ sender: Any) {
        let bookMeVC = self.storyboard!.instantiateViewController(withIdentifier: "BookMeVC") as! BookMeVC
       
        self.navigationController!.pushViewController(bookMeVC, animated: true)
    }
    @IBAction override func careemPressed(_ sender: Any) {
        ///self.goToCareem()
        let inviteFriendVC = self.storyboard?.instantiateViewController(withIdentifier: "InviteFriendVC") as! InviteFriendVC
        self.navigationController?.pushViewController(inviteFriendVC, animated: true)
    }
    @IBAction override func golootloPressed(_ sender: Any) {
        self.showToast(title: "Coming Soon")
//        UtilManager.showAlertMessage(message: "Coming Soon", viewController: self)
      //  self.golootlo()
//        let vc = UIStoryboard(name: "Messages", bundle: Bundle.main).instantiateViewController(withIdentifier: "MessagesChat") as! MessagesChat
//        navigationController?.pushViewController(vc, animated: true)
    }

    
    @IBAction func contactus(_ sender: UIButton) {
        let inviteFriendVC = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        self.navigationController?.pushViewController(inviteFriendVC, animated: true)
    }
    
    @IBAction func home(_ sender: UIButton) {
        let inviteFriendVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(inviteFriendVC, animated: true)
        
    }
    
}
