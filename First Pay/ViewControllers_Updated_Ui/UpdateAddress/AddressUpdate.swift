//
//  AddressUpdate.swift
//  HBLFMB
//
//  Created by Apple on 28/07/2023.
//

import UIKit

class AddressUpdate: UIViewController {
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var viewBackGroundNextButton: UIView!

    @IBOutlet weak var imageViewForwardButton: UIImageView!

    @IBOutlet weak var viewBackGroundTextView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var labelAddresHInt: UILabel!
    @IBOutlet weak var labelAddressSample: UILabel!

    @IBAction func buttonNext(_ sender: Any) {
    }
    var placeholderLabel : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBackGroundNextButton.circle()
        viewBackGroundTextView.radius(radius: 12, color: UIColor.clrGreen)
        // Do any additional setup after loading the view.
        placeHolderForTextView()
    }
    
    func placeHolderForTextView() {
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: UITextView.textDidChangeNotification, object: nil)

        textView.delegate = self
                placeholderLabel = UILabel()
                placeholderLabel.text = "Ho. 568, St. 17, Near Bilal Mosque, G-10/1 Islamabad"
                placeholderLabel.font = .italicSystemFont(ofSize: (textView.font?.pointSize)!)
                placeholderLabel.sizeToFit()
                textView.addSubview(placeholderLabel)
                placeholderLabel.frame.origin = CGPoint(x: 8, y: (textView.font?.pointSize)! / 2)
                placeholderLabel.textColor = .tertiaryLabel
                placeholderLabel.isHidden = !textView.text.isEmpty

        labelAddresHInt.attributedText = attributedText(label: labelAddresHInt, withString: labelAddresHInt.text!, boldString: "Address Must Include:", boldStringColor: UIColor.clrOrange)
        
        labelAddressSample.attributedText = attributedText(label: labelAddressSample, withString: labelAddressSample.text!, boldString: "Sample Address:", boldStringColor: UIColor.clrGray)
        
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 12, bottom: 4, right: 12)

//        Sample Address: Ho.No 456, St. No 99, Village Shah Allah Ditta, near Jamia masjid Bilal, Dist. Islamabad, Tehsil Islamabad.
    }
    
    @objc func textChanged() {
        
        if textView.text.count < 20 {
            imageViewForwardButton.image = UIImage(named: "forwardButtonGray")
        }
        else if textView.text.count > 19 {
            imageViewForwardButton.image = UIImage(named: "forwardButtonGreenIcon")
            if textView.text.count > 90 {
                textView.text.removeLast()
            }
        }
        else {
            
        }
        labelCount.text = "\(textView.text.count)/90"
    }
    func attributedText(label: UILabel, withString string: String, boldString: String, boldStringColor: UIColor) -> NSAttributedString {
        let font = label.font!
        let completeString = string
        let boldStringLocal = boldString
        let labelWidth = label.frame.size.width
        let myStyle = NSMutableParagraphStyle()
        myStyle.tabStops = [NSTextTab(textAlignment: .left, location: 0.0, options: [:]),
          NSTextTab(textAlignment: .right, location: labelWidth, options: [:])]

        let attributedString = NSMutableAttributedString(
            string: completeString,
            attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont(name: "System Bold", size: font.pointSize) ?? UIFont.boldSystemFont(ofSize: font.pointSize)
        ]
        
        let range = (completeString as NSString).range(of: boldStringLocal)
        attributedString.addAttributes(boldFontAttribute, range: range)
        attributedString.addAttribute(.foregroundColor, value: boldStringColor, range: range)
        attributedString.addAttribute(.paragraphStyle, value: myStyle, range: range)
        
        return attributedString
    }
}
extension AddressUpdate : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = true
    }
}
