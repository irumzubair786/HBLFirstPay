//
//  ATMDetailVC.swift
//  First Pay
//
//  Created by Irum Butt on 04/05/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class ATMDetailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var buttonCross: UIButton!
    @IBAction func buttonCross(_ sender: UIButton) {
        self.dismiss(animated: true)
        
    }
    

    

}

extension ATMDetailVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
}
