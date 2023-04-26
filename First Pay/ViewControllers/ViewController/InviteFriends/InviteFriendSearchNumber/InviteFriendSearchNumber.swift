//
//  InviteFriendSearchNumber.swift
//  HBLFMB
//
//  Created by Apple on 19/04/2023.
//

import UIKit
import Contacts
import ContactsUI
class InviteFriendSearchNumber: UIViewController {

    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var viewBackGroundSearch: UIView!
    @IBOutlet weak var textFieldSearch: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        viewBackGroundSearch.radius(radius: 5)
        // Do any additional setup after loading the view.
        
        InviteFriendSearchNumberCell.register(tableView: tableView)
        fetchAllContacts()
    }

    @IBAction func buttonBack(_ sender: Any) {
    }
    var contacts = [ContactsModel]()
    func fetchAllContacts() {
        contacts = ContactsModel.generateModelArray()
        print(contacts)
        tableView.reloadData()
    }
}
// MARK: TableView Delegates
extension InviteFriendSearchNumber: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteFriendSearchNumberCell") as! InviteFriendSearchNumberCell
        // if change internet package is true then we dont need to show subscribed package
        cell.labelName.text = contacts[indexPath.row].givenName
        cell.labelNumber.text = "\(contacts[indexPath.row].phoneNumber.first ?? "")"
        cell.imageViewUser.image = contacts[indexPath.row].image
        print("\(contacts[indexPath.row].phoneNumber.first ?? "")")

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
   
}
class ContactsModel : NSObject {
    let givenName: String
    let familyName: String
    let phoneNumber: [String]
    let emailAddress: String
    var identifier: String
    var image: UIImage

    init(givenName:String, familyName:String, phoneNumber:[String], emailAddress:String, identifier:String, image:UIImage) {
        self.givenName = givenName
        self.familyName = familyName
        self.phoneNumber = phoneNumber
        self.emailAddress = emailAddress
        self.identifier = identifier
        self.image = image
    }

    class func generateModelArray() -> [ContactsModel]{
        let contactStore = CNContactStore()
        var contactsData = [ContactsModel]()
        let key = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactImageDataKey,CNContactThumbnailImageDataKey,CNContactPhoneNumbersKey,CNContactEmailAddressesKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: key)
        try? contactStore.enumerateContacts(with: request, usingBlock: { (contact, stoppingPointer) in
            let givenName = contact.givenName
            let familyName = contact.familyName
            let emailAddress = contact.emailAddresses.first?.value ?? ""
            let phoneNumber: [String] = contact.phoneNumbers.map{ $0.value.stringValue }
            let identifier = contact.identifier
            var image = UIImage()
            if contact.thumbnailImageData != nil{
                image = UIImage(data: contact.thumbnailImageData!)!

            }else if  contact.thumbnailImageData == nil ,givenName.isEmpty || familyName.isEmpty{
                image = UIImage(named: "usertwo")!
            }
            contactsData.append(ContactsModel(givenName: givenName, familyName: familyName, phoneNumber: phoneNumber, emailAddress: emailAddress as String, identifier: identifier, image: image))
        })
        return contactsData
    }
}
