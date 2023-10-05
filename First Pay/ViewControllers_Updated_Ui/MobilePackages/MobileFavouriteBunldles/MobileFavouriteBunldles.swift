//
//  MobileFavouriteBunldles.swift
//  First Pay
//
//  Created by Shakeel Ahmed on 05/10/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire

class MobileFavouriteBunldles: UIViewController {

    @IBOutlet weak var collectionViewCategories: UICollectionView!
    @IBOutlet weak var collectionViewFavourites: UICollectionView!
    @IBOutlet weak var buttonBack: UIButton!

   
    var allFavouriteNames: [String]!
    var indexSelectedNetwork = 0

    var tempModelGetFavourites: MobilePackages.ModelGetFavourites!
    private var modelGetFavourites: MobilePackages.ModelGetFavourites? {
        didSet {
            if modelGetFavourites?.responsecode == 1 {
                allFavouriteNames = modelGetFavourites?.data.map({$0.favouriteCategory ?? ""})
                collectionViewCategories.reloadData()
                collectionViewFavourites.reloadData()
            }
            else {

            }
        }
    }
    var arrayNames = ["ios", "Android", "Apple", "Nokia Phone", "One Plus Phone"]

    override func viewDidAppear(_ animated: Bool) {
        collectionViewCategories.reloadData()
        collectionViewFavourites.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MobileFavouriteBunldlesCell.register(collectionView: collectionViewFavourites)
        MobilePackagesDataNameCell.register(collectionView: collectionViewCategories)
        
        if tempModelGetFavourites != nil {
            modelGetFavourites = tempModelGetFavourites
        }
        else {
            getFavourites()
        }
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func getFavourites() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)"
        ]
        APIs.postAPI(apiName: .getFavourites, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            if success {
                
            }
            let model: MobilePackages.ModelGetFavourites? = APIs.decodeDataToObject(data: responseData)
            self.modelGetFavourites = model
        }
    }
   
}

extension MobileFavouriteBunldles: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionViewCategories == collectionView {
            //        return CGSize(width: allFavouriteNames[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width + 50, height: 50)
                    return CGSize(width: arrayNames[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width + 50, height: 50)
        }
        else {
            let width = collectionView.frame.width / 3 - 8
         return CGSize(width: width, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionViewCategories == collectionView {
            return arrayNames.count
            if allFavouriteNames == nil {
                return 0
            }
            return allFavouriteNames.count
        }
        else if collectionViewFavourites == collectionView {
            return arrayNames.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionViewCategories == collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MobilePackagesDataNameCell", for: indexPath) as! MobilePackagesDataNameCell
            cell.labelName.text = arrayNames[indexPath.item]
//            cell.labelName.text = "\(modelGetFavourites?.data[indexSelectedNetwork].favouriteCategory ?? "")"
            return cell
        }
        else  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MobileFavouriteBunldlesCell", for: indexPath) as! MobileFavouriteBunldlesCell
            cell.labelName.text = arrayNames[indexPath.item]
            cell.labelBank.text = arrayNames[indexPath.item]

//            let favouriteDetail =  modelGetFavourites?.data[indexSelectedNetwork].favouriteDetails?[indexPath.item]
//            cell.labelName.text = "\(favouriteDetail?.benificiaryAccountTitle ?? "")"
//            cell.labelBank.text = "\(favouriteDetail?.benificiaryBank ?? "")"
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionViewCategories == collectionView {
            DispatchQueue.main.async {
                (cell as! MobilePackagesDataNameCell).viewBackGround.circle()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectedCell = indexPath.item
        collectionView.reloadData()
    }
}
