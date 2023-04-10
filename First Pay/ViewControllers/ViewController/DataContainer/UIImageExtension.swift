//
//  UIImageExtension.swift
//  First Pay
//
//  Created by Apple on 11/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    //MARK: - Usage

    
    func shareScreenShot(viewController: UIViewController) {
        // image to share
        let image = self
        
        // set up activity view controller
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = viewController.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        viewController.present(activityViewController, animated: true, completion: nil)
    }

}
