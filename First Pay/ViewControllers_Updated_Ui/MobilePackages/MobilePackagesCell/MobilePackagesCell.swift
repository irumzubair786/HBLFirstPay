//
//  MobilePackagesCell.swift
//  HBLFMB
//
//  Created by Apple on 20/06/2023.
//

import UIKit

class MobilePackagesCell: UITableViewCell {
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
    
    var buttonSubscribeNow: ((MobilePackages.BundleDetail) -> ())!
    var buttonFavouriteNow: ((MobilePackages.BundleDetail) -> ())!
    var bundleDetail: MobilePackages.BundleDetail! {
        didSet {
            labelPackageName.text = bundleDetail.bundleName
            labelBundleValidity.text = bundleDetail.bundleValidity ?? ""
            labelTaxPrice.text = "incl. tax"
            if bundleDetail.bundleDiscountPrice == 0 {
                labelCutPrice.isHidden = true
                labelPrice.text = "Rs.\(bundleDetail.bundleDefaultPrice)"
            }
            else {
                labelCutPrice.isHidden = false
                labelCutPrice.text = "Rs.\(bundleDetail.bundleDiscountPrice)"
                labelPrice.text = "Rs.\(bundleDetail.bundleDefaultPrice)"
                labelCutPrice.cutPrice()
            }
            labelData.text = bundleDetail.bundleResourceData ?? "0"
            labelMessages.text = bundleDetail.bundleResourceOnnet ?? "0"
            labelMessages.text = bundleDetail.bundleResourceOffnet ?? "0"
            labelMessages.text = bundleDetail.bundleResourceSMS ?? "0"
            labelPackageDescription.text = bundleDetail.bundleResources
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
        buttonSubscribeNow!(bundleDetail)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
