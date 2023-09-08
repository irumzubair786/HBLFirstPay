//
//  MainPageVC.swift
//  First Pay
//
//  Created by Irum Butt on 23/12/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import UIKit
import Foundation
import KYDrawerController
import SideMenu
import Alamofire

class MainPageVC: BaseClassVC {
    var sideMenu:  UISideMenuNavigationController!
    var selectedTabIndex  = 0
    var messgcount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
        sideMenuSetup()
        addChildViewController(VC: DashBoardVC)
        imgPromtionsPopup.isHidden = true
        imgQRPopup.isHidden = true
        imgMyAccountPopup.isHidden = true
        tapGestures()
        NotificationCenter.default.addObserver(self, selector: #selector(sideMenuSelectedOption(notification:)), name: NSNotification.Name(rawValue: "post"), object: nil)
        
        
       
        
        // Do any additional setup after loading the view.
    }
    
    func tapGestures(){
        
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(btnsideMenuAction(tapGestureRecognizer:)))
        toggleMenu.isUserInteractionEnabled = true
        toggleMenu.addGestureRecognizer(tapGestureRecognizer3)
    }
    @objc func btnsideMenuAction(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let storyBoard = UIStoryboard(name: Storyboard.TabBar.rawValue, bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ToggleMenuVC") as! ToggleMenuVC
        
       
        if let presentedViewController = self.presentedViewController {

            // yourViewController is currently presenting a view controller modally
        } else {
            // yourViewController is not presenting a view controller modally
            
            present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        }
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    var modelExpiredCnicVerification: ModelExpiredCnicVerification? {
        didSet {
            
        }
    }
    @IBOutlet weak var imgHome: UIImageView!
    @IBOutlet weak var imgLocation: UIImageView!

    
    
    @IBOutlet weak var imgPromtionsPopup: UIImageView!
    @IBOutlet weak var imgMyAccountPopup: UIImageView!
    @IBOutlet weak var imgQRPopup: UIImageView!
    @IBOutlet weak var myContentView: UIView!
    @IBOutlet weak var lblHome: UILabel!
    @IBOutlet weak var btnHomes: UIButton!
    @IBOutlet weak var lblLocator: UILabel!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var btnScanQR: UIButton!
    @IBOutlet weak var btnAccount: UIButton!
    @IBOutlet weak var lblAccount: UILabel!
  
    @IBOutlet weak var btnLocator: UIButton!
    @IBOutlet weak var toggleMenu: UIImageView!
    @IBAction func Action_Home(_ sender: UIButton) {
        imgHome.image = UIImage(named: "path0-6")
        imgLocation.image = UIImage(named: "BranchLocator")
        lblHome.textColor = UIColor.orange
        lblLocator.textColor = UIColor.white
        let  myDict = [ "name": "DashBoardVC"]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "post"), object: nil, userInfo: myDict)
    }
    @IBAction func Action_Notification(_ sender: UIButton) {
        print("done")
        imgLocation.image = UIImage(named: "locatorOrange")
        imgHome.image = UIImage(named: "grayHome")

        lblHome.textColor = UIColor.white
        lblLocator.textColor = UIColor.orange
//        btnLocator.setImage(UIImage(named: "Group 427320982"), for: .normal)
//        btnAccount.setImage(UIImage(named: "path0-2 copy"), for: .normal)
        let  myDict = [ "name": "ATMLocatormainVc"]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "post"), object: nil, userInfo: myDict)

    }
    

    @IBAction func Action_Main(_ sender: UIButton) {
//        showToast(title: "Coming Soon")
        self.imgQRPopup.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
        {
            self.imgQRPopup.isHidden = true
        }
//        OTPVerificationTransactionVC
        
        imgPromtionsPopup.isHidden = true
        imgMyAccountPopup.isHidden = true
//        let  myDict = [ "name": "Home_ScreenVC"]
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "post"), object: nil, userInfo: myDict)
        
//        MainView.backgroundColor =  UIColor(hexValue: 0x00CC96)
//        notificationView.backgroundColor = .clear
//        viewQuestionmark.backgroundColor = .clear
//        viewprofile.backgroundColor = .clear
//        homeView.backgroundColor = .clear
        
        
    }
    @IBAction func Action_Locator(_ sender: UIButton) {
        self.imgPromtionsPopup.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
        {
            self.imgPromtionsPopup.isHidden = true
        }
        imgPromtionsPopup.isHidden = false
        imgQRPopup.isHidden = true
        imgMyAccountPopup.isHidden = true
//        btnHome.setImage(UIImage(named: "grayHome"), for: .normal)
//        btnNotification.setImage(UIImage(named: "path0-7"), for: .normal)
//        btnLocator.setImage(UIImage(named: "Group 427320982"), for: .normal)
//        btnAccount.setImage(UIImage(named: "path0-2 copy"), for: .normal)
        
    }
    
    @IBAction func Action_Profile(_ sender: UIButton) {
        self.imgMyAccountPopup.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
        {
            self.imgMyAccountPopup.isHidden = true
        }
       
        imgPromtionsPopup.isHidden = true
        imgQRPopup.isHidden = true
//        btnHome.setImage(UIImage(named: "grayHome"), for: .normal)
//        btnNotification.setImage(UIImage(named: "path0-7"), for: .normal)
//        btnLocator.setImage(UIImage(named: "Group 427320982"), for: .normal)
//        btnAccount.setImage(UIImage(named: "Invite Prangepng"), for: .normal)
//        print("Done notification work")
//
//        let  myDict = [ "name": "ContactUSVC"]
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "post"), object: nil, userInfo: myDict)
        
        
    }
    var currentControllerName = "DashBoardVC"
//    let storyBoard = UIStoryboard(name: "Dash_Board", bundle: Bundle.main)
    lazy var DashBoardVC: DashBoardVC = {
        let storyBoard = UIStoryboard(name: Storyboard.Dash_Board.rawValue, bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DashBoardVC") as! DashBoardVC
        self.addChildViewController(vc)
        return vc
    }()
    lazy var ContactUSVC: ContactUSVC = {
        let storyBoard = UIStoryboard(name: Storyboard.ContactUs.rawValue, bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ContactUSVC") as! ContactUSVC
        self.addChildViewController(vc)
        return vc
    }()
    lazy var MobileTopUpVC: MobileTopUpVC = {
        let storyBoard = UIStoryboard(name: Storyboard.TopUp.rawValue, bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: "MobileTopUpVC") as! MobileTopUpVC
        self.addChildViewController(vc)
        return vc
    }()
    lazy var ATMLocatormainVc: ATMLocatormainVc = {
        let storyBoard = UIStoryboard(name: Storyboard.ATMLocator.rawValue, bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ATMLocatormainVc") as! ATMLocatormainVc
        self.addChildViewController(vc)
        return vc
    }()
    
    
    @objc func sideMenuSelectedOption(notification : NSNotification) {
        
        let selectedController = notification.userInfo!["name"]! as! String
        
        
        print(selectedController)
        
        if selectedController == "LogOut" {
            
        }
        //========= removing ViewController from Container View
        if currentControllerName == selectedController {
            return
        }else{
            switch currentControllerName {
            case  "DashBoardVC":                                // Actual
                removeVC(VC:DashBoardVC)
            case  "ContactUSVC":
                removeVC(VC:ContactUSVC)
            case "MobileTopUpVC":
                removeVC(VC: MobileTopUpVC)
            case "ATMLocatormainVc":
                removeVC(VC: ATMLocatormainVc)
//            case "ToggleMenuVC":
//               removeVC(VC: ToggleMenuVC)
//            case "RegisterationVC":
//                removeVC(VC: RegisterationVC)
                // local variable
//            case  "NotificationVC":                                // Actual VC name (Capital)
//                removeVC(VC:NotificationVC)
//            case  "ProfileVc":                                // Actual VC name (Capital)
//                removeVC(VC:ProfileVc)
//            case  "OnceVC":                                // Actual VC name (Capital)
//                removeVC(VC:OnceVC)
//            case  "MyCartVc":                                // Actual VC name (Capital)
//                removeVC(VC:MyCartVc)
//            case  "NoofMaidsVc":                                // Actual VC name (Capital)
//                removeVC(VC:NoofMaidsVc)
//            case  "NoofHoursVC":                                // Actual VC name (Capital)
//                removeVC(VC:NoofHoursVC)
//            case  "PropertyVc":                                // Actual VC name (Capital)
//                removeVC(VC:PropertyVc)
//
            
            default:
                print("No Controller Is Removed !!!!!!!!!!!!!")
                return
            }
            currentControllerName = selectedController
        }
     
        //======== adding viewController in container view
        if selectedController == "DashBoardVC"{ addChildViewController(VC: DashBoardVC)
            
        }
        else  if selectedController == "ContactUSVC"{ addChildViewController(VC:  ContactUSVC) }
        
        else if selectedController == "MobileTopUpVC"
        {
            addChildViewController(VC: MobileTopUpVC)
        }
        else if selectedController == "ATMLocatormainVc"
        {
            addChildViewController(VC: ATMLocatormainVc)
        }
//        else if selectedController == "ToggleMenuVC"
//        {
//            addChildViewController(VC: ToggleMenuVC)
//        }
//        else  if selectedController == "NotificationVC"{ addChildViewController(VC:  NotificationVC) }
//        else  if selectedController == "ProfileVc"{ addChildViewController(VC:  ProfileVc) }
//        else  if selectedController == "OnceVC"{ addChildViewController(VC:  OnceVC) }
//        else  if selectedController == "MyCartVc"{ addChildViewController(VC:  MyCartVc) }
//        else  if selectedController == "NoofMaidsVc"{ addChildViewController(VC:  NoofMaidsVc) }
//        else  if selectedController == "NoofHoursVC"{ addChildViewController(VC:  NoofHoursVC) }
//        else  if selectedController == "PropertyVc"{ addChildViewController(VC:  PropertyVc) }
        
        
        
  
  }
    
    
    func setupPageViewController(){
        let mainBoard = UIStoryboard(name: "TabBar", bundle: Bundle.main)
        let vc = mainBoard.instantiateViewController(withIdentifier: "NewsFeedRootVC") as! NewsFeedRootVC
        
        self.addChildViewController(vc)
        addChildViewController(vc)
        view.addSubview(vc.view)
        vc.view.frame = myContentView.bounds
        vc.view.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        self.myContentView.addSubview(vc.view)
        
    }
    
    
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
          sideMenuSetup()
//        if let drawerController = self.parent?.parent as? KYDrawerController {
//            drawerController.setDrawerState(.opened, animated: true)
//        }
    }
  
    
//    sideMenu
    private func sideMenuSetup(){
        self.sideMenu = storyboard!.instantiateViewController(withIdentifier: "sideMenu") as? UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = sideMenu
        SideMenuManager.default.menuPresentMode  = .menuSlideIn
        SideMenuManager.default.menuPushStyle = .preserve
        SideMenuManager.default.menuWidth = self.view.frame.width * 0.7
        SideMenuManager.default.menuShadowRadius = 10
        SideMenuManager.default.menuShadowColor = UIColor.black
        SideMenuManager.default.menuShadowOpacity = 1
        SideMenuManager.default.menuFadeStatusBar = false
    }
    
    
}
 
extension MainPageVC {
    public func addChildViewController(VC: UIViewController){
        
        addChildViewController(VC)
        view.addSubview(VC.view)
        VC.view.frame = myContentView.bounds
        VC.view.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        myContentView.addSubview(VC.view)
    }
    public func removeVC(VC: UIViewController){
        VC.willMove(toParentViewController: nil)
        VC.view.removeFromSuperview()
        VC.removeFromParentViewController()
    }
    
}
extension MainPageVC {
    // This file was generated from JSON Schema using quicktype, do not modify it directly.
    // To parse the JSON, add this file to your project and do:
    
    // MARK: - ModelGetActiveLoan
    struct ModelExpiredCnicVerification: Codable {
        let messages: String
        let responseblock: Responseblock?
        let responsecode: Int
        let data: JSONNull?
    }
    
    // MARK: - Responseblock
    struct Responseblock: Codable {
        let responseDescr, heading, responseType, responseCode: String
        let field: String
    }
    // MARK: - Encode/decode helpers
    class JSONNull: Codable, Hashable {
        
        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
        }
        
        public var hashValue: Int {
            return 0
        }
        
        public init() {}
        
        public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
}
