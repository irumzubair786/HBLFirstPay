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
    func radius(radius: Int? = 12, color: UIColor? = nil) {
        self.layer.cornerRadius = 12
        if color != nil {
            self.layer.borderColor = color?.cgColor
            self.layer.borderWidth = 1
        }
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat){
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    @discardableResult
    func radiusLineDashedStroke(pattern: [NSNumber]? = [2,2], radius: CGFloat? = 12, color: UIColor? = .red) -> CALayer {
            let borderLayer = CAShapeLayer()

        borderLayer.strokeColor = color?.cgColor
            borderLayer.lineDashPattern = pattern
            borderLayer.frame = bounds
            borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius!, height: radius!)).cgPath

            layer.addSublayer(borderLayer)
            return borderLayer
        }
}


extension UIButton {
    
}
