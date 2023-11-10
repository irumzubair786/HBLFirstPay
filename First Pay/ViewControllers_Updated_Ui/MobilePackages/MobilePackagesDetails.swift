//
//  MobilePackagesDetails.swift
//  First Pay
//
//  Created by Shakeel Ahmed on 19/09/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ContactsUI
import libPhoneNumber_iOS

class MobilePackagesDetails: BaseClassVC {

    @IBOutlet weak var buttonBack: UIButton!
   
    @IBOutlet weak var imageViewOperator: UIImageView!
    @IBOutlet weak var imageViewButtonContinue: UIImageView!
    @IBOutlet weak var viewBackGroundContinueButton: UIView!
    @IBOutlet weak var buttonContinue: UIButton!
    
    @IBOutlet weak var textFieldMobileNumber: UITextField!
    @IBOutlet weak var labelPackage: UILabel!
    @IBOutlet weak var labelCarrier: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var buttonContact: UIButton!
    var fetchNetworkId : Int?
    var companyIcon: String!
    var companyName: String!
    var bundleDetail: MobilePackages.ModelBundleDetail!
    var stringName = ""

    private let contactPicker = CNContactPickerViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        FBEvents.logEvent(title: .Bundles_confirm_landing)
        FaceBookEvents.logEvent(title: .Bundles_confirm_landing)
        
        viewBackGroundContinueButton.circle()
        // Do any additional setup after loading the view.
        setData()
        
        textFieldMobileNumber.addTarget(self, action: #selector(changeNumberInTextField), for: .editingChanged)
        textFieldMobileNumber.delegate = self
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageViewButtonContinue.addGestureRecognizer(tapGestureRecognizerr)
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonContinue(_ sender: Any) {
        FBEvents.logEvent(title: .Bundles_confirm_attempt)
        FaceBookEvents.logEvent(title: .Bundles_confirm_attempt)
        
        bundleSubscription()
    }
    @IBAction func buttonContact(_ sender: Any) {
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        
        if textFieldMobileNumber.text?.count  ==  11 || textFieldMobileNumber.text?.count == 15
        {
            let image = UIImage(named: "]greenarrow")
            imageViewButtonContinue.image = image
            imageViewButtonContinue.isUserInteractionEnabled = true
            buttonContinue.isUserInteractionEnabled = true
          
        }
        else
        {
            let image = UIImage(named: "grayArrow")
            imageViewButtonContinue.image = image
            imageViewButtonContinue.isUserInteractionEnabled = false
            buttonContinue.isUserInteractionEnabled = false
        }
        
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        bundleSubscription()
    }
    
       
    func setData() {
        if bundleDetail == nil {
            return()
        }
        if fetchNetworkId == 1 {
            labelCarrier.text =  "Telenor"
            imageViewOperator.image = UIImage(named: "telenor")
        }
        else if fetchNetworkId == 2 {
            labelCarrier.text =  "Jazz"
            imageViewOperator.image = UIImage(named: "jazz")
        }
        else if fetchNetworkId == 3 {
            labelCarrier.text =  "Zong4G"
            imageViewOperator.image = UIImage(named: "zong")
        }
        else if fetchNetworkId == 4 {
            labelCarrier.text =  "Ufone"
            imageViewOperator.image = UIImage(named: "ufone")
        }
        labelPackage.text = bundleDetail.bundleName
        labelCarrier.text =  companyName
        let convertValueToInt = Int(bundleDetail.bundleDefaultPrice)
        labelPrice.text = "Rs. \(convertValueToInt)"
        print("ConvertValueToInt", convertValueToInt)
        labelAmount.text = "\(convertValueToInt)"
//        imageViewOperator.image = companyIcon
        
        var url = URL(string: companyIcon)
        if let url {
            imageViewOperator.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                if (image != nil){
                    self.imageViewOperator.image = image
                }
                else {
//                        cell.imageViewIcon.image = UIImage.init(named: "user")
                }
            })
        }
    }
    
    var modelBundleSubscription: ModelBundleSubscription! {
        didSet {
            if modelBundleSubscription?.responsecode == 1 {
                FBEvents.logEvent(title: .Bundles_confirm_success)
                FaceBookEvents.logEvent(title: .Bundles_confirm_success)
                
                navigationToMobilePackagesSuccess()
            }
            else {
                FBEvents.logEvent(title: .Bundles_confirm_failure)
                FaceBookEvents.logEvent(title: .Bundles_confirm_failure)
                
                self.showAlertCustomPopup(message: modelBundleSubscription?.messages ?? "General Error", iconName: .iconError) {_ in
                    FBEvents.logEvent(title: .Bundles_error_popup)
                    FaceBookEvents.logEvent(title: .Bundles_error_popup)
                }
            }
        }
    }
    
    func navigationToMobilePackagesSuccess() {
        let vc = UIStoryboard(name: "Mobile Bunldles", bundle: nil).instantiateViewController(withIdentifier: "MobilePackagesSuccess") as! MobilePackagesSuccess
        vc.modelBundleSubscription = modelBundleSubscription
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func bundleSubscription() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
            "lat" : "\(DataManager.instance.Latitude ?? 0)",
            "lng" : "\(DataManager.instance.Longitude ?? 0)",
//            "mobileNo" : textFieldMobileNumber.text!, //"03445823336",
            "mobileNo" : textFieldMobileNumber.text!.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "+92", with: "0"),
            "bundleKey" : "\(bundleDetail.bundleKey!)",
            "bundleId" : "\(bundleDetail.ubpBundleID!)"
        ]
        
        APIs.postAPI(apiName: .bundleSubscription, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            print(responseData as Any)
            print(success)
            print(errorMsg)
            do {
                let model: ModelBundleSubscription? = try APIs.decodeDataToObject(data: responseData)
                self.modelBundleSubscription = model
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
    
    @objc func changeNumberInTextField() {
        let text = textFieldMobileNumber.text!.replacingOccurrences(of: "+92-", with: "")
        if textFieldMobileNumber.text?.count == 1 && text == "0" {
            textFieldMobileNumber.text = nil
            return
        }
        textFieldMobileNumber.text = format(with: "+92-XXX-XXXXXXX", phone: text)
        
        if textFieldMobileNumber.text?.count  ==  11 || textFieldMobileNumber.text?.count == 15
        {
            let image = UIImage(named: "]greenarrow")
            imageViewButtonContinue.image = image
            imageViewButtonContinue.isUserInteractionEnabled = true
            buttonContinue.isUserInteractionEnabled = true
            
        }
        else
        {
            let image = UIImage(named: "grayArrow")
            imageViewButtonContinue.image = image
            imageViewButtonContinue.isUserInteractionEnabled = false
            buttonContinue.isUserInteractionEnabled = false
        }
    }
    
    
    

}
extension MobilePackagesDetails: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
extension MobilePackagesDetails: CNContactPickerDelegate {

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        let phoneNumberCount = contact.phoneNumbers.count
      //  let name = "\(contact.givenName + contact.familyName)"
        let name = "\(contact.givenName) \(contact.familyName)"
        
        self.stringName = name
        guard phoneNumberCount > 0 else {
            dismiss(animated: true)
            //show pop up: "Selected contact does not have a number"
            return
        }

        if phoneNumberCount == 1 {
            setNumberFromContact(contactNumber: contact.phoneNumbers[0].value.stringValue)

        } else {
            let alertController = UIAlertController(title: "Select one of the numbers", message: nil, preferredStyle: .alert)

            for i in 0...phoneNumberCount-1 {
                let phoneAction = UIAlertAction(title: contact.phoneNumbers[i].value.stringValue, style: .default, handler: {
                alert -> Void in
                    self.setNumberFromContact(contactNumber: contact.phoneNumbers[i].value.stringValue)
                })
                alertController.addAction(phoneAction)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {
            alert -> Void in

            })
            alertController.addAction(cancelAction)

            dismiss(animated: true)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func setNumberFromContact(contactNumber: String) {

        //UPDATE YOUR NUMBER SELECTION LOGIC AND PERFORM ACTION WITH THE SELECTED NUMBER

        var contactNumber = contactNumber.replacingOccurrences(of: "-", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: "(", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: ")", with: "")
        
        let phoneUtil = NBPhoneNumberUtil()

          do {
            
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(contactNumber, defaultRegion: "PK")
            let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .NATIONAL)

            print("Formatted String : \(formattedString)")
              var tempPhoneNumber = "\(formattedString.allNumbers)".replace(string: "+92", replacement: "")
              if tempPhoneNumber.first == "0" {
                  tempPhoneNumber.removeFirst()
              }
              self.textFieldMobileNumber.text = format(with: "+92-XXX-XXXXXXX", phone: "\(tempPhoneNumber)")
          }
          catch let error as NSError {
              print(error.localizedDescription)
          }
    }

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
      
    }
}

extension MobilePackagesDetails {
    // MARK: - Welcome
    struct ModelBundleSubscription: Codable {
        let responsecode: Int?
        let data: ModelBundleSubscriptionData?
        let responseblock: JSONNull?
        let messages: String?
    }

    // MARK: - DataClass
    struct ModelBundleSubscriptionData: Codable {
        let receivedBy: String?
        let offerDiscount, amount: Int?
        let fee, packageName, dataOperator, sentBy: String?
        let responseDescr: String?

        enum CodingKeys: String, CodingKey {
            case receivedBy, offerDiscount, amount, fee, packageName, responseDescr
            case dataOperator = "operator"
            case sentBy
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




//
//  MobilePackages.swift
//  HBLFMB
//
//  Created by Apple on 19/06/2023.
//

//import UIKit
//import Alamofire
//import Kingfisher
//
//class MobilePackages: UIViewController {
//    @IBOutlet weak var viewOne: UIView!
//    @IBOutlet weak var viewTwo: UIView!
//    @IBOutlet weak var viewThree: UIView!
//    @IBOutlet weak var viewFour: UIView!
//    @IBOutlet weak var viewBackGroundDataType: UIView!
//
//    @IBOutlet weak var tableView: UITableView!
//
//    @IBOutlet weak var buttonBack: UIButton!
//    
//    @IBOutlet weak var buttonOne: UIButton!
//    @IBOutlet weak var buttonTwo: UIButton!
//    @IBOutlet weak var buttonThree: UIButton!
//    @IBOutlet weak var buttonFour: UIButton!
//    
//    @IBOutlet weak var buttonAllDataType: UIButton!
//    
//    @IBOutlet weak var viewCompaniesBackGround: UIView!
//    @IBOutlet weak var buttonSetting: UIButton!
//    @IBOutlet weak var collectionViewDataType: UICollectionView!
//    @IBOutlet weak var collectionViewNetwork: UICollectionView!
//    
//
//    var indexSelectedNetwork = 0
//    var indexSelectedDataTypeCell: Int!
//    var arrayCompanyIcons = ["telenor", "jazz", "ufone", "zong"]
//    var arrayNames = ["ios", "Android", "Apple", "Nokia Phone", "One Plus Phone"]
//    var companyNames: [String]!
//    var modelGetBundleDetails: ModelGetBundleDetails? {
//        didSet {
//            tableView.removeEmptyMessage()
//            if modelGetBundleDetails?.responsecode == 1 {
//                FBEvents.logEvent(title: .Bundles_list_success)
//                FaceBookEvents.logEvent(title: .Bundles_list_success)
//                
////                companyNames = self.modelGetBundleDetails?.data.map({
////                    print($0.companyName)
////                    return $0.companyName ?? "NA"
////                })
////                if buttonOne.tag == 1 {
////                    selectedNetwork(view: viewOne, button: buttonOne)
////                }
////                else if buttonTwo.tag == 1 {
////                    selectedNetwork(view: viewTwo, button: buttonTwo)
////                }
////                else if buttonThree.tag == 1 {
////                    selectedNetwork(view: viewThree, button: buttonThree)
////                }
////                else if buttonFour.tag == 1 {
////                    selectedNetwork(view: viewFour, button: buttonFour)
////                }
//                selectedNetwork(view: viewOne, button: buttonOne)
//            }
//            else {
//                FBEvents.logEvent(title: .Bundles_list_failure)
//                FaceBookEvents.logEvent(title: .Bundles_list_failure)
////                self.showAlertCustomPopup(title: "Error!", message: modelGetBundleDetails?.messages, iconName: .iconError) { _ in
////
////                }
//                tableView.setEmptyMessage(iconName: "bundleEmptyMessageIcon")
//            }
//        }
//    }
//    
//    var modelGetFavourites: ModelGetFavourites? {
//        didSet {
//            if modelGetFavourites?.responsecode == 1 {
//               
//            }
//            else {
//
//            }
//        }
//    }
//    
//    var modelAddToFavourite: ModelAddToFavourite? {
//        didSet {
//            if modelAddToFavourite?.responsecode == 1 {
//               
//            }
//            else {
//
//            }
//        }
//    }
//    
//    var modelUpdateFavourite: ModelUpdateFavourite? {
//        didSet {
//            if modelGetBundleDetails?.responsecode == 1 {
//               
//            }
//            else {
//
//            }
//        }
//    }
//    
//    var networkId : Int?
//
//    var searchedBundleDetails: [ModelBundleDetail]?
//    
//    var dictionaryFilterSelectedItems = [
//        0:[],
//        1:[],
//        2:[]
//    ] as? [Int: [Int]]
//    
//    
//    override func viewDidAppear(_ animated: Bool) {
//        buttonAllDataType.backgroundColor = .clrLightGraySelectionBackGround
//        buttonAllDataType.setTitleColor(.clrLightGrayCalendar, for: .normal)
//        buttonAllDataType.circle()
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        FBEvents.logEvent(title: .Bundles_list_landing)
//        FaceBookEvents.logEvent(title: .Bundles_list_landing)
//        
//        selectedNetwork(view: nil, button: buttonOne)
//        MobilePackagesCell.register(tableView: tableView)
//        MobilePackagesDataNameCell.register(collectionView: collectionViewDataType)
//        MobilePackagesTelcoCell.register(collectionView: collectionViewNetwork)
//        
//        collectionViewDataType.dataSource = self
//        collectionViewDataType.delegate = self
//        tableView.dataSource = self
//        tableView.delegate = self
//        viewCompaniesBackGround.radius()
//        print(arrayNames)
//        // Do any additional setup after loading the view.
//        getBundleDetails()
//        getFavourites()
//        selectedNetwork(view: viewOne, button: buttonOne)
//        viewBackGroundDataType.isHidden = true
//      
//    }
//    
//    @IBAction func buttonBack(_ sender: Any) {
//        self.dismiss(animated: true)
//    }
//    @IBAction func buttonAllDataType(_ sender: Any) {
//        dictionaryFilterSelectedItems?[0] = []
//        dictionaryFilterSelectedItems?[1] = []
//        dictionaryFilterSelectedItems?[2] = []
//        clearFilters(filterResponse: dictionaryFilterSelectedItems!)
//        buttonAllDataType.backgroundColor = .clrOrange
//        buttonAllDataType.setTitleColor(.white, for: .normal)
//        
//    }
//    @IBAction func buttonSetting(_ sender: UIButton) {
////        navigateToFavourite()
////return()
//        let totalCellCount = modelGetBundleDetails?.data[indexSelectedNetwork].bundleFilters?.count ?? 0
//        if totalCellCount > 0 {
//            let vc = UIStoryboard(name: "Mobile Bunldles", bundle: nil).instantiateViewController(withIdentifier: "PackagesFilter") as! PackagesFilter
//
//            vc.modelBundleFilters = modelGetBundleDetails?.data[indexSelectedNetwork].bundleFilters
//            vc.dictionaryFilterSelectedItems = self.dictionaryFilterSelectedItems
//            vc.buttonApplyApplied = { packageType, packageValidity, packagePriceRange, filterResponse in
//                self.dictionaryFilterSelectedItems = filterResponse
//                self.indexSelectedDataTypeCell = nil
//                self.filterApply(packageType: packageType, packageValidity: packageValidity, packagePriceRange: packagePriceRange, searchFromFilterScreen: true)
//            }
//            vc.buttonClearFilterBack = { filterResponse in
//                self.clearFilters(filterResponse: filterResponse)
//            }
//            self.present(vc, animated: true)
//        }
//    }
//    
//    func clearFilters(filterResponse: [Int: [Int]]) {
//        self.dictionaryFilterSelectedItems = filterResponse
//        self.networkId = 1
//        self.selectedNetwork(view: self.viewOne, button: self.buttonOne)
//    }
//    
//    func filterApply(packageType: [String]? = [], packageValidity: [String]? = [], packagePriceRange: [String]? = [], searchFromFilterScreen: Bool) {
////        modelGetBundleDetails?.data[indexSelectedNetwork].bundleDetails?[indexPath.row]
//        var tempSearchedBundleDetails = [[MobilePackages.ModelBundleDetail]]()
//
//        if let packageType {
//            for searchingText in packageType {
//                let searchRecord = modelGetBundleDetails?.data[indexSelectedNetwork].bundleDetails?.filter({ tempModelBundleDetail in
//                    tempModelBundleDetail.bundleType?.lowercased() == searchingText.lowercased()
//                })
//                if searchRecord?.count ?? 0 > 0 {
//                    tempSearchedBundleDetails.append(searchRecord!)
//                }
//            }
//        }
//        if let packageValidity {
//            for searchingText in packageValidity {
//                let searchRecord = modelGetBundleDetails?.data[indexSelectedNetwork].bundleDetails?.filter({ tempModelBundleDetail in
//                    tempModelBundleDetail.bundleValidityType?.lowercased() == searchingText.lowercased()
//                })
//                if searchRecord?.count ?? 0 > 0 {
//                    tempSearchedBundleDetails.append(searchRecord!)
//                }
//            }
//        }
//        
////            let searchRecord = modelGetBundleDetails?.data[indexSelectedNetwork].bundleDetails?.filter({ tempModelBundleDetail in
////                tempModelBundleDetail.bundleDefaultPrice?.lowercased() == searchingText.lowercased()
////            })
////            if searchRecord?.count ?? 0 > 0 {
////                tempSearchedBundleDetails.append(searchRecord!)
////            }
//        
//        
//        let mergedRecord = tempSearchedBundleDetails.flatMap({
//            record -> [ModelBundleDetail] in
//               return record
//        })
//        
//        if let packagePriceRange, packagePriceRange.count > 0 {
//            var finalRecord = [MobilePackages.ModelBundleDetail]()
//            if mergedRecord.count > 0 {
//                finalRecord = mergedRecord
//            }
//            else {
//                //MARK: - we are checking if search fire from filter screen then we will check in global data
//                if searchFromFilterScreen {
//                    finalRecord = (modelGetBundleDetails?.data[indexSelectedNetwork].bundleDetails!)!
//                }
//            }
//            
//            for searchingText in packagePriceRange {
//                if searchingText.lowercased() == "High To Low".lowercased() {
////                    # Sort the data by price (high to low)
//                    let sortedProducts = finalRecord.sorted { $0.bundleDefaultPrice > $1.bundleDefaultPrice }
//                    searchedBundleDetails = sortedProducts
//                }
//                else if searchingText.lowercased() == "Low To High".lowercased() {
////                    # Sort the data by price (low to high)
//                    let sortedProducts = finalRecord.sorted { $0.bundleDefaultPrice < $1.bundleDefaultPrice }
//                    searchedBundleDetails = sortedProducts
//                }
//            }
//        }
//        else {
//            searchedBundleDetails = mergedRecord
//        }
//        
//        collectionViewDataType.reloadData()
//        collectionViewNetwork.reloadData()
//        tableView.reloadData()
//    }
//    
//    @IBAction func buttonOne(_ sender: UIButton) {
//        networkId = 1
//        selectedNetwork(view: viewOne, button: buttonOne)
//    }
//    @IBAction func buttonTwo(_ sender: UIButton) {
//        networkId = 2
//        selectedNetwork(view: viewTwo, button: buttonTwo)
//    }
//    @IBAction func buttonThree(_ sender: UIButton) {
//        networkId = 3
//        selectedNetwork(view: viewThree, button: buttonThree)
//    }
//    @IBAction func buttonFour(_ sender: UIButton) {
//        networkId = 4
//        selectedNetwork(view: viewFour, button: buttonFour)
//    }
//      
//    
//    
//    
//    func navigateToFavourite() {
//        let vc = UIStoryboard(name: "Mobile Bunldles", bundle: nil).instantiateViewController(withIdentifier: "MobileFavouriteBunldles") as! MobileFavouriteBunldles
//        vc.tempModelGetFavourites = modelGetFavourites
//        self.navigationController!.pushViewController(vc, animated: true)
//    }
//    
//    
//    
//    func selectedNetwork(view: UIView?, button: UIButton?) {
//        indexSelectedDataTypeCell = nil
////        viewOne.backgroundColor = .clear
////        viewTwo.backgroundColor = .clear
////        viewThree.backgroundColor = .clear
////        viewFour.backgroundColor = .clear
////
////        buttonOne.tag = 0
////        buttonTwo.tag = 0
////        buttonThree.tag = 0
////        buttonFour.tag = 0
//        
////        if view != nil {
////            view!.backgroundColor = .clrOrange
////            button.tag = 1
////        }
////        if companyNames != nil {
////            for (index, companyName) in companyNames.enumerated() {
////                if buttonOne.tag == 1 {
////                    indexSelectedNetwork = index
////                    if companyName.lowercased() == "TELENOR".lowercased() {
////                        break
////                    }
////                }
////                else if buttonTwo.tag == 1 {
////                    indexSelectedNetwork = index
////                    if companyName.lowercased() == "JAZZ".lowercased() {
////                        break
////                    }
////                }
////                else if buttonThree.tag == 1 {
////                    indexSelectedNetwork = index
////                    if companyName.lowercased() == "UFONE".lowercased() {
////                        break
////                    }
////                }
////                else if buttonFour.tag == 1 {
////                    indexSelectedNetwork = index
////                    if companyName.lowercased() == "ZONG".lowercased() {
////                        break
////                    }
////                }
////            }
////        }
//        
//        if modelGetBundleDetails?.data[indexSelectedNetwork].bundleDetails != nil {
//            searchedBundleDetails = modelGetBundleDetails?.data[indexSelectedNetwork].bundleDetails
//        }
//        else {
//            searchedBundleDetails?.removeAll()
//        }
//        
//        tableView.reloadData()
//        collectionViewNetwork.reloadData()
//        collectionViewDataType.reloadData()
//    }
//    func getBundleDetails() {
//        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
//        let parameters: Parameters = [
//            "cnic" : userCnic!,
//            "imei" : DataManager.instance.imei!,
//            "channelId" : "\(DataManager.instance.channelID)"
//        ]
//        
//        APIs.postAPI(apiName: .getBundleDetails, parameters: parameters, viewController: self) { responseData, success, errorMsg in
//            print(responseData)
//            print(success)
//            print(errorMsg)
//            do {
//                let model: ModelGetBundleDetails? = try APIs.decodeDataToObject(data: responseData)
//                self.modelGetBundleDetails = model
//            }
//            catch let error as NSError {
//                print(error.localizedDescription)
//            }
//        }
//    }
//    
//    
//    
//    //For Testing api prefilled data
////    {
////        "cnic" : "3740584305117",
////        "lat" : "33.3612251",
////        "lng" : "72.26226",
////        "imei" : "0E8E953712DC4164A1CC221675CEBE81",
////        "mobileNo" : "03445823336",
////        "bundleKey" : "502333",
////        "bundleId" : "5",
////        "channelId" : "3"
////    }
//    
//    func navigateToMobilePackagesDetails() {
//        let vc = UIStoryboard(name: "Mobile Bunldles", bundle: nil).instantiateViewController(withIdentifier: "MobilePackagesDetails") as! MobilePackagesDetails
//        
//        self.navigationController!.pushViewController(vc, animated: true)
//    }
//
//    func navigateToMobilePackagesDetails(bundleDetails: ModelBundleDetail) {
//        let vc = UIStoryboard(name: "Mobile Bunldles", bundle: nil).instantiateViewController(withIdentifier: "MobilePackagesDetails") as! MobilePackagesDetails
//        vc.bundleDetail = bundleDetails
////        vc.companyIcon = UIImage(named: arrayCompanyIcons[indexSelectedNetwork])
//        vc.companyIcon = "\(GlobalConstants.BASE_URL)\(modelGetBundleDetails?.data[indexSelectedNetwork].enabledIcon ?? "")"
//        vc.fetchNetworkId = networkId
//        vc.companyName = modelGetBundleDetails?.data[indexSelectedNetwork].companyName ?? ""
//        self.navigationController!.pushViewController(vc, animated: true)
//    }
//    
//    func addToFavourite(bundleDetail: ModelBundleDetail) {
//        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
//        
//        let parameters: Parameters = [
//            "cnic" : userCnic!,
//            "imei" : DataManager.instance.imei!,
//            "channelId" : "\(DataManager.instance.channelID)",
//            "bundleId": "\(bundleDetail.ubpBundleID ?? 0)",
//            "status": "A",
////            "flow": "F", // D -> Direct, F -> Favourite
//            
//        ]
//        APIs.postAPI(apiName: .addToFavourite, parameters: parameters, viewController: self) { responseData, success, errorMsg in
//            if success {
//                
//            }
//            let model: ModelAddToFavourite? = APIs.decodeDataToObject(data: responseData)
//            self.modelAddToFavourite = model
//        }
//    }
//    
//    func getFavourites() {
//        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
//        let parameters: Parameters = [
//            "cnic" : userCnic!,
//            "imei" : DataManager.instance.imei!,
//            "channelId" : "\(DataManager.instance.channelID)"
//        ]
//        APIs.postAPI(apiName: .getFavourites, parameters: parameters, viewController: self) { responseData, success, errorMsg in
//            if success {
//                
//            }
//            let model: ModelGetFavourites? = APIs.decodeDataToObject(data: responseData)
//            self.modelGetFavourites = model
//        }
//    }
//    
//    func updateFavourite() {
//        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
//        let parameters: Parameters = [
//            "cnic" : userCnic!,
//            "imei" : DataManager.instance.imei!,
//            "channelId" : "\(DataManager.instance.channelID)",
//            "benificiaryId": "292",
//            "status": "A",   // I for Delete Benificiary, A for Update Benificiary
//            "nickName": "Butt",  // if status = 'I' nickName is null
//        ]
//        APIs.postAPI(apiName: .updateFavourite, parameters: parameters, viewController: self) { responseData, success, errorMsg in
//            if success {
//                
//            }
//            let model: ModelUpdateFavourite? = APIs.decodeDataToObject(data: responseData)
//            self.modelUpdateFavourite = model
//        }
//    }
//}
//
//extension MobilePackages: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if collectionView == self.collectionViewDataType {
//            DispatchQueue.main.async {
//                (cell as! MobilePackagesDataNameCell).viewBackGround.circle()
//            }
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == self.collectionViewDataType {
//            let bundleFilter =  modelGetBundleDetails?.data[indexSelectedNetwork].bundleFilters?[indexPath.item]
//            return CGSize(width: "\(bundleFilter?.filterName ?? "")".size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width + 50, height: 40)
//        }
//        else if collectionView == collectionViewNetwork {
//            return CGSize(width: collectionViewNetwork.frame.size.width / 4, height: collectionView.frame.height)
//        }
//        else {
//            return CGSize(width: 70, height: collectionView.frame.height)
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        if companyNames == nil {
////            return 0
////        }
//        if collectionView == self.collectionViewDataType {
//            let totalBundleFilterCount = modelGetBundleDetails?.data[indexSelectedNetwork].bundleFilters?.count ?? 0
//            viewBackGroundDataType.isHidden = !(modelGetBundleDetails?.data[indexSelectedNetwork].recordCount ?? 0 > 0)
//            
//            return totalBundleFilterCount
//        }
//        else if collectionView == collectionViewNetwork {
//            return self.modelGetBundleDetails?.data.count ?? 0
//        }
//        else {
//            return modelGetBundleDetails?.data[indexSelectedNetwork].bundleDetails?[collectionView.tag].resourceLists?.count ?? 0
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == self.collectionViewDataType {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MobilePackagesDataNameCell", for: indexPath) as! MobilePackagesDataNameCell
//            
//            let modelBundleFilter =  modelGetBundleDetails?.data[indexSelectedNetwork].bundleFilters?[indexPath.item]
//            
//            cell.labelName.text = "\(modelBundleFilter?.filterName ?? "")"
//            if indexSelectedDataTypeCell != nil {
//                if indexSelectedDataTypeCell == indexPath.item {
//                    cell.viewBackGround.backgroundColor = .clrOrange
//                    cell.labelName.textColor = .white
//                }
//                else {
//                    cell.viewBackGround.backgroundColor = .clrLightGraySelectionBackGround
//                    cell.labelName.textColor = .clrLightGrayCalendar
//                }
//            }
//            else {
//                cell.viewBackGround.backgroundColor = .clrLightGraySelectionBackGround
//                cell.labelName.textColor = .clrLightGrayCalendar
//            }
//            
//            return cell
//        }
//        else if collectionView == collectionViewNetwork {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MobilePackagesTelcoCell", for: indexPath) as! MobilePackagesTelcoCell
//            cell.viewDevider.isHidden = indexPath.item == 0
//            
//            cell.viewBottomLine.backgroundColor = .clear
//            
//            var url = URL(string: "\(GlobalConstants.BASE_URL)\(modelGetBundleDetails?.data[indexPath.item].disabledIcon ?? "")")
//            if indexPath.item == indexSelectedNetwork {
//                cell.viewBottomLine.backgroundColor = .clrOrange
//                url = URL(string: "\(GlobalConstants.BASE_URL)\(modelGetBundleDetails?.data[indexPath.item].enabledIcon ?? "")")
//            }
//            
//            if let url {
//                cell.imageViewIcon.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
//                    if (image != nil){
//                        cell.imageViewIcon.image = image
//                    }
//                    else {
////                        cell.imageViewIcon.image = UIImage.init(named: "user")
//                    }
//                })
//            }
//            
//            return cell
//        }
//        else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MobileSubPackagesCell", for: indexPath) as! MobileSubPackagesCell
//            
//            cell.modelResourceList = modelGetBundleDetails?.data[indexSelectedNetwork].bundleDetails?[collectionView.tag].resourceLists?[indexPath.item]
//            
//            return cell
//        }
//    }
//  
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        if collectionView == collectionViewNetwork {
////            networkId = self.modelGetBundleDetails?.data[indexPath.item].
//            indexSelectedNetwork = indexPath.item
//            selectedNetwork(view: nil, button: nil)
//        }
//        else if collectionView == self.collectionViewDataType {
//            buttonAllDataType.backgroundColor = .clrLightGraySelectionBackGround
//            buttonAllDataType.setTitleColor(.clrLightGrayCalendar, for: .normal)
//            
//            indexSelectedDataTypeCell = indexPath.item
//            if let filterName = modelGetBundleDetails?.data[indexSelectedNetwork].bundleFilters?[indexPath.item].filterName as? String {
//                filterApply(packageType: [filterName], searchFromFilterScreen: false)
//            }
//        }
//        else {
//            
//        }
//        
//    }
//}
//
//extension MobilePackages: UITableViewDelegate, UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
////        let totalCellCount = modelGetBundleDetails?.data[indexSelectedNetwork].bundleDetails?.count ?? 0
//        
//        let totalCellCount = searchedBundleDetails?.count ?? 0
//        tableView.removeEmptyMessage()
//        if totalCellCount == 0 {
//            tableView.setEmptyMessage(iconName: "bundleEmptyMessageIcon")
//        }
//        return totalCellCount
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MobilePackagesCell") as! MobilePackagesCell
//        // if change internet package is true then we dont need to show subscribed package
//        let bundleDetail = searchedBundleDetails?[indexPath.row]
////        modelGetBundleDetails?.data[indexSelectedNetwork].bundleDetails?[indexPath.row]
//        
//        cell.modelBundleDetail = bundleDetail
//        cell.buttonSubscribeNow = { tempBundleDetail in
//            FBEvents.logEvent(title: .Bundles_list_attempt)
//            FaceBookEvents.logEvent(title: .Bundles_list_attempt)
//            self.navigateToMobilePackagesDetails(bundleDetails: tempBundleDetail)
//        }
//        cell.buttonFavouriteNow = { tempBundleDetail in
//            self.addToFavourite(bundleDetail: tempBundleDetail)
//        }
//        if cell.modelBundleDetail.resourceLists?.count ?? 0 > 0 {
//            cell.collectionView.delegate = self
//            cell.collectionView.dataSource = self
//            cell.collectionView.tag = indexPath.row
//        }
//        return cell
//        
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//    }
//
//}
//extension UILabel {
//    func cutPrice() {
//        guard let text = self.text else {
//            return
//        }
//        
//        let attributedText = NSAttributedString(
//            string: self.text!,
//            attributes: [.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue]
//        )
//
//        self.attributedText = attributedText
//    }
//}
//
//
//extension MobilePackages {
//    
//    // MARK: - ModelAddToFavourite
//    struct ModelAddToFavourite: Codable {
//        let responsecode: Int
//        let data: String
//        let responseblock: JSONNull?
//        let messages: String
//    }
//    
//    // MARK: - ModelUpdateFavourite
//    struct ModelUpdateFavourite: Codable {
//        let responsecode: Int
//        let data, responseblock: JSONNull?
//        let messages: String
//    }
//    
//    
//    // MARK: - ModelGetFavourites
//    struct ModelGetFavourites: Codable {
//        let responsecode: Int
//        let data: [ModelGetFavouritesData]
//        let responseblock: JSONNull?
//        let messages: String?
//    }
//
//    // MARK: - Datum
//    struct ModelGetFavouritesData: Codable {
//        let favouriteCategory: String?
//        let favouriteDetails: [ModelFavouriteDetail]?
//        
//    }
//
//    // MARK: - FavouriteDetail
//    struct ModelFavouriteDetail: Codable {
//        let benificiaryID: Int
//        let bankImd: String
//        let bankImdID: Int
//        let benificiaryAccountNo, benificiaryAccountTitle, benificiaryNickName: String?
//        let benificiaryBank: String?
//        let benificiaryType: String?
//        let imdIcon: String?
//
//        enum CodingKeys: String, CodingKey {
//            case benificiaryID = "benificiaryId"
//            case bankImd
//            case bankImdID = "bankImdId"
//            case benificiaryAccountNo, benificiaryAccountTitle, benificiaryNickName, benificiaryBank, benificiaryType, imdIcon
//        }
//    }
//}
//
//extension MobilePackages {
//    // MARK: - ModelGetBundleDetails
//    struct ModelGetBundleDetails: Codable {
//        let messages: String
//        let responsecode: Int
//        let responseblock: JSONNull?
//        let data: [ModelGetBundleDetailsData]
//    }
//
//    // MARK: - Datum
//    struct ModelGetBundleDetailsData: Codable {
//        let enabledIcon: String?
//        let bundleDetails: [ModelBundleDetail]?
//        let bundleFilters: [ModelBundleFilter]?
//        let companyName, disabledIcon: String?
//        let recordCount: Int?
//    }
//    struct bundleFilterIds: Codable {
//        let bundleFilterId: Int?
//    }
//
//    // MARK: - BundleDetail
//    struct ModelBundleDetail: Codable {
//        let ubpBundleID, bundleDiscountPrice: Int?
//        let bundleFilterIDS: [BundleFilterID]?
//        let bundleSelfSubscription: JSONNull?
//        let bundleResources: String?
//        let bundleValidity: String?
//        let bundleSequence: Int?
//        let bundleDefaultPrice: Double
//        let bundleKey, bundleName: String?
//        let bundleValidityType: String?
//        let resourceLists: [ModelResourceList]?
//        let bundleType: String?
//        let favouriteBundle: String?
//        let bundleDiscountPercentage: Int?
//
//        enum CodingKeys: String, CodingKey {
//            case ubpBundleID = "ubpBundleId"
//            case bundleDiscountPrice
//            case bundleFilterIDS = "bundleFilterIds"
//            case bundleSelfSubscription, bundleResources, bundleValidity, bundleSequence, bundleDefaultPrice, bundleKey, bundleName, bundleValidityType, resourceLists, bundleType, bundleDiscountPercentage,favouriteBundle
//        }
//    }
//
//    // MARK: - BundleFilterID
//    struct BundleFilterID: Codable {
//        let bundleFilterID: Int?
//
//        enum CodingKeys: String, CodingKey {
//            case bundleFilterID = "bundleFilterId"
//        }
//    }
//
//    // MARK: - ResourceList
//    struct ModelResourceList: Codable {
//        let detail: String?
//        let type: String?
//        let dataType: String?
//        let description: String?
//
//        enum CodingKeys: String, CodingKey {
//            case detail = "Detail"
//            case type = "Type"
//            case dataType = "Data-Type"
//            case description = "Description"
//        }
//    }
//
//    // MARK: - BundleFilter
//    struct ModelBundleFilter: Codable {
//        let filterName: String?
//        let ubpBundleFilterID: Int?
//
//        enum CodingKeys: String, CodingKey {
//            case filterName
//            case ubpBundleFilterID = "ubpBundleFilterId"
//        }
//    }
//
//    // MARK: - Encode/decode helpers
//
//    class JSONNull: Codable, Hashable {
//
//        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//            return true
//        }
//
//        public var hashValue: Int {
//            return 0
//        }
//
//        public init() {}
//
//        public required init(from decoder: Decoder) throws {
//            let container = try decoder.singleValueContainer()
//            if !container.decodeNil() {
//                throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//            }
//        }
//
//        public func encode(to encoder: Encoder) throws {
//            var container = encoder.singleValueContainer()
//            try container.encodeNil()
//        }
//    }
//
//}
//
