//
//  MobilePackagesDetails.swift
//  First Pay
//
//  Created by Shakeel Ahmed on 19/09/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire

class MobilePackagesDetails: UIViewController {

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
    
    var companyIcon: UIImage!
    var companyName: String!
    var bundleDetail: MobilePackages.BundleDetail!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBackGroundContinueButton.circle()
        // Do any additional setup after loading the view.
        setData()
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonContinue(_ sender: Any) {
        bundleSubscription()
    }
    
    func setData() {
        labelPackage.text = bundleDetail.bundleName
        labelCarrier.text =  companyName
        labelPrice.text = "\(bundleDetail.bundleDefaultPrice)"
        labelAmount.text = "\(bundleDetail.bundleDefaultPrice)"
        imageViewOperator.image = companyIcon
    }
    
    func bundleSubscription() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
            "lat" : "\(DataManager.instance.Latitude ?? 0)",
            "lng" : "\(DataManager.instance.Longitude ?? 0)",
            "mobileNo" : "03445823336",//textFieldMobileNumber.text!, //"03445823336",
            "bundleKey" : "\(bundleDetail.bundleKey)",
            "bundleId" : "\(bundleDetail.ubpBundleID)"
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
