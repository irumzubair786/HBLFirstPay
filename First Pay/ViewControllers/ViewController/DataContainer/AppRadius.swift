//
//  AppRadius.swift
//  HBLFMB
//
//  Created by Apple on 24/03/2023.
//

import Foundation
import UIKit

extension UIView {
    
    func circle() {
        self.layer.cornerRadius = self.frame.height / 2
    }
    func radius(radius: CGFloat? = 12, color: UIColor? = nil, borderWidth: CGFloat? = 1) {
        self.layer.cornerRadius = radius!
        self.clipsToBounds = true
        if color != nil {
            self.layer.borderColor = color?.cgColor
            self.layer.borderWidth = borderWidth!
        }
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat){
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    @discardableResult
    func radiusLineDashedStroke(pattern: [NSNumber]? = [4,4], radius: CGFloat? = 12, color: UIColor? = .red) -> CALayer {
        let borderLayer = CAShapeLayer()
        
        borderLayer.strokeColor = color?.cgColor
        borderLayer.lineDashPattern = pattern
        borderLayer.frame = bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius!, height: radius!)).cgPath
        
        layer.addSublayer(borderLayer)
        return borderLayer
    }
    func setShadow(radius: CGFloat? = 6){
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.3
        self.layer.cornerRadius = radius!
    }
    func setShadowThin(radius: CGFloat? = 6){
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.3
        self.layer.cornerRadius = radius!
    }
}


extension UIButton {
    
}
