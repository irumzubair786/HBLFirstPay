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

    @IBOutlet weak var viewPackageTagBackground: UIView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewOne: UIView!
    @IBOutlet weak var viewTwo: UIView!
    @IBOutlet weak var viewThree: UIView!
    @IBOutlet weak var viewFour: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewOne.radius()
        viewTwo.radius()
        viewThree.radius()
        viewFour.radius()
        buttonSubscribe.circle()

        viewPackageTagBackground.roundCorners(corners: [.topRight, .bottomRight], radius: 20)
        labelCutPrice.cutPrice()
        DispatchQueue.main.async {
            self.viewBackground.setShadow(radius: 20)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
