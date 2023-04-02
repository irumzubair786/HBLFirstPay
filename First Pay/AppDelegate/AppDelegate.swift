//
//  AppDelegate.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 12/11/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
//import OneSignal
import Siren
import IQKeyboardManager
//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
   
    func getAppInfo()->String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return version + "(" + build + ")"
    }
    
    func getOSInfo()->String {
        let os = ProcessInfo().operatingSystemVersion
        return String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
    }
    
    static var dateformatter :DateFormatter =
            {
                let dateformat = DateFormatter()
                dateformat.dateFormat = "YYYY-MM-DD"
                return dateformat
            }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared().isEnabled = true
       
        if !UserDefaults.standard.bool(forKey: "firstTimeLaunchOccurred"){
            KeychainWrapper.standard.removeAllKeys()
//            print("\(KeychainWrapper.standard.removeAllKeys())")
            UserDefaults.standard.set(true, forKey: "firstTimeLaunchOccurred")
        }
        
        // Siren Pod for Version Check
        self.setupSiren()
//        //OneSignal Start
//        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
//                  // This block gets called when the user reacts to a notification received
//                  let payload: OSNotificationPayload? = result?.notification.payload
//
////                  print("Message: \(payload!.body)")
//
//            if let notiMessage = payload!.body {
//                let saveSuccessful : Bool = KeychainWrapper.standard.set(notiMessage, forKey: "notiMessage")
////                print("Notification Message SuccessFully Added to KeyChainWrapper \(saveSuccessful)")
//            }
//
////            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
////            let homePage = mainStoryboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
////            homePage.notificationMessage = payload?.body
////            self.window?.rootViewController = homePage
//
////                  print("badge number:", payload?.badge ?? "nil")
////                  print("notification sound:", payload?.sound ?? "nil")
//
//                  if let additionalData = result!.notification.payload!.additionalData {
////                      print("additionalData = \(additionalData)")
//
//                  }
//              }
//
//        //Remove this method to stop OneSignal Debugging
//         OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
//
//         //START OneSignal initialization code
//         let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: false]
//
//
//         OneSignal.initWithLaunchOptions(launchOptions,
//           appId: "12bac3c2-4ee7-41aa-9176-52c5bc4e1a7d",
//           handleNotificationAction: notificationOpenedBlock,
//           settings: onesignalInitSettings)
//
//         OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
//         OneSignal.promptForPushNotifications(userResponse: { accepted in
////           print("User accepted notifications: \(accepted)")
//         })
        //OneSignal Start


        return true
    }
    
    func setupSiren() {
        let sirenObj = Siren.sharedInstance
//
        // If app is available only in Pakistan AppStore
        sirenObj.countryCode = "PK"
        // Optional
        sirenObj.delegate = self as? SirenDelegate
        
        // Optional
        sirenObj.debugEnabled = true
        
//        sirenObj.showAlertAfterCurrentVersionHasBeenReleasedForDays = 0
        sirenObj.alertType = .force
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        self.window?.isHidden = true
    }
//
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        self.ExitOnJailbreak()
        self.window?.isHidden = false
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Jail Break Check
    
    func isJailbroken() -> Bool {
        
        if TARGET_IPHONE_SIMULATOR != 1 {
            // Check 1 : existence of files that are common for jailbroken devices
            if FileManager.default.fileExists(atPath: "/Applications/Cydia.app")
                || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib")
                || FileManager.default.fileExists(atPath: "/bin/bash")
                || FileManager.default.fileExists(atPath: "/usr/sbin/sshd")
                || FileManager.default.fileExists(atPath: "/etc/apt")
                || FileManager.default.fileExists(atPath: "/private/var/lib/apt/")
                || UIApplication.shared.canOpenURL(URL(string:"cydia://package/com.example.package")!)
                || UIApplication.shared.canOpenURL(URL(string:"/Applications/Cydia.app")!)
                || UIApplication.shared.canOpenURL(URL(string:"/Library/MobileSubstrate/MobileSubstrate.dylib")!)
                || UIApplication.shared.canOpenURL(URL(string:"/bin/bash")!)
                || UIApplication.shared.canOpenURL(URL(string:"/usr/sbin/sshd")!)
                || UIApplication.shared.canOpenURL(URL(string:"/etc/apt")!)
                || UIApplication.shared.canOpenURL(URL(string:"/usr/bin/ssh")!)
                || UIApplication.shared.canOpenURL(URL(string:"cydia:package/com.example.package")!){
                
//                print("JailBreak Device")
                return true
            }
            
            // Check 2 : Reading and writing in system directories (sandbox violation)
            
            let stringToWrite = "Jailbreak Test"
            do{
                try stringToWrite.write(toFile:"/private/JailbreakTest.txt", atomically:true, encoding:String.Encoding.utf8)
//                print("JailBreak Device")
                return true
            }
            catch{
                return false
            }
        }
        else{
//            print("Running on Simmulator")
            return false
        }
    }
    
    // MARK: -  Call this Jail Break Check
    
    func ExitOnJailbreak() {
        
        if isJailbroken() == true {
            // Exit the app if Jailbroken
            let alert = UIAlertController(title: "JailBreak Device", message:"This app is not supported on JailBreak Devices", preferredStyle: UIAlertControllerStyle.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil) }))
            // show the alert
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            
            
        }
    }

  
}

