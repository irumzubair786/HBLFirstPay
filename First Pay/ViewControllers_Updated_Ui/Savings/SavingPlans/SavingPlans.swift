//
//  SavingPlans.swift
//  First Pay
//
//  Created by Shakeel Ahmed on 17/11/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire

class SavingPlans: UIViewController {

    @IBOutlet weak var tableView: TableViewContentSized!
    @IBOutlet weak var buttonBack: UIButton!
    
    var modelGetSavingProducts: ModelGetSavingProducts? {
        didSet {
            if modelGetSavingProducts?.responsecode == 0 {
                self.showAlertCustomPopup(title: "Error!", message: modelGetSavingProducts?.messages, iconName: .iconError)
            }
            else {
                tableView.reloadData()
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // You can choose .default for dark text/icons or .lightContent for light text/icons
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SavingPlansCell.register(tableView: tableView)
        
        getSavingProducts()
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func getSavingProducts() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
        ]
        
        APIs.postAPI(apiName: .getSavingProducts, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: ModelGetSavingProducts? = APIs.decodeDataToObject(data: responseData)
            self.modelGetSavingProducts = model
            print(model)
        }
    }
}

extension SavingPlans: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        modelGetSavingProducts?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavingPlansCell") as! SavingPlansCell
        // if change internet package is true then we dont need to show subscribed package
       
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}

extension SavingPlans {
    // MARK: - ModelGetSavingProducts
    struct ModelGetSavingProducts: Codable {
        let messages: String
        let responseblock: JSONNull?
        let responsecode: Int
        let data: [ModelGetSavingProductsData]
    }

    // MARK: - Datum
    struct ModelGetSavingProductsData: Codable {
        let accountNo: String
        let minDeposit, accountID: Int
        let subscriptionStatus: String
        let filerTaxRate, minAmountRequired: Int
        let svgProductCode, svgProductSubConfigDescr: String
        let profitRateAmount, svgProductID: Int
        let profitFrequency: String
        let avgDeposit: Int
        let gender, levelCode, profitType, ageTo: String
        let subConfigSequence, nonfilerTaxRate: Int
        let svgProductDescr: String
        let dobYears: Double
        let svgProductSubConfigID: Int
        let ageFrom: String
        let maxDeposit: Int
        let accountLevelCode, profitPeriod: String

        enum CodingKeys: String, CodingKey {
            case accountNo, minDeposit
            case accountID = "accountId"
            case subscriptionStatus, filerTaxRate, minAmountRequired, svgProductCode, svgProductSubConfigDescr, profitRateAmount
            case svgProductID = "svgProductId"
            case profitFrequency, avgDeposit, gender, levelCode, profitType, ageTo, subConfigSequence, nonfilerTaxRate, svgProductDescr, dobYears
            case svgProductSubConfigID = "svgProductSubConfigId"
            case ageFrom, maxDeposit, accountLevelCode, profitPeriod
        }
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
