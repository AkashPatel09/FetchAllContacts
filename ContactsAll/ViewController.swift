//
//  ViewController.swift
//  ContactsAll
//
//  Created by Akash Patel on 30/11/17.
//  Copyright © 2017 Akash Patel. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ViewController: UIViewController {

    @IBOutlet var lblStatus: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
/************************ IMPORTANT NOTE *******************************************
 
     -> Don't Forget to add "Privacy - Contacts Usage Description" in info.plist file
     -> If you have more contacts then it may take more time to fetch all contacts with single click
     -> I have printed the contacts you get from device. It fetch all contacts including duplicates.
     You can use this contact object to get all the details of it and load your UITableView with it.
 
 ************************ BY AKASH PATEL ******************************************/


    @IBAction func btnFetchAllContactsPressed(_ sender:Any) {
        
        self.lblStatus.text = "Please wait..."
        var contacts: [CNContact] = {
            let contactStore = CNContactStore()
            let keysToFetch = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactEmailAddressesKey,
                CNContactPhoneNumbersKey,
                CNContactImageDataAvailableKey,
                CNContactThumbnailImageDataKey] as [Any]
            
            // Get all the containers
            var allContainers: [CNContainer] = []
            do {
                allContainers = try contactStore.containers(matching: nil)
            } catch {
                print("Error fetching containers")
            }
            
            var results: [CNContact] = []
            
            // Iterate all containers and append their contacts to our results array
            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                
                do {
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    results.append(contentsOf: containerResults)
                } catch {
                    print("Error fetching results for container")
                }
            }
            
            return results
        }()
        
        for i in 0..<contacts.count {
            
            //You can find all the contacts of your device and you can access them here
            self.lblStatus.text = "Process Completed!"
            print("\(contacts[i].familyName)\(contacts[i].givenName)\n\((contacts[i].phoneNumbers[0].value ).value(forKey: "digits") as! String)")
        }
    }

}

