//
//  AlertPopupMessage.swift
//  First Pay
//
//  Created by Apple on 06/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class AlertPopupMessage: UIViewController {

    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var viewButtonOne: UIView!
    @IBOutlet weak var viewButtonOneInner: UIView!
    @IBOutlet weak var labelButtonOne: UILabel!

    @IBOutlet weak var buttonOne: UIButton!
    @IBAction func buttonOne(_ sender: Any) {
        buttonPressed(buttonNumber: 0)
    }
    
    @IBOutlet weak var viewButtonTwo: UIView!
    @IBOutlet weak var viewButtonTwoInner: UIView!
    @IBOutlet weak var labelButtonTwo: UILabel!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBAction func buttonTwo(_ sender: Any) {
        buttonPressed(buttonNumber: 1)
    }
    
    @IBOutlet weak var viewButtonThree: UIView!
    @IBOutlet weak var viewButtonThreeInner: UIView!
    @IBOutlet weak var labelButtonThree: UILabel!
    @IBOutlet weak var buttonThree: UIButton!
    @IBAction func buttonThree(_ sender: Any) {
        buttonPressed(buttonNumber: 2)
    }

    @IBOutlet weak var imageViewMessageIcon: UIImageView!
    @IBOutlet weak var viewButtonFour: UIView!
    @IBOutlet weak var viewButtonFourInner: UIView!
    @IBOutlet weak var labelButtonFour: UILabel!
    @IBOutlet weak var buttonFour: UIButton!
    @IBAction func buttonFour(_ sender: Any) {
        buttonPressed(buttonNumber: 3)
    }
    
    
    @IBOutlet weak var viewButtonFive: UIView!
    @IBOutlet weak var viewButtonFiveInner: UIView!
    @IBOutlet weak var labelButtonFive: UILabel!
    @IBOutlet weak var buttonFive: UIButton!
    @IBAction func buttonFive(_ sender: Any) {
        buttonPressed(buttonNumber: 4)
    }
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelErrorCode: UILabel!
    
    @IBOutlet weak var labelDescription: UILabel!
    var arrayButtonNames = [String]()
    override func viewDidAppear(_ animated: Bool) {
        self.view.drawBackgroundBlur(withTag: 999)
    }
    var titleMessage = ""
    var message = ""
    var buttonArray = [String]()
    var complitionButtonAction: ((String)->())!
    var iconName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBackGround.radius(radius: 40)
        setUISetting()
        
        if iconName != "" {
            imageViewMessageIcon.image = UIImage(named: iconName)
        }
        else {
            //Default Icon
        }
        labelTitle.text = titleMessage
        labelDescription.text = message
        labelErrorCode.text = ""
        
        
    }
    
    
    func setUISetting() {
        viewButtonTwo.isHidden = true
        viewButtonThree.isHidden = true
        viewButtonFour.isHidden = true
        viewButtonFive.isHidden = true

        for (index, buttonName) in arrayButtonNames.enumerated() {
            if index == 0 {
                labelButtonOne.text = buttonName
            }
            if index == 1 {
                labelButtonTwo.text = buttonName
                viewButtonOne.isHidden = false
            }
            if index == 2 {
                labelButtonThree.text = buttonName
                viewButtonTwo.isHidden = false
            }
            if index == 3 {
                labelButtonFour.text = buttonName
                viewButtonThree.isHidden = false
            }
            if index == 4 {
                labelButtonFive.text = buttonName
                viewButtonFour.isHidden = false
            }
        }
        viewButtonOneInner.radius(color: .clrOrange, borderWidth: 1)
        viewButtonOneInner.circle()
        viewButtonTwoInner.radius(color: .clrOrange, borderWidth: 1)
        viewButtonTwoInner.circle()
        viewButtonThreeInner.radius(color: .clrOrange, borderWidth: 1)
        viewButtonThreeInner.circle()
        viewButtonFourInner.radius(color: .clrOrange, borderWidth: 1)
        viewButtonFourInner.circle()
        viewButtonFiveInner.radius(color: .clrOrange, borderWidth: 1)
        viewButtonFiveInner.circle()
        

    }
    
    func buttonPressed(buttonNumber: Int) {
        self.view.backgroundColor = .clear
        view.viewWithTag(999)?.removeFromSuperview()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.complitionButtonAction(self.arrayButtonNames[buttonNumber])
            self.dismiss(animated: true)
        }
    }
    
    


}