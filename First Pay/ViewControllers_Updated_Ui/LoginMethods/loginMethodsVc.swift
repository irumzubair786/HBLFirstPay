//
//  loginMethodsVc.swift
//  First Pay
//
//  Created by Irum Butt on 09/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import SideMenu
import FittedSheets
var flagisEnable : Bool?
protocol SwitchValueDelegate: class {
    func switchValueChanged(newValue: Bool)
}
class loginMethodsVc: BaseClassVC , DisableDrawer{
    static var name: String { "CategoryPicker" }
    weak var delegate: SwitchValueDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
//        buttonDissmiss.setTitle("", for: .normal)
        buttonback.setTitle("", for: .normal)
        viewdisble.isHidden = true
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector:#selector(dissmissViewController2), name: Notification.Name("dissmissViewController2"),object: nil)
        checkIdEnable()
    }
    
    @objc func dissmissViewController2() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismiss(animated: true)
        }
    }
    
func checkIdEnable()
    {
        if KeychainWrapper.standard.bool(forKey: "enableTouchID") == true {
            butttonEnableFaceid.isOn
        }
        else
        {
            
            butttonEnableFaceid.isOn = false
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.switchValueChanged(newValue: true)
//        checkIdEnable()
        // Your code here
    }
    
    @IBAction func butttonEnableFaceid(_ sender: UISwitch) {
        if butttonEnableFaceid.isOn  == false{
//
//            viewdisble.isHidden = false
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DisableBioLoginDrawerVC") as! DisableBioLoginDrawerVC
            openPicker(from: self, id:  "DisableBioLoginDrawerVC", in: nil)
            vc.delegate = self
            self.present(vc, animated: true)
            
            
        }
        else
        {
            
            guard let  FirsTimeLogin = UserDefaults.standard.string(forKey:  "enableTouchID")else
            {
                viewdisble.isHidden = true
                viewdisble.shadowColor = UIColor.gray
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BioMetricLoginVc") as! BioMetricLoginVc
              
                self.present(vc, animated: true)
                return
            }
        }
        
    }
    
    
    
    @IBAction func buttonChangePassowrd(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "ForgotPassword", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "navigateToChangePassword")
        self.present(vc, animated: true)
       
        
       
    }
    func animateViewSwipeDown() {
        UIView.animate(withDuration: 0.0) {
            // Change the frame of the animatedView to move it down
            self.viewdisble.frame.origin.y += 200 // Adjust the distance as needed
        }
    }

    @IBOutlet weak var buttonDissmiss: UIButton!
    @IBAction func buuttonDismiss(_ sender: UIButton) {
        animateViewSwipeDown()
        
    }
    @IBOutlet weak var buttonNotNow: UIButton!
    @IBOutlet weak var buttonDisable: UIButton!
    @IBOutlet weak var butttonEnableFaceid: UISwitch!
    @IBOutlet weak var buttonChangePassowrd: UIButton!
    @IBOutlet weak var viewdisble: UIView!
    @IBOutlet weak var buttonback: UIButton!
    @IBAction func buttonback(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func buttonDisable(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "enableTouchID")
        buttonDisable.setTitleColor(.white, for: .normal)
        buttonDisable.backgroundColor = UIColor(hexString: "CC6801")
        let unSaveAccountPreview : Bool = KeychainWrapper.standard.set(false, forKey: "enableTouchID")
        print("Successfully Added to KeyChainWrapper \(unSaveAccountPreview)")
        self.showToast(title: "Successfully Deactivated")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.dismiss(animated: true)

        }
            
        
    }
    
    @IBAction func buttonNotNow(_ sender: UIButton) {
        self.dismiss(animated: true)
        
    }
    func openPicker(from parent: UIViewController, id: String, in view: UIView?) {
            
            let useInlineMode = view != nil
            let controller = (UIStoryboard.init(name: "Face:ThumbIDLogin", bundle: Bundle.main).instantiateViewController(withIdentifier: "DisableBioLoginDrawerVC") as? DisableBioLoginDrawerVC)!
//        controller.daily = daily
//        controller.dailyAmount = dailyAmount
//        controller.dailyminValue = dailyminValue
//        controller.dailymaxValue = dailymaxValue
//        controller.tag  = tag
//        controller.delegate = self
//        controller.section = section
//        controller.refreshScreen = {
//            self.apicall()
//        }
//        controller.LimitType = LimitType
//        controller.AmounttType =  AmounttType
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
    
    
}
extension loginMethodsVc: SwitchValueDelegate {
    func switchValueChanged(newValue: Bool) {
        if KeychainWrapper.standard.bool(forKey: "enableTouchID") == true {
            butttonEnableFaceid.isOn
        }
        else
        {
            
            butttonEnableFaceid.isOn = false
        }
        
//       butttonEnableFaceid.isOn = newValue
    }
}
