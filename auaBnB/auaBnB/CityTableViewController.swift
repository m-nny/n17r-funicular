//
//  CityTableViewController.swift
//  auaBnB
//
//  Created by Alibek Manabayev on 15.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit
import KFSwiftImageLoader

class CityTableViewController: UITableViewController {

    let segueIdentifier : String = "ApartmentSegue"
    let cellIdentifier : String = "CityCell"
    
    var cities = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        findCitiesAsync()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CityTableViewCell

        
        let index = indexPath.row
        cell.cityNameLabel.text = cities[index].title
        
        if let url = cities[index].image {
            cell.cityImageView.loadImageFromURLString(url, placeholderImage: UIImage(named: "placeholder"), completion: nil)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(segueIdentifier, sender: indexPath)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == segueIdentifier) {
            let apartmentTVC = segue.destinationViewController as! ApartmentTableViewController
            let index = (sender as! NSIndexPath).row
            apartmentTVC.city = cities[index]
        }
    }
 
    // MARK: - Backendless
    func findCitiesAsync() {
        
        let dataStore = Backendless.sharedInstance().data.of(City.ofClass())
        self.cities = []
        
        dataStore.find(
            { (result: BackendlessCollection!) -> Void in
                let cities = result.getCurrentPage()
                for obj in cities {
                    print("\(obj)")
                    let city = obj as! City
                    self.cities.append(city)
                }
                self.tableView.reloadData()
            },
            error: { (fault: Fault!) -> Void in
                print("Server reported an error: \(fault)")
        })
    }
    
}
