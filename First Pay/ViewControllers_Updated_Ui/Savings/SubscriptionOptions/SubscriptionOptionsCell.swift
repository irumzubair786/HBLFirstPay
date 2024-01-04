//
//  SubscriptionOptionsCell.swift
//  First Pay
//
//  Created by Shakeel Ahmed on 15/11/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class SubscriptionOptionsCell: UITableViewCell {

    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelPackageDescription: UILabel!
    @IBOutlet weak var labelPackageName: UILabel!
    @IBOutlet weak var buttonUnSubscribe: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        buttonUnSubscribe.radius(radius: buttonUnSubscribe.frame.height/2, color: .clrOrange, borderWidth: 1)
        
        SubscriptionOptionsPackageCell.register(collectionView: collectionView)
        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func buttonUnSubscribe(_ sender: Any) {
    }
    
}
