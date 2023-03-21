//
//  TransportListVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 28/04/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class TransportListVC: BaseClassVC ,UITextFieldDelegate {
    
    
    var transportServiceObj : GetTransportServiceModel?
    @IBOutlet var dropDownTransportServices: UIDropDown!
    var selectedTransport: String?
    var selectedTransportId : String?
    var servicesList = [SingleTransportData]()
    var arrServicesList : [String]?
    
    var departureObj : GetDeparturesModel?
    @IBOutlet var dropDownDepartures: UIDropDown!
    var selectedDeparture: String?
    var selectedDepartureId : String?
    var departureList = [DepartureData]()
    var arrDepartureList : [String]?
    var stringDepartureList = [String]()
    
    @IBOutlet weak var lblDeparturdate: UILabel!
    
    @IBOutlet weak var btnnext: UIButton!
    @IBOutlet weak var lblmainTitle: UILabel!
    var destinationObj : GetDestinationModel?
    @IBOutlet var dropDownDestinations: UIDropDown!
    var selectedDestination: String?
    var selectedDestinationId : String?
    var destinationList = [DestinationData]()
    var arrDestinationList : [String]?
    var stringDestinationList = [String]()
    
    var selectedTime: String?
    @IBOutlet weak var datePickerTextField: UITextField!
    @IBOutlet weak var lblDepartureDate: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Changelanguages()
        self.getTransportList()
        self.hideTextFields()
        
        // Do any additional setup after loading the view.
    }
    //MARK: - Utility Method
    
    func Changelanguages()
    {
        lblmainTitle.text = "Bus Tickets".addLocalizableString(languageCode: languageCode)
        lblDeparturdate.text = "Departure Date".addLocalizableString(languageCode: languageCode)
        datePickerTextField.placeholder = "Select Date".addLocalizableString(languageCode: languageCode)
        btnnext.setTitle("NEXT".addLocalizableString(languageCode: languageCode), for: .normal)
    }
    func hideTextFields(){
        
        self.dropDownDepartures.isHidden = true
        self.dropDownDestinations.isHidden = true
        self.lblDepartureDate.isHidden = true
        self.datePickerTextField.isHidden = true
        
    }
    
    //MARK: - DatePicker
    
    @IBAction func textFieldFromEditing(sender: UITextField) {
        
        var sevenDaysfromNow: Date {
            return (Calendar.current as NSCalendar).date(byAdding: .day, value: 5, to: Date(), options: [])!
        }
        let datePickerObj: UIDatePicker = UIDatePicker()
        datePickerObj.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerObj
        datePickerObj.minimumDate = datePickerObj.date
        datePickerObj.maximumDate = sevenDaysfromNow
        datePickerObj.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDate = dateFormatter.string(from: datePickerObj.date)
        self.datePickerTextField.text = newDate
        if #available(ios 13.4, *)
        {
            if #available(iOS 13.4, *) {
                datePickerObj.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.datePickerTextField.text = dateFormatter.string(from: sender.date)
        
        
    }
    
    
    
    //MARK: - DropDown
    
    private func methodDropDownTransportServices(Services:[String]) {
        
        self.dropDownTransportServices.placeholder = "Select Bus Service"
        self.dropDownTransportServices.textColor = #colorLiteral(red: 0.262745098, green: 0.262745098, blue: 0.262745098, alpha: 1)
        self.dropDownTransportServices.options = Services
        self.dropDownTransportServices.tableHeight = 200.0
        self.dropDownTransportServices.didSelect(completion: {
            (option , index) in
            print("You Just select: \(option) at index: \(index)")
            self.selectedTransport = option
            
            let title = self.selectedTransport
            DataManager.instance.busServiceName = title
            for aService in self.servicesList {
                if aService.serviceName == title {
                    print(aService.serviceId)
                    self.selectedTransportId = aService.serviceId
                    self.getDepartures(serviceId: aService.serviceId!)
                    
                }
            }
        })
    }
    
    private func methodDropDownDepartures(Departures:[String]) {
        
        self.dropDownDepartures.placeholder = "From"
        self.dropDownDepartures.textColor = #colorLiteral(red: 0.262745098, green: 0.262745098, blue: 0.262745098, alpha: 1)
        self.dropDownDepartures.options = Departures
        self.dropDownDepartures.tableHeight = 150.0
        self.dropDownDepartures.didSelect(completion: {
            (option , index) in
            print("You Just select: \(option) at index: \(index)")
            self.selectedDeparture = option
            
            let title = self.selectedDeparture
            DataManager.instance.busFromCity = title
            for aDeparture in self.departureList {
                if aDeparture.originCityName == title {
                    print(aDeparture.originCityId)
                    self.selectedDepartureId = aDeparture.originCityId
                    self.getDestination(departureCityID: aDeparture.originCityId!)
                    
                }
            }
        })
    }
    
    private func methodDropDownDestinations(Destinations:[String]) {
        
        self.dropDownDestinations.placeholder = "To"
        self.dropDownDestinations.textColor = #colorLiteral(red: 0.262745098, green: 0.262745098, blue: 0.262745098, alpha: 1)
        self.dropDownDestinations.options = Destinations
        self.dropDownDestinations.tableHeight = 150.0
        self.dropDownDestinations.didSelect(completion: {
            (option , index) in
            print("You Just select: \(option) at index: \(index)")
            self.selectedDestination = option
            
            let title = self.selectedDestination
            DataManager.instance.busToCity = title
            for aDestination in self.destinationList {
                if aDestination.destinationCityName == title {
                    print(aDestination.destinationCityId)
                    self.selectedDestinationId = aDestination.destinationCityId
                    self.lblDepartureDate.isHidden = false
                    self.datePickerTextField.isHidden = false
                }
            }
        })
    }
    
    
    
    // MARK: - Action Methods
    
    @IBAction func btnSubmitPressed(_ sender: Any) {
        
        self.selectedTime =  self.datePickerTextField.text
        
        if self.selectedTransportId == nil {
            self.showToast(title: "Please Select Bus Service")
            return
        }
        if self.selectedDepartureId == nil {
            self.showToast(title: "Please Select From")
            return
        }
        if self.selectedDestinationId == nil {
            self.showToast(title: "Please Select To")
            return
        }
        if self.selectedTime == nil{
            self.showToast(title: "Please Select Date")
            return
        }
        
        
        let tranSerVC = self.storyboard!.instantiateViewController(withIdentifier: "TransportServiceTimeVC") as! TransportServiceTimeVC
        tranSerVC.selectedTransportId = self.selectedTransportId
        tranSerVC.selectedDepartureId = self.selectedDepartureId
        tranSerVC.selectedDestinationId = self.selectedDestinationId
        tranSerVC.selectedTime = self.selectedTime
        self.navigationController!.pushViewController(tranSerVC, animated: true)
        
        
        
    }
    
    
    
    // MARK: - API Call
    
    func getTransportList() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "transportServices"
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        
        print(header)
        print(compelteUrl)
        
        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<GetTransportServiceModel>) in
            
            self.hideActivityIndicator()
            
            if response.response?.statusCode == 200 {
                
                self.transportServiceObj = response.result.value
                if self.transportServiceObj?.responsecode == 2 || self.transportServiceObj?.responsecode == 1 {
                    
                    if let services = self.transportServiceObj?.data {
                        self.servicesList = services
                    }
                    self.arrServicesList = self.transportServiceObj?.stringServicesList
                    self.methodDropDownTransportServices(Services: (self.arrServicesList)!)
                    
                }
                else {
                    if let message = self.transportServiceObj?.messages{
                        self.showAlert(title: "", message: message, completion: nil)
                    }
                    
                }
            }
            else {
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    func getDepartures(serviceId: String) {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "departure/"+String(serviceId)
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        
        print(header)
        print(compelteUrl)
        
        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<GetDeparturesModel>) in
            
            self.hideActivityIndicator()
            
            if response.response?.statusCode == 200 {
                
                self.departureObj = response.result.value
                if self.departureObj?.responsecode == 2 || self.departureObj?.responsecode == 1 {
                    
                    self.stringDepartureList.removeAll()
                    self.dropDownDepartures.isHidden = false
                    for aDeparture in self.departureObj!.data! {
                        self.stringDepartureList.append(aDeparture.originCityName!)
                    }
                    if let departures = self.departureObj?.data {
                        self.departureList = departures
                    }
                    self.arrDepartureList = self.stringDepartureList
                    self.methodDropDownDepartures(Departures: self.arrDepartureList!)
                    
                }
                else {
                    // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                }
            }
            else {
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    
    func getDestination(departureCityID: String) {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "destination/"+String(self.selectedTransportId!) + "/\(departureCityID)"
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        
        print(header)
        print(compelteUrl)
        
        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<GetDestinationModel>) in
            
            self.hideActivityIndicator()
            
            if response.response?.statusCode == 200 {
                
                self.destinationObj = response.result.value
                if self.destinationObj?.responsecode == 2 || self.destinationObj?.responsecode == 1 {
                    
                    self.stringDestinationList.removeAll()
                    self.dropDownDestinations.isHidden = false
                    for aDestination in self.destinationObj!.data! {
                        self.stringDestinationList.append(aDestination.destinationCityName!)
                    }
                    if let destination = self.destinationObj?.data {
                        self.destinationList = destination
                    }
                    self.arrDestinationList = self.stringDestinationList
                    self.methodDropDownDestinations(Destinations: self.arrDestinationList!)
                    
                }
                else {
                    // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                }
            }
            else {
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
}
