//
//  MoviesListVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 19/03/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import Nuke

class MoviesListVC: BaseClassVC, UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet var moviesTableView: UITableView!
    var movieListObj : MoviesListModel?

    @IBOutlet weak var lblMainTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getMoviesList()
        lblMainTitle.text = "Movies".addLocalizableString(languageCode: languageCode)
    }
    
    // MARK: - Table View Methods
      
      func numberOfSections(in tableView: UITableView) -> Int {
          return 1
      }
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          
          if let count = self.movieListObj?.movies?.count {
              return count
          }
          
          return 0
          
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          
          let aCell = tableView.dequeueReusableCell(withIdentifier: "MoviesListTableViewCell") as! MoviesListTableViewCell
          aCell.selectionStyle = .none
          
          let aMovie = self.movieListObj?.movies![indexPath.row]
          
          aCell.lblMovieTitle.text = aMovie?.title
          aCell.lblMovieGenre.text = aMovie?.genre
          aCell.lblLength.text = "\((aMovie?.length) ?? "") min"
    
          let fileUrl = URL(string: aMovie!.thumbnail ?? "")
        
        let fileUrl2 = URL(fileURLWithPath: aMovie!.thumbnail ?? "")

        let url = URL(string: (aMovie?.thumbnail ?? "")!)
        
        print(fileUrl)
        print(fileUrl2)
        print(url)
        
          if let imgUrl = url{
              Nuke.loadImage(with: imgUrl, into: aCell.imgMovieThumbnail)
          }
        else
          {
            aCell.imgMovieThumbnail.image = UIImage(named: "FaceIDTouchID")
        }
          
          return aCell
      }
      
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
          
          let aMovie:SingleMovie = (self.movieListObj?.movies![indexPath.row])!
          
          NSLog ("You selected row: %@ \(indexPath)")
          
          let movieShowVC = self.storyboard!.instantiateViewController(withIdentifier: "MovieShowVC") as! MovieShowVC
          movieShowVC.movieID = aMovie.movie_id
          self.navigationController!.pushViewController(movieShowVC, animated: true)
          
          
          print("Title : \(aMovie.title))")
          print("Genre : \(aMovie.genre))")
          print("Thumbnail : \(aMovie.thumbnail))")
          print("Movie ID : \(aMovie.movie_id))")
          print("IMDB ID : \(aMovie.imdb_id))")
          print("Lang : \(aMovie.language))")
          print("Director : \(aMovie.director))")
          print("Producer : \(aMovie.producer))")
          print("Rel Date : \(aMovie.release_date))")
          print("Cast : \(aMovie.cast))")
          print("Rank : \(aMovie.ranking))")
          print("Length : \(aMovie.length))")

      }
      
      
      
      // MARK: - API Call
      
      private func getMoviesList() {
          
          if !NetworkConnectivity.isConnectedToInternet(){
              self.showToast(title: "No Internet Available")
              return
          }
          
          showActivityIndicator()
          
        let compelteUrl = GlobalConstants.BASE_URL + "getMovies"
          
         let header = ["Content-Type":"application/json"]
          
          
          print(header)
          print(compelteUrl)
          
          //NetworkManager.sharedInstance.enableCertificatePinning()
          Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<MoviesListModel>) in
              
              self.hideActivityIndicator()
              
              if response.response?.statusCode == 200 {
                  self.movieListObj = response.result.value
                  if self.movieListObj?.responsecode == 2 || self.movieListObj?.responsecode == 1 {
                 
                      self.moviesTableView.reloadData()
                  }
              
                  else {
                    UtilManager.showAlertMessage(message: "No Data Found", viewController: self)
//                    self.showAlert(title: "No Data Found", message: "", completion: nil)
//                    self.navigationController?.popViewController(animated: true)
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookMeVC") as! BookMeVC
//                                                self.navigationController?.pushViewController(vc, animated: true)

//                    if let message = self.movieListObj?.message{
//
//                    if message == "no data found"
//                    {
//                        self.showToast(title: "No Data Found")
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6)  {
//                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookMeVC") as! BookMeVC
//                            self.navigationController?.pushViewController(vc, animated: true)
//                        }
//                    }
//                    }
//
                  }
              }
              else {
//                  print(response.result.value)
//                  print(response.response?.statusCode)
              }
          }
      }

}
