//
//  EnableDisableTouchFaceIDVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 09/05/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper


class EnableDisableTouchFaceIDVC: BaseClassVC {
    
    var termsAccepted:Bool?
    @IBOutlet weak var checkboxButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeLanguage()
        termsAccepted = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action Methods
    
    @IBOutlet weak var lblhome: UILabel!
    @IBOutlet weak var lblContactus: UILabel!
    @IBOutlet weak var lblBookme: UILabel!
    @IBOutlet weak var lblInviteFriend: UILabel!
    
    @IBOutlet weak var lbliphone: UILabel!
    @IBOutlet weak var lblAcceptsTA: UILabel!
    func ChangeLanguage()
    {
   
//        lblhome.text = "Home".addLocalizableString(languageCode: languageCode)
//        lblInviteFriend.text = "Invite Friends".addLocalizableString(languageCode: languageCode)
//        lblBookme.text = "Tickets".addLocalizableString(languageCode: languageCode)
//        lblContactus.text = "Contact Us".addLocalizableString(languageCode: languageCode)
//        lbliphone.text = "iPhone".addLocalizableString(languageCode: languageCode)
//        lblAcceptsTA.text = "Please accept Terms & Conditions".addLocalizableString(languageCode: languageCode)
//        lblTouchId.text = "Touch ID/ Face ID".addLocalizableString(languageCode: languageCode)
//        lblDeviceName.text = "Device Name".addLocalizableString(languageCode: languageCode)
//        btnTermsConditions.setTitle("Terms & Conditions".addLocalizableString(languageCode: languageCode), for: .normal)
//        btnDeactivate.setTitle("Deactivate".addLocalizableString(languageCode: languageCode), for: .normal)
//        btnActivate.setTitle("Acitivate".addLocalizableString(languageCode: languageCode), for: .normal)
//        lblDisclamer.text = "Disclaimer".addLocalizableString(languageCode: languageCode)
//        lbldetailview.text = "By enabling TouchID/FaceID Login Service any person who's TouchID are enabled on your iPhone can Login your Banking Application without using password.".addLocalizableString(languageCode: languageCode)
        
    }
    
    @IBOutlet weak var lbldetailview: UILabel!
    @IBOutlet weak var lblTouchId: UILabel!
    @IBOutlet weak var lblDeviceName: UILabel!
    @IBOutlet weak var lblDisclamer: UILabel!
    @IBOutlet weak var btnTermsConditions: UIButton!
    @IBOutlet weak var btnActivate: UIButton!
    @IBOutlet weak var btnDeactivate: UIButton!
    @IBAction func acceptTermsPressed(_ sender: Any) {
//        termsAccepted = !termsAccepted!
//        
//        if termsAccepted! {
//            checkboxButton.setImage(#imageLiteral(resourceName: "checkbox_state2"), for: .normal)
//        }
//            
//        else {
//            checkboxButton.setImage(#imageLiteral(resourceName: "checkbox_state1"), for: .normal)
//        }
    }
    @IBAction func TermsAndConditionPressed(_ sender: Any) {
//
//        let webVC = self.storyboard?.instantiateViewController(withIdentifier:"WebViewVC") as! WebViewVC
//            webVC.forTouchIDTerms = true
//            webVC.forHTML = true
//            self.navigationController?.pushViewController(webVC, animated: true)
       
           
        
    }
    
    @IBAction func activateIDButtonPressed(_ sender: Any) {
        
 
//        if self.termsAccepted! {
            
//            let consentAlert = UIAlertController(title: "Alert", message: "Are you sure you want to enable FingerPrint Login?".addLocalizableString(languageCode: languageCode), preferredStyle: UIAlertControllerStyle.alert)
//
//            consentAlert.addAction(UIAlertAction(title: "Yes".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
//                let saveAccountPreview : Bool = KeychainWrapper.standard.set(true, forKey: "enableTouchID")
//
//                print("Successfully Added to KeyChainWrapper \(saveAccountPreview)")
//                self.showAlert(title: "Successfully Activated".addLocalizableString(languageCode: languageCode) , message: "", completion: {
//                    self.navigationController?.popViewController(animated: true)
//                })
////
//            }))
            
//            consentAlert.addAction(UIAlertAction(title: "Cancel".addLocalizableString(languageCode: languageCode), style: .cancel, handler: { (action: UIAlertAction!) in
//    //            print("Handle Cancel Logic here")
//                self.dismiss(animated: true, completion:nil)
//            }))
//
//            present(consentAlert, animated: true, completion: nil)
//
//
//        }
//        else{
//            self.showDefaultAlert(title: "Terms & Conditions".addLocalizableString(languageCode: languageCode), message: "Please accept Terms & Conditions".addLocalizableString(languageCode: languageCode))
        }
    }
    @IBAction func deActivateIDButtonPressed(_ sender: Any) {
//        let unSaveAccountPreview : Bool = KeychainWrapper.standard.set(false, forKey: "enableTouchID")
//        print("Successfully Added to KeyChainWrapper \(unSaveAccountPreview)")
//        self.showToast(title: "Successfully Deactivated")
        
    }
    @IBAction func backButtonPressed(_ sender: Any) {
//        let homeVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//        self.navigationController!.pushViewController(homeVC, animated: true)
    }
    
    @IBAction func invitefriend(_ sender: UIButton) {
//        let vc = self.storyboard!.instantiateViewController(withIdentifier: "InviteFriendVC") as! InviteFriendVC
//        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func golootlo(_ sender: UIButton) {
//        UtilManager.showAlertMessage(message: "Coming Soon", viewController: self)
//        let vc = UIStoryboard(name: "Messages", bundle: Bundle.main).instantiateViewController(withIdentifier: "MessagesChat") as! MessagesChat
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func contactus(_ sender: UIButton) {
//        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
//        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func tickets(_ sender: UIButton) {
//       let  vc = self.storyboard!.instantiateViewController(withIdentifier: "BookMeVC") as! BookMeVC
//       self.navigationController!.pushViewController(vc, animated: true)
    }
    
}
