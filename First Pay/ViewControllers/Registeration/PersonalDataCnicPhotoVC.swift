//
//  PersonalDataCnicPhotoVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 12/06/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class PersonalDataCnicPhotoVC: BaseClassVC , CardIOPaymentViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    var firstName:String?
    var middleName:String?
    var lastName:String?
    var motherName:String?
    var cityID: Int?
    var emailAddress:String?
    
    var personalDataObj : PersonalData?
    
    @IBOutlet weak var imgFrontCnic: UIImageView!
    @IBOutlet weak var imgBackCnic: UIImageView!
    @IBOutlet weak var imgUserSelfie: UIImageView!
    var picker = UIImagePickerController()
    var selectedImage : UIImage!
    
    var isFront: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Camera Usage
    
    func openCamera(){
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker.sourceType = .camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            picker.allowsEditing = false
            picker.delegate = self
            picker.cameraDevice = .front
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
        
        let image = self.selectedImage.resize(withPercentage: 0.5)
        self.imgUserSelfie.image = image
        let pngImage =  UIImagePNGRepresentation(image!)
        UserDefaults.standard.set(pngImage, forKey: "proImage")
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: - Action Methods
    
    
    @IBAction func nextButtonPressed(_ sender: Any)  {
        
        if self.imgFrontCnic.image == nil{
            self.showToast(title: "Please Select Cnic Front")
            return
        }
        if self.imgBackCnic.image == nil{
            self.showToast(title: "Please Select Cnic Back")
            return
        }
        if self.imgUserSelfie.image == nil{
            self.showToast(title: "Please Select User Photo")
            return
        }
        
     //   self.proceesToPin()
        
    }
    
    @IBAction func openCamera(_ sender: Any)  {
        self.openCamera()
    }
    
    @IBAction func cnicFrontPressed(_ sender: Any)  {
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        self.isFront = true
        cardIOVC?.detectionMode = .cardImageOnly
        cardIOVC?.hideCardIOLogo = true
        cardIOVC?.disableManualEntryButtons = true
        cardIOVC?.modalPresentationStyle = .formSheet
        present(cardIOVC!, animated: true, completion: nil)
    }
    @IBAction func cnicBackPressed(_ sender: Any)  {
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        self.isFront = false
        cardIOVC?.detectionMode = .cardImageOnly
        cardIOVC?.hideCardIOLogo = true
        cardIOVC?.disableManualEntryButtons = true
        cardIOVC?.modalPresentationStyle = .formSheet
        present(cardIOVC!, animated: true, completion: nil)
    }
    
    
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        paymentViewController?.dismiss(animated: true, completion: nil)
    }
    
    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            if self.isFront == true{
                self.imgFrontCnic.image = info.cardImage
            }
            else {
                self.imgBackCnic.image = info.cardImage
            }
        }
        paymentViewController?.dismiss(animated: true, completion: nil)
    }

    // MARK: - Api Call
    
    private func proceesToPin() {

        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }

        showActivityIndicator()


        if (firstName?.isEmpty)!{
            firstName = ""
        }
        if (middleName?.isEmpty)!{
            middleName = ""
        }
        if (lastName?.isEmpty)!{
            lastName = ""
        }
        if (motherName?.isEmpty)!{
            motherName = ""
        }
        if (emailAddress?.isEmpty)!{
            emailAddress = ""
        }

        var userCnic : String?
        let cnicFront: String?
        let cnicBack: String?
        let userSelfie: String?

        if let imageCnicFront = self.imgFrontCnic.image{
            cnicFront = ConvertImageToBase64String(img: imageCnicFront)
        }
        else{
            cnicFront = "No Image"
            self.showToast(title: "Please Select Front Cnic ")
            return
        }
        if let imageCnicBack = self.imgBackCnic.image{
            cnicBack = ConvertImageToBase64String(img: imageCnicBack)
        }
        else{
            cnicBack = "No Image"
            self.showToast(title: "Please Select Back Cnic ")
            return
        }

        if let imageUser = self.imgUserSelfie.image{
            userSelfie = ConvertImageToBase64String(img: imageUser)
        }
        else{
            userSelfie = "No Image"
            self.showToast(title: "Please Select your Photo ")
            return
        }
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }

        let compelteUrl = GlobalConstants.BASE_URL + "customerKyc"


        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"email":emailAddress!,"firstName":firstName!,"lastName":lastName!,"middleName":middleName!,"motherName":motherName!,"custselfie":userSelfie!,"custcnicF":cnicFront!,"custcnicB":cnicBack!,"createuser":"1","cnicIssueDate":DataManager.instance.cnicIssueDate!,"lkpCity":["cityId":"\(self.cityID!)"]] as [String : Any]

        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))

        print(result.apiAttribute1)
        print(result.apiAttribute2)

        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]

        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]

        print(params)
        print(compelteUrl)

        NetworkManager.sharedInstance.enableCertificatePinning()

        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<PersonalData>) in

     //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<PersonalData>) in



            self.hideActivityIndicator()

            self.personalDataObj = response.result.value
            if response.response?.statusCode == 200 {

                if self.personalDataObj?.responsecode == 2 || self.personalDataObj?.responsecode == 1 {

                    let enterPinVC = self.storyboard!.instantiateViewController(withIdentifier: "EnterPinVC") as! EnterPinVC
                    if let custID = self.personalDataObj?.customerId{
                        enterPinVC.customerID = custID
                    }
                    self.navigationController!.pushViewController(enterPinVC, animated: true)
                }
                else {
                    if let message = self.personalDataObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.personalDataObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
                print(response.result.value)
                print(response.response?.statusCode)
            }
        }
    }

}

extension UIImage {
    
    func resize(withPercentage percentage: CGFloat) -> UIImage? {
        var newRect = CGRect(origin: .zero, size: CGSize(width: size.width*percentage, height: size.height*percentage))
        UIGraphicsBeginImageContextWithOptions(newRect.size, true, 1)
        self.draw(in: newRect)
        defer {UIGraphicsEndImageContext()}
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
