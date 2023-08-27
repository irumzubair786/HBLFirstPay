//
//  FakeLoginVc.swift
//  First Pay
//
//  Created by Irum Butt on 18/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Kingfisher
import CryptoSwift
import SDWebImage
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
class FakeLoginVc: UIViewController {
    let pageIndicator = UIPageControl()
    var counter = 0
    var banArray = [UIImage]()
    var timerChangeBannerImage = Timer()
    var banaryyString =  [String]()
    
    @IBOutlet weak var viewGreen: UIView!
    override func viewDidAppear(_ animated: Bool) {
        changeImageTimerStart()
    }
    override func viewDidDisappear(_ animated: Bool) {
        timerChangeBannerImage.invalidate()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonLoginAll.setTitle("", for: .normal)
        viewGreen.layer.cornerRadius = 8
        
        btnHome.setTitle("", for: .normal)
        btnmain.setTitle("", for: .normal)
        btnQuestion.setTitle("", for: .normal)
        btnProfile.setTitle("", for: .normal)
        btnNotification.setTitle("", for: .normal)
        buttonLogin.setTitle("", for: .normal)
        updateUI()
        banapi ()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBOutlet weak var buttonLogin: UIButton!
    
    @IBOutlet weak var buttonLoginAll: UIButton!
    @IBOutlet weak var imageLogin: UIImageView!
    @IBAction func buttonLogin(_ sender: UIButton) {
//        self.showAlertCustomPopup() { button in
//            print(button)
//            print(button)
//        }
        if isfromHomwWithoutCreationAccount == false
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login_VC") as! Login_VC
            vc.moveToSignUp = {
                DispatchQueue.main.async {
                    self.moveToSignUp(isFromDeviceAuthentication: true)
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    func loginAction()
    {
        if isfromHomwWithoutCreationAccount == true
        {
            
           
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
            labelLoginorSignUp.isUserInteractionEnabled = true
            labelLoginorSignUp.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)    {
        moveToSignUp()
    }
    
    func moveToSignUp(isFromDeviceAuthentication: Bool? = false) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Mobile_VerificationVC") as! Mobile_VerificationVC
        vc.isFromLoginScreen = isFromDeviceAuthentication!
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var btnmain: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnQuestion: UIButton!
    
    @IBOutlet weak var labelLoginorSignUp: UILabel!
    @IBOutlet weak var img: UIImageView!
    func updateUI()
    {
        if let _ = UserDefaults.standard.value(forKey: "AlreadyRegistered") as? String {
            isfromHomwWithoutCreationAccount = false
        }
        else {
            isfromHomwWithoutCreationAccount = true
        }
        if isfromHomwWithoutCreationAccount == true {
            imageLogin.image = UIImage(named: "Button copy")
        }
        else {
            imageLogin.image = UIImage(named: "btnLogin")
        }
    }
    func banapi ()
    {
        loginAction()
        ServerManager.GEt_typeWithoutParmsfetchApiData_PostAppJSON(APIMethodName: APIMethods.banner.rawValue, Token: DataManager.instance.accessToken ?? "" ) { [self] (Result : MYBanersModel?) in
            
            //== check if api is responding or not
            guard Result != nil else {
                //                UtilManager.showAlertMessage(message: "No Internet Connection...", viewController: self)
                
                return
            }
            
            GlobalData.banner = Result!
            print("Result",Result!)
            print("token is :",GlobalData.banner.data[0].brandCode)
            if GlobalData.banner.responsecode == 1 {
                for data in GlobalData.banner.data {
                    if data.banner != nil {
                        self.banaryyString.append(data.banner!) //step2
                        
                    }
                    
                }
                print("ban array is",banaryyString)
                DispatchQueue.main.async {
                    self.changeImageTimerStart()
                }
            }
        }
    }
    
    func changeImageTimerStart() {
        timerChangeBannerImage.invalidate()
        self.timerChangeBannerImage = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
    }
    @objc func changeImage() {
        if self.banaryyString.count == 0 {
            return()
        }
        if counter < self.banaryyString.count {
            let index = IndexPath.init(item: counter, section: 0)
            
            let url = self.banaryyString[counter].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            img.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "Button copy"))
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            let url = self.banaryyString[counter].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            img.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "Button copy"))
            counter = 1
        }
    }
}
