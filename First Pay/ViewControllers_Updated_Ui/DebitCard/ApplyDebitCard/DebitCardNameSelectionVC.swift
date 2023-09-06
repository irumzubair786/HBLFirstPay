//
//  DebitCardNameSelectionVC.swift
//  First Pay
//
//  Created by Irum Butt on 09/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Foundation
class abc{
    var name = ""
    var isSelected = false
}
class DebitCardNameSelectionVC: BaseClassVC {
    var List = [String]()
    var selectedIndex = -1
    var myarray = [String]()
    var fullUserName : String?
    var arrNameList : [String]?
    var nameSelected:[String] = []
    var arry = [abc]()
//    var arrNameList = ["Muhammad", "Arshad", "Khawaj", "Bhatti", "Khan"]
    
    override func viewDidLoad() {
        FBEvents.logEvent(title: .Debit_ordername_landing)
        super.viewDidLoad()
        backView.dropShadow1()
        
       
        print("get userName", fullUserName)
        buttonContinue.isUserInteractionEnabled = false
        imgNextArrow.isUserInteractionEnabled = false
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(Movetoback(tapGestureRecognizer:)))
        blurView.isUserInteractionEnabled = true
        blurView.addGestureRecognizer(tapGestureRecognizerr)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        imgNextArrow.addGestureRecognizer(tapGestureRecognizer)
//        setUpCollectionView()
        self.arrNameList = (fullUserName?.components(separatedBy: " "))!
        self.arrNameList = self.arrNameList?.filter({ $0 != ""})
        
        labelName.text = ""
        labelCount.text = "0/20"
        collectionView.delegate = self
        collectionView.dataSource = self
        
        load()
    }
   
    @IBOutlet weak var backView: UIView!
    func load(){
        for i in arrNameList ?? []{
            var temp = abc()
            temp.isSelected = false
            temp.name = i
            arry.append(temp)
        }
    }
    private func setUpCollectionView() {
        /// 1
        //        // gridCollectionView
        //                .register(UICollectionViewCell.self,
        //                 forCellWithReuseIdentifier: "cell")
        
        /// 2
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// 3
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        /// 4
        layout.minimumLineSpacing = 8
        /// 5
        layout.minimumInteritemSpacing = 4

        /// 6
        collectionView
            .setCollectionViewLayout(layout, animated: true)
    }
   
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var labelName: UILabel!
    var selectedName = ""
    @IBOutlet weak var imgNextArrow: UIImageView!
    @IBOutlet weak var blurView: UIImageView!
    @IBOutlet weak var buttonContinue: UIButton!
    @objc func Movetoback(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer) {
        FBEvents.logEvent(title: .Debit_orderdeliverypostal_click)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DebitCardAddressVC") as!  DebitCardAddressVC
        vc.fullUserName = fullUserName!
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func buttonContinue(_ sender: UIButton) {
        FBEvents.logEvent(title: .Debit_orderdeliverypostal_click)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DebitCardAddressVC") as!  DebitCardAddressVC
        vc.fullUserName = fullUserName!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//
}
extension DebitCardNameSelectionVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: arry[indexPath.item].name.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]).width + 30, height: 35)
       }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arry.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellDebitCardNameSelection", for: indexPath) as! cellDebitCardNameSelection

        cell.labelName.text = arry[indexPath.row].name
        
        cell.backView.borderColor = .clear
        cell.backView.borderWidth = 0
        if arry[indexPath.row].isSelected == false {
            DispatchQueue.main.async {
                cell.backView.backgroundColor = .white
                cell.labelName.textColor = .clrGray
                cell.backView.radiusLineDashedStroke(radius: cell.backView.frame.height / 2, color: .gray)
            }
        }
        else {

            DispatchQueue.main.async {
                cell.backView.backgroundColor = .clrOrange
                cell.backView.circle()
                cell.labelName.textColor = .white
            }
        }
        cell.buttonName.tag = indexPath.row
        cell.buttonName.addTarget(self, action:  #selector(buttonpress(_:)), for: .touchUpInside)
        cell.contentView.borderColor = .clear
        cell.contentView.borderWidth = 0

        return cell
    }
    
    @objc func buttonpress(_ sender:UIButton) {
        collectionView.scrollsToTop = false
        
        // disbtn.backgroundColor = UIColor.red
        let cell = collectionView.cellForItem(at: IndexPath(row: sender.tag, section: 0))
        as! cellDebitCardNameSelection
    
        selectedIndex = sender.tag
        if selectedIndex == sender.tag {
            if cell.backView.backgroundColor == UIColor.white {
                arry[sender.tag].isSelected = true
                let a = UIImage(named: "")
                let val = cell.labelName.text!
                for id in (arry) {
                    if val == id.name {
                        let name = id.name
                        List.append(name)
                    }
                }
                myarray.append(val)
            }
            else if cell.backView.backgroundColor == UIColor(hexValue: 0xF19434) {
                arry[sender.tag].isSelected = false
       
                let v = cell.labelName.text!
                for a in (arry) {
                    if v == a.name {
                        let id = a.name
                        if let index = List.index(of: id) {
                            List.remove(at: index)
                            myarray.remove(at: index)
                        }
                    }
                }
            }
        }
        
        self.labelName.text = ""
        for name in myarray {
            self.labelName.text = "\(self.labelName.text ?? "")\(" ")\(name)"
            GlobalData.debitCardUserFullName = self.labelName.text
        }
        if  labelName.text?.count ?? 0 > 20 {
            if labelName.text?.count != 0 {
                //                   showToast(title: "You can Enter 20 ")
                buttonContinue.isUserInteractionEnabled = false
                imgNextArrow.isUserInteractionEnabled = false
                let image = UIImage(named:"grayArrow")
                imgNextArrow.image = image
                self.collectionView.reloadData()
            }
        }
        else {
            labelCount.text = "\(labelName.text?.count ?? 0)/20"
            buttonContinue.isUserInteractionEnabled = true
            imgNextArrow.isUserInteractionEnabled = true
            let image = UIImage(named:"]greenarrow")
            imgNextArrow.image = image
            self.collectionView.reloadData()
        }
        print(myarray)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellDebitCardNameSelection", for: indexPath) as! cellDebitCardNameSelection
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let deselectedCell = collectionView.cellForItem(at: indexPath) as? cellDebitCardNameSelection
    }
}


class name
{
    var valuename : String
    var isSeleccted : Bool
    init(valuename : String , isSeleccted : Bool ){
        self.valuename = valuename
        self.isSeleccted = isSeleccted
    }
    
}

