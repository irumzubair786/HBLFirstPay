//
//  languageSelectionVC.swift
//  First Pay
//
//  Created by Irum Zubair on 14/12/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import FittedSheets
import Alamofire
import Foundation
import ObjectMapper



class languageSelectionVC: BaseClassVC, UITableViewDelegate, UITableViewDataSource{
   
     var valueDelegate: DataDelegate?
    @IBOutlet weak var tableView: UITableView!
    var id : Int?
    var tag : Int?
    var languageId : Int?
    var reasonsObj: GetLanguagesModel?
    var selectedLang : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        getLanguages()
      
    }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return  reasonsObj?.dataobj?.count ?? 0
        }
    //
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellLanguageSelection") as! cellLanguageSelection
            let aRequest  = reasonsObj?.dataobj?[indexPath.row]
            cell.label.text = reasonsObj?.dataobj?[indexPath.row].languageDescr
            cell.radionButton.setTitle("", for: .normal)
            cell.radionButton.tag = indexPath.row
            cell.radionButton.addTarget(self, action: #selector(buttontaped), for: .touchUpInside)
            return cell
    
        }
    @objc func buttontaped(_sender:UIButton)
    {
        let tag = _sender.tag
        let cell = tableView.cellForRow(at: IndexPath(row: tag, section: 0)) as! cellLanguageSelection
        languageId = reasonsObj?.dataobj?[tag].languageId
        selectedLang =  reasonsObj?.dataobj?[tag].languageDescr
//      api call
        cell.radionButton.setBackgroundImage(UIImage(named: "circleOrange"), for: .normal)
        self.setPrefLangForSms()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.setPrefLangForSms()
//        }
       
        
    }
//http://bbuat.hblmfb.com/FirstPayInfo/v1/setPrefLangForSms
    func setPrefLangForSms() {
        var userCnic = UserDefaults.standard.string(forKey: "userCnic")
        userCnic = DataManager.instance.userCnic
        let parameters: Parameters = [
            "cnic": UserDefaults.standard.string(forKey: "userCnic")!,
            "channelId": "\(DataManager.instance.channelID)",
            "imei": DataManager.instance.imei!,
            "language" : "\(languageId!)",
            
        ]
 
        APIs.postAPI(apiName: .setPrefLangForSms, parameters: parameters, viewController: self) { responseData, success, errorMsg in

            let model: GenericResponseUpdatedAPI? = APIs.decodeDataToObject(data: responseData)
            self.genResponseObj = model
        }
    }
    
    
 
    var genResponseObj: GenericResponseUpdatedAPI? {
        didSet {
            if genResponseObj?.responsecode == 1 {

                print("Success")
                self.showAlertCustomPopup(title: "Success", message: genResponseObj?.messages, iconName: .iconSuccess, completion: { [self] _ in

                    print("selectedLang is ", selectedLang)
                    self.valueDelegate?.receiveData(data: selectedLang!)
                    
                    self.dismiss(animated: true)
                    })

                    
               
            }
            else {
                self.showAlertCustomPopup(title: "Error", message: genResponseObj?.messages, iconName: .iconError)
            }
        }
    }
//    end API
    
    
    
   
    
    
    
   
    private func getLanguages() {
        ////
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/getLanguages"
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).response {
            //            (response: DataResponse<GetDisputeTypesModel>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.reasonsObj = Mapper<GetLanguagesModel>().map(JSONObject: json)
                
                
                
                
                self.hideActivityIndicator()
                guard let data = response.data else { return }
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    //            self.reasonsObj = Mapper<GetReasonsModel>().map(JSONObject: json)
                    
                    if response.response?.statusCode == 200 {
                        //                self.reasonsObj = response.result.value
                        
                        if self.reasonsObj?.responsecode == 2 || self.reasonsObj?.responsecode == 1 {
                        
                                                    self.tableView.delegate = self
                                                    self.tableView.dataSource = self
                                                    self.tableView.reloadData()
                                                      self.tableView.rowHeight = 90
                          
                        }
                    }
                }
                
            }
        }
//        api end
    }
}
//    class end
    protocol BottomSheets {
        static var name: String { get }
        func openPicker(from parent: UIViewController , in view: UIView?, valu : String?)
        
    }
    extension BottomSheets {
        static func addSheetEventLogging(to sheet: SheetViewController) {
            let previousDidDismiss = sheet.didDismiss
            sheet.didDismiss = {
                print("did dismiss")
                previousDidDismiss?($0)
            }
            
            let previousShouldDismiss = sheet.shouldDismiss
            sheet.shouldDismiss = {
                print("should dismiss")
                return previousShouldDismiss?($0) ?? true
            }
            
            let previousSizeChanged = sheet.sizeChanged
            sheet.sizeChanged = { sheet, size, height in
                print("Changed to \(size) with a height of \(height)")
                previousSizeChanged?(sheet, size, height)
            }
        }
    }
    
    struct GetLanguagesModel : Mappable {
        var responsecode : Int?
        var dataobj : [LanguageData]?
        var responseblock : String?
        var messages : String?

        init?(map: Map) {

        }

        mutating func mapping(map: Map) {

            responsecode <- map["responsecode"]
            dataobj <- map["data"]
            responseblock <- map["responseblock"]
            messages <- map["messages"]
        }

    }
    struct LanguageData : Mappable {
        var languageId : Int?
        var languageCode : String?
        var languageDescr : String?

        init?(map: Map) {

        }

        mutating func mapping(map: Map) {

            languageId <- map["languageId"]
            languageCode <- map["languageCode"]
            languageDescr <- map["languageDescr"]
        }

    }

extension languageSelectionVC{
    struct GenericResponseUpdatedAPI: Codable {
        let responsecode: Int
        let data: JSONNull?
        let messages: String
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
