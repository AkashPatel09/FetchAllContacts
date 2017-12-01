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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var tableView: UITableView!
    var arrayContacts = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        
        if contacts.count > 0 {
            
            self.arrayContacts = NSMutableArray.init(array: contacts)
            self.tableView.reloadData()
            self.lblStatus.text = "Process Completed!"
        }
        
        /*for i in 0..<contacts.count {
            
            //You can find all the contacts of your device and you can access them here
            self.lblStatus.text = "Process Completed!"
            print("\(contacts[i].familyName)\(contacts[i].givenName)\n\((contacts[i].phoneNumbers[0].value ).value(forKey: "digits") as! String)")
        }*/
    }
    
    
    //MARK: TableView Datasource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (arrayContacts.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let contactName = "\((arrayContacts[indexPath.row] as! CNContact).familyName)\((arrayContacts[indexPath.row] as! CNContact).givenName)"
        cell.textLabel?.text = contactName
        
        return cell
    }

}

