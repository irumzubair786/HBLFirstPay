//
//  DiscountHistoryCellVc.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 27/05/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit
import MapKit

class DiscountHistoryCellVc: UITableViewCell ,CLLocationManagerDelegate{

    var locationManager = CLLocationManager()
        var lat = [CLLocationDegrees]()
        var long = [CLLocationDegrees]()
        var coord = [CLLocationCoordinate2D]()
    var coords = CLLocationCoordinate2D(latitude: GlobalData.lat!,longitude: GlobalData.long!)
        var locationmanager : CLLocationManager!
        var marker = MKPointAnnotation()
    override func awakeFromNib() {
        super.awakeFromNib()
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
               let regin = MKCoordinateRegion(center: coords, span: span)
               
               map.setRegion(regin, animated: true)
        user_loc_Draw_pins(lat: GlobalData.lat!, long: GlobalData.long!, name: "", subtitle: "")
    }
    func user_loc_Draw_pins(lat:CLLocationDegrees,long:CLLocationDegrees,name:String , subtitle : String) {
            //        MapView.clear()
           // var bounds = GMSCoordinateBounds()
            
            var annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude:lat, longitude:long)
        var a = String()
           
           
            a.append("")
            a.append(name)
            annotation.title = a
            var name = [String()]
            var vaccine = [String()]
            name.removeAll()
           
//            let aa = "name"
//            let b = "mpv"
//            let c = "03899877"
//            annotation.subtitle = "\(subtitle)" + "\n" + " \(vaccine)" + "\n" + "\(name)" + " \n" + " \(c)"
            //annotation.subtitle = "\(subtitle)" + "\n" + " \(aa)" + "\n" + "\(b)" + " \n" + " \(c)"
            
            map.addAnnotation(annotation)
            
//            let marker = GMSMarker()
//
//            marker.title = name
//            marker.position = CLLocationCoordinate2D(latitude:lat, longitude:long)
//
//                            marker.icon = GMSMarker.markerImage(with: AppDelegate.appcolor)
//
//            marker.map = self.MapView
//            bounds = bounds.includingCoordinate(marker.position)
//            let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
//            MapView.animate(toZoom: 10)
//            MapView.animate(with: update)
//
            
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @IBOutlet weak var imgview: UIImageView!
    @IBOutlet weak var lbldiscountproduct: UILabel!
    @IBOutlet weak var lblemail: UILabel!
    @IBOutlet weak var lblmobilenumber: UILabel!
    @IBOutlet weak var lbldiscountDetails: UILabel!
    @IBOutlet weak var btncity: UIButton!
    @IBOutlet weak var map: MKMapView!
    
}
