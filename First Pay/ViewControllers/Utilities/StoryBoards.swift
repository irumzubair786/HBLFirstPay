//
//  StoryBords.swift
//  Maid
//
//  Created by Macbook Pro on 05/07/2022.
//

import Foundation
import UIKit
enum Storyboard: String {
    case Home = "Home"
    case Main = "Main"
    case Mybookings = "Mybookings"
    case Notifications = "Notifications"
    case registration_Login = "Registration_Login"
    case Profile = "Profile"
    case MyCart = "MyCart"
    
    

    func instantiate<T>(identifier: T.Type) -> T {
        let storyboard = UIStoryboard(name: rawValue, bundle: nil)
        guard let viewcontroller = storyboard.instantiateViewController(withIdentifier: String(describing: identifier)) as? T else {
            fatalError("No such view controller found")
        }
        return viewcontroller
    }
}

