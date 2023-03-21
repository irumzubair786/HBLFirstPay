//
//  HomeVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 12/11/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
import RNCryptor
import Kingfisher
import KYDrawerController
var firsttimenanoloan = "false"
var UserAppliedLoan = ""
var languageCode = "en"
var UserName : String?
var firsttimeemailCheck  = "false"
class HomeVC: BaseClassVC , UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UITextFieldDelegate {
    let encryptionkey = "65412399991212FF65412399991212FF65412399991212FF"
   
    @IBOutlet weak var lblhome: UILabel!
    
    @IBOutlet weak var lblContactus: UILabel!
   
    @IBOutlet weak var lblInviteFriend: UILabel!
    @IBOutlet weak var lblweather: UILabel!
    @IBOutlet weak var lblLasttra: UIButton!
    @IBOutlet weak var btnManagefund: UIButton!
    @IBOutlet weak var btnquickpay: UIButton!
    @IBOutlet weak var btnBillPayment: UIButton!
    @IBOutlet weak var btnsendmoney: UIButton!
    @IBOutlet weak var btnothers: UIButton!
    @IBOutlet weak var btnDiscounts: UIButton!
    @IBOutlet weak var btnMobilePayment: UIButton!
    
    @IBOutlet weak var lblTicket: UILabel!
    @IBOutlet weak var lblOthers: UILabel!
    @IBOutlet weak var lblMblTp: UILabel!
    @IBOutlet weak var lblSndMny: UILabel!
    @IBOutlet weak var lblMng: UILabel!
    @objc private func changeLanguage() {
        languageCode = UserDefaults.standard.string(forKey: "language-Code") ?? ""
        btnquickpay.setTitle("QuickPay".addLocalizableString(languageCode: languageCode), for: .normal)
        lblhome.text = "Home".addLocalizableString(languageCode: languageCode)
        lblInviteFriend.text = "Invite Friends".addLocalizableString(languageCode: languageCode)
        lblTicket.text = "Tickets".addLocalizableString(languageCode: languageCode)
        lblContactus.text = "Contact Us".addLocalizableString(languageCode: languageCode)
        lblbillpayment.text = "Nano Loan".addLocalizableString(languageCode: languageCode)
        lblMng.text = "Manage Funds".addLocalizableString(languageCode: languageCode)
        lblSndMny.text = "Send Money".addLocalizableString(languageCode: languageCode)
        lblMblTp.text = "Mobile TopUp".addLocalizableString(languageCode: languageCode)
        lblOthers.text  = "Others".addLocalizableString(languageCode: languageCode)
        lableLastTransaction.text = "Last Transaction".addLocalizableString(languageCode: languageCode)
           
    }
  
    
    
    @IBOutlet weak var emailtf: UITextField!
  
    @IBAction func SideMenu(_ sender: UIButton) {
        
//        let drawerViewController = storyboard.instantiateViewController(withIdentifier: "SideDrawerVC") as! SideDrawerVC
//           let mainViewController   = self.storyboard!.instantiateViewController(withIdentifier: "HomeNavCntlr") as! UINavigationController
//                       var drawerController:KYDrawerController? = nil
//
//                       drawerController = KYDrawerController(drawerDirection: .left,drawerWidth: 290)
//                       drawerController!.mainViewController = mainViewController
//                       drawerController!.drawerViewController = drawerViewController
        if let drawerController = self.parent?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
        
        
    }
    
    @IBAction func btndiscount_secod(_ sender: UIButton) {
        if DataManager.instance.nanoloan == "Y"
        {
            
            lbldiscount.text = "Bill Payment".addLocalizableString(languageCode: languageCode)
            imgdiscount.image = #imageLiteral(resourceName: "bill_payment")
            
            if #available(iOS 13.0, *) {
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "UtilityBillPaymentMainVC") as! UtilityBillPaymentMainVC
           
                self.navigationController!.pushViewController(vc, animated: true)
        }
        }
        else
        {
            lbldiscount.text = "Discounts".addLocalizableString(languageCode: languageCode)
            imgdiscount.image = #imageLiteral(resourceName: "discounts")
            let billPaymentVC = self.storyboard!.instantiateViewController(withIdentifier: "DiscountsVC") as! DiscountsVC

            self.navigationController!.pushViewController(billPaymentVC, animated: true)
        }

            }
    func fixBackgroundSegmentControl( _ segmentControl: UISegmentedControl){
        if #available(iOS 13.0, *) {
            //just to be sure it is full loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                for i in 0...(segmentControl.numberOfSegments-1)  {
//
                    let backgroundSegmentiew = segmentControl.subviews[i]
                    //it is not enogh changing the background color. It has some kind of shadow layer
                   
                }
            }
        }
    }
    @IBAction func segment(_ sender: UISegmentedControl) {
        
        let consentAlert = UIAlertController(title: "", message: "Do you want to change langugae?" , preferredStyle: UIAlertControllerStyle.alert)
        
        
        consentAlert.addAction(UIAlertAction(title: "YES".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
//
//            DispatchQueue.main.async {
            
       if sender.selectedSegmentIndex == 0
       {
//           sender.tintColor = UIColor.blueColor
           self.segmentControl.updateTintColor(selected:UIColor.red, normal: UIColor.white)
           UserDefaults.standard.setValue("en", forKey: "language-Code")
           
           let vc = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
           self.navigationController!.pushViewController(vc, animated: true)
//

       }
       else if sender.selectedSegmentIndex == 1
       {
//           sender.backgroundColor = UIColor.blueColor
           UserDefaults.standard.setValue("ur-Arab-PK", forKey: "language-Code")

           let vc = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
           self.navigationController!.pushViewController(vc, animated: true)
//            changeLanguage(str: "ur-Arab-PK")
       }
//            }
//       
//       NotificationCenter.default.post(name: Notification.Name("LanguageChangeThroughObserver"), object: nil)

}))
        
        consentAlert.addAction(UIAlertAction(title: "CANCEL".addLocalizableString(languageCode: languageCode), style: .cancel, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion:nil)
//
}))
        self.present(consentAlert, animated: true, completion: nil)

    }
        
    @IBAction func btnbill_second(_ sender: UIButton) {
        if DataManager.instance.nanoloan == "Y"
        {
            lblbillpayment.text = "Nano Loan".addLocalizableString(languageCode: languageCode)
            imgbill.image = #imageLiteral(resourceName: "PHOTO-2021-09-27-09-31-18")
            
            if #available(iOS 13.0, *) {
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "NLTerms_ConditionVC") as! NLTerms_ConditionVC
            
            self.navigationController!.pushViewController(vc, animated: true)
        }
        }
        else
        {
            lblbillpayment.text = "Bill Payment".addLocalizableString(languageCode: languageCode)
            imgbill.image = #imageLiteral(resourceName: "bill_payment")
            let billPaymentVC = self.storyboard!.instantiateViewController(withIdentifier: "UtilityBillPaymentMainVC") as! UtilityBillPaymentMainVC

            self.navigationController!.pushViewController(billPaymentVC, animated: true)
        }
        
    }
    @IBOutlet weak var segmentControl: UISegmentedControl!

    @IBOutlet weak var lbldiscount: UILabel!
    @IBOutlet weak var imgdiscount: UIImageView!
    @IBOutlet weak var viewdiscount: UIView!
    @IBOutlet weak var viewbill: UIView!
    @IBOutlet weak var imgbill: UIImageView!
    @IBOutlet weak var lblbillpayment: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var imgviewloadingbar: UIImageView!
    @IBOutlet weak var imginsured: UIButton!
    let direction: [UISwipeGestureRecognizer.Direction] = [ .left, .right]
    static var changeaccounttype = ""
    var accountName : String?
    var CheckLoanObj : CheckEligilibityModel?
    var imgflag = "true"
    
    var userCnic : String?
    var GenericResponseObj : GenericResponse?
    @IBOutlet weak var pageView: UIPageControl!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    
    @IBOutlet weak var lableLastTransaction: UILabel!
    @IBOutlet weak var lblbalncedate: UILabel!
    @IBOutlet weak var lblLastTransactionValue: UILabel!
    @IBOutlet weak var lblTransactionDateValue: UILabel!
    @IBOutlet weak var lblBalanceValue: UILabel!
    
    @IBOutlet weak var lblinsured: UILabel!
    @IBOutlet weak var lblAccountBalanceValue: UILabel!
    @IBOutlet weak var lblAccountTitle: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var imgProfilePhoto: UIImageView!
    @IBOutlet weak var imgSliderPhotos: UIImageView!
    let pageIndicator = UIPageControl()
   
    //   WALLET ACCOUNT
    @IBOutlet weak var lblAccountNumValue: UILabel!
    @IBOutlet weak var walletlbl: UILabel!
    @IBOutlet weak var curentblncwallet: UIButton!
    @IBOutlet weak var walletheader: UIImageView!
    var timer = Timer()
    var swipeGesture = UISwipeGestureRecognizer()
    
    var imageNames = ["slideBanners1","slideBanners2","slideBanners1","slideBanners2"]//List of image names
    
    var imgArr = [     UIImage(named:"home-Header"),
                       UIImage(named:"header2"),
                       UIImage(named: "home-Header")
                       
    ]
    var transactionobj : lasttransaction?
    var homeObj : HomeModel?
    var bannersObj : BannersModel?
    //    var transactionres : TransactionHomeResponse?
    var counter = 0
    var picker = UIImagePickerController()
    var selectedImage : UIImage!
    let imageViewWidth = CGFloat(100)
    let imageViewHeight = CGFloat(100)
    var accountyp: String?
    var cusid : Int?
    var banArray = [String]()
    
    @IBOutlet weak var scrollViewHome: UIScrollView!
    
    @IBOutlet weak var lblDegreeDesc: UILabel!
    var weatherObj:WeatherModel?
    @IBOutlet var viewsLocation: UIView!
    @IBOutlet var viewsLastTransaction: UIView!
    
   
    
    var isFromUpdate = ""
    var isFromVerify = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("firsttimeemailCheck is ", firsttimeemailCheck)
        changeLanguage()
        print("Check value is ",UserName)
        print ("user cinc is",DataManager.instance.userCnic)
        NotificationCenter.default.removeObserver(self)

        NotificationCenter.default.addObserver(self, selector: #selector(viewDidLoadCustom), name: Notification.Name("LanguageChangeThroughObserver"), object: nil)
//        viewDidLoadCustom()
       print("Email Flow is",  DataManager.instance.emailVerified)
    }
    
    
    
    
    
    
    
    var checkEmailVerificationObj : checkEmailVerification?
    private  func checkEmailVerification() {
        
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
        
        let compelteUrl = GlobalConstants.BASE_URL + "v2/checkEmailVerification"
        
        print(compelteUrl)
//        print("user email already", DataManager.instance.UserEmail)
        print("user userUUID already", DataManager.instance.userUUID)
        // IPA Params
        let params = ["cnic":userCnic!, "imei": DataManager.instance.imei!, "channelId" : DataManager.instance.channelID, ] as [String : Any]
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        let result = (splitString(stringToSplit: base64EncodedString(params: params)))
        let paramsencoded = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        
        print(paramsencoded)
        
        print(params)
        print(compelteUrl)
        print(header)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: paramsencoded , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<checkEmailVerification>) in
            
            
            //        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<lasttransaction>) in
            
            self.hideActivityIndicator()
            
            self.checkEmailVerificationObj = response.result.value
            
            if response.response?.statusCode == 200 {
             
            self.checkEmailVerificationObj = response.result.value
                if self.checkEmailVerificationObj?.responsecode == 2 || self.checkEmailVerificationObj?.responsecode == 1 {
                    DataManager.instance.Checkemail = self.checkEmailVerificationObj?.EmailData?.checkEmail
                    DataManager.instance.CheckEmailVerified = self.checkEmailVerificationObj?.EmailData?.checkEmailVerified
                    
        }
            }
        }
    }
    func CheckEmailVerified()
    {
     
         if DataManager.instance.emailVerified == "N" && DataManager.instance.emailExists != nil
        {
            firsttimeemailCheck = "true"
//            let getemail = UserDefaults.standard.string(forKey: "EmailVerification")
            let message = "Dear \(UserName ?? "") Your email address \( DataManager.instance.emailExists ?? "") is not Verified Yet, if your Provided email is correct, please verify the same, otherwise update the same to enjoy transaction alert the other services."
            let consentAlert = UIAlertController(title: "Unverified Email", message: message , preferredStyle: UIAlertControllerStyle.alert)

consentAlert.addAction(UIAlertAction(title: "VERIFY".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
//
//              Unverified Email
   
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "GenerateOtpForEmailVC") as! GenerateOtpForEmailVC
    isfromVerifyEmail = "true"
    IsFromUpdateEmail = "false"
    vc.maintitle = "Email Verification".addLocalizableString(languageCode: languageCode)
    self.navigationController?.pushViewController(vc, animated: true)
    
    
//
}))
            consentAlert.addAction(UIAlertAction(title: "UPDATE".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
                
                self.getOtpForEmailVerification()
                
                
    //
            }))

consentAlert.addAction(UIAlertAction(title: "Remind me Later".addLocalizableString(languageCode: languageCode), style: .cancel, handler: { (action: UIAlertAction!) in

}))
            self.present(consentAlert, animated: true, completion: nil)
            
        }
        
        else if DataManager.instance.emailVerified == "N" && DataManager.instance.emailExists
                    == nil
        {
            firsttimeemailCheck = "true"
//           let getemail = UserDefaults.standard.string(forKey: "EmailVerification")
            let message = "Dear \(UserName ?? "") Your email address \(  DataManager.instance.emailExists ?? "") is not Verified Yet, if your Provided email is correct, please verify the same, otherwise update the same to enjoy transaction alert the other services."
            let consentAlert = UIAlertController(title: "Email Not provided", message: message , preferredStyle: UIAlertControllerStyle.alert)


            consentAlert.addAction(UIAlertAction(title: "UPDATE".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
             
                self.getOtpForEmailVerification()
                
                
    //
            }))

consentAlert.addAction(UIAlertAction(title: "CANCEL".addLocalizableString(languageCode: languageCode), style: .cancel, handler: { (action: UIAlertAction!) in
//
}))
            self.present(consentAlert, animated: true, completion: nil)
            
        }

    }
//      -----------------start
    //    ------------end
       
    
   
    @objc func viewDidLoadCustom() {
        changeLanguage()
        
//        ChangePasswordVC
        print( "nanoloanproduct is" ,  DataManager.instance.NanoLoanProductType)
        print( "nanoloan type is ", DataManager.instance.NanoLoanType)
        print("amount is" ,    DataManager.instance.Nanoloanamount)
        print("UserAppliedLoan value is ",  DataManager.instance.AppliedLoan)
        banapi()
      
        if #available(iOS 13.0, *) {
            nanoloanvaluecheck()
        } else {
            // Fallback on earlier versions
        }
        
        scrollview.delegate = self
        scrollview.isScrollEnabled  = true
        self.homeAction()
//
        
        self.saveInDataManager(index: 0)
        self.scrollViewHome.addSubview(self.refreshControl)
        //        self.bannersSlideShow()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgviewloadingbar.isUserInteractionEnabled = true
        imgviewloadingbar.addGestureRecognizer(tapGestureRecognizer)
        
        
        let tapGestureRecognizers = UITapGestureRecognizer(target: self, action: #selector(imageInsuredTapped(tapGestureRecognizers:)))
        viewsLocation.isUserInteractionEnabled = true
        viewsLocation.addGestureRecognizer(tapGestureRecognizers)
        self.dismissKeyboard()
        self.hideKeyboardWhenTappedAround()
        DispatchQueue.main.async {
            self.decrypt(encryptedText: DataManager.lasttransamt, password: self.encryptionkey)
       
            
        }
        print("encrption is ", DataManager.AccountNo)
        //        DispatchQueue.main.async {
        //            self.AccNodecrypt(encryptedText: DataManager.AccountNo, password: self.encryptionkey)
        //
        //        }
        DispatchQueue.main.async {
            self.Currentblncdecrypt(encryptedText: DataManager.Currentbalanc, password: self.encryptionkey)
            
        }
        
        print("encrption is ", DataManager.levelDescr)
        DispatchQueue.main.async {
            self.LevelDescriptiondecrypt(encryptedText: DataManager.levelDescr, password: self.encryptionkey)
           
        }
        
        changeLanguage()
    }
  
    @objc func changeImage() {
        
        if counter < banArray.count {
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
    //
    func banapi ()
    {
        
        // let token = "eWptR0NMbk43RlBINWJCM1JjbWtSc0g1TWFzNFZHVGMgOm1MSzM1WEd3bUtHUFpRclM="
        
        ServerManager.GEt_typeWithoutParmsfetchApiData_PostAppJSON(APIMethodName: APIMethods.banner.rawValue, Token: DataManager.instance.accessToken ?? "" ) { [self] (Result : MYBanersModel?) in
            
            //== check if api is responding or not
            guard Result != nil else {
//                UtilManager.showAlertMessage(message: "No Internet Connection...", viewController: self)
                
                return
            }
            
            GlobalData.banner = Result!
            print(Result!)
            print("token is :",GlobalData.banner.data[0].brandCode)
            if GlobalData.banner.responsecode == 1 {
                for data in GlobalData.banner.data {
                    if data.banner != nil {
                        if data.banner != "" {
                            self.banArray.append(data.banner ?? "")
                        }
                    }
                    print(banArray)
                }
                self.sliderCollectionView.delegate = self
                self.sliderCollectionView.dataSource = self
                self.pageView.numberOfPages = self.banArray.count
                self.pageView.currentPage = 0
                DispatchQueue.main.async {
                    self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
                }
                
            }
            
        }
        
    }
    //
    //    -----------decrypt
    var lasttransamtAfterDycrpt = ""
    func decrypt(encryptedText: String, password: String) -> String{
        do{
            let data: Data = Data(base64Encoded: encryptedText)!
            let decryptedData = try RNCryptor.decrypt(data: data, withPassword: password)
            let decryptedString = String(data: decryptedData, encoding: .utf8)
            print("decryptedString",decryptedString)
            lasttransamtAfterDycrpt = decryptedString!
            return decryptedString ?? ""
            
        }
        catch{
            return "Failed"
        }
        
        
    }
    
    //    -----------decrypt--------
    var CurntblncAfterDycrpt = ""
    func Currentblncdecrypt(encryptedText: String, password: String) -> String{
        do{
            let data: Data = Data(base64Encoded: encryptedText)!
            let decryptedData = try RNCryptor.decrypt(data: data, withPassword: password)
            let decryptedString = String(data: decryptedData, encoding: .utf8)
            print("decryptedString",decryptedString)
            CurntblncAfterDycrpt = decryptedString!
            return decryptedString ?? ""
            
        }
        catch{
            return "Failed"
        }
    }
    
    
    var levelDescrAfterDycrpt = ""
    func LevelDescriptiondecrypt(encryptedText: String, password: String) -> String{
        do{
            let data: Data = Data(base64Encoded: encryptedText)!
            let decryptedData = try RNCryptor.decrypt(data: data, withPassword: password)
            let decryptedString = String(data: decryptedData, encoding: .utf8)
            print("decryptedString",decryptedString)
            levelDescrAfterDycrpt = decryptedString!
            return decryptedString ?? ""
            
        }
        catch{
            return "Failed"
        }
    }
    
    
    //    -----------------end
    
    @objc private func Check_for_swipe(){
        for dir in direction{
            if((self.homeObj?.userData?.count)! == 2){
                swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeView(_:)))
                walletheader.image = imgArr[0]
                walletheader.addGestureRecognizer(swipeGesture)
                swipeGesture.direction = dir
               
                walletheader.isUserInteractionEnabled = true
                walletheader.isMultipleTouchEnabled = true
            }
            else if((self.homeObj?.userData?.count)! == 3){
                
                swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe_View(_:)))
                walletheader.image = imgArr[0]
                walletheader.addGestureRecognizer(swipeGesture)
                swipeGesture.direction = dir
                
                walletheader.isUserInteractionEnabled = true
                walletheader.isMultipleTouchEnabled = true
            }else if((self.homeObj?.userData?.count)! == 1){
                
                saveInDataManager(index: 0)
                walletheader.isUserInteractionEnabled = false
                walletheader.isMultipleTouchEnabled = false
            }
            
            
        }
        
        
    }
    @IBAction func test(_ sender: UIButton) {
        let manageFunds = self.storyboard!.instantiateViewController(withIdentifier: "AllDonationsVC") as! AllDonationsVC        //   utilityInfoVC.isFromHome = true
        self.navigationController!.pushViewController(manageFunds, animated: true)
        
    }
    @objc func swipe_View(_ sender:UISwipeGestureRecognizer){
        // counter = 0
        UIView.animate(withDuration: 0.5) { [self] in
            if sender.direction == .left{
                self.walletheader.frame = CGRect(x: 0, y: self.walletheader.frame.origin.y , width: self.walletheader.frame.size.width, height: self.walletheader.frame.size.height)
                
                print("left")
                print(counter)
                if(counter >= 0){
                    walletheader.image = #imageLiteral(resourceName: "home-Header")
                    self.saveInDataManager(index: counter)
                    counter = counter + 1
                    
                }
                
                
            }else if sender.direction == .right{
                
                self.walletheader.frame = CGRect(x: self.view.frame.size.width - self.walletheader.frame.size.width, y: self.walletheader.frame.origin.y , width: self.walletheader.frame.size.width, height: self.walletheader.frame.size.height)
                print("right")
                print(counter)
                if(counter < (self.homeObj?.userData!.count)!){
                    
                    walletheader.image = #imageLiteral(resourceName: "home-Header")
                    self.saveInDataManager(index: counter) //run krook
                    counter = counter - 1
                    
                }
            }
        }
    }
    
    private func updateUI(){
        //        showActivityIndicator()
        DataManager.instance.LevelDesc = self.homeObj?.userData?[0].levelDescr
        walletlbl.text = self.homeObj?.userData?[0].levelDescr?.addLocalizableString(languageCode: languageCode) ?? ""
        print(self.homeObj?.userData?[0].levelDescr ?? "")
        if counter == 0{
            //   walletlbl.text = " Level 1"
            
            
            walletheader.image = #imageLiteral(resourceName: "home-Header")
            
            print(counter)
        }
        else {
           
            
        }
        
        if KeychainWrapper.standard.hasValue(forKey: "accountTitle") {
            accountName = KeychainWrapper.standard.string(forKey: "accountTitle")
            self.lblAccountTitle.text = accountName
        }
        else{
            if let accountTitle = DataManager.instance.accountTitle{
                self.lblAccountTitle.text = accountTitle
                UserName = accountTitle
            }
        }
        
        if let accountNumValue = DataManager.instance.accountNo {
            self.lblAccountNumValue.text = "\(accountNumValue)"
        }
        if let balanceValue = DataManager.instance.currentBalance {
            self.lblBalanceValue.text = " Balance : \(convertToCurrrencyFormat(amount:String(balanceValue)))"
           
        }
        if let lastTrans = (DataManager.instance.lasttransamt){
            self.lblLastTransactionValue.text = "PKR \(convertToCurrrencyFormat(amount:String(lastTrans)))"
        }
        lblbalncedate.text = DataManager.instance.balancedate
        //        if let transDate = DataManager.instance.balanceDate {
        //            self.lblTransactionDateValue.text = transDate
        //        }
        if let cityName = DataManager.instance.CityName{
            self.lblLocation.text = cityName
        }
        
        if (DataManager.instance.insured) == "Y"
        
        {
            imginsured.setBackgroundImage(#imageLiteral(resourceName: "iconinsured"), for: .normal)
            lblinsured.text = "Insured".addLocalizableString(languageCode: languageCode)
            lblinsured.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            
            
            print("insured data")
        }
        if (DataManager.instance.insured) == "N"
        {
            lblinsured.text = "Not Insured".addLocalizableString(languageCode: languageCode)
            imginsured.setBackgroundImage(#imageLiteral(resourceName: "icon notinsured.jpg"), for: .normal)
            print("not isured")
            lblinsured.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        
        viewsLastTransaction.layer.borderWidth = 1
        viewsLastTransaction.layer.borderColor = #colorLiteral(red: 0.6588235294, green: 0.8705882353, blue: 1, alpha: 1)
        viewsLastTransaction.layer.cornerRadius = 5
        viewsLocation.layer.borderWidth = 1
        viewsLocation.layer.borderColor = #colorLiteral(red: 0.6588235294, green: 0.8705882353, blue: 1, alpha: 1)
        viewsLocation.layer.cornerRadius = 5
        //        pickcurrnetbalnce ()
        self.updateProfilePhoto()
        self.getWeather()
        //        hideActivityIndicator()
        
    }
    
    //    getDiscountList
    
    
    @objc func imageInsuredTapped(tapGestureRecognizers: UITapGestureRecognizer)
    {
        if (DataManager.instance.insured) == "Y"
        
        {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "InsuredVC") as! InsuredVC
            self.navigationController!.pushViewController(vc, animated: true)
            
        }
        if (DataManager.instance.insured) == "N"
        {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "NotInsuredVC") as! NotInsuredVC
            self.navigationController!.pushViewController(vc, animated: true)
            print("not isured")
        }
    }
    
    
    
    @IBAction func btn_insured(_ sender: UIButton) {
        if (DataManager.instance.insured) == "Y"
        
        {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "InsuredVC") as! InsuredVC
            self.navigationController!.pushViewController(vc, animated: true)
            
        }
        if (DataManager.instance.insured) == "N"
        {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "NotInsuredVC") as! NotInsuredVC
            self.navigationController!.pushViewController(vc, animated: true)
            print("not isured")
        }
         
    }
    
    private func checkLoanEligibilityHome() {

        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        let userSelfie: String?
        var userCnic : String?

        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        showActivityIndicator()
        let compelteUrl = GlobalConstants.BASE_URL + "checkLoanEligibility"
        let parameters = ["imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"amount" :"5000","productId": "2","apiCheck":"L"] as [String : Any]

        print(parameters)

        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        print(result.apiAttribute1)
        print(result.apiAttribute2)

        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]

        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
       
        
        print(params)
        print(compelteUrl)
        print(header)
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<CheckEligilibityModel>) in
            self.hideActivityIndicator()

            self.CheckLoanObj = response.result.value

            if response.response?.statusCode == 200 {
                if self.CheckLoanObj?.responsecode == 2 || self.CheckLoanObj?.responsecode == 1 {
             
                    firsttimenanoloan = "true"
                    DataManager.instance.maximumamount =  (CheckLoanObj?.data?[0].maxAmount)
                    DataManager.instance.minamount =  CheckLoanObj?.data?[0].minAmount
                    
                    let consentAlert = UIAlertController(title: "Congratulations", message: "You have successfully qualified for FirstPay Loan upto PKR 10,000.You can instantly get this loan on few clicks without any documentation.                                      Do you want to apply loan now? ", preferredStyle: UIAlertControllerStyle.alert)
       
                    consentAlert.addAction(UIAlertAction(title: "Yes".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
//            nanoloanflag = "false"
          
            if #available(iOS 13.0, *) {
                let vc =  self.storyboard!.instantiateViewController(withIdentifier: "NLTerms_ConditionVC") as! NLTerms_ConditionVC
                
                self.navigationController!.pushViewController(vc, animated: true)

            }
            else {
                // Fallback on earlier versions
            }
            
            
//            print("Handle Ok logic here")
        }))
        
                    consentAlert.addAction(UIAlertAction(title: "Cancel".addLocalizableString(languageCode: languageCode), style: .cancel, handler: { (action: UIAlertAction!) in
//            checkloanapply = "false"
//                        self.CheckEmailVerified()
            self.navigationController!.popToRootViewController(animated: true)
            
//            print("Handle Cancel Logic here")
        }))
        present(consentAlert, animated: true, completion: nil)
    
                }
                else {
                  
//                    if let message = self.CheckLoanObj?.messages{
//                        showAlert(title: "", message: self.CheckLoanObj?.messages ?? "", completion: nil)
//                    }
//                    if let message = self.CheckLoanObj?.messages{
//                        self.showAlert(title: (self.CheckLoanObj?.messages)! , message: message, completion: {
//                            self.navigationController?.popViewController(animated: true)
//                        })
////                        self.showDefaultAlert(title: "", message: message)
//                    }
                }
            }
            else {
                if let message = self.CheckLoanObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    
    @objc func swipeView(_ sender:UISwipeGestureRecognizer){
        // counter = 0
        UIView.animate(withDuration: 0.5) { [self] in
            if sender.direction == .left{
                self.walletheader.frame = CGRect(x: 0, y: self.walletheader.frame.origin.y , width: self.walletheader.frame.size.width, height: self.walletheader.frame.size.height)
                
                print("left")
                print(counter)
                if counter == 0{
                    //                    walletlbl.text = "   Level 1"
                    walletheader.image = #imageLiteral(resourceName: "home-Header")
                    counter = counter + 1
                    
                    //if( (self.homeObj?.userData!.count)! < 1){
                    self.saveInDataManager(index: counter)
                    // }else{
                    //    self.saveInDataManager(index: 0)
                    // }
                    //
                    print(counter)
                }
                
            }else if sender.direction == .right{
                
                self.walletheader.frame = CGRect(x: self.view.frame.size.width - self.walletheader.frame.size.width, y: self.walletheader.frame.origin.y , width: self.walletheader.frame.size.width, height: self.walletheader.frame.size.height)
                print("right")
                print(counter)
                if(counter == 1){
                    //                    walletlbl.text = "Home REmitence"
                    
                    walletheader.image = #imageLiteral(resourceName: "home-Header")
                    counter = counter - 1
                    //if( (self.homeObj?.userData!.count)! < 1){
                    self.saveInDataManager(index: counter)
                    // }
                    // self.saveInDataManager(index: counter)
                    print(counter)
                }
                
                
            }
        }
    }
    
    
    func updateName() {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Edit", message: "", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            
            var accountName : String?
            
            if KeychainWrapper.standard.hasValue(forKey: "accountTitle") {
                accountName = KeychainWrapper.standard.string(forKey: "accountTitle")
                textField.text = accountName
            }
            else {
                textField.text = DataManager.instance.accountTitle
            }
            
            // updated code
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            
            if let accountTitle = textField?.text {
                let saveSuccessful : Bool = KeychainWrapper.standard.set(accountTitle, forKey: "accountTitle")
                print("SuccessFully Added to KeyChainWrapper \(saveSuccessful)")
            }
            textField?.keyboardType = .alphabet
            print("Text field: \(textField!.text)")
            self.updateUI()
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
            self.dismiss(animated: true, completion:nil)
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @available(iOS 13.0, *)
    func nanoloanvaluecheck()
    {
        if DataManager.instance.nanoloan == "Y"
        {
            lblbillpayment.text = "Nano Loan".addLocalizableString(languageCode: languageCode)
            imgbill.image = #imageLiteral(resourceName: "PHOTO-2021-09-27-09-31-18-2")
            lbldiscount.text = "Bill Payment".addLocalizableString(languageCode: languageCode)
            imgdiscount.image = #imageLiteral(resourceName: "bill_payment")
//            let vc = self.storyboard!.instantiateViewController(withIdentifier: "MainNanoLoanVC") as! MainNanoLoanVC
//            self.navigationController!.pushViewController(vc, animated: true)
        }
        else
        {
            lblbillpayment.text = "Bill Payment".addLocalizableString(languageCode: languageCode)
            imgbill.image = #imageLiteral(resourceName: "bill_payment")
//            let billPaymentVC = self.storyboard!.instantiateViewController(withIdentifier: "UtilityBillPaymentMainVC") as! UtilityBillPaymentMainVC
//
//            self.navigationController!.pushViewController(billPaymentVC, animated: true)
//
        }
        
    }
    func checkValue ()
    {
        if levelDescrAfterDycrpt == "LEVEL 1"
        {
            
            DataManager.instance.accountType = "20"
            self.saveInDataManager(index: counter)
            if let balanceValue = Int(CurntblncAfterDycrpt) {
                print(CurntblncAfterDycrpt)
                self.lblBalanceValue.text = " Balance : \(convertToCurrrencyFormat(amount:String(balanceValue)))"
            }
            print("Level 1 type is ", DataManager.instance.accountType)
            
            
        }
        else   if levelDescrAfterDycrpt == "HOME REMITTANCE"
        {
            DataManager.instance.accountType = "30"
            if let balanceValue = Int(CurntblncAfterDycrpt) {
                print(CurntblncAfterDycrpt)
                self.lblBalanceValue.text = "Balance : \(convertToCurrrencyFormat(amount:String(balanceValue)))"
            }
            print("Home Remi type is ", DataManager.instance.accountType)
        }
        else
        {
            DataManager.instance.accountType = "20"
            //                walletlbl.text = "Level 0"
        }
    }
    
    
    private func saveInDataManager(index : Int){
        DataManager.instance.balancedate = self.transactionobj?.data?.balanceDate
        DataManager.instance.lasttransamt = self.transactionobj?.data?.lasttransamt
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
        
        self.updateUI()
//        NotificationCenter.default.addObserver(self, selector: #selector(updateProfilePhoto), name: Notification.Name("batteryLevelChanged"), object: nil)
    }
    
    @objc  private func updateProfilePhoto(){
        if let imageCheck = UserDefaults.standard.object(forKey: "proImage"){
            imgProfilePhoto.layer.cornerRadius = imgProfilePhoto.frame.height / 2
            imgProfilePhoto.layer.masksToBounds = false
            imgProfilePhoto.clipsToBounds = true
            let retrievedImage = imageCheck
            self.imgProfilePhoto.image = UIImage(data: retrievedImage as! Data)
        }
            else {
                self.imgProfilePhoto.image = #imageLiteral(resourceName: "icons8-male-user-100-2")
            }
    }
    func bannersSlideShow(){
        
        imgProfilePhoto.layer.cornerRadius = imgProfilePhoto.frame.height / 2
        imgProfilePhoto.layer.masksToBounds = false
        imgProfilePhoto.clipsToBounds = true
        
        let timer1 = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
            for data in GlobalData.banner.data
            {
                
                let imageurl = data.banner
                print("img is",imageurl)
                //cell.roomImg.sd_setImage(with: URL(string: "\(imageurl ?? "abc")"), placeholderImage:#imageLiteral(resourceName: "10"))
                self.imgSliderPhotos.sd_setImage(with: URL(string: "\(imageurl ?? "abc")"), placeholderImage:#imageLiteral(resourceName: "request_card"))
                
            }
            //self.imgSliderPhotos.image = UIImage(named: self.imageNames.randomElement()!) //Slideshow logic
        }
        timer1.fire()
    }
    
    @IBOutlet weak var btnquickpy: UIButton!
    // MARK: -  Pull to Refresh
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
//        irummm
        
        refreshControl.addTarget(self, action: #selector(handleRefresh),for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.homeAction()
        refreshControl.endRefreshing()
        self.getWeather()
        updateUI()
        if #available(iOS 13.0, *) {
            nanoloanvaluecheck()
        } else {
            // Fallback on earlier versions
        }
        
    }
    override func viewWillAppear(_ animated: Bool)  {
        var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(handleRefresh),for: UIControlEvents.valueChanged)
    refreshControl.tintColor = UIColor.gray
    return refreshControl
}()
    }
    // MARK: - Image Picker Methods
    
    @IBAction func selectPictureFromPhotos(sender: UIButton) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        //        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler:
        //            {
        //                (alert: UIAlertAction!) -> Void in
        //
        //            })
//        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
//            self.deleteimage()
//            print("User click Delete button")
//        }))
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func updateNamePressed(_ sender: Any){
        self.updateName()
    }
//    func deleteimage()
//    {
//
//        imgProfilePhoto.image = #imageLiteral(resourceName: "person")
//        imgflag = "true"
//
//
//    }
    
    func openGallery(){
        imgflag = "false"
        picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    func openCamera(){
        imgflag = "false"
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker.sourceType = UIImagePickerControllerSourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            picker.allowsEditing = true
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.selectedImage = img
        }
        else if let img = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.selectedImage = img
        }
        let image = self.selectedImage
        let pngImage =  UIImagePNGRepresentation(image!)
        UserDefaults.standard.set(pngImage, forKey: "proImage")
        
        
        self.updateProfilePhoto()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // Do any additional setup after loading the view.
    
    @IBAction func currentblnceaction(_ sender: UIButton) {
        let miniStatementVC = self.storyboard!.instantiateViewController(withIdentifier: "MiniStatementVC") as! MiniStatementVC
   
        if let balance  = Int(DataManager.Currentbalanc) {
            miniStatementVC.balanceAmount = String(balance)
        }
        self.navigationController!.pushViewController(miniStatementVC, animated: true)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        self.lasttransaction()
        imgviewloadingbar.isHidden = true
        
        
    }
    @IBAction func miniStatementPressed(_ sender: Any) {
        self.lasttransaction()
        imgviewloadingbar.isHidden = true
        //        let miniStatementVC = self.storyboard!.instantiateViewController(withIdentifier: "MiniStatementVC") as! MiniStatementVC
        //        if let balance  = Int(DataManager.Currentbalanc) {
        //            miniStatementVC.balanceAmount = String(balance)
        //        }
        //        self.navigationController!.pushViewController(miniStatementVC, animated: true)
    }
        
    @IBAction func sendMoneyPressed(_ sender: Any) {
      
        let sendMVC = self.storyboard!.instantiateViewController(withIdentifier: "SendMoneyMainVC") as! SendMoneyMainVC
        self.navigationController!.pushViewController(sendMVC, animated: true)
    }
    @IBAction func discountsPressed(_ sender: Any) {
        if DataManager.instance.nanoloan == "Y"
        {
            lbldiscount.text = "Bill Payment".addLocalizableString(languageCode: languageCode)
            imgdiscount.image = #imageLiteral(resourceName: "bill_payment")
            
            if #available(iOS 13.0, *) {
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "UtilityBillPaymentMainVC") as! UtilityBillPaymentMainVC
            
            self.navigationController!.pushViewController(vc, animated: true)
        }
        }
        else
        {
            lbldiscount.text = "Discounts".addLocalizableString(languageCode: languageCode)
            imgdiscount.image = #imageLiteral(resourceName: "discounts")
            let billPaymentVC = self.storyboard!.instantiateViewController(withIdentifier: "DiscountsVC") as! DiscountsVC

            self.navigationController!.pushViewController(billPaymentVC, animated: true)
            
        }

//        let discVC = self.storyboard!.instantiateViewController(withIdentifier: "DiscountsVC") as! DiscountsVC
//        self.navigationController!.pushViewController(discVC, animated: true)
    }
    
    @IBAction func othersPressed(_ sender: Any) {
        let otherVC = self.storyboard?.instantiateViewController(withIdentifier: "OtherHomeVC") as! OtherHomeVC
        self.navigationController?.pushViewController(otherVC, animated: true)
    }
    
    @IBAction func quickPayPressed(_ sender: Any) {
//        checkEmailVerification()
        let addBeneVC = self.storyboard!.instantiateViewController(withIdentifier: "AddBeneVC") as! AddBeneVC
        self.navigationController!.pushViewController(addBeneVC, animated: true)
    }
    
    @IBAction func billPaymentPressed(_ sender: Any) {
        if DataManager.instance.nanoloan == "Y"
        {
            lblbillpayment.text = "Nano Loan".addLocalizableString(languageCode: languageCode)
            imgbill.image = #imageLiteral(resourceName: "PHOTO-2021-09-27-09-31-18-2")
           
            if #available(iOS 13.0, *) {
                if  DataManager.instance.AppliedLoan != "true"
                {
                    
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "NLTerms_ConditionVC") as! NLTerms_ConditionVC
                
                self.navigationController!.pushViewController(vc, animated: true)
                  
                }
                else
                {  let vc = self.storyboard!.instantiateViewController(withIdentifier: "MainNanoLoanVC") as! MainNanoLoanVC
                    
                    self.navigationController!.pushViewController(vc, animated: true)
              
        }
            }
        }
        else
        {
            lblbillpayment.text = "Bill Payment".addLocalizableString(languageCode: languageCode)
            imgbill.image = #imageLiteral(resourceName: "bill_payment")
            let billPaymentVC = self.storyboard!.instantiateViewController(withIdentifier: "UtilityBillPaymentMainVC") as! UtilityBillPaymentMainVC
            self.present(billPaymentVC, animated: true)
            
//            self.navigationController!.pushViewController(billPaymentVC, animated: true)
        }

    }
    @IBAction func topUpPressed(_ sender: Any) {
        let topUpVC = self.storyboard!.instantiateViewController(withIdentifier: "TopUpMainVC") as! TopUpMainVC
        //   utilityInfoVC.isFromHome = true
        self.navigationController!.pushViewController(topUpVC, animated: true)
        //  self.showToast(title: "Coming Soon")
    }
    @IBAction func fundsManagement(_ sender: Any) {
        let manageFunds = self.storyboard!.instantiateViewController(withIdentifier: "ManageFundsVC") as! ManageFundsVC
        //   utilityInfoVC.isFromHome = true
        self.navigationController!.pushViewController(manageFunds, animated: true)
    }
    
    
    // MARK: - POP UP
    
    
    private func popUpConsent(){
        
        let consentAlert = UIAlertController(title: "Alert", message: "Do you want to activate IBFT Services", preferredStyle: UIAlertControllerStyle.alert)
        
        consentAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
            let OTPVerifyVC = self.storyboard!.instantiateViewController(withIdentifier: "OTPVerifyVC") as! OTPVerifyVC
            OTPVerifyVC.ForTransactionConsent = true
            self.navigationController!.pushViewController(OTPVerifyVC, animated: true)
            print("Handle Ok logic here")
        }))
        
        consentAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
            self.navigationController?.popViewController(animated: true)
        }))
        
        present(consentAlert, animated: true, completion: nil)
    }
    
    // MARK: - API CALL
    
    
    private func getWeather(){
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        //        showActivityIndicator()
        
        //      let compelteUrl = "http://api.weatherunlocked.com/api/current/33.69,72.97?app_id=88f5ab3a&app_key=2d41dabe0ba2909ab9c9271d31d7e588"
        
        let compelteUrl = "http://api.weatherunlocked.com/api/current/\(DataManager.instance.Latitude!),\(DataManager.instance.Longitude!)?app_id=88f5ab3a&app_key=2d41dabe0ba2909ab9c9271d31d7e588"
        
        print(compelteUrl)
        
        Alamofire.request(compelteUrl).responseObject { (response: DataResponse<WeatherModel>) in
            
            //            self.hideActivityIndicator()
            
            if response.response?.statusCode == 200 {
                
                self.weatherObj = response.result.value
                if let weather = self.weatherObj{
                    //                    if let degree = weather.temp_c{
                    //                        self.lblDegree.text = "\(degree) °C"
                    //                    }
                    if let degreeDesc = weather.wx_desc{
                        self.lblDegreeDesc.text = "\(weather.temp_c ?? 00) °C - " + "\(degreeDesc)"
                    }
                }
            }
        }
    }
    
    func homeAction() {
        showActivityIndicator()
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        //        showActivityIndicator()
        
        //        let compelteUrl = GlobalConstants.BASE_URL + "home"
        //
        let compelteUrl = GlobalConstants.BASE_URL + "v2/home"
        // IPA Params
        let params = ["":""] as [String : Any]
       
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        
        print(params)
        print(compelteUrl)
        print(header)
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<HomeModel>) in
            
            self.homeObj = response.result.value
            
            if response.response?.statusCode == 200 {
                
                self.homeObj = response.result.value
                if self.homeObj?.responsecode == 2 || self.homeObj?.responsecode == 1 {
                    //                    self.updateUI()
//                    if #available(iOS 13.0, *) {
//                        self.nanoloan()
//                    } else {
//                        // Fallback on earlier versions
//                    }
                    
                    self.saveInDataManager(index: 0)
                    self.hideActivityIndicator()
                    self.checkValue()
                
                    self.Check_for_swipe()
                   if firsttimenanoloan  == "false"
                   {
//
                           self.checkLoanEligibilityHome()
                      
                   }
                    
                  else if firsttimeemailCheck == "false"
                  {
//email+invitefriend
                     DispatchQueue.main.async {
                         print("second popup done")
//                                CheckEmailVerified()
                            }
                        }
                         
                
                }
                else {
                    if let message = self.homeObj?.messages{
                        self.showAlert(title: "", message: message, completion:nil)
                    }
                }
            }
            else {
                //                self.showAlert(title: "", message: "Something Went Wrong", completion:nil)
                //                print(response.result.value)
                //                print(response.response?.statusCode)
            }
        }
    }
    //
    //    transactionhome
    private  func lasttransaction() {
        
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
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "v2/custLastTransaction"
        
        print(compelteUrl)
        
        // IPA Params
        let params = ["cnic":userCnic!, "imei": DataManager.instance.imei!, "accountType" : DataManager.instance.accountType!, "channelId" : DataManager.instance.channelID]
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        let result = (splitString(stringToSplit: base64EncodedString(params: params)))
        let paramsencoded = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        print(paramsencoded)
        
        print(params)
        print(compelteUrl)
        print(header)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: paramsencoded , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<lasttransaction>) in
            
            
            //        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<lasttransaction>) in
            
            self.hideActivityIndicator()
            
            self.transactionobj = response.result.value
            
            if response.response?.statusCode == 200 {
                
                self.transactionobj = response.result.value
                if self.transactionobj?.responsecode == 2 || self.transactionobj?.responsecode == 1 {
                    //
                    self.saveInDataManager(index: 0)
                    
                }
                else {
                    if let message = self.transactionobj?.messages{
                        UtilManager.showAlertMessage(message: (self.transactionobj?.messages)!, viewController: self)
                        //                        self.showAlert(title: "", message: message, completion:nil)
                    }
                }
            }
            else {
                self.showAlert(title: "", message: "No internert Connection ", completion:nil)
                //                print(response.result.value)
                //                print(response.response?.statusCode)
            }
        }
    }
    
    
    
//    ------------------------generate otp -------------
    private  func getOtpForEmailVerification() {
        
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
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "v2/getOtpForEmailVerification"
        
        print(compelteUrl)
        
        // IPA Params
        let params = ["cnic":userCnic!, "imei": DataManager.instance.imei!, "accountType" : DataManager.instance.accountType!, "channelId" : DataManager.instance.channelID]
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        let result = (splitString(stringToSplit: base64EncodedString(params: params)))
        let paramsencoded = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        
        print(paramsencoded)
        
        print(params)
        print(compelteUrl)
        print(header)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: paramsencoded , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            
            //        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<lasttransaction>) in
            
            self.hideActivityIndicator()
            
            self.GenericResponseObj = response.result.value
            
            if response.response?.statusCode == 200 {
                
                self.GenericResponseObj = response.result.value
                if self.GenericResponseObj?.responsecode == 2 || self.GenericResponseObj?.responsecode == 1 {
                    let vc =  self.storyboard!.instantiateViewController(withIdentifier: "verifyOtpForEmailVC") as! verifyOtpForEmailVC
                    IsFromUpdateEmail = "true"
                    isfromVerifyEmail = "false"
                    
                    vc.mainTitle = "Update Email".addLocalizableString(languageCode: languageCode)
                    self.navigationController!.pushViewController(vc, animated: true)
                    
                }
                else {
                    if let message = self.GenericResponseObj?.messages{
                        UtilManager.showAlertMessage(message: (self.GenericResponseObj?.messages)!, viewController: self)
                        //                        self.showAlert(title: "", message: message, completion:nil)
                    }
                }
            }
            else {
                self.showAlert(title: "", message: "No internert Connection ", completion:nil)
                //                print(response.result.value)
                //                print(response.response?.statusCode)
            }
        }
    }
       
}
extension HomeVC : UICollectionViewDelegate , UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //  return imgArr.count
        return banArray.count
//return 10
        print("banner array",banArray.count)

    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        king fisher
        if let vc = cell.viewWithTag(111) as? UIImageView {
            let profilepic = banArray[indexPath.row]
            if profilepic != "" {
                let urlString = profilepic.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let url = URL(string:(urlString!))
                if let url = url {
                    vc.kf.setImage(with: url as Resource, placeholder: UIImage(named: "") , options: [], progressBlock: nil, completionHandler: {
                        (image,error,cache, imageurl) in
                        if(error == nil){
                            // vc.image = image
                            print("done")
                        }
                    })
                }

            }

        }
        return cell
    }
}



extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = sliderCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
        
    }
}
extension UISegmentedControl {

// create a 1x1 image with this color
private func imageWithColor(color: UIColor) -> UIImage {
    let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context!.setFillColor(color.cgColor);
    context!.fill(rect);
    let image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image!
}

func removeBackgroundColors() {
    self.setBackgroundImage(imageWithColor(color: .clear), for: .normal, barMetrics: .default)
    self.setBackgroundImage(imageWithColor(color: .clear), for: .selected, barMetrics: .default)
    self.setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
}

struct viewPosition {
    let originX: CGFloat
    let originIndex: Int
}

func updateTintColor(selected: UIColor, normal: UIColor) {
    let views = self.subviews
    var positions = [viewPosition]()
    for (i, view) in views.enumerated() {
        let position = viewPosition(originX: view.frame.origin.x, originIndex: i)
        positions.append(position)
    }
    positions.sort(by: { $0.originX < $1.originX })

    for (i, position) in positions.enumerated() {
        let view = self.subviews[position.originIndex]
        if i == self.selectedSegmentIndex {
            view.tintColor = selected
        } else {
            view.tintColor = normal
        }
    }
}
}


