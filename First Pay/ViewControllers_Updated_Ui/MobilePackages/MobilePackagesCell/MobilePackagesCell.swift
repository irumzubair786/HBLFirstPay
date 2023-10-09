//
//  MobilePackagesCell.swift
//  HBLFMB
//
//  Created by Apple on 20/06/2023.
//

import UIKit

class MobilePackagesCell: UITableViewCell {
    @IBOutlet weak var viewTag: UIView!
    @IBOutlet weak var labelCutPrice: UILabel!
    @IBOutlet weak var buttonSubscribe: UIButton!
    @IBOutlet weak var buttonStar: UIButton!
    
    @IBOutlet weak var labelBundleValidity: UILabel!
    @IBOutlet weak var labelPackageName: UILabel!
    @IBOutlet weak var viewPackageTagBackground: UIView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewOne: UIView!
    @IBOutlet weak var viewTwo: UIView!
    @IBOutlet weak var viewThree: UIView!
    @IBOutlet weak var viewFour: UIView!
    
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelTaxPrice: UILabel!
    
    @IBOutlet weak var labelData: UILabel!
    @IBOutlet weak var labelDataDescription: UILabel!
    @IBOutlet weak var labelOnNetMinute: UILabel!
    @IBOutlet weak var labelOnNetMinuteDescription: UILabel!
    @IBOutlet weak var labelOffNetMinute: UILabel!
    @IBOutlet weak var labelOffNetMinuteDescription: UILabel!
    
    @IBOutlet weak var labelMessages: UILabel!
    @IBOutlet weak var labelMessagesDescription: UILabel!
    @IBOutlet weak var labelPackageDescription: UILabel!
    @IBOutlet weak var labelDiscountPercentage: UILabel!
    @IBOutlet weak var buttonFavourite: UIButton!
    
    var buttonSubscribeNow: ((MobilePackages.ModelBundleDetail) -> ())!
    var buttonFavouriteNow: ((MobilePackages.ModelBundleDetail) -> ())!
    var modelBundleDetail: MobilePackages.ModelBundleDetail! {
        didSet {
            labelPackageName.text = modelBundleDetail.bundleName
            labelBundleValidity.text = modelBundleDetail.bundleValidity ?? ""
            labelTaxPrice.text = "incl. tax"
            labelCutPrice.text = "Rs.\(modelBundleDetail.bundleDiscountPrice ?? 0)"
            labelPrice.text = "Rs.\(modelBundleDetail.bundleDefaultPrice)"
            if modelBundleDetail.bundleDiscountPrice == 0 {
                labelCutPrice.isHidden = true
            }
            else {
                labelCutPrice.isHidden = false
                labelCutPrice.cutPrice()
            }
//            labelData.text = modelBundleDetail.bundleResourceData ?? "0"
//            labelMessages.text = modelBundleDetail.bundleResourceOnnet ?? "0"
//            labelMessages.text = modelBundleDetail.bundleResourceOffnet ?? "0"
//            labelMessages.text = modelBundleDetail.bundleResourceSMS ?? "0"
            labelPackageDescription.text = modelBundleDetail.bundleResources
            viewPackageTagBackground.isHidden = true
            viewTag.isHidden = true
            if modelBundleDetail.bundleDiscountPercentage != nil && modelBundleDetail.bundleDiscountPercentage != 0 {
                viewTag.isHidden = false
                viewPackageTagBackground.isHidden = false
                labelDiscountPercentage.text = "\(modelBundleDetail.bundleDiscountPercentage ?? 0)"
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewOne.radius()
        viewTwo.radius()
        viewThree.radius()
        viewFour.radius()
        buttonSubscribe.circle()
        
        viewPackageTagBackground.roundCorners(corners: [.topRight, .bottomRight], radius: 20)
        
        DispatchQueue.main.async {
            self.viewBackground.setShadow(radius: 20)
        }
    }
    @IBAction func buttonSubscribe(_ sender: Any) {
        buttonSubscribeNow!(modelBundleDetail)
    }
    
    @IBAction func buttonFavourite(_ sender: Any) {
        buttonFavouriteNow(modelBundleDetail)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}
    

