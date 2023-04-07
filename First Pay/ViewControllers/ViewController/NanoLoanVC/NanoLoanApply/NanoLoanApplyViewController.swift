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
    
    @IBOutlet weak var textFieldAmount: UITextField!
    var selectedAmountIndex: Int? {
        didSet {
            let text = "\(getLoanAmount(index: selectedAmountIndex!))"
            textFieldAmount.text = format(with: "PKR XXXXXX", phone: text)
            changeAmountInTextField()
        }
    }
    var modelGetActiveLoan: ModelGetActiveLoan? {
        didSet {
            if modelGetActiveLoan?.data.currentLoan.count ?? 0 > 0 {
                
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
            if modelNanoLoanEligibilityCheck?.data.count ?? 0 > 0 {
                labelLoanAmountDescription.text = "You can Apply a loan between Rs. \(modelNanoLoanEligibilityCheck?.data.first?.minAmount ?? 0)-\(modelNanoLoanEligibilityCheck?.data.first?.maxAmount ?? 0)"
                labelOtherDescription.text = modelNanoLoanEligibilityCheck?.data.first?.nlProductDescr ?? ""
                
                collectionViewLoanAmounts.reloadData()
            }
        }
    }
    var modelGetLoanCharges: ModelGetLoanCharges? {
        didSet {
            openConfirmationLoanVC()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textFieldAmount.text = "PKR "
        
        viewBenifitRepaying.circle()
        viewApplyButton.circle()
        viewEnterLoanAmount.radius()
        ApplyAmountCell.register(collectionView: collectionViewLoanAmounts)
        textFieldAmount.addTarget(self, action: #selector(changeAmountInTextField), for: .editingChanged)
    }
    func validationError() -> Bool {
        let text = textFieldAmount.text!.replacingOccurrences(of: "PKR ", with: "")
        let minAmount = (modelNanoLoanEligibilityCheck?.data.first?.minAmount ?? 0) - 1
        let maxAmount = (modelNanoLoanEligibilityCheck?.data.first?.maxAmount ?? 0) + 1
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
                let model: ModelNanoLoanEligibilityCheck? = APIs.decodeDataToObject(data: responseData)
                print(model)
                print(model)
                self.modelNanoLoanEligibilityCheck = model
            }
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
            if success {
                let model: ModelGetLoanCharges? = APIs.decodeDataToObject(data: responseData)
                print(model)
                print(model)
                self.modelGetLoanCharges = model
            }
        }
    }
    
    func openConfirmationLoanVC() {
        let vc = UIStoryboard.init(name: "NanoLoan", bundle: nil).instantiateViewController(withIdentifier: "NanoLoanConfirmationVC") as! NanoLoanConfirmationVC
        DispatchQueue.main.async {
            vc.selectedAmount = Int(self.textFieldAmount.text!.replacingOccurrences(of: "PKR ", with: ""))
            vc.modelNanoLoanEligibilityCheck = self.modelNanoLoanEligibilityCheck
            vc.modelGetLoanCharges = self.modelGetLoanCharges
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func changeAmountInTextField() {
        var text = textFieldAmount.text!.replacingOccurrences(of: "PKR ", with: "")
        textFieldAmount.text = format(with: "PKR XXXXXX", phone: text)
        if textFieldAmount.text != "" {
            text = textFieldAmount.text!.replacingOccurrences(of: "PKR ", with: "")
            let minAmount = (modelNanoLoanEligibilityCheck?.data.first?.minAmount ?? 0) - 1
            let maxAmount = (modelNanoLoanEligibilityCheck?.data.first?.maxAmount ?? 0) + 1

            let selectedColor = (Int(text)! > minAmount && Int(text)! < maxAmount) ? UIColor.clrGreen : UIColor.clrLightRed
            
            textFieldAmount.attributedText = attributedText(textField: textFieldAmount, withString: textFieldAmount.text!, boldString: text, boldStringColor: selectedColor)
        }
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
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApplyAmountCell", for: indexPath) as! ApplyAmountCell
        cell.labelAmount.text = "PKR \(getLoanAmount(index: indexPath.item))"
        if selectedAmountIndex != nil && indexPath.item == selectedAmountIndex {
            cell.viewBackGround.backgroundColor = .clrOrange
        }
        else {
            cell.viewBackGround.backgroundColor = .clrBlackWithOccupacy20
        }
        
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
            return modelNanoLoanEligibilityCheck?.data.first?.minAmount ?? 0
        }
        else if index == 1 {
            return modelNanoLoanEligibilityCheck?.data.first?.avgAmount ?? 0
        }
        else if index == 2 {
            return modelNanoLoanEligibilityCheck?.data.first?.maxAmount ?? 0
        }
        else {
            return 0
        }
    }
    
    
}

extension NanoLoanApplyViewController {
    // This file was generated from JSON Schema using quicktype, do not modify it directly.
    // To parse the JSON, add this file to your project and do:
    
    // MARK: - ModelGetActiveLoan
    struct ModelGetActiveLoan: Codable {
        let messages: String
        let responseblock: JSONNull?
        let responsecode: Int
        let data: ModelActiveLoanData
    }
    
    // MARK: - DataClass
    struct ModelActiveLoanData: Codable {
        let loanHistory, currentLoan: [ModelCurrentLoan]
    }
    
    // MARK: - CurrentLoan
    struct ModelCurrentLoan: Codable {
        let loanAmount: Int
        let accountNo: String
        let markupRate: Int
        let accountTitle: String
        let installmentAmount: Int
        let startDate: String
        let nlDisbursementID, totalInstallments, totalMarkupAmount: Int
        let loanNo, endDate, nlProductDescr: String
        
        enum CodingKeys: String, CodingKey {
            case loanAmount = "loan_amount"
            case accountNo = "account_no"
            case markupRate = "markup_rate"
            case accountTitle = "account_title"
            case installmentAmount = "installment_amount"
            case startDate = "start_date"
            case nlDisbursementID = "nl_disbursement_id"
            case totalInstallments = "total_installments"
            case totalMarkupAmount = "total_markup_amount"
            case loanNo = "loan_no"
            case endDate = "end_date"
            case nlProductDescr = "nl_product_descr"
        }
    }
    
    // MARK: - ModelNanoLoanEligibilityCheck
    struct ModelNanoLoanEligibilityCheck: Codable {
        let responsecode: Int
        let data: [ModelNanoLoanEligibilityCheckData]
        let responseblock: JSONNull?
        let messages: String
    }
    
    // MARK: - Datum
    struct ModelNanoLoanEligibilityCheckData: Codable {
        let nlProductID, maxAmount, minAmount, avgAmount: Int
        let nlProductDescr: String
        let repaymentFrequency, processingFeeAmount, markupfee, markupAmountPerDay: Int?
        let loanAmount, noOfDays: Int?
        
        enum CodingKeys: String, CodingKey {
            case nlProductID = "nlProductId"
            case maxAmount, minAmount, avgAmount, nlProductDescr, repaymentFrequency, processingFeeAmount, markupfee, markupAmountPerDay, loanAmount, noOfDays
        }
    }
    
    
    // MARK: - ModelGetLoanCharges
    struct ModelGetLoanCharges: Codable {
        let responsecode: Int
        let responseblock: JSONNull?
        let messages: String
        let data: [String: Double?]
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
