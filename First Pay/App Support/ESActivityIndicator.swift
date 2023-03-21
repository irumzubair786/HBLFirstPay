
import Foundation
import UIKit

class ESActivityIndicator: UIView {
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.frame = bounds
        imageView.image = #imageLiteral(resourceName: "indicator")
        imageView.contentMode = .scaleAspectFit
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(imageView)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func startAnimatingIndicator() {
        isHidden = false
        rotate()
    }
    
    func stopAnimatingIndicator() {
        isHidden = true
        removeRotation()
    }
    
    private func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.imageView.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    private func removeRotation() {
        self.imageView.layer.removeAnimation(forKey: "rotationAnimation")
    }
}
