//
//  ATMLocatormainVc.swift
//  First Pay
//
//  Created by Irum Butt on 04/05/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import GoogleMaps
//import GooglePlaces

class ATMLocatormainVc: UIViewController {
    @IBOutlet weak var viewForMap: GMSMapView!
    @IBOutlet weak var viewDetail: UIView!
    @IBOutlet weak var buttonDetail: UIButton!
    @IBOutlet weak var buttonATM: UIButton!
    @IBAction func buttonATM(_ sender: UIButton) {
        viewForMap.clear()
        branchFlag = false
        cashFlag = false
        atmFlag = true
        buttonATM.backgroundColor = UIColor(hexValue: 0xF1943)
        buttonATM.setTitleColor(UIColor.white, for: .normal)
        buttonATM.borderColor = UIColor.clear
        buttonBranch.backgroundColor = UIColor.clear
        buttonBranch.borderColor = UIColor.gray
        buttonBranch.setTitleColor(UIColor.black, for: .normal)
        buttonCash.backgroundColor = UIColor.clear
        buttonCash.borderColor = UIColor.gray
        buttonCash.setTitleColor(UIColor.black, for: .normal)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        viewDetail.isUserInteractionEnabled = true
        viewDetail.addGestureRecognizer(tapGestureRecognizer)
        buttonDetail.isUserInteractionEnabled = true
        buttonDetail.backgroundColor = UIColor.clear
        if modelATMLocation?.data.atmLocation.count ?? 0 > 0 {
            let atmLocations = modelATMLocation?.data.atmLocation
            viewForMap.camera = GMSCameraPosition.camera(withLatitude: (atmLocations?.first?.latitude)!, longitude: (atmLocations?.first?.longitude)!, zoom: 12.0)
            for item in atmLocations! {
                let coordinate2D = CLLocationCoordinate2D(latitude: item.latitude,longitude: item.longitude)
                let markerColor = "markerAtm"
                let marker = drawMarker(labelText: item.branchName, imageName: markerColor, coordinate2D: coordinate2D)
                marker.map = self.viewForMap
            }
        }
    }
    
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)    {
        if branchFlag == true{
            let vc = UIStoryboard.init(name: "ATMLocator", bundle: nil).instantiateViewController(withIdentifier: "test") as! test
            DispatchQueue.main.async {
                self.present(vc, animated: true)
            }
//            ATMBranchDetailViewController
        }
        else if cashFlag == true{
            let vc =  UIStoryboard.init(name: "ATMLocator", bundle: nil).instantiateViewController(withIdentifier: "CashDetailVC") as! CashDetailVC
            DispatchQueue.main.async {
                self.present(vc, animated: true)
            }
        }
        else
        {
            let vc =  UIStoryboard.init(name: "ATMLocator", bundle: nil).instantiateViewController(withIdentifier: "ATMDetailVC") as! ATMDetailVC
            DispatchQueue.main.async {
                self.present(vc, animated: true)
            }
        }
    }
    @IBOutlet weak var buttonCash: UIButton!
    @IBAction func buttonCash(_ sender: UIButton) {
        viewForMap.clear()

        branchFlag = false
        cashFlag = true
        atmFlag = false
        
        buttonCash.backgroundColor = UIColor(hexValue: 0xF19434)
        buttonCash.setTitleColor(.white, for: .normal)
        buttonCash.borderColor = UIColor.clear
        
        buttonBranch.backgroundColor = UIColor.clear
        buttonBranch.borderColor = UIColor.gray
        buttonBranch.setTitleColor(UIColor.black, for: .normal)
        
        buttonATM.backgroundColor = UIColor.clear
        buttonATM.borderColor = UIColor.gray
        buttonATM.setTitleColor(UIColor.black, for: .normal)
        buttonDetail.isUserInteractionEnabled = true
        
        if modelATMLocation?.data.branchLocation.count ?? 0 > 0 {
            let atmLocations = modelATMLocation?.data.branchLocation
            viewForMap.camera = GMSCameraPosition.camera(withLatitude: (atmLocations?.first?.latitude)!, longitude: (atmLocations?.first?.longitude)!, zoom: 12.0)
            for item in atmLocations! {
                let coordinate2D = CLLocationCoordinate2D(latitude: item.latitude,longitude: item.longitude)
                let markerColor = "markerCashPoints"
                let marker = drawMarker(labelText: item.branchName, imageName: markerColor, coordinate2D: coordinate2D)
                marker.map = self.viewForMap
            }
        }
    }
    @IBOutlet weak var buttonBranch: UIButton!
    @IBAction func buttonBranch(_ sender: UIButton) {
        viewForMap.clear()

        branchFlag = true
        cashFlag = false
        atmFlag = false
        buttonBranch.backgroundColor = UIColor(hexValue: 0x00CC96)
        buttonBranch.setTitleColor(.white, for: .normal)
        buttonBranch.borderColor = UIColor.clear
        
        buttonCash.backgroundColor = UIColor.clear
        buttonCash.borderColor = UIColor.gray
        buttonCash.setTitleColor(UIColor.black, for: .normal)
        
        buttonATM.backgroundColor = UIColor.clear
        buttonATM.borderColor = UIColor.gray
        buttonATM.setTitleColor(UIColor.black, for: .normal)
        buttonDetail.isUserInteractionEnabled = true
        if modelATMLocation?.data.branchLocation.count ?? 0 > 0 {
            let atmLocations = modelATMLocation?.data.branchLocation
            viewForMap.camera = GMSCameraPosition.camera(withLatitude: (atmLocations?.first?.latitude)!, longitude: (atmLocations?.first?.longitude)!, zoom: 12.0)
            for item in atmLocations! {
                let coordinate2D = CLLocationCoordinate2D(latitude: item.latitude,longitude: item.longitude)
                let markerColor = "markerBranch"
                let marker = drawMarker(labelText: item.branchName, imageName: markerColor, coordinate2D: coordinate2D)
                marker.map = self.viewForMap
            }
        }
    }
    @IBAction func buttonDetail(_ sender: UIButton) {
        if branchFlag == true{
            let vc = UIStoryboard.init(name: "ATMLocator", bundle: nil).instantiateViewController(withIdentifier: "test") as! test
            DispatchQueue.main.async {
                self.present(vc, animated: true)
            }
//            ATMBranchDetailViewController
        }
        
        else if cashFlag == true{
            let vc =  UIStoryboard.init(name: "ATMLocator", bundle: nil).instantiateViewController(withIdentifier: "CashDetailVC") as! CashDetailVC
            DispatchQueue.main.async {
                self.present(vc, animated: true)
            }
        }
        else
        {
            let vc =  UIStoryboard.init(name: "ATMLocator", bundle: nil).instantiateViewController(withIdentifier: "ATMDetailVC") as! ATMDetailVC
            DispatchQueue.main.async {
                self.present(vc, animated: true)
            }
        }
    }

    var branchFlag : Bool = false
    var cashFlag :Bool = false
    var atmFlag : Bool = false
    var modelATMLocation: ModelATMLocation? {
        didSet {
            viewForMap.clear()
            print(modelATMLocation)
            dump(modelATMLocation)
            viewForMap.clear()
            branchFlag = true
            cashFlag = false
            atmFlag = false
            buttonBranch.backgroundColor = UIColor(hexValue: 0x00CC96)
            buttonBranch.setTitleColor(.white, for: .normal)
            buttonBranch.borderColor = UIColor.clear
            buttonCash.backgroundColor = UIColor.clear
            buttonCash.borderColor = UIColor.gray
            buttonCash.setTitleColor(UIColor.black, for: .normal)
            buttonATM.backgroundColor = UIColor.clear
            buttonATM.borderColor = UIColor.gray
            buttonATM.setTitleColor(UIColor.black, for: .normal)
            buttonDetail.isUserInteractionEnabled = true
            if modelATMLocation?.data.branchLocation.count ?? 0 > 0 {
                let atmLocations = modelATMLocation?.data.branchLocation
                viewForMap.camera = GMSCameraPosition.camera(withLatitude: (atmLocations?.first?.latitude)!, longitude: (atmLocations?.first?.longitude)!, zoom: 12.0)
                for item in atmLocations! {
                    let coordinate2D = CLLocationCoordinate2D(latitude: item.latitude,longitude: item.longitude)
                    let markerColor = "markerBranch"
                    let marker = drawMarker(labelText: item.branchName, imageName: markerColor, coordinate2D: coordinate2D)
                    marker.map = self.viewForMap
                }
            }
        
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //Rawalpindi Latitude Longitude
        viewForMap.camera = GMSCameraPosition.camera(withLatitude: 33.5651, longitude: 73.0169, zoom: 12.0)
        buttonDetail.setTitle("", for: .normal)
        buttonDetail.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
//        viewForMap.camera = GMSCameraPosition.camera(withLatitude: 18.514043, longitude: 57.377796, zoom: 6.0)
        

//        for i in 1...3 {
//            print(i)
//            var coordinate2D = CLLocationCoordinate2D(latitude: 17.411647,longitude: 78.435637)
//            var markerColor = "markerGreen"
//            if i == 1 {
//                coordinate2D = CLLocationCoordinate2D(latitude: 30.3753,longitude: 69.3451)
//                markerColor = "markerOrange"
//            }
//            if i == 2 {
//                coordinate2D = CLLocationCoordinate2D(latitude: 56.1304,longitude: 106.3468)
//                markerColor = "markerGreen"
//
//            }
//            if i == 3 {
//                coordinate2D = CLLocationCoordinate2D(latitude: 18.514043,longitude: 57.377796)
//                markerColor = "markerBlack"
//            }
//            let marker = drawMarker(labelText: "marker\(i)", imageName: markerColor, coordinate2D: coordinate2D)
//            marker.map = self.viewForMap
//
//            self.viewForMap.delegate = self;
//        }
        
        getAtmBranchLocation()
       
    }
    
    
    
    func getAtmBranchLocation() {
        APIs.getAPI(apiName: .getAtmBranchLocation, parameters: nil) { responseData, success, errorMsg in
            
            print(responseData)
            print(success)
            print(errorMsg)
            let model: ModelATMLocation? = APIs.decodeDataToObject(data: responseData)
            self.modelATMLocation = model
        }
    }
}



func drawMarker(labelText: String, imageName: String, coordinate2D: CLLocationCoordinate2D) -> GMSMarker {
    let marker = GMSMarker()
    marker.position = coordinate2D
    marker.title = labelText
//    marker.appearAnimation = GMSMarkerAnimation;

//    marker.snippet = "Australia"
    marker.icon = UIImage(named: imageName) // Marker icon

    return marker
}

extension ATMLocatormainVc: GMSMapViewDelegate {
    
}

extension ATMLocatormainVc {
    // MARK: - ModelinvitedFriendsList
    struct ModelATMLocation: Codable {
        let responsecode: Int
        let data: DataClass
        let responseblock: JSONNull?
        let messages: String
    }

    // MARK: - DataClass
    struct DataClass: Codable {
        let atmLocation, branchLocation: [Location]
    }

    // MARK: - Location
    struct Location: Codable {
        let branchName, branchAddress: String
        let latitude, longitude: Double
        let branchCode, branchContactNo: String
    }

    // MARK: - Encode/decode helpers

    class JSONNull: Codable, Hashable {

        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
        }

        public var hashValue: Int {
            return 0
        }

        public init() {}

        public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }

}
