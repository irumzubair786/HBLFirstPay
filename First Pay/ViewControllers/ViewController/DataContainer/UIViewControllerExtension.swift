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
    func showAlertCustomPopup(title:String? = "", message: String? = "", iconName: String? = nil, buttonNames: [String]? = ["OK"]) {
        let alertCustomPopup = UIStoryboard.init(name: "AlertPopup", bundle: nil).instantiateViewController(withIdentifier: "AlertPopupMessage") as! AlertPopupMessage
        alertCustomPopup.titleMessage = title!
        alertCustomPopup.message = message!
        alertCustomPopup.buttonArray = buttonNames!
        alertCustomPopup.iconName = iconName!
        
        alertCustomPopup.modalPresentationStyle = .overFullScreen
        self.present(alertCustomPopup, animated: true)
    }
    
    func showEmptyView(message: String? = "", iconName: String? = nil, buttonName: String? = "OK", complition: @escaping(_ actionCall: Bool, _ emptyView: UIView) -> Void) {
        
//        , completion: @escaping(_ response: Data?, Bool, _ errorMsg: String) -> Void) {
            
        let emptyVC = UIStoryboard.init(name: "AlertPopup", bundle: nil).instantiateViewController(withIdentifier: "EmptyVC") as! EmptyVC
        emptyVC.messageDescription = message!
        emptyVC.buttonName = buttonName!
        emptyVC.iconName = iconName!
        emptyVC.callBackButtonAction = {
            complition(true, emptyVC.view)
        }
        emptyVC.view.frame = self.view.frame
        self.view.addSubview(emptyVC.view)
        
//        emptyVC.modalPresentationStyle = .overFullScreen
//        self.present(emptyVC, animated: false)
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
