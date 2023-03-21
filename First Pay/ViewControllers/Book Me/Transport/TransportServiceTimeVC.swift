//
//  TransportServiceTimeVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 28/04/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class TransportServiceTimeVC: BaseClassVC , UITableViewDelegate , UITableViewDataSource {
    
    
    
   
    @IBOutlet var seatsInfoTableView: UITableView!
    var timeObj : GetTimeModel?
    var selectedTransportId : String?
    var selectedDepartureId : String?
    var selectedDestinationId : String?
    var selectedTime : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.getTransportServiceTime()
    }
    
// // MARK: - Utility Methods
//
//    private func updateUI(){
//
//        let aMovieInfo = self.movieShowInfoObj?.movieShows![0]
//
//        if let url = URL(string: (aMovieInfo?.thumbnail)!){
//            Nuke.loadImage(with: url, into: self.imgMovieThumbnail)
//        }
//        //let url = URL(string: (aMovieInfo?.thumbnail)!)
//
//        if let ranking = aMovieInfo?.ranking{
//            self.lblRanking.text = ranking
//        }
//        if let duration = aMovieInfo?.length{
//            self.lblDuration.text = duration
//        }
//        if let director = aMovieInfo?.director{
//            self.lblDirector.text = director
//        }
//        if let cast = aMovieInfo?.cast{
//            self.lblStars.text = cast
//        }
//        if let synopsis = aMovieInfo?.synopsis{
//            self.lblSynopsis.text = synopsis
//        }
//        self.moviesShowInfoTableView.reloadData()
//    }
    
    // MARK: - Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = self.timeObj?.data?.count{
            return count
        }
        return 0
        
        //return (self.notificationsObj?.notifications?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "MoviesBookingTableViewCell") as! MoviesBookingTableViewCell
        aCell.selectionStyle = .none
        
        let aSeat = self.timeObj?.data?[indexPath.row]
        
        aCell.lblCinemaName.text = aSeat?.time
        aCell.lblCityName.text = "Total Seats : \(aSeat?.seats ?? "0.00")"
        aCell.lblShowDate.text = "Available Seats : \(aSeat?.available_seats ?? "0.00")"
        aCell.lblTicketPrice.text = "Rs. \(aSeat?.original_fare ?? "Rs.")"
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let aSeatValue:TimeData = (self.timeObj?.data![indexPath.row])!
        
        let seatsSelectionVC = self.storyboard!.instantiateViewController(withIdentifier: "TransportSeatsSelectionVC") as! TransportSeatsSelectionVC
        seatsSelectionVC.serviceId = aSeatValue.service_id
        seatsSelectionVC.originCityId = aSeatValue.departure_city_id
        seatsSelectionVC.arrivalCityId = aSeatValue.arrival_city_id
        seatsSelectionVC.date = self.selectedTime
        seatsSelectionVC.depTime = aSeatValue.time
        seatsSelectionVC.timeId = aSeatValue.time_id
        seatsSelectionVC.scheduleId = aSeatValue.schedule_id
        seatsSelectionVC.routeId = aSeatValue.route_id
        seatsSelectionVC.seats = aSeatValue.seats

        self.navigationController!.pushViewController(seatsSelectionVC, animated: true)
  
        print("You selected row: %@ \(indexPath)")
        

        DataManager.instance.busServiceId = aSeatValue.service_id
        DataManager.instance.busOriginCityId = aSeatValue.departure_city_id
        DataManager.instance.busArrivalCityId = aSeatValue.arrival_city_id
        DataManager.instance.busDate = self.selectedTime
        DataManager.instance.busDepTime = aSeatValue.time
        DataManager.instance.busTimeId = aSeatValue.time_id
        DataManager.instance.busScheduleId = aSeatValue.schedule_id
        DataManager.instance.busRouteId = aSeatValue.route_id
        DataManager.instance.busTicketPrice = aSeatValue.original_fare
        DataManager.instance.busTicketDiscountedPrice = aSeatValue.fare
        
        
        print("Service ID : \(aSeatValue.service_id))")
        print("Departure ID : \(aSeatValue.departure_city_id))")
        print("Arrival City ID  : \(aSeatValue.arrival_city_id))")
        print("Date : \(self.selectedTime))")
        print("Departure Time : \(aSeatValue.time))")
        print("Time ID : \(aSeatValue.time_id))")
        print("Schedule Type  : \(aSeatValue.schedule_id))")
        print("Route ID  : \(aSeatValue.route_id))")
        print("Seats  : \(aSeatValue.seats))")
        print("Original Fare  : \(aSeatValue.seats))")
        print("Discounted Fare  : \(aSeatValue.seats))")
        
      
    }
    
    
    // MARK: - API Call
    
    func getTransportServiceTime() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "tranServicesTime" + "/\(self.selectedTransportId!)" + "/\(self.selectedDepartureId!)" + "/\(self.selectedDestinationId!)" + "/\(self.selectedTime!)"
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        
        print(header)
        print(compelteUrl)
        
        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<GetTimeModel>) in
            
            self.hideActivityIndicator()
            
            if response.response?.statusCode == 200 {
                
                self.timeObj = response.result.value
                
                if self.timeObj?.responsecode == 2 || self.timeObj?.responsecode == 1 {
                    self.seatsInfoTableView.reloadData()
                }
                else {
                    self.showAlert(title: "", message: (self.timeObj?.messages)!, completion: nil)
                }
            }
            else {
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
}
