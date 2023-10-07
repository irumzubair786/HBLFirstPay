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
    var topBtnarr =  ["sendMoneyIcon", "mobileTopUpIcon", "payBillsIcon","getLoanIcon","debitCardIcon","sellAllIcon"]
    var topBtnNameArray =  ["Send Money", "Mobile Top Up", "Pay Bills","Get Loan","Debit Card","See All"]
    @IBOutlet weak var viewGreen: UIView!
    override func viewDidAppear(_ animated: Bool) {
//        banapi ()
//        playSlider()
    }
    override func viewDidDisappear(_ animated: Bool) {
        timerChangeBannerImage.invalidate()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonLoginAll.setTitle("", for: .normal)
        viewGreen.layer.cornerRadius = 8
        collectionView.delegate = self
        collectionView.dataSource = self
        btnHome.setTitle("", for: .normal)
        btnmain.setTitle("", for: .normal)
        btnQuestion.setTitle("", for: .normal)
        btnProfile.setTitle("", for: .normal)
        btnNotification.setTitle("", for: .normal)
        buttonLogin.setTitle("", for: .normal)
        updateUI()
        banapi ()
    }
//        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
//           swipeGesture.direction = .right
//           img.addGestureRecognizer(swipeGesture)
//           img.isUserInteractionEnabled = true
//        // Do any additional setup after loading the view.
//    }
//
//    @objc func handleSwipeGesture(_ sender: UISwipeGestureRecognizer) {
//        if sender.direction == .right {
//            print("left to Right")
//            // Handle the right swipe here
//            // For example, you can change the image or perform some action
//            // e.g., imageView.image = UIImage(named: "newImage")
//        }
//    }
    
    @IBOutlet weak var pageView: UIPageControl!
    
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
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
 
    @objc func changeImage() {

        if counter < banaryyString.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageView.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageView.currentPage = counter
            counter = 1
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
                for data in GlobalData.banner.data ?? [] {
                    if data.banner != nil {
                        self.banaryyString.append(data.banner ?? "") //step2
                        
                    }
                    
                }
                print("ban array is",banaryyString)
                DispatchQueue.main.async {
                    addDelegates()
                    self.playSlider()
                }
            }
        }
    }
    func addDelegates(){
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        }
    func playSlider(){
        if(!banaryyString.isEmpty){
            DispatchQueue.main.async {
                self.timerChangeBannerImage = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
            }
        }
    }
   

//    func changeImageTimerStart() {
//        timerChangeBannerImage.invalidate()
//        self.timerChangeBannerImage = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
//    }
//    @objc func changeImage() {
//        if self.banaryyString.count == 0 {
//            return()
//        }
//        if counter < self.banaryyString.count {
//            let index = IndexPath.init(item: counter, section: 0)
//
//            let url = self.banaryyString[counter].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//            img.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "Button copy"))
//            counter += 1
//        } else {
//            counter = 0
//            let index = IndexPath.init(item: counter, section: 0)
//            let url = self.banaryyString[counter].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//            img.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "Button copy"))
//            counter = 1
//        }
//    }
   
}
extension FakeLoginVc: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == sliderCollectionView
        {
            return banaryyString.count
            
        }
        else
        {
            return topBtnarr.count
        }
       return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == sliderCollectionView
        {
            let cell = sliderCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            if let vc = cell.viewWithTag(111) as? UIImageView {
                // vc.image = sliderImages[indexPath.row]
                let imgURL = URL(string: banaryyString[indexPath.row])
                vc.sd_setImage(with:(imgURL), placeholderImage: UIImage(named: "Button copy"))
               
                
            }
            return cell
        }
        else
        {
            let cella = collectionView .dequeueReusableCell(withReuseIdentifier: "cellmainfourTransaction", for: indexPath) as! cellmainfourTransaction
            cella.btn.setTitle("", for: .normal)
            cella.btn.tag = indexPath.row
            cella.img.image = UIImage(named: topBtnarr[indexPath.row])
            cella.lblName.text = topBtnNameArray[indexPath.row]
//            cella.btn.addTarget(self, action: #selector(buttontaped), for: .touchUpInside)
            //        cella.img.image = topBtnarr[indexPath.row
            return cella
        }

        
    }
}
extension FakeLoginVc: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == sliderCollectionView
        {
            let size = self.sliderCollectionView.frame.size
            return CGSize(width: size.width, height: size.height)
        }
        else
        {
            let itemsInRow = 4
            let height = collectionView.bounds.height
            let width = collectionView.bounds.width - 5
            let cellWidth = width / CGFloat(itemsInRow)
            return CGSize(width: cellWidth, height: height)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
