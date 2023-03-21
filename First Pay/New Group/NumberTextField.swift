//
//  NumberTextField.swift
//  First Pay
//
//  Created by Irum Butt on 01/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import Foundation
enum NumberTextFieldMode {
    case localNumber
    case internationalNumber
    case cnic
    
    case last6CnicDigits
}
class NumberTextField: UITextField, UITextFieldDelegate {
    
    var mode: NumberTextFieldMode?{ didSet{ self.delegate = self } }
 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch (self.mode) {
       
        case .localNumber:
            return self.handleLocal(self, shouldChangeCharactersIn: range, replacementString: string)
        case .internationalNumber:
            return self.handleInternational(self, shouldChangeCharactersIn: range, replacementString: string)
        case .cnic:
            return self.handleCnic(self, shouldChangeCharactersIn: range, replacementString: string)
        
        case .last6CnicDigits:
            return self.handleLast6CnicDigits(self, shouldChangeCharactersIn: range, replacementString: string)
        default:
            return false
        }
    }
    
    func handleLast6CnicDigits(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.isBackspace {
            return true
        }else{
            guard string.isNumeric(string: textField.text! as NSString, range: range) else { return false }
            if textField.text?.count ?? 0 > 5{
                return false
            }else{
                return true
            }
        }
    }
    

    
    //    11111-1111111-1
    fileprivate func handleCnic(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //  will limit characters
        if range.lowerBound <= 14{
            if string.isBackspace{
                if textField.text?.count == 15{ textField.text?.removeLast(1) }
                if textField.text?.count == 7{ textField.text?.removeLast(1) }
                
                return true
            }
            else{
                
                guard string.isNumeric(string: textField.text! as NSString, range: range) else { return false }
                
                //  insert space after 03xx
                if textField.text?.count == 5{
                    DispatchQueue.main.async {
                        textField.text! += "-"+string
                    }
                }else if textField.text?.count == 13{
                    DispatchQueue.main.async {
                        textField.text! += "-"+string
                    }
                }
                return true
            }
            
        }
        return false
    }
    
    
    
 fileprivate func handleLocal(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //  will limit characters
        if range.lowerBound <= 11{
            if string.isBackspace{
                if textField.text?.count == 6{ textField.text?.removeLast(1) }
                //                if textField.text?.count == 3{
                //                    DispatchQueue.main.async {
                //                        textField.text?.removeLast(3)
                //                    }
                //                }
                return true
            }
            else{
                
                guard string.isNumeric(string: textField.text! as NSString, range: range) else { return false }
                
                //  insert 03 as prefix
                if textField.text?.count == 0{
                    //                    textField.text?.insert(contentsOf: "03", at: string.startIndex)
                    return (string == "0")
                }
                
                if textField.text?.count == 1{
                    //                    textField.text?.insert(contentsOf: "03", at: string.startIndex)
                    return (string == "3")
                }
               
                
                //  insert space after 03xx
                if textField.text?.count == 4{
                    DispatchQueue.main.async {
                        
                        textField.text! += "-"+string
                    }
                }
                return true
            }
            
        }
        return false
    }
    
    
    fileprivate func handleInternational(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.lowerBound <= 14{
            if string.isBackspace{
                
                if textField.text?.count == 9{ textField.text?.removeLast(1) }
                
                if textField.text?.count == 5{
                    textField.text?.removeLast(4)
                }
                
                return true
            }
            else{
                
                guard string.isNumeric(string: textField.text! as NSString, range: range) else { return false }
                
                if textField.text?.count == 0{ textField.text?.insert(contentsOf: "+92 ", at: string.startIndex) }
                
                //  insert space after +92 3xx
                if textField.text?.count == 7{
                    DispatchQueue.main.async {
                        textField.text! += " "+string
                    }
                }
                return true
                
            }
        }
        return false
    }
}
    

extension String {
    
    var isBackspace: Bool {
        let char = self.cString(using: String.Encoding.utf8)!
        return strcmp(char, "\\b") == -92
    }
    
    func isNumeric(string: NSString, range: NSRange) -> Bool{
        let numericRegEx = "[0-9]"
        return NSPredicate(format:"SELF MATCHES %@", numericRegEx).evaluate(with: self)
    }
    
}
