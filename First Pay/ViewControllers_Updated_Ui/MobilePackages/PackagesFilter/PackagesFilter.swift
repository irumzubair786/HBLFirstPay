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
    var arraySections = ["TYPE", "VALIDITY", "PRICE"]
    var dictionaryNames = [
        0:["All", "Favourite", "Data", "SMS", "Super Card", "Device", "Social Media", "Upower", "Hybrid"],
        1:["All", "Monthly", "Weekly", "Daily"],
        2:["Height To Low", "Low To Height", ""]]
    
    var dictionarySelectedItems = [
        0:[],
        1:[],
        2:[]
    ] as? [Int: [Int]]
    
    var selectedCell: Int!

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
        return dictionaryNames[section]?.count ?? 0
//        return arrayNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PackagesFilterCell", for: indexPath) as! PackagesFilterCell
        let name = dictionaryNames[indexPath.section]?[indexPath.item] ?? ""
        if name == "" {
            cell.viewBackGround.backgroundColor = .clear
        }
        else {
            cell.viewBackGround.backgroundColor = .clrLightGraySelectionBackGround
        }
        cell.labelName.text = "\(dictionaryNames[indexPath.section]?[indexPath.item] ?? "NA")"
        cell.viewBackGround.backgroundColor = .clrLightGraySelectionBackGround
        cell.labelName.textColor = .clrLightGrayCalendar
        if dictionarySelectedItems != nil {
            if dictionarySelectedItems![indexPath.section]!.count > 0 {
                if (dictionarySelectedItems![indexPath.section]!).contains(indexPath.item) {
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
        let itemName = dictionaryNames[indexPath.section]![indexPath.item]
        
        if (dictionarySelectedItems![indexPath.section]!).contains(indexPath.item) {
            if let indexOf = dictionarySelectedItems![indexPath.section]?.firstIndex(of: indexPath.item) {
                if indexPath.section == 0 || indexPath.section == 1 {
                    if indexPath.item == 0 {
                        dictionarySelectedItems![indexPath.section] = []
                        collectionView.reloadData()
                        return()
                    }
                }
                dictionarySelectedItems![indexPath.section]?.remove(at: indexOf)
            }
        }
        else {
            if indexPath.section == 0 || indexPath.section == 1 {
                if indexPath.item == 0 {
                    dictionarySelectedItems![indexPath.section] = []
                    dictionarySelectedItems![indexPath.section]?.append(indexPath.item)
                    collectionView.reloadData()
                    return()
                }
                if let indexOf = dictionarySelectedItems![indexPath.section]?.firstIndex(of: 0) {
                    dictionarySelectedItems![indexPath.section]?.remove(at: indexOf)
                }
            }
            dictionarySelectedItems![indexPath.section]?.append(indexPath.item)
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
        return CGSize(width: (dictionaryNames[indexPath.section]?[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width ?? 0) + 30, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PackagesFilterSectionView", for: indexPath) as? PackagesFilterSectionView {
            sectionHeader.labelName.text = "\(arraySections[indexPath.section])"
            if indexPath.section == 0 {
                sectionHeader.viewClearFilter.isHidden = false
            }
            else {
                sectionHeader.viewClearFilter.isHidden = true
            }
            return sectionHeader
        }
        return UICollectionReusableView()
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
