//
//  MovieSeatSelectionVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 18/04/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class MovieSeatSelectionVC: BaseClassVC, UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    
    var showID : String?
    var movieSeatBookingObj : MoviesSeatModel?
    var genericResObj : GenericResponse?
    var filteredRowsAndColumns = [Seats]()
    @IBOutlet var moviesCollectionView : UICollectionView!
    
    var seatsSelected = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getMovieSeats()
        self.moviesCollectionView.allowsMultipleSelection = true
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - CollectionView Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Columns
        return (self.movieSeatBookingObj?.data?.movieShowHallSeatPlans![section].movieShowHallSeatsDetail?.count)!
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        // Rows
        if let count = self.movieSeatBookingObj?.data?.movieShowHallSeatPlans?.count{
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeatBookingPlanCollectionViewCell", for: indexPath) as! SeatBookingPlanCollectionViewCell
        
        let aSeat = self.movieSeatBookingObj?.data?.movieShowHallSeatPlans![indexPath.section]
        
        aCell.title.text = aSeat?.movieShowHallSeatsDetail![indexPath.row].seatId
        
        
        return aCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        NSLog ("You selected row: %@ \(indexPath)")
        
        if let aCell = collectionView.cellForItem(at: indexPath) as? SeatBookingPlanCollectionViewCell{
            //   aCell.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            aCell.imageView.image = #imageLiteral(resourceName: "seatSelected")
        }
        
        let aSeatPlan = self.movieSeatBookingObj?.data?.movieShowHallSeatPlans![indexPath.section]
        
        let aSeat:Seats = (aSeatPlan?.movieShowHallSeatsDetail![indexPath.row])!
        
        
        print("Seat ID : \(aSeat.seatId))")
        print("Seat Row Name : \(aSeat.seatRowName))")
        print("Seat Number : \(aSeat.seatNumber))")
        print("Seat Type : \(aSeat.seatType))")
        print("Status : \(aSeat.status))")
        
        self.seatsSelected.append(aSeat.seatId!)
        print(self.seatsSelected)
        
        //        movieConfirmObj.seatsSelectedObj = self.seatsSelected
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        NSLog ("You selected row: %@ \(indexPath)")
        
        if let aCell = collectionView.cellForItem(at: indexPath) as? SeatBookingPlanCollectionViewCell{
            //      aCell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            aCell.imageView.image = #imageLiteral(resourceName: "seatAvailable")
        }
        
        let aSeatPlan = self.movieSeatBookingObj?.data?.movieShowHallSeatPlans![indexPath.section]
        
        let aSeat:Seats = (aSeatPlan?.movieShowHallSeatsDetail![indexPath.row])!
        
        
        print("DeSelect Seat ID : \(aSeat.seatId))")
        print("DeSelect Seat Row Name : \(aSeat.seatRowName))")
        print("DeSelect Seat Number : \(aSeat.seatNumber))")
        print("DeSelect Seat Type : \(aSeat.seatType))")
        print("DeSelect Status : \(aSeat.status))")
        
        //     self.seatsSelected.removeAll(where: { $0 == aSeat.seat_id })
        print(self.seatsSelected)
        
        //  self.seatsSelected.remove(at: indexPath)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderCollectionReusableView", for: indexPath) as? SectionHeaderCollectionReusableView{
            sectionHeader.lblRowHeader.text = "Row \(self.movieSeatBookingObj?.data?.movieShowHallSeatPlans![indexPath.section].row! ?? "Row")"
            //  sectionHeader.sectionHeaderlabel.text = "Section \(indexPath.section)"
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    // MARK: - Action Methods
    
    @IBAction func btnProceedToPayPressed(_ sender: Any) {
        
        if self.seatsSelected.isEmpty{
            self.showToast(title: "Please select at least 1 seat")
            return
        }
        self.getOTPForBookMe()
        
    }
    
    // MARK: - Api Call
    
    private func getMovieSeats() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "getMovieShowPlans/" + String(self.showID!)
        
        let header = ["Accept":"application/json"]
        
        print(header)
        print(compelteUrl)
        
        //NetworkManager.sharedInstance.enableCertificatePinning()
        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<MoviesSeatModel>) in
            
            self.hideActivityIndicator()
            
            if response.response?.statusCode == 200 {
                self.movieSeatBookingObj = response.result.value
                if self.movieSeatBookingObj?.responsecode == 2 || self.movieSeatBookingObj?.responsecode == 1 {
                    
                    self.moviesCollectionView.reloadData()
                }
                else {
                    // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                }
            }
            else {
                print(response.result.value)
                print(response.response?.statusCode)
            }
        }
    }
    
    private func getOTPForBookMe() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        var userCnic : String?
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "sendOtpForBookMe"
        
        
        let parameters = ["imei":DataManager.instance.imei!,"cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)"]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        print(header)
        
        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            self.hideActivityIndicator()
            
            self.genericResObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.genericResObj?.responsecode == 2 || self.genericResObj?.responsecode == 1 {
                 
                    let moviesTicketConfirmVC = self.storyboard!.instantiateViewController(withIdentifier: "MovieTicketConfirmationVC") as! MovieTicketConfirmationVC
                    moviesTicketConfirmVC.seatsConfirmSelected = self.seatsSelected
                    self.navigationController!.pushViewController(moviesTicketConfirmVC, animated: true)
                }
                else {
                    if let message = self.genericResObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.genericResObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
                print(response.result.value)
                print(response.response?.statusCode)
            }
        }
    }
    
    
    
}




