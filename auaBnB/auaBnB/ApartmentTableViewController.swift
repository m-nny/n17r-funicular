//
//  ApartmentTableViewController.swift
//  auaBnB
//
//  Created by Alibek Manabayev on 15.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit

class ApartmentTableViewController: UITableViewController {

    let cellIdentifier : String = "ApartmentCell"
    
    var city : City!
    var apartments = [Apartment]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.findApartmentsAsync(self.city)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return apartments.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ApartmentTableViewCell
        
        let index = indexPath.row
        cell.apartmentTitleLabel.text = apartments[index].title
        cell.apartmentPriceLabel.text = "\(apartments[index].price) тнг"
        
        if let url = apartments[index].image {
            cell.apartmentImageView.loadImageFromURLString(url, placeholderImage: UIImage(named: "placeholder2"), completion: nil)
        }

        return cell
    }
    
    // MARK: - Backendless
    func findApartmentsAsync(city : City) {
        
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = "city.objectId = \'\(city.objectId!)\'"
        

        let dataStore = Backendless.sharedInstance().data.of(Apartment.ofClass())
        self.apartments = []
        dataStore.find(dataQuery, response: { (result : BackendlessCollection!) in
            let aprts = result.getCurrentPage()
            for obj in aprts {
                print("\(obj)")
                let aprt = obj as! Apartment
                self.apartments.append(aprt)
            }
            self.tableView.reloadData()

        }) { (error : Fault!) in
                print ("\(error)")
        }
        
    }
    
}
