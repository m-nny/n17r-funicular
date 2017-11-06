//
//  UniversitiesTableViewController.swift
//  University.kz
//
//  Created by Alibek Manabayev on 23.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit

class UniversitiesTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!

    let cellIdentifier : String = "UniversityCell"
    let segueIdentifier : String = "DetailsSegue"
    
    var city = City()
    var universities = [University]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        self.navigationItem.title = city.name
        
        /*
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl!.addTarget(self, action: #selector(CitiesTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        */
        self.refresh(self)
        
    }
    
    func refresh(sender: AnyObject) {
        if (self.city.name == "All") {
            self.getAllUniversitiesAsync()
        } else {
            self.getUniversitiesInAsync(self.city)
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return universities.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UniversityTableViewCell

        let index = indexPath.row
        if let url = universities[index].imageURL {
            cell.universityImageView.loadImageFromURLString(url, placeholderImage: UIImage(named: "placeholder_uni"), completion: nil)
        } else {
            cell.universityImageView.image = UIImage(named: "placeholder_uni")
        }
        
//        cell.universityLabel?.text = universities[index].shortName ?? "Uni short name"
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(segueIdentifier, sender: indexPath)
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == segueIdentifier) {
            let index = (sender as! NSIndexPath).row
            let tb = segue.destinationViewController as! UniversityTabBarController
            let vc = tb.viewControllers?.first as! UniversityDetailsViewController
            vc.university = universities[index]
            let svc = tb.viewControllers?.last as! SpecialitiesViewController
            svc.university = universities[index]
        }
    }
    
    //MARK: - Backendless
    
    func getAllUniversitiesAsync() {
        let dataStore = Backendless.sharedInstance().data.of(University.ofClass())
        
        dataStore.find(
            { (result: BackendlessCollection!) -> Void in
                self.universities = []
                let contacts = result.getCurrentPage()
                for obj in contacts {
                    let university = obj as! University
                    self.universities.append(university)
                }
                print("universities downloaded")
                self.tableView.reloadData()
                self.refreshControl!.endRefreshing()
            },
            error: { (fault: Fault!) -> Void in
                print("Server reported an error: \(fault)")
        })
    }
    
    func getUniversitiesInAsync(city : City) {
        let whereClause = "city.name = \'\(city.name!)\'"
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = whereClause
        let dataStore = Backendless.sharedInstance().data.of(University.ofClass())
        
        dataStore.find(dataQuery,
            response: { (result: BackendlessCollection!) -> Void in
                self.universities = []
                let contacts = result.getCurrentPage()
                for obj in contacts {
                    let university = obj as! University
                    let text = self.searchBar.text!
                    var x = ""
                    if university.fullName != nil {
                        x = university.fullName!
                    }
                    var y = ""
                    if university.shortName != nil {
                        y = university.shortName!
                    }
                    print("|\(text)| - \(x) = \(y)")
                    if text.isEmpty || x.containsString(text) || y.containsString(text) {
                        self.universities.append(university)
                    }
                }
                print("universities downloaded")
                self.tableView.reloadData()
                //self.refreshControl!.endRefreshing()
            },
            error: { (fault: Fault!) -> Void in
                print("Server reported an error: \(fault)")
        })
    }
}

extension UniversitiesTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.getUniversitiesInAsync(city)
    }
}
