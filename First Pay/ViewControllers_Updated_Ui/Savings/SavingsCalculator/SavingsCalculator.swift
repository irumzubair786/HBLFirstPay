//
//  SavingsCalculator.swift
//  First Pay
//
//  Created by Shakeel Ahmed on 20/11/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class SavingsCalculator: UIViewController {
    @IBOutlet weak var viewBackGroundButtonStartEarning: UIView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var viewBackGroundButtonCalculator: UIView!
    @IBOutlet weak var buttonStartEarning: UIButton!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var buttonThreeDot: UIButton!
    @IBOutlet weak var textFieldAmount: UITextField!
    @IBOutlet weak var buttonCalculator: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewBackGroundEnterAmount: UIView!
    @IBOutlet weak var viewBackGroundHowMuch: UIView!
    var arrayAmount = ["Rs. 10,000", "Rs. 25,000", "Rs. 50,000", "Rs. 100,000"]
    
//    var myarr = [SavingCalculatorAmount]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        SavingsCalculatorAmountCell.register(collectionView: collectionView)
        viewBackGroundButtonCalculator.circle()
        viewBackGroundButtonStartEarning.circle()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        viewBackGroundHowMuch.radius(radius: 20)
        viewBackGroundEnterAmount.radius(radius: 20, color: .clrGreen, borderWidth: 1)
    }
    @IBAction func buttonCalculator(_ sender: Any) {
    }
    @IBAction func buttonBack(_ sender: Any) {
    }
    @IBAction func buttonThreeDot(_ sender: Any) {
    }
    @IBAction func buttonStartEarning(_ sender: Any) {
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


extension SavingsCalculator: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: arrayAmount[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width + 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayAmount.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavingsCalculatorAmountCell", for: indexPath) as! SavingsCalculatorAmountCell
        
         
//        if(myarr[indexPath.row].isSeleccted == true) {
//            cell.btnAmount.setTitleColor(.white, for: .normal)
//            cell.btnAmount.backgroundColor = UIColor(red: 241/255, green: 147/255, blue: 52/255, alpha: 1)
//            cell.btnAmount.borderColor = UIColor(red: 241/255, green: 147/255, blue: 52/255, alpha: 1)
//        }
//        else
//        {
            cell.btnAmount.setTitleColor(.black, for: .normal)
            cell.btnAmount.backgroundColor = .clear
//        }
        
//        cell.btnAmount.tag = indexPath.row
        cell.btnAmount.setTitle(arrayAmount[indexPath.row], for: .normal)
//        cell.btnAmount.addTarget(self, action: #selector(buttontaped), for: .touchUpInside)
  
        cell.btnAmount.circle()
        cell.btnAmount.borderWidth = 1
        cell.btnAmount.borderColor = .clrLightGray
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectedCell = indexPath.item
        collectionView.reloadData()
    }
}
class SavingCalculatorAmount
{
    var valueamount : String
    var isSeleccted : Bool
    init(valueamount : String , isSeleccted : Bool ){
        self.valueamount = valueamount
        self.isSeleccted = isSeleccted
    }
    
}
