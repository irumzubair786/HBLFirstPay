//
//  UIViewControllerExtension.swift
//  First Pay
//
//  Created by Apple on 06/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlertCustomPopup(title:String? = "", message: String? = "", imageIcon: String? = nil, buttonName: [String]? = ["OK"]) {
        let alertCustomPopup = UIStoryboard.init(name: "AlertPopup", bundle: nil).instantiateViewController(withIdentifier: "AlertPopupMessage") as! AlertPopupMessage
        alertCustomPopup.modalPresentationStyle = .overFullScreen
        self.present(alertCustomPopup, animated: true)
    }
    
    public func showActivityIndicator2() {
        customActivityIndicatory(self.view, startAnimate: true)
//            ESActivityIndicator.startAnimatingIndicator(self.view)
    }
    
    public func hideActivityIndicator2() {
        customActivityIndicatory(self.view, startAnimate: false)
//            ESActivityIndicator.stopAnimatingIndicator(<#T##ESActivityIndicator#>)
    }
}
