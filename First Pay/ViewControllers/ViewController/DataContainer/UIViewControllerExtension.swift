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
    func showAlertCustomPopup(title:String? = "", message: String? = "", iconName: IconNames.iconNameError = .iconError, buttonNames: [[String: AnyObject]]? = [[
        "buttonName": "OKAY",
        "buttonBackGroundColor": UIColor.clrOrange,
        "buttonTextColor": UIColor.white] as [String : Any]] as? [[String: AnyObject]]
//    ) {
                              , completion: ((String?) -> Void)? = nil) {
            
        let alertCustomPopup = UIStoryboard.init(name: "AlertPopup", bundle: nil).instantiateViewController(withIdentifier: "AlertPopupMessage") as! AlertPopupMessage
        alertCustomPopup.titleMessage = title!
        alertCustomPopup.message = message ?? ""
        alertCustomPopup.arrayButtonNames = buttonNames!
        alertCustomPopup.iconName = iconName.rawValue
        
        alertCustomPopup.modalPresentationStyle = .overFullScreen
        
        alertCustomPopup.complitionButtonAction = { buttonName in
            completion?(buttonName)
        }
        
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
    
    func dismissToViewController<T>(viewController: T) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: viewController.self as! AnyClass) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
}

final class TableViewContentSized: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIViewNoIntrinsicMetric, height: contentSize.height)
    }
}

extension UITableView {
    func setEmptyMessage(iconName: String) {
        let imageView = UIImageView(image: UIImage(named: iconName))
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        
        var backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        imageView.center = backgroundView.center
        imageView.frame.origin.y = backgroundView.frame.midX - 50
        backgroundView.addSubview(imageView)
        
        self.backgroundView = backgroundView
    }
    
    func removeEmptyMessage() {
        self.backgroundView = nil
    }
    
}
