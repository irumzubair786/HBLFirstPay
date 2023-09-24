//
//  DisableBioLoginDrawerVC.swift
//  First Pay
//
//  Created by Irum Zubair on 24/09/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import FittedSheets
class DisableBioLoginDrawerVC: BaseClassVC {
    weak var delegate: SwitchValueDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
   
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var viewdisble: UIView!
    @IBOutlet weak var buttonNotNow: UIButton!
    @IBOutlet weak var buttonDisable: UIButton!
    @IBAction func buttonDisable(_ sender: UIButton) {
        delegate?.switchValueChanged(newValue: true)
               // Dismiss the second view controller
              
        UserDefaults.standard.removeObject(forKey: "enableTouchID")
        buttonDisable.setTitleColor(.white, for: .normal)
        buttonDisable.backgroundColor = UIColor(hexString: "CC6801")
        let unSaveAccountPreview : Bool = KeychainWrapper.standard.set(false, forKey: "enableTouchID")
        print("Successfully Added to KeyChainWrapper \(unSaveAccountPreview)")
        self.showToast(title: "Successfully Deactivated")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    @IBAction func buuttonDismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
        
    }
    
    
    
}

protocol DisableDrawer {
    static var name: String { get }
    func openPicker(from parent: UIViewController , id : String , in view: UIView?)
    
}

extension DisableDrawer {
    static func addSheetEventLogging(to sheet: SheetViewController) {
        let previousDidDismiss = sheet.didDismiss
        sheet.didDismiss = {
            print("did dismiss")
            previousDidDismiss?($0)
        }
        
        let previousShouldDismiss = sheet.shouldDismiss
        sheet.shouldDismiss = {
            print("should dismiss")
            return previousShouldDismiss?($0) ?? true
        }
        
        let previousSizeChanged = sheet.sizeChanged
        sheet.sizeChanged = { sheet, size, height in
            print("Changed to \(size) with a height of \(height)")
            previousSizeChanged?(sheet, size, height)
        }
    }
}

