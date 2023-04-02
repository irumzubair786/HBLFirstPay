//
//  NanoLoanRepayViewController.swift
//  HBLFMB
//
//  Created by Apple on 24/03/2023.
//

import UIKit

class NanoLoanRepayViewController: UIViewController {
    
    @IBOutlet weak var viewApplyButton: UIView!
    @IBOutlet weak var viewBenifitRepaying: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewBenifitRepaying.circle()
        viewApplyButton.circle()

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
