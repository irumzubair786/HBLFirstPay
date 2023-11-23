//
//  NanoLoanApplyViewController.swift
//  HBLFMB
//
//  Created by Apple on 24/03/2023.
//

import UIKit
import Alamofire
import Foundation
import SwiftyJSON

class NanoLoanApplyViewController: UIViewController {
    
    @IBOutlet weak var labelLoanAmount: UILabel!
    
    @IBOutlet weak var labelLoanAmountDescription: UILabel!
    @IBOutlet weak var labelOtherDescription: UILabel!
    @IBOutlet weak var collectionViewLoanAmounts: UICollectionView!
    
    @IBOutlet weak var viewBenifitRepaying: UIView!
    
    @IBOutlet weak var buttonCreditLimitImprove: UIButton!
    @IBOutlet weak var viewEnterLoanAmount: UIView!
    @IBOutlet weak var viewApplyButton: UIView!
    
    @IBOutlet weak var buttonApply: UIButton!
    
    @IBOutlet weak var imageViewForwordButtonGray: UIImageView!
    
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var textFieldAmount: UITextField!
    let amountArray = ["PKR 1000", "PKR 2500", "PKR 5000"]
    var selectedAmountIndex: Int? {
        didSet {
            let text = "\(getLoanAmount(index: selectedAmountIndex!))"
            textFieldAmount.text = format(with: "PKR XXXXXX", phone: text)
            changeAmountInTextField()
        }
    }
    var modelGetActiveLoan: ModelGetActiveLoan? {
        didSet {
            if modelGetActiveLoan?.data?.currentLoan.count ?? 0 > 0 {
                
            }
            else {
                DispatchQueue.main.async {
                    self.nanoLoanEligibilityCheck()
                }
            }
        }
    }
    var modelNanoLoanEligibilityCheck: ModelNanoLoanEligibilityCheck? {
        didSet {
            if modelNanoLoanEligibilityCheck?.responsecode == 0 {
                self.viewBackGround.isHidden = true
                self.showEmptyView(message: modelNanoLoanEligibilityCheck?.messages, iconName: "repayEmptyIcon", buttonName: "Apply") { callBackAction, emptyView in
                    if callBackAction {
                        print("Function call")
                        //self.viewBackGround.isHidden = false
                        //emptyView.removeFromSuperview()
                    }
                }
            }
            else {
                if modelNanoLoanEligibilityCheck?.data?.count ?? 0 > 0 {
                    viewBackGround.isHidden = false
                    
                    labelLoanAmountDescription.text = "You can Apply a loan between Rs. \((modelNanoLoanEligibilityCheck?.data?.first?.minAmount ?? 0).twoDecimal()) - \((modelNanoLoanEligibilityCheck?.data?.first?.maxAmount ?? 0).twoDecimal())"
                    
                    labelOtherDescription.text = "Enjoy the lowest markup rate of \((modelNanoLoanEligibilityCheck?.data?.first?.markupfee ?? 0).twoDecimal())% monthly on loans. Repay early and save on daily markup amount."
                                        collectionViewLoanAmounts.reloadData()
                }
                else {

                }
            }
        }
    }
    var modelGetLoanCharges: ModelGetLoanCharges? {
        didSet {
            if modelGetLoanCharges?.responsecode == 0 {
                self.showAlertCustomPopup(title: "Error", message: modelGetLoanCharges?.messages ?? "", iconName: .iconError)
            }
            else {
                openConfirmationLoanVC()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FBEvents.logEvent(title: .Loans_apply_landing)
        FaceBookEvents.logEvent(title: .Loans_apply_landing)
        // Do any additional setup after loading the view.
        textFieldAmount.delegate = self
        textFieldAmount.text = "PKR "
        viewBackGround.isHidden = true
        
        viewApplyButton.circle()
        viewEnterLoanAmount.radius()
        ApplyAmountCell.register(collectionView: collectionViewLoanAmounts)
        textFieldAmount.addTarget(self, action: #selector(changeAmountInTextField), for: .editingChanged)
        
        DispatchQueue.main.async {
            self.viewBenifitRepaying.circle()
            self.viewBenifitRepaying.radiusLineDashedStroke(radius: self.viewBenifitRepaying.frame.height / 2, color: .clrGreen)
        }
    }
    func validationError() -> Bool {
        let text = textFieldAmount.text!.replacingOccurrences(of: "PKR ", with: "")
        if text == "" || text == "PKR" {
            return true
        }
        let minAmount = (modelNanoLoanEligibilityCheck?.data?.first?.minAmount ?? 0) - 1
        let maxAmount = (modelNanoLoanEligibilityCheck?.data?.first?.maxAmount ?? 0) + 1
        if (Int(text)! > minAmount && Int(text)! < maxAmount) {
            return false
        }
        return true
    }
    @IBAction func buttonApply(_ sender: Any) {
        if validationError() {
            //Error Message
            return()
        }
        getLoanCharges()
    }
    @IBAction func buttonCreditLimitImprove(_ sender: Any) {
        let vc = UIStoryboard.init(name: "NanoLoan", bundle: nil).instantiateViewController(withIdentifier: "NanoLoanImproveCreditLimit") as! NanoLoanImproveCreditLimit
        
        self.present(vc, animated: true)
    }
    func nanoLoanEligibilityCheck() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)"
        ]
        //NOTE:
        //        agar currentLoan object me data araha ha to ye api call ni ho ge
        //        agar ni a raha to ye api call karin ga r data disply karwa dain ga
        APIs.postAPI(apiName: .nanoLoanEligibilityCheck, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            if success {
                
            }
            let model: ModelNanoLoanEligibilityCheck? = APIs.decodeDataToObject(data: responseData)
            self.modelNanoLoanEligibilityCheck = model
        }
    }
    
    func getLoanCharges() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
            "amount" : "1000",
            //            "productId" : "2"
            "productId" : "\(DataManager.instance.NanoloanProductid ?? 2)"
        ]
        
        APIs.postAPI(apiName: .getLoanCharges, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: ModelGetLoanCharges? = APIs.decodeDataToObject(data: responseData)
            self.modelGetLoanCharges = model
        }
    }
    
    func openConfirmationLoanVC() {
        let vc = UIStoryboard.init(name: "NanoLoan", bundle: nil).instantiateViewController(withIdentifier: "NanoLoanConfirmationVC") as! NanoLoanConfirmationVC
        vc.selectedAmount = Int(self.textFieldAmount.text!.replacingOccurrences(of: "PKR ", with: ""))
        vc.modelNanoLoanEligibilityCheck = self.modelNanoLoanEligibilityCheck
        vc.modelGetLoanCharges = self.modelGetLoanCharges
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func changeAmountInTextField() {
        var text = textFieldAmount.text!.replacingOccurrences(of: "PKR ", with: "")
        textFieldAmount.text = format(with: "PKR XXXXXX", phone: text)
        if textFieldAmount.text != "" {
            text = textFieldAmount.text!.replacingOccurrences(of: "PKR ", with: "")
            let minAmount = (modelNanoLoanEligibilityCheck?.data?.first?.minAmount ?? 0) - 1
            let maxAmount = (modelNanoLoanEligibilityCheck?.data?.first?.maxAmount ?? 0) + 1

            let selectedColor = (Int(text)! > minAmount && Int(text)! < maxAmount) ? UIColor.clrGreen : UIColor.clrLightRed
           
            imageViewForwordButtonGray.image = selectedColor == .clrGreen ? UIImage(named: "forwardButtonGreenIcon") : UIImage(named: "forwardButtonGray")
            textFieldAmount.attributedText = attributedText(textField: textFieldAmount, withString: textFieldAmount.text!, boldString: text, boldStringColor: selectedColor)
//            if selectedColor != .clrGreen {
//                selectedAmountIndex = nil
//                collectionViewLoanAmounts.reloadData()
//            }
        }
        else {
            textFieldAmount.text = "PKR"
            imageViewForwordButtonGray.image = UIImage(named: "forwardButtonGray")
//            selectedAmountIndex = nil
//            collectionViewLoanAmounts.reloadData()
        }
    }
}
extension NanoLoanApplyViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}


extension NanoLoanApplyViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsInRow = 3.2
        let width = collectionView.bounds.width
        let cellWidth = width / CGFloat(itemsInRow)
        return CGSize(width: cellWidth, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amountArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApplyAmountCell", for: indexPath) as! ApplyAmountCell
        cell.labelAmount.text = "PKR \(getLoanAmount(index: indexPath.item).twoDecimal())"
        if selectedAmountIndex != nil && indexPath.item == selectedAmountIndex {
            cell.viewBackGround.backgroundColor = .clrOrange
            cell.labelAmount.textColor = .white
        }
        else {
            cell.viewBackGround.backgroundColor = .clrExtraLightGray
            cell.labelAmount.textColor = .clrTextNormal
        }
        cell.viewBackGround.borderColor = .clrBlackWithOccupacy20
        cell.viewBackGround.borderWidth = 1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            (cell as! ApplyAmountCell).viewBackGround.circle()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedAmountIndex = indexPath.item
        collectionViewLoanAmounts.reloadData()
    }
    
    func getLoanAmount(index: Int) -> Int {
        if index == 0 {
            return modelNanoLoanEligibilityCheck?.data?.first?.minAmount ?? 0
        }
        else if index == 1 {
            return modelNanoLoanEligibilityCheck?.data?.first?.avgAmount ?? 0
        }
        else if index == 2 {
            return modelNanoLoanEligibilityCheck?.data?.first?.maxAmount ?? 0
        }
        else {
            return 0
        }
    }
}




/// mask example: `+X (XXX) XXX-XXXX`
func format(with mask: String, phone: String) -> String {
    let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    var result = ""
    var index = numbers.startIndex // numbers iterator
    
    // iterate over the mask characters until the iterator of numbers ends
    for ch in mask where index < numbers.endIndex {
        if ch == "X" {
            // mask requires a number in this place, so take the next one
            result.append(numbers[index])
            
            // move numbers iterator to the next index
            index = numbers.index(after: index)
            
        } else {
            result.append(ch) // just append a mask character
        }
    }
    return result
}

func attributedText(textField: UITextField, withString string: String, boldString: String, boldStringColor: UIColor) -> NSAttributedString {
    let font = textField.font!
    let completeString = string
    let boldStringLocal = boldString
    let labelWidth = textField.frame.size.width
    let myStyle = NSMutableParagraphStyle()
    myStyle.tabStops = [NSTextTab(textAlignment: .left, location: 0.0, options: [:]),
                        NSTextTab(textAlignment: .right, location: labelWidth, options: [:])]
    
    let attributedString = NSMutableAttributedString(
        string: completeString,
        attributes: [NSAttributedString.Key.font: font])
    let boldFontAttribute: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: UIFont(name: "WorkSans-SemiBold", size: font.pointSize) ?? UIFont.boldSystemFont(ofSize: font.pointSize)
    ]
    
    let range = (completeString as NSString).range(of: boldStringLocal)
    attributedString.addAttributes(boldFontAttribute, range: range)
    attributedString.addAttribute(.foregroundColor, value: boldStringColor, range: range)
    
    attributedString.addAttribute(.paragraphStyle, value: myStyle, range: range)
    
    return attributedString
}
