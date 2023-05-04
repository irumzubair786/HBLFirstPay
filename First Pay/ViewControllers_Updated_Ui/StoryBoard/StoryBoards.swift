//
//  StoryBords.swift
//  Maid
//
//  Created by Macbook Pro on 05/07/2022.
//

import Foundation
import UIKit
enum Storyboard: String {
    case Dash_Board = "Dash_Board"
    case Main = "Main"
    case ForgotPassword = "ForgotPassword"
    case RegistrationProcess = "RegistrationProcess"
    case ContactUs = "ContactUs"
    case TabBar = "TabBar"
    case TopUp = "TopUp"
    case AddCash = "AddCash"
    case ATMLocator = "ATMLocator"
//    case ToggleMenuVC = "TabBar"
   
    
    

    func instantiate<T>(identifier: T.Type) -> T {
        let storyboard = UIStoryboard(name: rawValue, bundle: nil)
        guard let viewcontroller = storyboard.instantiateViewController(withIdentifier: String(describing: identifier)) as? T else {
            fatalError("No such view controller found")
        }
        return viewcontroller
    }
}

