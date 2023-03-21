//
//  DisableEditingTextfield.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 31/12/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import Foundation
import UIKit

class DisableEditingTextfield: UITextField {
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
