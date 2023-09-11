//
//  MobilePackages.swift
//  HBLFMB
//
//  Created by Apple on 19/06/2023.
//

import UIKit
import Alamofire

class MobilePackages: UIViewController {
    @IBOutlet weak var viewOne: UIView!
    @IBOutlet weak var viewTwo: UIView!
    @IBOutlet weak var viewThree: UIView!
    @IBOutlet weak var viewFour: UIView!

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var buttonBack: UIButton!
    
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var buttonThree: UIButton!
    @IBOutlet weak var buttonFour: UIButton!
    
    @IBOutlet weak var viewCompaniesBackGround: UIView!
    @IBOutlet weak var buttonSetting: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    var selectedCell: Int!
    var arrayNames = ["ios", "Android", "Apple", "Nokia Phone", "One Plus Phone"]
    
    var modelGetBundleDetails: ModelGetBundleDetails? {
        didSet {
            if modelGetBundleDetails?.responsecode == 1 {
                
            }
            else {
                self.showAlertCustomPopup(title: "Error!", message: modelGetBundleDetails?.messages, iconName: .iconError) { _ in
                    
                    
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedButton(view: nil, button: buttonOne)
        MobilePackagesCell.register(tableView: tableView)
        MobilePackagesDataNameCell.register(collectionView: collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        viewCompaniesBackGround.radius()
        collectionView.reloadData()
        print(arrayNames)
        // Do any additional setup after loading the view.
        getBundleDetails()
        bundleSubscription()
    }
    @IBAction func buttonBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func buttonSetting(_ sender: UIButton) {
    }
    @IBAction func buttonOne(_ sender: UIButton) {
        selectedButton(view: viewOne, button: buttonOne)
    }
    @IBAction func buttonTwo(_ sender: UIButton) {
        selectedButton(view: viewTwo, button: buttonTwo)
    }
    @IBAction func buttonThree(_ sender: UIButton) {
        selectedButton(view: viewThree, button: buttonThree)
    }
    @IBAction func buttonFour(_ sender: UIButton) {
        selectedButton(view: viewFour, button: buttonFour)
    }
    
    func selectedButton(view: UIView?, button: UIButton) {
        viewOne.backgroundColor = .clear
        viewTwo.backgroundColor = .clear
        viewThree.backgroundColor = .clear
        viewFour.backgroundColor = .clear
        
        
        buttonOne.tag = 0
        buttonTwo.tag = 0
        buttonThree.tag = 0
        buttonFour.tag = 0
        
        if view != nil {
            view!.backgroundColor = .clrOrange
            button.tag = 1
        }
    }
    func getBundleDetails() {
        APIs.getAPI(apiName: .getBundleDetails, parameters: nil) { responseData, success, errorMsg in
            
            print(responseData)
            print(success)
            print(errorMsg)
            let model: ModelGetBundleDetails? = APIs.decodeDataToObject(data: responseData)
            self.modelGetBundleDetails = model
        }
    }
    
    
    
    //For Testing api prefilled data
//    {
//        "cnic" : "3740584305117",
//        "lat" : "33.3612251",
//        "lng" : "72.26226",
//        "imei" : "0E8E953712DC4164A1CC221675CEBE81",
//        "mobileNo" : "03445823336",
//        "bundleKey" : "502333",
//        "bundleId" : "5",
//        "channelId" : "3"
//    }
    
    func bundleSubscription() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
            "lat" : "1000",
            "lng" : "1000",
            "mobileNo" : DataManager.instance.mobile_number ?? "", //"03445823336",
            "bundleKey" : "502333",
            "bundleId" : "5"
        ]
        
        APIs.postAPI(apiName: .bundleSubscription, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            print(responseData)
            print(success)
            print(errorMsg)
//            let model: ModelGetLoanCharges? = APIs.decodeDataToObject(data: responseData)
//            self.modelGetLoanCharges = model
        }
    }
}

extension MobilePackages: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: arrayNames[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width + 45, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MobilePackagesDataNameCell", for: indexPath) as! MobilePackagesDataNameCell
        cell.labelName.text = "\(arrayNames[ indexPath.row])"
        if selectedCell != nil {
            if selectedCell == indexPath.item {
                cell.viewBackGround.backgroundColor = .clrOrange
                cell.labelName.textColor = .white
            }
            else {
                cell.viewBackGround.backgroundColor = .clrLightGraySelectionBackGround
                cell.labelName.textColor = .clrLightGrayCalendar
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            (cell as! MobilePackagesDataNameCell).viewBackGround.circle()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = indexPath.item
        collectionView.reloadData()
    }
}

extension MobilePackages: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MobilePackagesCell") as! MobilePackagesCell
        // if change internet package is true then we dont need to show subscribed package
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
extension UILabel {
    func cutPrice() {
        guard let text = self.text else {
            return
        }
        
        let attributedText = NSAttributedString(
            string: self.text!,
            attributes: [.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue]
        )

        self.attributedText = attributedText
    }
}


extension MobilePackages {
    // MARK: - ModelGetBundleDetails
    struct ModelGetBundleDetails: Codable {
        let responseblock: JSONNull?
        let responsecode: Int
        let data: [Datum]
        let messages: String
    }

    // MARK: - Datum
    struct Datum: Codable {
        let disabledIcon: String
        let bundleDetails: [BundleDetail]
        let companyName, enabledIcon: String
        let bundleFilters: [BundleFilter]
        let recordCount: Int
    }

    // MARK: - BundleDetail
    struct BundleDetail: Codable {
        let bundleKey, bundleResources: String
        let bundleType: BundleType
        let bundleResourceOffnet, bundleResourceOnnet: JSONNull?
        let bundleResourceSMS: String?
        let bundleSelfSubscription: JSONNull?
        let bundleName: String
        let bundleDiscountPrice: Int
        let bundleValidityType: BundleValidityType?
        let bundleDiscountPercentage, ubpBundleFilterID: Int
        let bundleSequence: JSONNull?
        let bundleValidity: BundleValidity
        let bundleResourceData: String?
        let ubpBundleID: Int
        let bundleDefaultPrice: Double

        enum CodingKeys: String, CodingKey {
            case bundleKey, bundleResources, bundleType, bundleResourceOffnet, bundleResourceOnnet
            case bundleResourceSMS = "bundleResourceSms"
            case bundleSelfSubscription, bundleName, bundleDiscountPrice, bundleValidityType, bundleDiscountPercentage
            case ubpBundleFilterID = "ubpBundleFilterId"
            case bundleSequence, bundleValidity, bundleResourceData
            case ubpBundleID = "ubpBundleId"
            case bundleDefaultPrice
        }
    }

    enum BundleType: String, Codable {
        case data = "Data"
        case ec = "EC"
        case hybrid = "Hybrid"
        case lbc = "LBC"
        case voice = "Voice"
    }

    enum BundleValidity: String, Codable {
        case bundleValidity30Days = "30 days"
        case the1Day = "1 Day"
        case the30Days = "30 Days"
        case the3Days = "3 Days"
        case the60Days = "60 Days"
        case the7Days = "7 Days"
    }

    enum BundleValidityType: String, Codable {
        case d = "D"
        case m = "M"
        case w = "W"
    }

    // MARK: - BundleFilter
    struct BundleFilter: Codable {
        let filterName: String
        let ubpBundleFilterID: Int

        enum CodingKeys: String, CodingKey {
            case filterName
            case ubpBundleFilterID = "ubpBundleFilterId"
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
