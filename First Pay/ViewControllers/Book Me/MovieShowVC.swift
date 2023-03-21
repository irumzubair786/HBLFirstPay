//
//  MovieShowVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 19/03/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import Nuke

class MovieShowVC: BaseClassVC, UITableViewDelegate , UITableViewDataSource {
    
    var movieID : String?
    var movieShowInfoObj : MovieShowInfoModel?
    @IBOutlet weak var imgMovieThumbnail: UIImageView!
    @IBOutlet weak var lblRanking: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblDirector: UILabel!
    @IBOutlet weak var lblStars: UILabel!
    @IBOutlet weak var lblSynopsis: UILabel!
    @IBOutlet var moviesShowInfoTableView: UITableView!

    @IBOutlet weak var lblMainTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeLanguage()
        self.getMovieInfo()

    }
    
    func ChangeLanguage()
    {
        lblMainTitle.text = "Movies".addLocalizableString(languageCode: languageCode)
        lblRanking.text = "Ranking".addLocalizableString(languageCode: languageCode)
        lblDuration.text = "Durations".addLocalizableString(languageCode: languageCode)
        lblDirector.text = "Director".addLocalizableString(languageCode: languageCode)
        lblStars.text = "Stars".addLocalizableString(languageCode: languageCode)
        lblSynopsis.text = "Synopsis".addLocalizableString(languageCode: languageCode)
        
    }
    // MARK: - Utility Methods
    
    private func updateUI(){
        
        let aMovieInfo = self.movieShowInfoObj?.movieShows![0]
        
//        if let url = URL(string: (aMovieInfo?.thumbnail)!){
//            Nuke.loadImage(with: url, into: self.imgMovieThumbnail)
//        }
//        //let url = URL(string: (aMovieInfo?.thumbnail)!)
        
        if let ranking = aMovieInfo?.ranking{
            self.lblRanking.text = "\(ranking) /10"
        }
        if let duration = aMovieInfo?.length{
            self.lblDuration.text = duration
        }
        if let director = aMovieInfo?.director{
            self.lblDirector.text = director
        }
        if let cast = aMovieInfo?.cast{
            self.lblStars.text = cast
        }
        if let synopsis = aMovieInfo?.synopsis{
            self.lblSynopsis.text = synopsis
        }
        self.moviesShowInfoTableView.reloadData()
    }
    
    // MARK: - Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = self.movieShowInfoObj?.movieShows![0].movieShowsDetail?.count{
            return count
        }
        return 0
        
        //return (self.notificationsObj?.notifications?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "MoviesBookingTableViewCell") as! MoviesBookingTableViewCell
        aCell.selectionStyle = .none
        
        let aMovieShow = self.movieShowInfoObj?.movieShows![0].movieShowsDetail![indexPath.row]
        
        aCell.lblCinemaName.text = aMovieShow?.cinemaName
        aCell.lblCityName.text = aMovieShow?.city_name
        aCell.lblShowDate.text = aMovieShow?.showStartTime
        aCell.lblTicketPrice.text = "Rs. \(aMovieShow?.ticketPrice ?? "Rs.")"
      //  aCell.btn_Delete.tag = indexPath.row
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let aValue:SingleShowInfo = (self.movieShowInfoObj?.movieShows![0].movieShowsDetail![indexPath.row])!
        
        let moviesBookingVC = self.storyboard!.instantiateViewController(withIdentifier: "MovieSeatSelectionVC") as! MovieSeatSelectionVC
        moviesBookingVC.showID = aValue.show_id
        
        self.navigationController!.pushViewController(moviesBookingVC, animated: true)
    
        NSLog ("You selected row: %@ \(indexPath)")
        
        DataManager.instance.showID = aValue.show_id
        DataManager.instance.movieID = aValue.showMovieId
        DataManager.instance.handlingCahrges = aValue.handlingCharges
        if let bookingType = self.movieShowInfoObj?.movieShows![0].booking_type{
            DataManager.instance.bookingType = bookingType
        }
//        if let imgThumbnail = self.movieShowInfoObj?.movieShows![0].thumbnail{
//            DataManager.instance.imgURL = imgThumbnail
//        }
        if let movieTitle = self.movieShowInfoObj?.movieShows![0].title{
            DataManager.instance.movieName = movieTitle
        }
        DataManager.instance.cinemaName = aValue.cinemaName
        DataManager.instance.ticketPrice = aValue.ticketPrice
        
        
        
        print("Cinema Name : \(aValue.cinemaName))")
        print("City Name : \(aValue.city_name))")
        print("Show Date  : \(aValue.showDate))")
        print("Show ID : \(DataManager.instance.showID))")
        print("Movie ID : \(DataManager.instance.movieID))")
        print("Handling Charges  : \(DataManager.instance.handlingCahrges))")
        print("Booking Type  : \(DataManager.instance.bookingType))")
        print("Image Url  : \(DataManager.instance.imgURL))")
    
    }
    


    // MARK: - Api Call
    
    private func getMovieInfo() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
            let compelteUrl = GlobalConstants.BASE_URL + "getMovieShows/"+String(self.movieID!)
 
        
        let header = ["Accept":"application/json"]
        
        
        print(header)
        print(compelteUrl)
        
        //NetworkManager.sharedInstance.enableCertificatePinning()
        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<MovieShowInfoModel>) in
            
            self.hideActivityIndicator()
            
            if response.response?.statusCode == 200 {
                self.movieShowInfoObj = response.result.value
                
                if self.movieShowInfoObj?.responsecode == 2 || self.movieShowInfoObj?.responsecode == 1 {
                    self.updateUI()
                }
                else {
                     self.showAlert(title: "", message: (self.movieShowInfoObj?.messages)!, completion: nil)
                }
            }
            else {
                print(response.result.value)
                print(response.response?.statusCode)
            }
        }
    }

}
