//
//  TransferAmountVc.swift
//  First Pay
//
//  Created by Irum Butt on 04/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
import SDWebImage
class TransferAmountVc: BaseClassVC , UITextFieldDelegate{
    @IBOutlet weak var viewBackGroungEnterAmount: UIImageView!
    @IBOutlet weak var viewBackGroundButton: UIView!
    var arrAmount = ["Rs.100","Rs.250","Rs.500","Rs.1000"]
    var IsSelectedAmount = true
    var selectedAmount:String?
    var myarr = [amount]()
    var fundsTransSuccessObj: TopUpApiResponse?
    var phoneNumber  : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBackGroungEnterAmount.radius(radius: 20)
        viewBackGroundButton.circle()
        collectionView.delegate = self
        collectionView.dataSource = self
        btnContinue.isUserInteractionEnabled = false
        amountTextField.delegate = self
        backbtn.setTitle("", for: .normal)
        
        img_next_arrow.isUserInteractionEnabled = false
        appendArray()
        updateui()
        self.amountTextField.addTarget(self, action: #selector(changeTextInTextField), for: .editingChanged)

        // Do any additional setup after loading the view.
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissViewController), name: Notification.Name("dismissViewController"), object: nil)
    }
  
    @objc func dismissViewController() {
        self.dismiss(animated: true)
    }
    @objc func changeTextInTextField() {
        for i in  myarr {
            i.isSeleccted = false
        }
        setColorTextField(isFromChangeChar: true)
        if amountTextField.text?.count ?? 0 > 000
        {
            if Int(amountTextField.text!.getIntegerValue()) ?? 0  < (minValue)  || Int(amountTextField.text!.getIntegerValue()) ?? 0 > (maxValue)
            {
                let image = UIImage(named:"grayArrow")
                img_next_arrow.image = image
                img_next_arrow.isUserInteractionEnabled = false
                btnContinue.isUserInteractionEnabled = false
                
            }
            else
            {
                let image = UIImage(named:"]greenarrow")
                img_next_arrow.image = image
                img_next_arrow.isUserInteractionEnabled = true
                btnContinue.isUserInteractionEnabled = true
                lblAmountLimit.textColor = UIColor(red: 241/255, green: 147/255, blue: 52/255, alpha: 1)
    
                amountTextField.textColor = UIColor.clrGreen
                self.collectionView.reloadData()
                
            }
        }
            else  if amountTextField.text?.count == 0
            {
                let image = UIImage(named:"grayArrow")
                img_next_arrow.image = image
                img_next_arrow.isUserInteractionEnabled = false
                btnContinue.isUserInteractionEnabled = false
            }
   
    }
    

    func setColorTextField(isFromChangeChar: Bool? = false) {
        if myarr.count > 0 {
            var text = amountTextField.text?.getIntegerValue()
            if text == "" {
                return
            }
            
            var tempText = text?.components(separatedBy: ".").first as? String
            if tempText == nil {
                text = (amountTextField.text?.getIntegerValue())!
            }
            else {
                text = tempText ?? ""
            }
            amountTextField.text = text
            if amountTextField.text != "" {
                text = amountTextField.text!.replacingOccurrences(of: "", with: "")
                
                let minAmount = Int(myarr.first!.valueamount.getIntegerValueFromFirstIndex())! - 1
                let maxAmount = (Int(myarr.last!.valueamount.getIntegerValueFromFirstIndex()) ?? 0) + 1

                let selectedColor = (Int(text!)! > minAmount && Int(text!)! < maxAmount) ? UIColor.clrGreen : UIColor.clrLightRed
                amountTextField.textColor = selectedColor
                text = String(Int(text!)!.twoDecimal())
                text = text?.components(separatedBy: ".").first as? String
                amountTextField.text = text
               // amountTextField.attributedText = attributedText(textField: amountTextField, withString: amountTextField.text!, boldString: text!, boldStringColor: selectedColor)
                
                lblAmountLimit.textColor = selectedColor
                
                if selectedColor == UIColor.clrGreen {
                    let image = UIImage(named:"]greenarrow")
                    img_next_arrow.image = image
                    img_next_arrow.isUserInteractionEnabled = true
                    btnContinue.isUserInteractionEnabled = true
                }
                else {
                    let image = UIImage(named:"grayArrow")
                    img_next_arrow.image = image
                    img_next_arrow.isUserInteractionEnabled = false
                    btnContinue.isUserInteractionEnabled = false
                }
            }
        }
        if isFromChangeChar! {
            self.collectionView.reloadData()
        }
    }
//    hhhh
    var minValue = 100
    var maxValue = 10000
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var imgoperator: UIImageView!
    @IBOutlet weak var lblAmountLimit: UILabel!
    @IBOutlet weak var img_next_arrow: UIImageView!
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func Action_back(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func Action_Continue(_ sender: UIButton) {
        initiateTopUp()
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        img_next_arrow.isUserInteractionEnabled = true
        img_next_arrow.addGestureRecognizer(tapGestureRecognizerr)
    }
    @IBOutlet weak var btn: UIButton!
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)
    {
                initiateTopUp()
    
        
//        self.present(vc, animated: true)
    }
      
    func appendArray(){
        for i in  arrAmount{

            myarr.append(amount(valueamount: i, isSeleccted: false))
        }
    }
    
    @IBOutlet weak var labelMainTitle: UILabel!
    func updateui()
    {
        let url = URL(string:"\(GlobalConstants.BASE_URL)\(GlobalData.selected_operator_logo!)")
        imgoperator.sd_setImage(with: url)
        
        labelMainTitle.text = GlobalData.topup
//        imgoperator.image = GlobalData.selected_operator_logo
        lblMobileNumber.text =  phoneNumber
       
    }
  
    @objc func buttontaped(indexPath: IndexPath) {
        let tag = indexPath.item
        self.amountTextField.textColor = .gray
        let cell = collectionView.cellForItem(at: indexPath) as! cellAmount
        for i in  myarr{
            i.isSeleccted = false
        }
        cell.btnAmount.circle()
        cell.btnAmount.borderWidth = 1
        cell.btnAmount.borderColor = .clrLightGray
        self.myarr[tag].isSeleccted = true
        cell.btnAmount.setTitleColor(.white, for: .normal)
        ///set title color here to white
        let setimg = UIImage(named: "")
        cell.btnAmount.backgroundColor = UIColor(hexString: "CC6801")
        //        cell.backView.backgroundColor =  UIColor(red: 241/255, green: 147/255, blue: 52/255, alpha: 1)
        //        cell.btnAmount.borderColor = .clear
        let a = cell.btnAmount.currentTitle
        let x = a?.substring(from: 3)
        amountTextField.text = x
//        change
        btnContinue.isUserInteractionEnabled = true
        let image = UIImage(named:"]greenarrow")
        img_next_arrow.image = image
        img_next_arrow.isUserInteractionEnabled = true
        lblAmountLimit.textColor = UIColor(red: 241/255, green: 147/255, blue: 52/255, alpha: 1)
        self.collectionView.reloadData()
    }
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == amountTextField
         {
            for i in myarr
            {
                i.isSeleccted = false
                
            }
            collectionView.reloadData()
         }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength:Int = (textField.text?.count)! + string.count - range.length
     
        if textField == amountTextField{
            return newLength <= 6
            
//            lbl1.textColor = UIColor.green
        }
        if textField == amountTextField{
            return newLength <= 6
        }
        return newLength <= 6
        
    
}
    
    private func initiateTopUp() {
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
        
        
//        let compelteUrl = GlobalConstants.BASE_URL + "topUp"
        let compelteUrl = GlobalConstants.BASE_URL + "\(transactionV1or2)/topUp"
        
       
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["lat":"\(DataManager.instance.Latitude)","lng":"\(DataManager.instance.Longitude)","channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!,"cnic":userCnic!,"utilityBillCompany":   GlobalData.Select_operator_code,"utilityConsumerNo":self.phoneNumber!, "accountType": DataManager.instance.accountType!]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        print(header)
                NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
//            (response: DataResponse<TopUpApiResponse>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.fundsTransSuccessObj = Mapper<TopUpApiResponse>().map(JSONObject: json)
                
                
                
                //            self.fundsTransSuccessObj = response.result.value
                if response.response?.statusCode == 200 {
                    
                    if self.fundsTransSuccessObj?.responsecode == 2 || self.fundsTransSuccessObj?.responsecode == 1 {
                        self.navigatezToConfirmationVC()
                    }
                    else {
                        if let message = self.fundsTransSuccessObj?.messages{
                            self.showDefaultAlert(title: "", message: "\(message) \(self.fundsTransSuccessObj?.messages ?? "") ")
                        }
                    }
                }
                else {
                    if let message = self.fundsTransSuccessObj?.messages{
                        self.showAlertCustomPopup(title: "",message: message, iconName: .MismatchNumber)                }
                    print(response.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
    
    func navigatezToConfirmationVC()
    {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "TransferAmountConfirmationVc") as! TransferAmountConfirmationVc
        vc.amount =  (amountTextField.text!.getIntegerValue())
        vc.phoneNumber = phoneNumber
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
//        self.navigationController!.pushViewController(vc, animated: false)
    }
    
    
    
    
    
    
    
}
extension TransferAmountVc: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myarr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView .dequeueReusableCell(withReuseIdentifier: "cellAmount", for: indexPath) as! cellAmount
         
        if(myarr[indexPath.row].isSeleccted == true)
        {
            cell.btnAmount.setTitleColor(.white, for: .normal)
            cell.btnAmount.backgroundColor = UIColor(red: 241/255, green: 147/255, blue: 52/255, alpha: 1)
            cell.btnAmount.borderColor = UIColor(red: 241/255, green: 147/255, blue: 52/255, alpha: 1)
        }
        else
        {
            cell.btnAmount.setTitleColor(.black, for: .normal)
            cell.btnAmount.backgroundColor = .clear
        }
        
        
        cell.btnAmount.tag = indexPath.row
        cell.btnAmount.setTitle(myarr[indexPath.row].valueamount, for: .normal)
        cell.btnAmount.addTarget(self, action: #selector(buttontaped), for: .touchUpInside)
  
        cell.btnAmount.circle()
        cell.btnAmount.borderWidth = 1
        cell.btnAmount.borderColor = .clrLightGray
        return cell

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! cellAmount
        buttontaped(indexPath: indexPath)
        setColorTextField()
    }
    
   
}
class amount
{
    var valueamount : String
    var isSeleccted : Bool
    init(valueamount : String , isSeleccted : Bool ){
        self.valueamount = valueamount
        self.isSeleccted = isSeleccted
    }
    
}
