//
//  NLApplyVC.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 21/06/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit
import iOSDropDown
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
import Photos
import Foundation
var selfiNanoloan = "false"
class NLApplyVC: BaseClassVC, UITextFieldDelegate ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var fetchimage : UIImage?
    var fetchcnicdata : String?
    var userSelfie: String?
    var amount: Int?
    var array2 = ""
    var typeId : Int?
    var loanid : Int?
    var datalist = [String]()
    var descrptionlist = [String]()
    var selectedlist : String?
    var selectpurpose : Int?
    var fromapinoOfDays : Int?
    var fromapimarkupfee : Double?
    var fromapiprocessingFeeAmount : Double?
    var RepaymentFrequency : String?
    
    //    var  minamount: Int?
    //    var  maximumamount: Int?
    var CaptureImage : UIImage!
    var arrlist : [Checkloaneligibilty] = []
    var picker = UIImagePickerController()
    var defaultVideoDevice: AVCaptureDevice?
    var CheckLoanObj : CheckEligilibityModel?
    var  userimg : String?
    var genResObj: GenericResponse?
    var geloanpurposeobj : getloanpuppose?
    var Nanloangetprocutobj : NanoloangetProductModel?
    
    
       @IBOutlet weak var lblhome: UILabel!
        @IBOutlet weak var lblContactus: UILabel!
        @IBOutlet weak var lblBookme: UILabel!
        @IBOutlet weak var lblInviteFriend: UILabel!

    @IBOutlet weak var btnCheckLoanEligibility: UIButton!
  
    @IBOutlet weak var lblMainTitle: UILabel!
  
    @IBOutlet weak var lblTakeaPhoto: UILabel!
    @IBOutlet weak var lblEnterAmount: UILabel!
    @IBOutlet weak var lblSeelctLoanProduct: UILabel!
    @IBOutlet weak var lblSelectLoanType: UILabel!
    
    func ChangeConvert()
    {
        lblhome.text = "Home".addLocalizableString(languageCode: languageCode)
        lblInviteFriend.text = "Invite Friends".addLocalizableString(languageCode: languageCode)
        lblBookme.text = "Tickets".addLocalizableString(languageCode: languageCode)
        lblContactus.text = "Contact Us".addLocalizableString(languageCode: languageCode)
        lblMainTitle.text = "Apply  Loan".addLocalizableString(languageCode: languageCode)
        lblTakeaPhoto.text = "Take a Photo".addLocalizableString(languageCode: languageCode)
        lblSelectLoanType.text = "Select Loan Purpose".addLocalizableString(languageCode: languageCode)
        lblSeelctLoanProduct.text = "Select Loan Product".addLocalizableString(languageCode: languageCode)
        lblEnterAmount.text = "Enter Amount".addLocalizableString(languageCode: languageCode)
        nextoutlet.setTitle("Apply  Loan".addLocalizableString(languageCode: languageCode), for: .normal)
        btnCheckLoanEligibility.setTitle("CheckLoan Eligibility".addLocalizableString(languageCode: languageCode), for: .normal)
        selectloantypetf.placeholder = "Select Loan Product"
        selecttypetf2.placeholder = "Select Loan Purpose"
        amounttextfield.placeholder = ""
        
        
    }
    
    @IBAction func btnhideproductview(_ sender: UIButton) {
        self.lblProductDetail.isHidden = true
        self.productview.isHidden = true
    }
    
    
    
    
    @IBAction func hideproductview(_ sender: UIButton) {
        self.lblProductDetail.isHidden = true
        self.productview.isHidden = true
    }
    let viewToAnimate = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeConvert()
    
//        nextoutlet.isHidden = true
//        lblProductDetail.isHidden = true
        productview.isHidden = true
        amounttextfield.placeholder = "Enter amount between".addLocalizableString(languageCode: languageCode)
        ChangeConvert()
        NanoloangetProduct()
        print("test is ",selfiNanoloan)
        print(fetchcnicdata)
        self.hideKeyboardWhenTappedAround()
        amounttextfield.delegate = self
        print("minimum amount loan" , minvalu)
        print("maximum amount loan" , maxvalue)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cameraimage.isUserInteractionEnabled = true
        cameraimage.addGestureRecognizer(tapGestureRecognizer)
        print("id is",typeId)
        print("done")
        self.selectloantypetf.didSelect{(b , index ,id) in
            self.selectedlist = b
          
            self.lblProductDetail.isHidden = false
            self.productview.isHidden = false
            self.productview.dropShadow1()
            self.lblProductDetail.text = b
            self.selectloantypetf.isSelected = true
            self.selectloantypetf.selectedRowColor = UIColor.gray
            self.selectloantypetf.isSearchEnable = true
            DataManager.instance.productText = self.selectloantypetf.text
            DataManager.instance.NanoLoanProductType = b
            self.btnCheckLoanEligibility.isHidden = false
            self.nextoutlet.isHidden = true
            self.amounttextfield.text = ""
            self.getproductid()
           
        }
        self.selecttypetf2.didSelect{(b , index ,id) in
            self.lblProductDetail.isHidden = true
            self.productview.isHidden = true
            self.selectpurpose = Int(b)
            self.selecttypetf2.isSelected = true
            self.selecttypetf2.selectedRowColor = UIColor.gray
            self.selecttypetf2.isSearchEnable = true
            DataManager.instance.NanoLoanType = "\(b)"
            self.btnCheckLoanEligibility.isHidden = false
            self.nextoutlet.isHidden = true
            self.amounttextfield.text = ""
        }
        var tap = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        backgroundview.isUserInteractionEnabled = true
        backgroundview.addGestureRecognizer(tap)
       
        
    }
    
    @IBOutlet weak var backgroundview: UIView!
    @objc func didTap(onTableView recognizer: UIGestureRecognizer) {
//        var tapLocation: CGPoint = recognizer.location(in: backgroundview)
        self.lblProductDetail.isHidden = true
        self.productview.isHidden = true
        
            }
    
    @IBOutlet weak var lblProductDetail: UILabel!
    @IBOutlet weak var productview: UIView!
    @IBOutlet weak var selectloantypetf: DropDown!
    @IBOutlet weak var cameraimage: UIImageView!
    @IBOutlet weak var selecttypetf2: DropDown!
    @IBOutlet weak var amounttextfield: UITextField!
    @IBOutlet weak var nextoutlet: UIButton!
    @IBAction func select_loan(_ sender: DropDown) {
        DataManager.instance.NanoLoanProductType = self.selectloantypetf.text
       
    }
    
    @IBAction func Loan_type(_ sender: DropDown) {
        DataManager
            .instance.NanoLoanType =  self.selecttypetf2.text
    }
    
    @IBAction func amountf(_ sender: UITextField) {
        DataManager.instance.Nanoloanamount = self.amounttextfield.text
    }
    @IBAction func CheckLoanEligibilty(_ sender: UIButton) {
        if selectloantypetf.text?.count == 0
        {
            self.showToast(title: "Please Select Loan Product ")
            return
        }
        if selecttypetf2.text?.count == 0{
            self.showToast(title: "Please Select Loan Purpose")
            return
        }
        if amounttextfield.text?.count == 0{
            self.showToast(title: "Please Enter amount")
            return
            
        }
        
        if Int(amounttextfield.text!) ?? 0  < Int((minvalu)! ?? 0)
        {
            self.showToast(title: "Enter amount between  \(minvalu!) to \(maxvalue!)")
            return
        }
        else if   Int(amounttextfield.text!) ?? 0  > Int((maxvalue)! ?? 0)
        {
            self.showToast(title: "Enter amount between  \(minvalu!) to \(maxvalue!)")
            return

        }
        checkvalue()
        
    }
    
    func checkvalue()
    {
        if (selecttypetf2 == nil)  && (selectloantypetf == nil) {
            nextoutlet.isHidden = true
            amounttextfield.isHidden = true
            
        }
        else{
            amounttextfield.isHidden = false
            
            
        }
        self.checkLoanEligibility()
        
        
    }
    @IBAction override func bookMePressed(_ sender: Any) {
        let bookMeVC = self.storyboard!.instantiateViewController(withIdentifier: "BookMeVC") as! BookMeVC
        self.navigationController!.pushViewController(bookMeVC, animated: true)
    }
    @IBAction override func careemPressed(_ sender: Any) {
        ///self.goToCareem()
        let inviteFriendVC = self.storyboard?.instantiateViewController(withIdentifier: "InviteFriendVC") as! InviteFriendVC
        self.navigationController?.pushViewController(inviteFriendVC, animated: true)
    }
    @IBAction override func golootloPressed(_ sender: Any) {
        //        self.showToast(title: "Coming Soon")
        UtilManager.showAlertMessage(message: "Coming Soon", viewController: self)
        //  self.golootlo()
//         let vc = UIStoryboard(name: "Messages", bundle: Bundle.main).instantiateViewController(withIdentifier: "MessagesChat") as! MessagesChat
//        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func contactus(_ sender: UIButton) {
        let inviteFriendVC = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        self.navigationController?.pushViewController(inviteFriendVC, animated: true)
    }
    
    @IBAction func home(_ sender: UIButton) {
        let inviteFriendVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(inviteFriendVC, animated: true)
        
    }
    
    @IBAction func next(_ sender: UIButton)  {
        self.amount = Int(self.amounttextfield.text!)
        if selectloantypetf.text?.count == 0
        {
            self.showToast(title: "Please Select Loan ")
            return
        }
        if selecttypetf2.text?.count == 0{
            self.showToast(title: "Please Select Loan Product")
            return
        }
        if amounttextfield.text?.count == 0{
            self.showToast(title: "Please Enter amount")
            return
            
        }
       
        if (amount!  < minvalu ?? 0)
        {
            self.showToast(title: "Enter amount between  \(minvalu) to \(maxvalue!)")
            return
        }
        if (amount!   > maxvalue ?? 0)
        {
            self.showToast(title: "Enter amount between  \(minvalu!) to \(maxvalue!)")
            return
            
        }
        
        let tempImage = UIImage(named: "icons8-male-user-100-2")!
        if cameraimage.image!.isEqualToImage(tempImage) {
            self.showToast(title: "Please Take your Photo")
        }
        else {
            if let imageUser = self.cameraimage.image{
                              userSelfie = ConvertImageToBase64String(img: imageUser)
                              userSelfie = ConvertImageToBase64String(img: imageUser)
                         }
            self.popupalert()
        }
    }
    func popupalert()
    {
        let loanamount = "Principal Amount : PKR \(amounttextfield.text ?? "")"
        let loanpurpose = "Loan Purpose : \(selecttypetf2.text ?? "")"
        let loantenure = "Loan Tenure :\(selectloantypetf.text ?? "")"
        let processingFeeAmount = "Processing fee:  PKR \(fromapiprocessingFeeAmount ?? 0)"
        let markupfee = "Markup Percentage: \(fromapimarkupfee ?? 0) %"
        let noOfDays = "No of Days :\(fromapinoOfDays ?? 0)"
        let RepaymentFrequency = "Frequency: \(RepaymentFrequency! ?? "")"
        let message = "Your loan with following details have been approved: \n\(loanamount) \n\(loanpurpose) \n\(loantenure) \n\(processingFeeAmount) \n\(markupfee) \n\(noOfDays)  \n\(RepaymentFrequency) \n\("Processing fee will be deducted in advance from the loan amount being disbursed.")"
        
        let consentAlert = UIAlertController(title: "Loan Detail Summary", message: message,preferredStyle: UIAlertControllerStyle.alert)
        
        consentAlert.addAction(UIAlertAction(title: "ACCEPT".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
            
            self.SendOtpForLoan()
        }))
        
        consentAlert.addAction(UIAlertAction(title: "REJECT".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
            
            self.dismiss(animated: true, completion:nil)
        }))
        DispatchQueue.main.async {
            self.present(consentAlert, animated: true, completion: nil)
            
        }
    }
    
    var SelectProduct :String?
    var ProductId : Int?
    var minvalu : Int?
    var maxvalue : Int?
    
    
    func getproductid()
    {
        
        
        if let  productlist = self.Nanloangetprocutobj?.data
        {
            for data in productlist
            {
                if selectedlist == data.nlProductDescr
                {
                    ProductId = data.nlProductId
                    DataManager.instance.NanoloanProductid = ProductId
                    minvalu = data.minAmount
                    maxvalue = data.maxAmount
                    print("id is",DataManager.instance.NanoloanProductid!)
                    print("min is",minvalu!)
                    print("max is",maxvalue!)
                }
            }
            amounttextfield.placeholder = "Enter amount between  \(minvalu ?? 0) to \(maxvalue ?? 0)"
            
        }
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.openCamera()
        
    }
    
    @IBAction func back(_ sender: UIButton) {
        selfiNanoloan = ""
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logout(_ sender: UIButton) {
        self.popUpLogout()
    }
    
    private func checkLoanEligibility() {
        
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
        print("product id is given::::", ProductId)
        let compelteUrl = GlobalConstants.BASE_URL + "checkLoanEligibility"
        //        let compelteUrl  = GlobalConstants.demourl +  "http://bbuat.fmfb.pk/nanoloan/checkLoanEligibility"
        let parameters = ["imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"amount" :amounttextfield.text!,"productId": ProductId!,"apiCheck":"B"] as [String : Any]
        
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        if let imageUser = self.cameraimage.image{
            //            selfiNanoloan = "true"
            userSelfie = ConvertImageToBase64String(img: imageUser)
            print("userSelfie true", selfiNanoloan)
        }
        
        print(params)
        print(compelteUrl)
        print(header)
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<CheckEligilibityModel>) in
            self.hideActivityIndicator()
            
            self.CheckLoanObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.CheckLoanObj?.responsecode == 2 || self.CheckLoanObj?.responsecode == 1 {
                   
                    fromapimarkupfee = 100 * (CheckLoanObj?.data?[0].markupfee! ?? 0)
                    fromapinoOfDays = CheckLoanObj?.data?[0].noOfDays! ?? 0
                    fromapiprocessingFeeAmount = CheckLoanObj?.data?[0].processingFeeAmount! ?? 0
                    RepaymentFrequency = CheckLoanObj?.data?[0].repaymentFrequency! ?? ""
                    
                    let consentAlert = UIAlertController(title: "", message: self.CheckLoanObj?.messages! , preferredStyle: UIAlertControllerStyle.alert)
       
                    consentAlert.addAction(UIAlertAction(title: "YES".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
                        if  Int(amounttextfield.text!) ?? 0 < Int((CheckLoanObj?.data?[0].maxAmount!)! ?? 0)
                        {
                            amounttextfield.text =   amounttextfield.text
                        }
                        else{
                            amounttextfield.text = "\(CheckLoanObj?.data?[0].maxAmount! ?? 0)"
                        }
                        nextoutlet.isHidden = false
                        btnCheckLoanEligibility.isHidden = true
            
            
//
        }))
        
        consentAlert.addAction(UIAlertAction(title: "NO".addLocalizableString(languageCode: languageCode), style: .cancel, handler: { (action: UIAlertAction!) in
            amounttextfield.text = ""
            nextoutlet.isHidden = true
            btnCheckLoanEligibility.isHidden = false
            
//
        }))
                    self.present(consentAlert, animated: true, completion: nil)
    
                
                    
//                    if let message = self.CheckLoanObj?.messages{
//                        if message == "All Nano Loan Products"{
//
//                    }
//                        else{
//                        self.showDefaultAlert(title: "", message: message)
//                    }
//                }
                    
                }
                else {
                    if let message = self.CheckLoanObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
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
    
    private func NanoloangetProduct() {
        
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
        print("product id is given::::", ProductId)
        let compelteUrl = GlobalConstants.BASE_URL + "getNanoLoanProducts"
       
//        let parameters = ["imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"amount" :"5000","productId": "2", "apiCheck":"L"] as [String : Any]
        
//        print(parameters)
        
//        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
//        print(result.apiAttribute1)
//        print(result.apiAttribute2)
        
//        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
       
//        print(params)
        print(compelteUrl)
        print(header)
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<NanoloangetProductModel>) in
            self.hideActivityIndicator()
            
            self.Nanloangetprocutobj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.Nanloangetprocutobj?.responsecode == 2 || self.Nanloangetprocutobj?.responsecode == 1 {
                
                    if let typelist = self.Nanloangetprocutobj?.data{

                        for data in typelist
                        {
                            datalist.append(data.nlProductDescr ?? "")
                            if selectedlist == data.nlProductDescr
                            {
                                typeId = data.nlProductId
                                //                                minamount = data.minAmount
                                //                                maximumamount = data.maxAmount
                                print("product id",typeId)
                                DataManager.instance.LoanType = typeId
                                print( DataManager.instance.LoanType)
                            }
                        }

                        typeId = self.Nanloangetprocutobj?.data?[0].nlProductId
                        selectloantypetf.optionArray = datalist
//                        come
                        self.getLoanpurpose()
//                        self.lblProductDetail.isHidden = true
//                        self.productview.isHidden = true
                    }
//                    //
                    self.getLoanpurpose()
                    
                }
                else {
                    if let message = self.Nanloangetprocutobj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.Nanloangetprocutobj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
                //                print(response.result.value)
                //                print(response.response?.statusCode)
            }
        }
    }
    
    private func getLoanpurpose() {
        
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
        
        //        let compelteUrl = "http://bbuat.fmfb.pk/nanoloan/getLoanPurpose"
        let compelteUrl  = GlobalConstants.BASE_URL + "getLoanPurpose"
        let parameters = ["":""]
        
        
        //
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        
        print(compelteUrl)
        print(header)
        
        //        NetworkManager.sharedInstance.enableCertificatePinning()
        //
        //        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<getloanpuppose>) in
        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<getloanpuppose>) in
            self.hideActivityIndicator()
            
            self.geloanpurposeobj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.geloanpurposeobj?.responsecode == 2 || self.geloanpurposeobj?.responsecode == 1 {
//                    self.lblProductDetail.isHidden = true
//                    self.productview.isHidden = true
                    if let purposedescrlist = self.geloanpurposeobj?.data{
                        for data in purposedescrlist
                        {
                            self.descrptionlist.append(data.nlPurposeDescr ?? "")
                            if self.selectpurpose == data.nlPurposeId
                            {
                                self.loanid = data.nlPurposeId
                                print(self.loanid)
                                DataManager.instance.Nanoloantype = self.loanid
                                print(DataManager.instance.Nanoloantype)
                            }
                            self.loanid = data.nlPurposeId!
                            self.getproductid()
                        }
                        
                        self.selecttypetf2.optionArray = self.descrptionlist
                    }
                    
                    
                }
                else {
                    if let message = self.geloanpurposeobj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.geloanpurposeobj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
                //                print(response.result.value)
                //                print(response.response?.statusCode)
            }
        }
    }
    //    for open camera
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func updatePhoto(){
        //        if imgflag == "true"
        //        {
        
        
        if let imageCheck = UserDefaults.standard.object(forKey: "userimage"){
            cameraimage.layer.cornerRadius = cameraimage.frame.height / 2
            cameraimage.layer.masksToBounds = false
            cameraimage.clipsToBounds = true
            let retrievedImage = imageCheck
            self.cameraimage.image = UIImage(data: retrievedImage as! Data)
            //                let imageData:Data = ca.jpegData(compressionQuality: 0.5)!
            //                           let imgStr = imageData.base64EncodedString()
            //
            //                           print("base url " , imgStr)
            
            
            //            }
            
        }
    }
    func openCamera(){
       
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
            self.CaptureImage = img
            //            selfiNanoloan = "true"
        }
        
        else if let img = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.CaptureImage = img
            //            selfiNanoloan = "true"
        }
        let image = self.CaptureImage
        let pngImage =  UIImagePNGRepresentation(image!)
        UserDefaults.standard.set(pngImage, forKey: "userimage")
        let imageData:NSData = UIImagePNGRepresentation(cameraimage.image!)! as NSData
        selfiNanoloan = "true"
        //          fetchimage = UserDefaults.standard.set(pngImage, forKey: "userimage")
        self.updatePhoto()
        dismiss(animated: true, completion: nil)
    }
    //       send otp api calling check kahan laga ha?
    private func SendOtpForLoan() {
        
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
        if let checkuserimg = self.cameraimage.image{
            userimg = ConvertImageToBase64String(img: checkuserimg)
        }
        else{
            userimg = "No Image"
            self.showToast(title: "Please Capture Image ")
            return
        }
        
        if let imageUser = self.cameraimage.image{
            userSelfie = ConvertImageToBase64String(img: imageUser)
            print(userSelfie)
        }
        else{
            userSelfie  = "No Image"
            self.showToast(title: " Please capture Image")
            return
        }
        
        //        let compelteUrl = "http://bbuat.fmfb.pk/nanoloan/sendOtpForLoan"
        let compelteUrl  = GlobalConstants.BASE_URL + "sendOtpForLoan"
        let parameters = ["imei":DataManager.instance.imei!,"cnic":userCnic!] as [String : Any]
        
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
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<GenericResponse>) in
            self.hideActivityIndicator()
            
            self.genResObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.genResObj?.responsecode == 2 || self.genResObj?.responsecode == 1 {
                    print("api done")
                    
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "NLOTPVerificationVC") as! NLOTPVerificationVC
                    vc.amount = amounttextfield.text!
                    vc.loanPurpose = "\(loanid!)"
                    print("loan id is:" ,  loanid)
                    vc.LoanProfileimage = userSelfie!
                    print(amounttextfield.text!)
                    print(selecttypetf2.text!)
                    print(userSelfie!)
                    //
                    self.navigationController!.pushViewController(vc, animated: true)
                   
                }
                else {
                    if let message = self.genResObj?.messages{
                        self.showAlert(title: (self.genResObj?.messages)! , message: message, completion: {
                            self.navigationController?.popViewController(animated: true)
                        })
                        //
                    }
                }
            }
            else {
                if let message = self.genResObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
                //                print(response.result.value)
                //                print(response.response?.statusCode)
            }
        }
    }
    
    
}

class Checkloaneligibilty
{
    var nlProductId = 0
    var maxAmount = 0
    var minAmount = 0
    var nlProductDescr = ""
    var repaymentFrequency = ""
}

extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}
extension UIImage {
    //Bari ho jao bachi ni ho mujh sy moti ho
    func isEqualToImage(_ image: UIImage) -> Bool {
        return UIImagePNGRepresentation(self) == UIImagePNGRepresentation(image)
    }
    
}
