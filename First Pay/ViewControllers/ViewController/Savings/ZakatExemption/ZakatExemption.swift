//
//  ZakatExemption.swift
//  First Pay
//
//  Created by Shakeel Ahmed on 08/11/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class ZakatExemption: UIViewController {

    @IBOutlet weak var viewBackGroundButtonAttachments: UIView!
    @IBOutlet weak var imageViewAttachment: UIImageView!
    @IBOutlet weak var labelFileAttachedName: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewBackGroundButtonAttachments.radius(radius: viewBackGroundButtonAttachments.frame.height/2, color: .clrOrange, borderWidth: 1)
    }
    
}
