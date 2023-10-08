//
//  PackagesFilter.swift
//  HBLFMB
//
//  Created by Apple on 21/06/2023.
//

import UIKit

class PackagesFilter: BaseClassVC {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var buttonApply: UIButton!
    @IBOutlet weak var buttonDismiss: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    
    var arraySections = ["TYPE", "VALIDITY", "PRICE"]
    //    var bundleFilters: [MobilePackages.BundleFilter]!
//        var bundleFilters = [MobilePackages.BundleFilter]()
    
    var modelBundleFilters : [MobilePackages.ModelBundleFilter]! {
        didSet {
            if modelBundleFilters != nil {
                dictionaryNames[0] = modelBundleFilters
            }
        }
    }
    
    var dictionaryNames = [
        0: [MobilePackages.ModelBundleFilter].self,
        1: ["All", "Monthly", "Weekly", "Daily"],
        2: ["Height To Low", "Low To Height", ""]
    ] as [Int : Any]
    
    var dictionaryFilterSelectedItems = [
        0:[],
        1:[],
        2:[]
    ] as? [Int: [Int]]
    
    var selectedCell: Int!
    
    var buttonApplyApplied: (([String], [String], [String], [Int: [Int]]?) -> ())!
    var buttonClearFilterBack: (([Int: [Int]]) -> ())!


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
        viewBackGround.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        PackagesFilterCell.register(collectionView: collectionView)
        
        self.collectionView.register(UINib(nibName: "PackagesFilterSectionView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "PackagesFilterSectionView");

        collectionView.register(UINib(nibName: "PackagesFilterSectionView", bundle: nil), forCellWithReuseIdentifier: "PackagesFilterSectionView")

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonDismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func buttonCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func buttonApply(_ sender: Any) {
        self.dismiss(animated: true)
        
        var searchedDataArray = [String]()
        
        var packageTypeArray = [String]()
        var packageValidityArray = [String]()
        var packagePriceRangeArray = [String]()
        
        for selectedItemIfAny in dictionaryFilterSelectedItems! {
            let selectedItem = selectedItemIfAny.value
            if selectedItem.count > 0 {
                if selectedItemIfAny.key == 0 {
                    let tempModelBundleFilter = dictionaryNames[selectedItemIfAny.key] as! [MobilePackages.ModelBundleFilter]
                    for indexNo in selectedItem {
                        let tempName = tempModelBundleFilter[indexNo].filterName
                        packageTypeArray.append(tempName!)
                    }
                }
                else if selectedItemIfAny.key == 1 {
                    let tempDataArray = dictionaryNames[selectedItemIfAny.key]
                    for indexNo in selectedItem {
                        var tempName = (dictionaryNames[selectedItemIfAny.key] as! [String])[indexNo]

                        if tempName == "Daily" {
                            tempName = "D"
                        }
                        else if tempName == "Weekly" {
                            tempName = "W"
                        }
                        else if tempName == "Monthly" {
                            tempName = "M"
                        }
                        packageValidityArray.append(tempName)
                    }
                }
                else if selectedItemIfAny.key == 2 {
                    let tempDataArray = dictionaryNames[selectedItemIfAny.key]
                    for indexNo in selectedItem {
                        let tempName = (dictionaryNames[selectedItemIfAny.key] as! [String])[indexNo]
                        packagePriceRangeArray.append(tempName)
                    }
                }
            }
            print(selectedItem)
        }
        buttonApplyApplied?(packageTypeArray, packageValidityArray, packagePriceRangeArray, dictionaryFilterSelectedItems)
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

extension PackagesFilter: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return arraySections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return (dictionaryNames[section] as AnyObject).count ?? 0
//        return arrayNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PackagesFilterCell", for: indexPath) as! PackagesFilterCell
        var name = ""
        if indexPath.section == 0 {
            name = (dictionaryNames[indexPath.section] as! [MobilePackages.ModelBundleFilter])[indexPath.item].filterName ?? ""
        }
        else {
            name = (dictionaryNames[indexPath.section] as! [String])[indexPath.item]
        }
        if name == "" {
            cell.viewBackGround.backgroundColor = .clear
        }
        else {
            cell.viewBackGround.backgroundColor = .clrLightGraySelectionBackGround
        }
        cell.labelName.text = name
        cell.viewBackGround.backgroundColor = .clrLightGraySelectionBackGround
        cell.labelName.textColor = .clrLightGrayCalendar
        if dictionaryFilterSelectedItems != nil {
            if dictionaryFilterSelectedItems![indexPath.section]!.count > 0 {
                if (dictionaryFilterSelectedItems![indexPath.section]!).contains(indexPath.item) {
                    cell.viewBackGround.backgroundColor = .clrOrange
                    cell.labelName.textColor = .white
                }
                else {
                    cell.viewBackGround.backgroundColor = .clrLightGraySelectionBackGround
                    cell.labelName.textColor = .clrLightGrayCalendar
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
//            (cell as! MobilePackagesDataNameCell).viewBackGround.circle()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (dictionaryFilterSelectedItems![indexPath.section]!).contains(indexPath.item) {
            if let indexOf = dictionaryFilterSelectedItems![indexPath.section]?.firstIndex(of: indexPath.item) {
                if indexPath.section == 0 || indexPath.section == 1 {
                    if indexPath.item == 0 {
                        dictionaryFilterSelectedItems![indexPath.section] = []
                        collectionView.reloadData()
                        return()
                    }
                }
                dictionaryFilterSelectedItems![indexPath.section]?.remove(at: indexOf)
            }
        }
        else {
            if indexPath.section == 0 || indexPath.section == 1 {
                if indexPath.item == 0 {
                    dictionaryFilterSelectedItems![indexPath.section] = []
                    dictionaryFilterSelectedItems![indexPath.section]?.append(indexPath.item)
                    collectionView.reloadData()
                    return()
                }
                if let indexOf = dictionaryFilterSelectedItems![indexPath.section]?.firstIndex(of: 0) {
                    dictionaryFilterSelectedItems![indexPath.section]?.remove(at: indexOf)
                }
            }
            dictionaryFilterSelectedItems![indexPath.section]?.append(indexPath.item)
        }
        
        collectionView.reloadData()
    }
}

extension PackagesFilter: UICollectionViewDelegateFlowLayout {
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    //
    //       return CGSize(width: collectionView.frame.width, height: 100)
    //     }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var itemName = ""
        if indexPath.section == 0 {
            itemName = (dictionaryNames[indexPath.section] as! [MobilePackages.ModelBundleFilter])[indexPath.section].filterName ?? ""
        }
        else {
            itemName = (dictionaryNames[indexPath.section] as! [String])[indexPath.item]
        }
        
        return CGSize(width: (itemName.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width) + 30, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PackagesFilterSectionView", for: indexPath) as? PackagesFilterSectionView {
            sectionHeader.labelName.text = "\(arraySections[indexPath.section])"
            if indexPath.section == 0 {
                sectionHeader.viewClearFilter.isHidden = false
                sectionHeader.buttonClearFilter.addTarget(self, action: #selector(buttonClearFilter), for: .touchUpInside)
            }
            else {
                sectionHeader.viewClearFilter.isHidden = true
            }
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    @objc func buttonClearFilter() {
        if dictionaryFilterSelectedItems != nil {
            dictionaryFilterSelectedItems?[0] = []
            dictionaryFilterSelectedItems?[1] = []
            dictionaryFilterSelectedItems?[2] = []
            buttonClearFilterBack?(dictionaryFilterSelectedItems!)
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        // Get the view for the first header
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionElementKindSectionHeader, at: indexPath)
        
        // Use this view to calculate the optimal size based on the collection view's width
        return headerView.systemLayoutSizeFitting(
            CGSize(width: collectionView.frame.width,
                   height: UILayoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required, // Width is fixed
            verticalFittingPriority: .fittingSizeLevel) // Height can be as large as needed
        
    }
    
}
final class CollectionViewContentSized: UICollectionView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIViewNoIntrinsicMetric, height: contentSize.height)
    }
}
