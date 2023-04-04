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
    
    var modelGetActiveLoan: ModelGetActiveLoan? {
        didSet {
            if modelGetActiveLoan?.data.currentLoan.count ?? 0 > 0 {
                
            }
        }
    }
    var modelNanoLoanEligibilityCheck: ModelNanoLoanEligibilityCheck? {
        didSet {
            
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
        
        viewBenifitRepaying.circle()
        viewApplyButton.circle()
        viewEnterLoanAmount.radius()
        ApplyAmountCell.register(collectionView: collectionViewLoanAmounts)
        
        nanoLoanEligibilityCheck()
    }
    
    @IBAction func buttonApply(_ sender: Any) {
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
        
        APIs.postAPI(apiName: .nanoLoanEligibilityCheck, parameters: parameters) { responseData, success, errorMsg in
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
              
        APIs.postAPI(apiName: .getLoanCharges, parameters: parameters) { responseData, success, errorMsg in
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
        vc.modelGetLoanCharges = modelGetLoanCharges
        self.navigationController?.pushViewController(vc, animated: true)
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
        cell.labelAmount.text = "label: \(indexPath.row)"
        if indexPath.item == 1 {
            cell.viewBackGround.backgroundColor = .clrOrange
        }
        else {
            cell.viewBackGround.backgroundColor = .clrBlackWithOccupacy20
        }
        
        if indexPath.row == 0 {
            cell.labelAmount.text = "500"
        }
        else if indexPath.row == 1 {
            cell.labelAmount.text = "4750"
        }
        else {
            cell.labelAmount.text = "9000"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            (cell as! ApplyAmountCell).viewBackGround.circle()
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
        let data: JSONNull?
        let messages: String
        let responseblock: JSONNull?
        let responsecode: Int
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
