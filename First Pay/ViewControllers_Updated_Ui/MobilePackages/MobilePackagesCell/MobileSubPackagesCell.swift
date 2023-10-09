//
//  MobileSubPackagesCell.swift
//  First Pay
//
//  Created by Shakeel Ahmed on 09/10/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class MobileSubPackagesCell: UICollectionViewCell {
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var viewBackGroup: UIView!
    
    var modelResourceList: MobilePackages.ModelResourceList! {
        didSet {
            labelTitle.text = modelResourceList.detail
            labelDescription.text = modelResourceList.description
            
            if modelResourceList.type?.lowercased() == "Data".lowercased() {
                imageViewIcon.image = UIImage(named: "dataGB")
                labelDescription.text = (modelResourceList.dataType ?? "") + "\n" + (modelResourceList.description ?? "")
            }
            else if modelResourceList.type?.lowercased() == "On-Net".lowercased() {
                imageViewIcon.image = UIImage(named: "callOnNet")
            }
            else if modelResourceList.type?.lowercased() == "Off-Net".lowercased() {
                imageViewIcon.image = UIImage(named: "callOffNet")
            }
            else if modelResourceList.type?.lowercased() == "Sms".lowercased() {
                imageViewIcon.image = UIImage(named: "smsAllNet")
            }
                
            viewBackGroup.radius(radius: 8)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
