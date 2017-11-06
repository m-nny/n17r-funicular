//
//  CitiesTableViewController.swift
//  University.kz
//
//  Created by Alibek Manabayev on 23.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit
import KFSwiftImageLoader

class CitiesTableViewController: UITableViewController {

    let cellIdentifier : String = "CityCell"
    let segueIndentifier : String = "UniversitiesSegue"
    
    
    var cities = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        refreshControl = UIRefreshControl()
//        refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refreshControl!.addTarget(self, action: #selector(CitiesTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.getAllCitiesAsync()
    }

    
    func refresh(sender:AnyObject) {
        self.getAllCitiesAsync()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cities.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CityTableViewCell

        let index = indexPath.row
        
        if let url = cities[index].imageURL {
            cell.cityImageView.loadImageFromURLString(url, placeholderImage: UIImage(named: "placeholder_city"), completion: nil)
        } else {
            cell.cityImageView.image = UIImage(named: "placeholder_city")
        }
        
        cell.cityNameLabel.text = cities[index].name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(segueIndentifier, sender: indexPath)
    }
    
    // MARK: - Navigation

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == segueIndentifier) {
            let vc = segue.destinationViewController as! UniversitiesTableViewController
            let index = (sender as! NSIndexPath).row
            vc.city = cities[index]
        }
    }
    
    //MARK: - Backendless
    
    func getAllCitiesAsync() {
        let dataStore = Backendless.sharedInstance().data.of(City.ofClass())
        
        dataStore.find(
            { (result: BackendlessCollection!) -> Void in
                self.cities = []
                let contacts = result.getCurrentPage()
                for obj in contacts {
                    let city = obj as! City
                    self.cities.append(city)
                }
                print("cities downloaded")
                self.tableView.reloadData()
//                self.refreshControl!.endRefreshing()
            },
            error: { (fault: Fault!) -> Void in
                print("Server reported an error: \(fault)")
        })
    }
}
