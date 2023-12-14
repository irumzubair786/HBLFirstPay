//
//  languageSelectionVC.swift
//  First Pay
//
//  Created by Irum Zubair on 14/12/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import FittedSheets
class languageSelectionVC: BaseClassVC{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
    var id : Int?
    var tag : Int?
//    var Array: [getPrefLangForSmsModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        radioButon1.setTitle("", for: .normal)
       
//        print("fetch data", Array)
//        print("fetch data count", Array.count)
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var radioButon1: UIButton!
    
    @IBAction func radioButon1(_ sender: UIButton) {
    }
    
   
    
    
    
}
protocol BottomSheets {
    static var name: String { get }
    func openPicker(from parent: UIViewController , id : Int , in view: UIView?, tag : Int?)
    
}
extension BottomSheets {
    static func addSheetEventLogging(to sheet: SheetViewController) {
        let previousDidDismiss = sheet.didDismiss
        sheet.didDismiss = {
            print("did dismiss")
            previousDidDismiss?($0)
        }
        
        let previousShouldDismiss = sheet.shouldDismiss
        sheet.shouldDismiss = {
            print("should dismiss")
            return previousShouldDismiss?($0) ?? true
        }
        
        let previousSizeChanged = sheet.sizeChanged
        sheet.sizeChanged = { sheet, size, height in
            print("Changed to \(size) with a height of \(height)")
            previousSizeChanged?(sheet, size, height)
        }
    }
}
