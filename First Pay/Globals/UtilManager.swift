//
//  UtilManager.swift
//  WebDoc
//
//  Created by apple on 11/02/2020.
//  Copyright © 2020 apple. All rights reserved.



//UtilManager.swift
//  Webdoc Report System
//
//  Created by Hassan on 30/08/2018.
//  Copyright © 2018 WebDoc. All rights reserved.
//

import Foundation
import UIKit
import Toaster
import JHTAlertController
import MBProgressHUD
import Toast_Swift

struct UtilManager {

    static var hud:MBProgressHUD = MBProgressHUD()

    public static func showAlertMessage(message:String , viewController : UIViewController)
    {

        let alertController = JHTAlertController(title: "", message: message, preferredStyle: .alert )
        alertController.titleViewBackgroundColor = .white
        alertController.titleTextColor = .black
        alertController.alertBackgroundColor = .white
        alertController.messageFont = .systemFont(ofSize: 12)
        alertController.messageTextColor = .black
        alertController.setButtonTextColorFor(.default, to: .white)
        alertController.setButtonTextColorFor(.cancel, to: .white)
        alertController.dividerColor = .black
        alertController.hasRoundedCorners = true

        // Create the action.
        let okAction = JHTAlertAction(title: "OK", style: .cancel,  bgColor: #colorLiteral(red: 0.1254901961, green: 0.1529411765, blue: 0.2039215686, alpha: 1), handler: nil)
        alertController.addAction(okAction)

        viewController.present(alertController, animated:true, completion:nil);
    }


    //Progress Bar
    public static func showGlobalProgressHUDWithTitle(_ title:String , viewController : UIViewController)
    {
        // let window:UIWindow = UIApplication.shared.windows.last!
        hud.mode = MBProgressHUDMode.indeterminate
//        if !GlobalData.isHudShowing {
//            hud = MBProgressHUD.showAdded(to: viewController.view, animated: true)
//        }
        //        hud.bezelView.backgroundColor = UIColor.clear
        //hud.activityIndicatorColor = UIColor.lightGrayColor();
        hud.label.numberOfLines = 0
        hud.label.text = title;
        //        }
        //        return BGUtilManager.hud;
//        GlobalData.isHudShowing = true
    }
    public static func showProgress()
    {
        //        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        //        alertWindow.rootViewController = UIViewController()
        //        alertWindow.windowLevel = UIWindow.Level.alert + 1


        let window:UIWindow = UIApplication.shared.windows.last!
        hud.mode = MBProgressHUDMode.indeterminate
//        if !GlobalData.isHudShowing {
//            hud = MBProgressHUD.showAdded(to: window , animated: true)
//        }
        //        hud.bezelView.backgroundColor = UIColor.clear
        //hud.activityIndicatorColor = UIColor.lightGrayColor();
        hud.label.numberOfLines = 0
        hud.label.text = "Pleas Wait...";
        //        }
        //        return BGUtilManager.hud;
        // alertWindow.makeKeyAndVisible()
        // alertWindow.rootViewController?.

//       GlobalData.isHudShowing = true
    }



    public static func dismissGlobalHUD()
    {
        hud.hide(animated: true)
//        GlobalData.isHudShowing = false
    }

    //Toast
    public static func showToast(message: String)
    {
        //get the current VC
        let window = UIApplication.shared.keyWindow?.rootViewController
        //display the alert
        window?.view.makeToast(message, duration: 1.0, position: .center)
    }
}
