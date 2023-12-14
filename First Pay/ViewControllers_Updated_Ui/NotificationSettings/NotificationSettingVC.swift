//
//  NotificationSettingVC.swift
//  First Pay
//
//  Created by Irum Zubair on 14/12/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import FittedSheets
import ObjectMapper
import Alamofire

class NotificationSettingVC: BaseClassVC, BottomSheets {
    func openPicker(from parent: UIViewController, id: Int, in view: UIView?, tag: Int?) {
        let useInlineMode = view != nil
        let controller = (UIStoryboard.init(name: "NotificationsSettings", bundle: Bundle.main).instantiateViewController(withIdentifier: "languageSelectionVC") as? languageSelectionVC)!
        controller.id = 1
        controller.tag = 2
       
        let sheet = SheetViewController(
            controller: controller,
            sizes: [.percent(0.45), .fullscreen],
            options: SheetOptions(useInlineMode: useInlineMode))
        NotificationSettingVC.addSheetEventLogging(to: sheet)
        
        if let view = view {
            sheet.animateIn(to: view, in: parent)
        } else {
            
            parent.present(sheet, animated: true, completion: nil)
        }
    }
    
    static var name: String { "CategoryPicker" }
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonback.setTitle("", for: .normal)
        buttonDropdown.setTitle("", for: .normal)
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var buttonback: UIButton!
    
    @IBAction func buttonback(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBOutlet weak var labelSelectedLanguage: UILabel!
    
    @IBOutlet weak var buttonDropdown: UIButton!
    
    @IBAction func buttonDropdown(_ sender: UIButton) {
        getPrefLangFor()
       
        
    }
    //    -------------------getPrefLangForSms API
    func getPrefLangFor() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic": userCnic!,
            "channelId": "\(DataManager.instance.channelID)",
            "imei": DataManager.instance.imei!
        ]
          
        APIs.postAPI(apiName: .getPrefLangForSms, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            
            let model: getPrefLangForSmsModel? = APIs.decodeDataToObject(data: responseData)
            self.modelgetPrefLangForSms = model
        }
    }
    var modelgetPrefLangForSms: getPrefLangForSmsModel? {
        didSet {
            if modelgetPrefLangForSms?.responsecode == 1 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "languageSelectionVC") as! languageSelectionVC
                openPicker(from: self, id: 0, in: nil, tag: 2)
                
                self.present(vc, animated: true)
              
            }
            else {
                self.showAlertCustomPopup(title: "Error", message: modelgetPrefLangForSms?.messages, iconName: .iconError)
            }
        }
    }
    
//    ------------------------end
    
    
    
    
}
extension NotificationSettingVC
{
    struct getPrefLangForSmsModel: Codable {
        let responsecode: Int
        let data: DataClass
        let responseblock: JSONNull?
        let messages: String
    }
    
    // MARK: - DataClass
    struct DataClass: Codable {
        let language: String
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
    }
}
