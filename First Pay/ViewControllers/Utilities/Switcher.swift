//
//  Switcher.swift
//  Maid
//
//  Created by Macbook Pro on 07/07/2022.
//

import Foundation
import UIKit
class Switcher {
    

    class func presentAboutus(viewController: UIViewController?) {
        
        let storyBoard = UIStoryboard(name:Storyboard.Profile.rawValue, bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
        viewController?.present(vc, animated: true, completion: nil)
    }
    class func presentPrivacyPolicy(viewController: UIViewController?) {
        
        let storyBoard = UIStoryboard(name:Storyboard.Profile.rawValue, bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
        viewController?.present(vc, animated: true, completion: nil)
    }
    class func presentTermsConditions(viewController: UIViewController?) {
        
        let storyBoard = UIStoryboard(name:Storyboard.Profile.rawValue, bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: "TermsConditionVC") as! TermsConditionVC
        viewController?.present(vc, animated: true, completion: nil)
    }
    class func presentchangePassword(viewController: UIViewController?) {
        
        let storyBoard = UIStoryboard(name:Storyboard.Profile.rawValue, bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        viewController?.present(vc, animated: true, completion: nil)
    }
    class func presentFaqs(viewController: UIViewController?) {
        
        let storyBoard = UIStoryboard(name:Storyboard.Profile.rawValue, bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: "FAQsVc") as! FAQsVc
        viewController?.present(vc, animated: true, completion: nil)
    }
    class func presentNotification(viewController: UIViewController?) {
        
        let storyBoard = UIStoryboard(name:Storyboard.Profile.rawValue, bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: "profileNotificationsVC") as! profileNotificationsVC
        viewController?.present(vc, animated: true, completion: nil)
    }
    
}
