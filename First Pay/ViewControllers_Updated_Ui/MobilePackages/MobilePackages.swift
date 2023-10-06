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

    var indexSelectedNetwork = 0
    var selectedCell: Int!
    var arrayCompanyIcons = ["telenor", "jazz", "ufone", "zong"]
    var arrayNames = ["ios", "Android", "Apple", "Nokia Phone", "One Plus Phone"]
    var companyNames: [String]!
    var modelGetBundleDetails: ModelGetBundleDetails? {
        didSet {
            tableView.removeEmptyMessage()
            if modelGetBundleDetails?.responsecode == 1 {
                companyNames = self.modelGetBundleDetails?.data.map({
                    print($0.companyName)
                    return $0.companyName ?? "NA"
                })
                if buttonOne.tag == 1 {
                    selectedButton(view: viewOne, button: buttonOne)
                }
                else if buttonTwo.tag == 1 {
                    selectedButton(view: viewTwo, button: buttonTwo)
                }
                else if buttonThree.tag == 1 {
                    selectedButton(view: viewThree, button: buttonThree)
                }
                else if buttonFour.tag == 1 {
                    selectedButton(view: viewFour, button: buttonFour)
                }
            }
            else {
//                self.showAlertCustomPopup(title: "Error!", message: modelGetBundleDetails?.messages, iconName: .iconError) { _ in
//
//                }
                tableView.setEmptyMessage(iconName: "bundleEmptyMessageIcon")
            }
        }
    }
    
    var modelGetFavourites: ModelGetFavourites? {
        didSet {
            if modelGetFavourites?.responsecode == 1 {
               
            }
            else {

            }
        }
    }
    
    var modelAddToFavourite: ModelAddToFavourite? {
        didSet {
            if modelAddToFavourite?.responsecode == 1 {
               
            }
            else {

            }
        }
    }
    
    var modelUpdateFavourite: ModelUpdateFavourite? {
        didSet {
            if modelGetBundleDetails?.responsecode == 1 {
               
            }
            else {

            }
        }
    }
    
    
    
    var networkId : Int?

    var searchedBundleDetails: [ModelBundleDetail]?
    
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
        getFavourites()
        selectedButton(view: viewOne, button: buttonOne)
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func buttonSetting(_ sender: UIButton) {
//        navigateToFavourite()
//return()
        let vc = UIStoryboard(name: "Mobile Bunldles", bundle: nil).instantiateViewController(withIdentifier: "PackagesFilter") as! PackagesFilter

        vc.modelBundleFilters = modelGetBundleDetails?.data[indexSelectedNetwork].bundleFilters
        vc.buttonApplyApplied = {
            searchingData in
            self.filterApply(searchingData: searchingData)
        }
        self.present(vc, animated: true)
    }
    
    func filterApply(searchingData: [String]) {
//        modelGetBundleDetails?.data[indexSelectedNetwork].bundleDetails?[indexPath.row]
        var tempSearchedBundleDetails = [[MobilePackages.ModelBundleDetail]]()

        for searchingText in searchingData {
            let searchRecord = modelGetBundleDetails?.data[indexSelectedNetwork].bundleDetails?.filter({ tempModelBundleDetail in
                tempModelBundleDetail.bundleType?.lowercased() == searchingText.lowercased()
            })
            if searchRecord?.count ?? 0 > 0 {
                tempSearchedBundleDetails.append(searchRecord!)
            }
        }
        
        let mergedRecord = tempSearchedBundleDetails.flatMap({
            record -> [ModelBundleDetail] in
               return record
        })
        
        searchedBundleDetails = mergedRecord
        tableView.reloadData()
    }
    
    @IBAction func buttonOne(_ sender: UIButton) {
       
        networkId = 1
        
        selectedButton(view: viewOne, button: buttonOne)
        
        
    }
    @IBAction func buttonTwo(_ sender: UIButton) {
        networkId = 2
        selectedButton(view: viewTwo, button: buttonTwo)
    }
    @IBAction func buttonThree(_ sender: UIButton) {
    networkId = 3
        
        selectedButton(view: viewThree, button: buttonThree)
    }
    @IBAction func buttonFour(_ sender: UIButton) {
       networkId = 4
        selectedButton(view: viewFour, button: buttonFour)
    }
      
    
    
    
    func navigateToFavourite() {
        let vc = UIStoryboard(name: "Mobile Bunldles", bundle: nil).instantiateViewController(withIdentifier: "MobileFavouriteBunldles") as! MobileFavouriteBunldles
        vc.tempModelGetFavourites = modelGetFavourites
        self.navigationController!.pushViewController(vc, animated: true)
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
        if companyNames != nil {
            for (index, companyName) in companyNames.enumerated() {
                if buttonOne.tag == 1 {
                    indexSelectedNetwork = index
                    if companyName.lowercased() == "TELENOR".lowercased() {
                        break
                    }
                }
                else if buttonTwo.tag == 1 {
                    indexSelectedNetwork = index
                    if companyName.lowercased() == "JAZZ".lowercased() {
                        break
                    }
                }
                else if buttonThree.tag == 1 {
                    indexSelectedNetwork = index
                    if companyName.lowercased() == "UFONE".lowercased() {
                        break
                    }
                }
                else if buttonFour.tag == 1 {
                    indexSelectedNetwork = index
                    if companyName.lowercased() == "ZONG".lowercased() {
                        break
                    }
                }
            }
        }
        
        if modelGetBundleDetails?.data[indexSelectedNetwork].bundleDetails != nil {
            searchedBundleDetails = modelGetBundleDetails?.data[indexSelectedNetwork].bundleDetails
        }
        else {
            searchedBundleDetails?.removeAll()
        }
        
        tableView.reloadData()
        collectionView.reloadData()
    }
    func getBundleDetails() {
        APIs.getAPI(apiName: .getBundleDetails, parameters: nil) { responseData, success, errorMsg in
            print(responseData)
            print(success)
            print(errorMsg)
            do {
                let model: ModelGetBundleDetails? = try APIs.decodeDataToObject(data: responseData)
                self.modelGetBundleDetails = model
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
            
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
    
    func navigateToMobilePackagesDetails() {
        let vc = UIStoryboard(name: "Mobile Bunldles", bundle: nil).instantiateViewController(withIdentifier: "MobilePackagesDetails") as! MobilePackagesDetails
        
        self.navigationController!.pushViewController(vc, animated: true)
    }

    func navigateToMobilePackagesDetails(bundleDetails: ModelBundleDetail) {
        let vc = UIStoryboard(name: "Mobile Bunldles", bundle: nil).instantiateViewController(withIdentifier: "MobilePackagesDetails") as! MobilePackagesDetails
        vc.bundleDetail = bundleDetails
        vc.companyIcon = UIImage(named: arrayCompanyIcons[indexSelectedNetwork])
        vc.fetchNetworkId = networkId
        vc.companyName = modelGetBundleDetails?.data[indexSelectedNetwork].companyName ?? ""
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func addToFavourite(bundleDetail: ModelBundleDetail) {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
            "accountNo": "033359662888528",
            "accountImd": "220585",
            "accountTitle": "Abdullah Butt",
            "favouriteType": "IBT", // IBT -> Local Funds Transfer, IBFT -> IBFT, BBP -> Bill Payment, TUP -> TopUp
            "nickName": "Abdullah Butt",
            "favouriteAcctType": "C",  // C -> Core, W -> Wallet, B -> Bill Payment / Topup
            "flow": "F", // D -> Direct, F -> Favourite
            "otp": "", // Null in case of flow value 'F'
        ]
        APIs.postAPI(apiName: .addToFavourite, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            if success {
                
            }
            let model: ModelAddToFavourite? = APIs.decodeDataToObject(data: responseData)
            self.modelAddToFavourite = model
        }
    }
    
    func getFavourites() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)"
        ]
        APIs.postAPI(apiName: .getFavourites, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            if success {
                
            }
            let model: ModelGetFavourites? = APIs.decodeDataToObject(data: responseData)
            self.modelGetFavourites = model
        }
    }
    
    func updateFavourite() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
            "benificiaryId": "292",
            "status": "A",   // I for Delete Benificiary, A for Update Benificiary
            "nickName": "Butt",  // if status = 'I' nickName is null
        ]
        APIs.postAPI(apiName: .updateFavourite, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            if success {
                
            }
            let model: ModelUpdateFavourite? = APIs.decodeDataToObject(data: responseData)
            self.modelUpdateFavourite = model
        }
    }
}

extension MobilePackages: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let bundleFilter =  modelGetBundleDetails?.data[indexSelectedNetwork].bundleFilters?[indexPath.item]
        return CGSize(width: "\(bundleFilter?.filterName ?? "")".size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width + 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if companyNames == nil {
            return 0
        }
        
        
        return modelGetBundleDetails?.data[indexSelectedNetwork].bundleFilters?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MobilePackagesDataNameCell", for: indexPath) as! MobilePackagesDataNameCell
        
        let modelBundleFilter =  modelGetBundleDetails?.data[indexSelectedNetwork].bundleFilters?[indexPath.item]
        
        cell.labelName.text = "\(modelBundleFilter?.filterName ?? "")"
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
        
//        let totalCellCount = modelGetBundleDetails?.data[indexSelectedNetwork].bundleDetails?.count ?? 0
        
        let totalCellCount = searchedBundleDetails?.count ?? 0
        tableView.removeEmptyMessage()
        if totalCellCount == 0 {
            tableView.setEmptyMessage(iconName: "bundleEmptyMessageIcon")
        }
        return totalCellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MobilePackagesCell") as! MobilePackagesCell
        // if change internet package is true then we dont need to show subscribed package
        let bundleDetail = searchedBundleDetails?[indexPath.row]
//        modelGetBundleDetails?.data[indexSelectedNetwork].bundleDetails?[indexPath.row]
        
        cell.modelBundleDetail = bundleDetail
        cell.buttonSubscribeNow = { tempBundleDetail in
            self.navigateToMobilePackagesDetails(bundleDetails: tempBundleDetail)
        }
        cell.buttonFavouriteNow = { tempBundleDetail in
            self.addToFavourite(bundleDetail: tempBundleDetail)
        }
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
    
    // MARK: - ModelAddToFavourite
    struct ModelAddToFavourite: Codable {
        let responsecode: Int
        let data: String
        let responseblock: JSONNull?
        let messages: String
    }
    
    // MARK: - ModelUpdateFavourite
    struct ModelUpdateFavourite: Codable {
        let responsecode: Int
        let data, responseblock: JSONNull?
        let messages: String
    }
    
    
    // MARK: - ModelGetFavourites
    struct ModelGetFavourites: Codable {
        let responsecode: Int
        let data: [ModelGetFavouritesData]
        let responseblock: JSONNull?
        let messages: String?
    }

    // MARK: - Datum
    struct ModelGetFavouritesData: Codable {
        let favouriteCategory: String?
        let favouriteDetails: [ModelFavouriteDetail]?
        
    }

    // MARK: - FavouriteDetail
    struct ModelFavouriteDetail: Codable {
        let benificiaryID: Int
        let bankImd: String
        let bankImdID: Int
        let benificiaryAccountNo, benificiaryAccountTitle, benificiaryNickName: String?
        let benificiaryBank: String?
        let benificiaryType: String?
        let imdIcon: String?

        enum CodingKeys: String, CodingKey {
            case benificiaryID = "benificiaryId"
            case bankImd
            case bankImdID = "bankImdId"
            case benificiaryAccountNo, benificiaryAccountTitle, benificiaryNickName, benificiaryBank, benificiaryType, imdIcon
        }
    }
}

extension MobilePackages {
    // MARK: - ModelGetBundleDetails
    struct ModelGetBundleDetails: Codable {
        let messages: String
        let responsecode: Int
        let responseblock: JSONNull?
        let data: [ModelGetBundleDetailsData]
    }

    // MARK: - Datum
    struct ModelGetBundleDetailsData: Codable {
        let enabledIcon: String?
        let bundleDetails: [ModelBundleDetail]?
        let bundleFilters: [ModelBundleFilter]?
        let companyName, disabledIcon: String?
        let recordCount: Int?
    }

    // MARK: - BundleDetail
    struct ModelBundleDetail: Codable {
        let ubpBundleID, bundleDiscountPrice: Int?
        let bundleFilterIDS: [BundleFilterID]?
        let bundleSelfSubscription: JSONNull?
        let bundleResources: String?
        let bundleValidity: String?
        let bundleSequence: Int?
        let bundleDefaultPrice: Double
        let bundleKey, bundleName: String?
        let bundleValidityType: String?
        let resourceLists: [ModelResourceList]?
        let bundleType: String?
        let bundleDiscountPercentage: Int?

        enum CodingKeys: String, CodingKey {
            case ubpBundleID = "ubpBundleId"
            case bundleDiscountPrice
            case bundleFilterIDS = "bundleFilterIds"
            case bundleSelfSubscription, bundleResources, bundleValidity, bundleSequence, bundleDefaultPrice, bundleKey, bundleName, bundleValidityType, resourceLists, bundleType, bundleDiscountPercentage
        }
    }

    // MARK: - BundleFilterID
    struct BundleFilterID: Codable {
        let bundleFilterID: Int?

        enum CodingKeys: String, CodingKey {
            case bundleFilterID = "bundleFilterId"
        }
    }

    // MARK: - ResourceList
    struct ModelResourceList: Codable {
        let detail: String?
        let type: String?
        let dataType: String?
        let description: String?

        enum CodingKeys: String, CodingKey {
            case detail = "Detail"
            case type = "Type"
            case dataType = "Data-Type"
            case description = "Description"
        }
    }

    // MARK: - BundleFilter
    struct ModelBundleFilter: Codable {
        let filterName: String?
        let ubpBundleFilterID: Int?

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


//extension MobilePackages {
//    // MARK: - ModelGetBundleDetail
//    struct ModelGetBundleDetail: Codable {
//        let bundleResources: String
//        let bundleSequence: Int
//        let bundleFilterIDS: [BundleFilterID]
//        let bundleName: String
//        let bundleDefaultPrice: Double
//        let bundleKey: String
//        let ubpBundleID, bundleDiscountPercentage: Int
//        let bundleType: String?
//        let bundleSelfSubscription: JSONNull?
//        let bundleValidity: String?
//        let resourceLists: [ResourceList]
//        let bundleValidityType: String?
//        let bundleDiscountPrice: Int
//
//        enum CodingKeys: String, CodingKey {
//            case bundleResources, bundleSequence
//            case bundleFilterIDS = "bundleFilterIds"
//            case bundleName, bundleDefaultPrice, bundleKey
//            case ubpBundleID = "ubpBundleId"
//            case bundleDiscountPercentage, bundleType, bundleSelfSubscription, bundleValidity, resourceLists, bundleValidityType, bundleDiscountPrice
//        }
//    }
//
//    // MARK: - ResourceList
//    struct ResourceList: Codable {
//        let description: String?
//        let dataType: String?
//        let type: String?
//        let detail: String?
//
//        enum CodingKeys: String, CodingKey {
//            case description = "Description"
//            case dataType = "Data-Type"
//            case type = "Type"
//            case detail = "Detail"
//        }
//    }
//
//}
