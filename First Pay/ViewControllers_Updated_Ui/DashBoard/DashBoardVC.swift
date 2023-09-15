//
//  DashBoardVC.swift
//  First Pay
//
//  Created by Irum Butt on 04/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import RNCryptor
import Kingfisher
import CryptoSwift
import SDWebImage
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
import SideMenu
import FingerprintSDK

var isfromReactivateCard :Bool?
var isFromDeactivate : Bool?
var isFromChangePin : Bool?
var isfromActivate : Bool?
//var isfromServics : Bool?
var isfromATMON : Bool?
var isfromATMOFF : Bool?
var isfromPOSON : Bool?
var isfromPOSOFF: Bool?
var isfromDisableService : Bool?
var isfromServiceOTpVerification : Bool?
var isfromOTPHblmfb : Bool?
class DashBoardVC: BaseClassVC , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var homeObj : HomeModel?
    var banObj : GenericResponse?
    var getDebitDetailsObj : GetDebitCardModel?
    var availableLimitObj: AvailableLimitsModel?
    var topBtnarr =  ["SendMoney", "Mobile Topup", "PayBill","First Option","DebitCard","SeeAll"]
    var fingerPrintVerification: FingerPrintVerification!
    var fingerprintPngs : [Png]?
   
    var modelAcccountLevelUpgradeResponse: FingerPrintVerification.ModelAcccountLevelUpgradeResponse? {
        didSet {
            print(modelAcccountLevelUpgradeResponse)
            if modelAcccountLevelUpgradeResponse?.responsecode == 1 {
                NotificationCenter.default.post(name: Notification.Name("updateAccountLevel"), object: nil)
                let viewController = UIStoryboard.init(name: "AccountLevel", bundle: nil).instantiateViewController(withIdentifier: "AccountUpgradeSuccessullVC") as! AccountUpgradeSuccessullVC
                viewController.accountUpGradeSuccessfull = {
                    self.getActiveLoan()
                }
                DispatchQueue.main.async {
                    self.present(viewController, animated: true)
                }
            }
            else if modelAcccountLevelUpgradeResponse?.responsecode == 0 {
                self.showAlertCustomPopup(message: modelAcccountLevelUpgradeResponse?.messages ?? "No Message from API") {_ in
                    
                }
            }
            else {
                self.showAlertCustomPopup(message: "ERROR IN RESPONSE API") {_ in
                    
                }
            }
        }
    }

    @IBOutlet weak var imgSeeAll: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        changeImageTimerStart()
    }
    override func viewDidDisappear(_ animated: Bool) {
        timerChangeBannerImage.invalidate()
    }
    override func viewDidLoad() {
        FBEvents.logEvent(title: .Homescreen_Landing)
        super.viewDidLoad()
        banapi()
        collectionView.delegate = self
        collectionView.dataSource = self
       
        buttonLevelIcon.setTitle("", for: .normal)
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(MovetoStatement(tapGestureRecognizer:)))
        lblAmount.isUserInteractionEnabled = true
        lblAmount.addGestureRecognizer(tapGestureRecognizerr)
        AddCash()
//        imgLevel.isHidden = true
        buttonMobilepakegs.setTitle("", for: .normal)
        homeAction()
        let tapGestureRecognizerrs = UITapGestureRecognizer(target: self, action: #selector(MovetoAccountLevel(tapGestureRecognizer:)))
        imgLevel.isUserInteractionEnabled = true
        imgLevel.addGestureRecognizer(tapGestureRecognizerrs)
        
        
        let tapGestureRecognizr = UITapGestureRecognizer(target: self, action: #selector(moveToDebitCard(tapGestureRecognizer:)))
        viewDebitCard.isUserInteractionEnabled = true
        viewDebitCard.addGestureRecognizer(tapGestureRecognizr)
        
        let tapGestureRecognizrz = UITapGestureRecognizer(target: self, action: #selector(moveToInviteFriend(tapGestureRecognizer:)))
        imgInviteFriend.isUserInteractionEnabled = true
        imgInviteFriend.addGestureRecognizer(tapGestureRecognizrz)
        
        let tapGestureRecognizrzSeeAll = UITapGestureRecognizer(target: self, action: #selector(moveToSeeAll(tapGestureRecognizer:)))
//        imgSeeAll.isUserInteractionEnabled = true
        imgSeeAll.addGestureRecognizer(tapGestureRecognizrzSeeAll)
//        labelSeeAll.isUserInteractionEnabled = true
        labelSeeAll.addGestureRecognizer(tapGestureRecognizrzSeeAll)
       
//        getActiveLoan()
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector:#selector(homeAction), name: Notification.Name("updateAccountLevel"),object: nil)

        
    }
    @IBOutlet weak var toggleMenu: UIImageView!
    @IBOutlet weak var imageAddCash: UIImageView!
    @IBOutlet weak var buttonLevelIcon: UIButton!
    @IBOutlet weak var viewDebitCard: UIImageView!
    @IBAction func buttonLevelIcon(_ sender: UIButton) {
        getAvailableLimits()
    }
    @IBAction func buttonInvite(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "InviteFriends", bundle: nil).instantiateViewController(withIdentifier: "InviteAFriendsNAvigation")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }

    
    
    
    @IBOutlet weak var labelSeeAll: UILabel!
    
    @IBOutlet weak var buttonMobilepakegs: UIButton!
    @IBAction func buttonMobilepakegs(_ sender: UIButton) {
//        let vc = UIStoryboard.init(name: "Mobile Bunldles", bundle: nil).instantiateViewController(withIdentifier: "MobilePackagesNavigationController")
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true)
    }
    func AddCash(){
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(btnAddCash(tapGestureRecognizer:)))
        imageAddCash.isUserInteractionEnabled = true
        imageAddCash.addGestureRecognizer(tapGestureRecognizer3)
    }
    @objc func btnAddCash(tapGestureRecognizer: UITapGestureRecognizer) {
        FBEvents.logEvent(title: .Homescreen_addcash_click)
        let storyBoard = UIStoryboard(name: Storyboard.AddCash.rawValue, bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: "navigateToAddCash")
        self.present(vc, animated: true)
    }
    
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsInRow = 4
        let width = collectionView.bounds.width - 10
        let cellWidth = width / CGFloat(itemsInRow)
        return CGSize(width: cellWidth, height: 130)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topBtnarr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cella = collectionView .dequeueReusableCell(withReuseIdentifier: "cellmainfourTransaction", for: indexPath) as! cellmainfourTransaction
        cella.btn.setTitle("", for: .normal)
        cella.btn.tag = indexPath.row
        cella.img.image = UIImage(named: topBtnarr[indexPath.row])
        cella.btn.addTarget(self, action: #selector(buttontaped), for: .touchUpInside)
        //        cella.img.image = topBtnarr[indexPath.row
        return cella
    }
    @objc func buttontaped(_sender:UIButton) {
        let tag = _sender.tag
        let cell = collectionView.cellForItem(at: IndexPath(row: tag, section: 0)) as! cellmainfourTransaction
        if tag == 0 {
            FBEvents.logEvent(title: .Homescreen_sendmoney_click)
            let storyboard = UIStoryboard(name: "SendMoney", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SendMoney_MainVc")
            self.present(vc, animated: true)
        }
        else if tag == 1 {
            FBEvents.logEvent(title: .Homescreen_topup_click)
            let storyboard = UIStoryboard(name: "TopUp", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "movtToTopUp")
            self.present(vc, animated: true)
            
        }
        else if tag == 2 {
            FBEvents.logEvent(title: .Homescreen_paybills_click)
            let storyboard = UIStoryboard(name: "BillPayment", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "moveToBillpayment")
           
            self.present(vc, animated: true)
        }
       
        else if tag == 3 {
            FBEvents.logEvent(title: .Homescreen_getloan_click)
            if DataManager.instance.accountLevel == "LEVEL 0" {
//               call sdk
//                let decode = [[
//                    "fingerIndex" : 2,
//                    "fingerTemplate" : 2,
//                    "templateType" : "hbb"
//                ],
//                [
//                    "fingerIndex" : 3,
//                    "fingerTemplate" : 3,
//                    "templateType" : "bb"
//                ],
//                [
//                    "fingerIndex" : 4,
//                    "fingerTemplate" : 4,
//                    "templateType" : "oo"
//                ],
//                [
//                    "fingerIndex" : 5,
//                   "fingerTemplate" : 5,
//                    "templateType" : "gg"
//                ],
//                [
//                    "fingerIndex" : 7,
//                    "fingerTemplate" : 7,
//                    "templateType" : "hh"
//                ],
//                [
//                    "fingerIndex" : 8,
//                    "fingerTemplate" : 8,
//                    "templateType" : "hjg"
//                ],
//                [
//                    "fingerIndex" : 9,
//                    "fingerTemplate" : 9,
//                    "templateType" : "jj"
//                ],
//                [
//                    "fingerIndex" : 10,
//                    "fingerTemplate" : 10,
//                    "templateType" : "nn"
//                ]]
//
//
//                self.acccountLevelUpgrade(fingerprints: decode)
//                return
                fingerPrintVerification = FingerPrintVerification()
                DispatchQueue.main.async {
                    self.fingerPrintVerification(viewController: self)
                }
                //                dummy finger print api calling
                //                self.acccountLevelUpgrade(fingerprints: fingerPrintDataHardCoded)
            }
           else {
               getActiveLoan()
               //                dummy finger print api calling
               //                self.acccountLevelUpgrade(fingerprints: fingerPrintDataHardCoded)
            }
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if tag == 4 {
            getDebitCard()
        }
       
    }
    
    var modelNanoLoanEligibilityCheck: NanoLoanApplyViewController.ModelNanoLoanEligibilityCheck? {
      didSet {
            if modelNanoLoanEligibilityCheck?.responsecode ?? 0 == 0 {
                showAlertCustomPopup(title: "Alert", message: modelNanoLoanEligibilityCheck?.messages ?? "", iconName: .iconError)
            }
            else {
                openNanoLoan()
            }
        }
    }
    
    func nanoLoanEligibilityCheck() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)"
        ]
        APIs.postAPI(apiName: .nanoLoanEligibilityCheck, parameters: parameters) { responseData, success, errorMsg in
            let model: NanoLoanApplyViewController.ModelNanoLoanEligibilityCheck? = APIs.decodeDataToObject(data: responseData)
            self.modelNanoLoanEligibilityCheck = model
        }
    }
    
    
    var modelGetActiveLoan: NanoLoanApplyViewController.ModelGetActiveLoan? {
        didSet {
            
            if modelGetActiveLoan?.data?.currentLoan.count ?? 0 > 0 {
                self.openNanoLoan()
            }
            else {
                nanoLoanEligibilityCheck()
            }
        }
    }
   

    func getActiveLoan() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)"
        ]
        APIs.postAPI(apiName: .getActiveLoan, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: NanoLoanApplyViewController.ModelGetActiveLoan? = APIs.decodeDataToObject(data: responseData)
            self.modelGetActiveLoan = model
        }
    }
    
    func openNanoLoan() {
        let vc = UIStoryboard.init(name: "NanoLoan", bundle: nil).instantiateViewController(withIdentifier: "NanoLoanContainerNavigatior")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    var comabalanceLimit : String?
    func CommaSepration()
    {
        var number = Double(self.getCurrentBal!)
        var formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        //        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_US")
        comabalanceLimit = (formatter.string(from: NSNumber(value: number)))!
    }
    
    let pageIndicator = UIPageControl()
    var counter = 0
    var banArray = [UIImage]()
    var timerChangeBannerImage = Timer()
    var banaryyString =  [String]()
    
    @IBOutlet weak var buttonInvite: UIButton!
    
    @IBOutlet weak var imgLevel: UIImageView!
    
    @IBOutlet weak var imgInviteFriend: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var LblMobNo: UILabel!
    @IBOutlet weak var img: UIImageView!

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

    @objc func homeAction() {
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()

        //        showActivityIndicator()
        
        //        let compelteUrl = GlobalConstants.BASE_URL + "home"
        //
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/home"
        // IPA Paramsself    FirstPay.DashBoardVC    0x00007fbba2061000
        let params = ["":""] as [String : Any]
        
         let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken  ?? "nil")"]
        
        
        print(params)
        print(compelteUrl)
        print(header)
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response { [self]
//            (response: DataResponse<HomeModel>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            
//            self.homeObj = response.result.value
            
            if response.response?.statusCode == 200 {
                self.homeObj = Mapper<HomeModel>().map(JSONObject: json)

//                self.homeObj = response.result.value
                if self.homeObj?.responsecode == 2 || self.homeObj?.responsecode == 1 {
                 
                    self.saveInDataManager(index: 0)
                 
                    self.hideActivityIndicator()
//                    banapi()
//
                }
                else {
                    if let message = self.homeObj?.messages{
                        self.showAlert(title: "", message: message, completion: nil)
                    }
                }
            }
            else {
                //                self.showAlert(title: "", message: "Something Went Wrong", completion:nil)
                                print(response.value)
                                print(response.response?.statusCode)
            }
        }
    }
    var getCurrentBal : Double?
    private func saveInDataManager(index : Int){
//
        getCurrentBal =  homeObj?.userData?[0].currentBalance
        CommaSepration()
        lblAmount.text =   "Rs.\(comabalanceLimit!)"
        lblName.text =  homeObj?.userData?[0].accountTitile
        LblMobNo.text =  homeObj?.userData?[0].accountNo
        DataManager.instance.mobile_number = homeObj?.userData?[0].accountNo
        DataManager.instance.accountTitle =
        homeObj?.userData?[0].accountTitile
        DataManager.instance.accountNo =
        homeObj?.userData?[0].accountNo
                DataManager.instance.balancedate = homeObj?.userData?[0].balanceDate
       
                DataManager.instance.lastamount = Int(self.homeObj?.userData?[index].lasttransamt ?? 0)
                DataManager.instance.customerId = self.homeObj?.userData?[index].customerId
                DataManager.instance.firstName = self.homeObj?.userData?[index].firstName
                DataManager.instance.lastName = self.homeObj?.userData?[index].lastName
                DataManager.instance.middleName = self.homeObj?.userData?[index].middleName
                DataManager.instance.accountId = self.homeObj?.userData?[index].accountId
                DataManager.instance.accountAlias = self.homeObj?.userData?[index].accountAlias
                DataManager.instance.accountNo = self.homeObj?.userData?[index].accountNo
                DataManager.instance.balanceDate = self.homeObj?.userData?[index].balanceDate
                DataManager.instance.currentBalance = self.homeObj?.userData?[index].currentBalance
                DataManager.instance.accountType = self.homeObj?.userData?[index].accountType
                DataManager.instance.serverAccountTitile = self.homeObj?.userData?[index].accountTitile
                DataManager.instance.insured = self.homeObj?.userData?[index].insured
        
        
        var accountName : String?
        if KeychainWrapper.standard.hasValue(forKey: "accountTitle") {
            accountName = KeychainWrapper.standard.string(forKey: "accountTitle")
            DataManager.instance.accountTitle = accountName
            var accountype : String?
            if KeychainWrapper.standard.hasValue(forKey: "accounttype"){
                DataManager.instance.accountType = accountype
            }
            
            
        }
        else {
            DataManager.instance.accountTitle = self.homeObj?.userData?[index].accountTitile
        }
        DataManager.instance.accountType = self.homeObj?.userData?[index].accountType
        print("Account Type is ",  DataManager.instance.accountType as Any)
        if self.homeObj?.userData?[index].levelDescr == "LEVEL 1"
        {
            imgLevel.isHidden = false
//            please change level here.... level 0 replace by level 1
            DataManager.instance.accountLevel = "LEVEL 1"
            imgLevel.image = UIImage(named: "Verified 24x")
        }
        else
        {
            imgLevel.isHidden = false
            DataManager.instance.accountLevel = "LEVEL 0"
            imgLevel.image = UIImage(named: "Un-Verified 24x")
        }
        
     
        //        NotificationCenter.default.addObserver(self, selector: #selector(updateProfilePhoto), name: Notification.Name("batteryLevelChanged"), object: nil)
    }
    
    func banapi ()
    {

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
    
    @objc func MovetoStatement(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let storyboard = UIStoryboard(name: "MiniStatement", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MinistatemnetMainVc")
        self.present(vc, animated: true)
    }
      
    @objc func moveToDebitCard(tapGestureRecognizer: UITapGestureRecognizer)
    {
        getDebitCard()
    }
    
    
    @objc func moveToInviteFriend(tapGestureRecognizer: UITapGestureRecognizer) {
        let vc = UIStoryboard.init(name: "InviteFriends", bundle: nil).instantiateViewController(withIdentifier: "InviteFriendsAddNumber") as! InviteFriendsAddNumber
        self.present(vc, animated: true)
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func moveToSeeAll(tapGestureRecognizer: UITapGestureRecognizer) {
//        FBEvents.logEvent(title: .Homescreen_seeall_click)
//        let vc = storyboard?.instantiateViewController(withIdentifier: "OtherServices_VC") as! OtherServices_VC
//        self.present(vc, animated: true)
//        self.navigationController?.pushViewController(vc, animated: true)
       
    }
    @objc func MovetoAccountLevel(tapGestureRecognizer: UITapGestureRecognizer) {
        getAvailableLimits()
    }
    
    // MARK: - Api Call
    var checkDebitCardObj : GetDebitCardCheckModel?
    private func getDebitCardCheck() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        var userCnic : String?
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "DebitCard/v1/debitCardEligibilityCheck"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["imei":"\(DataManager.instance.imei!)","cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)"]
        
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
         let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
//            (response: DataResponse<GetDebitCardCheckModel>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            self.checkDebitCardObj = Mapper<GetDebitCardCheckModel>().map(JSONObject: json)
            
//            self.checkDebitCardObj = response.result.value
            if response.response?.statusCode == 200 {
                if self.checkDebitCardObj?.responsecode == 2 || self.checkDebitCardObj?.responsecode == 1 {
                            let storyboard = UIStoryboard(name: "DebitCard", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "moveToDebitCard")
                            self.present(vc, animated: true)
                }
                  else
                    {
                      if let message = self.checkDebitCardObj?.messages
                      {
                          if message == "Debit Card Already Exists"
                          {
                              let storyboard = UIStoryboard(name: "DebitCard", bundle: nil)
                              let vc = storyboard.instantiateViewController(withIdentifier: "movetoDebitCardActivate")
                              self.present(vc, animated: true)
                          }

                  }
                      
                  }
                      
                  
              
                }
              
                }
            
        
    }
    
    private func getDebitCard() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }

        self.showActivityIndicator()
        
        var userCnic : String?
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        let compelteUrl = GlobalConstants.BASE_URL + "DebitCard/v1/getDebitCards"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters : Parameters = ["cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!]
        
        print(parameters)

        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
         let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        print(params)
        print(compelteUrl)
        print(header)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
//            (response: DataResponse<GetDebitCardModel>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            self.getDebitDetailsObj = Mapper<GetDebitCardModel>().map(JSONObject: json)
            
//            self.getDebitDetailsObj = response.result.value
            print(self.getDebitDetailsObj)
        
            if response.response?.statusCode == 200 {
               
                if self.getDebitDetailsObj?.responsecode == 2 || self.getDebitDetailsObj?.responsecode == 1 {
                    if self.getDebitDetailsObj?.debitCardData != nil{
                        GlobalData.accountDebitCardId = self.getDebitDetailsObj?.debitCardData?[0].accountDebitCardId
                       
                        if self.getDebitDetailsObj?.debitCardData?[0].apiFlow == "ActivateCard"
                        {
                            let storyboard = UIStoryboard(name: "DebitCard", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "movetoDebitCardActivate")
                            self.present(vc, animated: true)
                        }
                        else if self.getDebitDetailsObj?.debitCardData?[0].apiFlow == "DeactivateCard"
                        {
                            
                            let storyboard = UIStoryboard(name: "DebitCard", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "movetoCardDeactivation")
                           isFromDeactivate  = true
                            self.present(vc, animated: true)
                            
                            
                        }
                        else if self.getDebitDetailsObj?.debitCardData?[0].apiFlow == "ReactivateCard"
                        {
                            let storyboard = UIStoryboard(name: "DebitCard", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "movetoDebitCardActivate")
                            isfromReactivateCard = true
                            self.present(vc, animated: true)
                        }
         
                    }
                    else
                    {
                        
                        if self.getDebitDetailsObj?.newCarddata != nil{
                            if
                                self.getDebitDetailsObj?.newCarddata?.apiFlow == "NewCard"
                            {
                                let storyboard = UIStoryboard(name: "DebitCard", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "moveToDebitCard")
                                self.present(vc, animated: true)
                            }
                            else if self.getDebitDetailsObj?.newCarddata?.apiFlow == "DeactivateCard"
                            {
                                
                                let storyboard = UIStoryboard(name: "DebitCard", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "movetoCardDeactivation")
                                self.present(vc, animated: true)
                                
                            }
                        }
                        
                    }
                    
                }
                else {
                    if let message = self.getDebitDetailsObj?.messages{
                        self.showAlertCustomPopup(title: "", message: message, iconName: .iconError)


                    }
                }
            }
            else {
                if let message = self.getDebitDetailsObj?.messages{
                    self.showAlertCustomPopup(title: "", message: message, iconName: .iconError)
                    
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    ////    ----------getaccountlimits
        private func getAvailableLimits() {
      //
              if !NetworkConnectivity.isConnectedToInternet(){
                  self.showToast(title: "No Internet Available")
                  return
              }
      
              showActivityIndicator()
              var userCnic : String?
              if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
                  userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
              }
              else{
                  userCnic = ""
              }
            userCnic = UserDefaults.standard.string(forKey: "userCnic")
      
      //        let compelteUrl = GlobalConstants.BASE_URL + "getAccLimits"
              let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/getLevelLimits"
      
              let parameters : Parameters = ["cnic":userCnic!, "accountType" : DataManager.instance.accountType ?? "20", "imeiNo": DataManager.instance.imei!,"channelId": DataManager.instance.channelID ]
      
              print(parameters)
      
      
              let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
      
              let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
      
      
               let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
      
              print(params)
              print(compelteUrl)
      
      
              NetworkManager.sharedInstance.enableCertificatePinning()
      
      
              NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
//                  (response: DataResponse<AvailableLimitsModel>) in
      
                  response in
                  self.hideActivityIndicator()
                  guard let data = response.data else { return }
                  let json = try! JSONSerialization.jsonObject(with: data, options: [])
                  self.availableLimitObj = Mapper<AvailableLimitsModel>().map(JSONObject: json)
//                  self.availableLimitObj = response.result.value
      
                  if response.response?.statusCode == 200 {
      
                      if self.availableLimitObj?.responsecode == 2 || self.availableLimitObj?.responsecode == 1 {
      
                          self.updateUI()
      //                                    self.fromlevel1()
                      }
                      else {
                          if let message = self.availableLimitObj?.messages{
                              self.showAlertCustomPopup(title: "",message: message, iconName: .iconError)
                          }
                      }
                  }
                  else {
                      if let message = self.availableLimitObj?.messages{
                          self.showAlertCustomPopup(title: "",message: message, iconName: .iconError)
                      }
    //                  print(response.result.value)
    //                  print(response.response?.statusCode)
                  }
              }
          }
    private func updateUI(){
        
        if DataManager.instance.accountLevel == "LEVEL 0" {
            FBEvents.logEvent(title: .Homescreen_Myaccount_click)
            
            let vc = UIStoryboard(name: "AccountLevel", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyAccountLimitsVc") as! MyAccountLimitsVc
            if let balnceLimit = self.availableLimitObj?.limitsData?.levelLimits?[0].balanceLimit{
                vc.balanceLimit = Int(balnceLimit)
                print("balnceLimit",balnceLimit)
            }
            if let balnceLimit1 = self.availableLimitObj?.limitsData?.levelLimits?[1].balanceLimit{
                vc.balanceLimit1 = Int(balnceLimit1)
                print("balnceLimit",balnceLimit1)
            }
            
            if let dailyTotalCr = self.availableLimitObj?.limitsData?.levelLimits?[0].totalDailyLimitCr{
                vc.totalDailyLimitCr = Int(dailyTotalCr)
            }
            if let dailyTotalCr1 = self.availableLimitObj?.limitsData?.levelLimits?[1].totalDailyLimitCr{
                vc.totalDailyLimitCr1 = Int(dailyTotalCr1)
            }
            if let monthlyTotalCr = self.availableLimitObj?.limitsData?.levelLimits?[0].totalMonthlyLimitCr{
                vc.totalMonthlyLimitCr = Int(monthlyTotalCr)
            }
            if let monthlyTotalCr1 = self.availableLimitObj?.limitsData?.levelLimits?[1].totalMonthlyLimitCr{
                vc.totalMonthlyLimitCr1 = Int(monthlyTotalCr1)
            }
            if let yearlyTotalCr = self.availableLimitObj?.limitsData?.levelLimits?[0].totalYearlyLimitCr{
                vc.totalYearlyLimitCr = Int(yearlyTotalCr)
            }
            if let yearlyTotalCr1 = self.availableLimitObj?.limitsData?.levelLimits?[1].totalYearlyLimitCr{
                vc.totalYearlyLimitCr1 = Int(yearlyTotalCr1)
            }
            if let  totalDailyLimitDr = self.availableLimitObj?.limitsData?.levelLimits?[0].totalDailyLimitDr{
                vc.totalDailyLimitDr = Int(totalDailyLimitDr)
            }
            if let  totalDailyLimitDr1 = self.availableLimitObj?.limitsData?.levelLimits?[1].totalDailyLimitDr{
                vc.totalDailyLimitDr1 = Int(totalDailyLimitDr1)
            }
            if let  totalMonthlyLimitDr = self.availableLimitObj?.limitsData?.levelLimits?[0].totalMonthlyLimitDr{
                vc.totalMonthlyLimitDr = Int(totalMonthlyLimitDr)
            }
            if let totalMonthlyLimitDr1 = self.availableLimitObj?.limitsData?.levelLimits?[1].totalMonthlyLimitDr{
                vc.totalMonthlyLimitDr1 = Int(totalMonthlyLimitDr1)
            }
            if let totalYearlyLimitDr = self.availableLimitObj?.limitsData?.levelLimits?[0].totalYearlyLimitDr{
                vc.totalYearlyLimitDr = Int(totalYearlyLimitDr)
            }
            if let  totalYearlyLimitDr1 = self.availableLimitObj?.limitsData?.levelLimits?[1].totalYearlyLimitDr{
                vc.totalYearlyLimitDr1 = Int(totalYearlyLimitDr1)
            }
            self.present(vc, animated: true)
        }
        
        else if DataManager.instance.accountLevel == "LEVEL 1" {
            FBEvents.logEvent(title: .Homescreen_Myaccount_click)
            let vc = UIStoryboard(name: "AccountLevel", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyAccountLimitsVc") as! MyAccountLimitsVc
            if let balnceLimit = self.availableLimitObj?.limitsData?.levelLimits?[0].balanceLimit{
                vc.balanceLimit = Int(balnceLimit)
                print("balnceLimit",balnceLimit)
            }
            if let balnceLimit1 = self.availableLimitObj?.limitsData?.levelLimits?[1].balanceLimit{
                vc.balanceLimit1 = Int(balnceLimit1)
                print("balnceLimit",balnceLimit1)
            }
            
            if let dailyTotalCr = self.availableLimitObj?.limitsData?.levelLimits?[0].totalDailyLimitCr{
                vc.totalDailyLimitCr = Int(dailyTotalCr)
            }
            if let dailyTotalCr1 = self.availableLimitObj?.limitsData?.levelLimits?[1].totalDailyLimitCr{
                vc.totalDailyLimitCr1 = Int(dailyTotalCr1)
            }
            
            
            if let monthlyTotalCr = self.availableLimitObj?.limitsData?.levelLimits?[0].totalMonthlyLimitCr{
                vc.totalMonthlyLimitCr = Int(monthlyTotalCr)
            }
            if let monthlyTotalCr1 = self.availableLimitObj?.limitsData?.levelLimits?[1].totalMonthlyLimitCr{
                vc.totalMonthlyLimitCr1 = Int(monthlyTotalCr1)
            }
            
            
            if let yearlyTotalCr = self.availableLimitObj?.limitsData?.levelLimits?[0].totalYearlyLimitCr{
                vc.totalYearlyLimitCr = Int(yearlyTotalCr)
            }
            if let yearlyTotalCr1 = self.availableLimitObj?.limitsData?.levelLimits?[1].totalYearlyLimitCr{
                vc.totalYearlyLimitCr1 = Int(yearlyTotalCr1)
            }
            
            //        dr
            if let  totalDailyLimitDr = self.availableLimitObj?.limitsData?.levelLimits?[0].totalDailyLimitDr{
                vc.totalDailyLimitDr = Int(totalDailyLimitDr)
            }
            if let  totalDailyLimitDr1 = self.availableLimitObj?.limitsData?.levelLimits?[1].totalDailyLimitDr{
                vc.totalDailyLimitDr1 = Int(totalDailyLimitDr1)
            }
            if let  totalMonthlyLimitDr = self.availableLimitObj?.limitsData?.levelLimits?[0].totalMonthlyLimitDr{
                vc.totalMonthlyLimitDr = Int(totalMonthlyLimitDr)
            }
            if let  totalMonthlyLimitDr1 = self.availableLimitObj?.limitsData?.levelLimits?[1].totalMonthlyLimitDr{
                vc.totalMonthlyLimitDr1 = Int(totalMonthlyLimitDr1)
            }
            if let  totalYearlyLimitDr = self.availableLimitObj?.limitsData?.levelLimits?[0].totalYearlyLimitDr{
                vc.totalYearlyLimitDr = Int(totalYearlyLimitDr)
            }
            if let  totalYearlyLimitDr1 = self.availableLimitObj?.limitsData?.levelLimits?[1].totalYearlyLimitDr{
                vc.totalYearlyLimitDr1 = Int(totalYearlyLimitDr1)
            }
            self.present(vc, animated: true)
        }
    }
        func fingerPrintVerification(viewController: UIViewController) {
            //#if targetEnvironment(simulator)
            //        #else

            let customUI = CustomUI(
                topBarBackgroundImage: nil,
                topBarColor: .clrNavigationBarBVS,
                topBarTextColor: .white,
                containerBackgroundColor: UIColor.white,
                scannerOverlayColor: UIColor.clrGreenBVS,
                scannerOverlayTextColor: UIColor.white,
                instructionTextColor: UIColor.white,
                buttonsBackgroundColor: .clrNextButtonBackGroundBVS,
                buttonsTextColor: UIColor.white,
                imagesColor: .clrGreenBVS,
                isFullWidthButtons: true,
                guidanceScreenButtonText: "NEXT",
                guidanceScreenText: "User Demo",
                guidanceScreenAnimationFilePath: nil,
                showGuidanceScreen: true)

            let customDialog = CustomDialog(
                dialogImageBackgroundColor: UIColor.white,
                dialogImageForegroundColor: .green,
                dialogBackgroundColor: UIColor.white,
                dialogTitleColor: .clrGreenBVS,
                dialogMessageColor: .clrBlack,
                dialogButtonTextColor: UIColor.white,
                dialogButtonBackgroundColor: .orange)
            
            let uiConfig = UIConfig(
                splashScreenLoaderIndicatorColor: .clrBlack,
                splashScreenText: "Please wait",
                splashScreenTextColor: UIColor.white,
                customUI: customUI,
                customDialog: customDialog,
                customFontFamily: nil)
            
            let fingerprintConfig = FingerprintConfig(mode: .EXPORT_WSQ,
                                                      hand: .BOTH_HANDS,
                                                      fingers: .EIGHT_FINGERS,
                                                      isPackPng: true, uiConfig: uiConfig)
            let vc = FaceoffViewController.init(nibName: "FaceoffViewController", bundle: Bundle(for: FaceoffViewController.self))
            
            vc.fingerprintConfig = fingerprintConfig
            vc.fingerprintResponseDelegate = viewController as? FingerprintResponseDelegate
            viewController.present(vc, animated: true, completion: nil)
            //        #endif
        }
    
    
//class end
}

extension DashBoardVC: FingerprintResponseDelegate {
    func onScanComplete(fingerprintResponse: FingerprintResponse) {
        //Shakeel ! added
        if fingerprintResponse.response == Response.SUCCESS_WSQ_EXPORT {
            fingerprintPngs = fingerprintResponse.pngList
            var fingerprintsList = [FingerPrintVerification.Fingerprints]()
            
            var tempFingerPrintDictionary = [[String:Any]]()
            if let fpPNGs = fingerprintPngs {
                for item in fpPNGs {
                    guard let imageString = item.binaryBase64ObjectPNG else { return }
                    guard let instance = FingerPrintVerification.Fingerprints(fingerIndex: "\(item.fingerPositionCode)", fingerTemplate: imageString) else { return }
                    
                    tempFingerPrintDictionary.append(
                        ["fingerIndex": "\(item.fingerPositionCode)",//getFingerIndex(index: item.fingerPositionCode),
                         "fingerTemplate": imageString,
                         "templateType": "WSQ"]
                    )
                }
            }
            self.acccountLevelUpgrade(fingerprints: tempFingerPrintDictionary)
        }else {
            self.showAlertCustomPopup(title: "Faceoff Results", message: fingerprintResponse.response.message, iconName: .iconError) {_ in
                //                self.dismiss(animated: true)
            }
        }
    }
    
    override func motionCancelled(_ motion: UIEventSubtype, with event: UIEvent?) {
        self.dismiss(animated: true)
    }
    
    func acccountLevelUpgrade(fingerprints: [[String:Any]]) {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
        ]
        
        //    let apiAttribute3 = [
        //        "apiAttribute3" : fingerprints.template
        //    ]
        //    print(parameters)
        
        APIs.postAPIForFingerPrint(apiName: .acccountLevelUpgrade, parameters: parameters, apiAttribute3: fingerprints, viewController: self) {
            responseData, success, errorMsg in
            
            print(responseData)
            print(success)
            print(errorMsg)
            do {
                let json: Any? = try JSONSerialization.jsonObject(with: (responseData ?? Data()), options: [.fragmentsAllowed])
                print(json)
            }
            catch let error {
                print(error)
            }
            
            let model: FingerPrintVerification.ModelAcccountLevelUpgradeResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelAcccountLevelUpgradeResponse = model
        }
    }
}

func getFingerIndex(index: Int) -> String {
    switch index {
        case 1:
            return "1"
        case 2:
            return "2"
        case 3:
            return "3"
        case 4:
            return "4"
        case 5:
            return "5"
        case 6:
            return "6"
        case 7:
            return "7"
        case 8:
            return "8"
        case 9:
            return "9"
        case 10:
            return "10"
        default:
            return ""
    }
}

extension DashBoardVC {
    // MARK: - Welcome
    struct ModelAcccountLevelUpgrade: Codable {
        let responsecode: Int
        let data, responseblock: JSONNull?
        let messages: String
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
