//
//  ViewController.swift
//  Google Books
//
//  Created by Alibek Manabayev on 09.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
 
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let BooksCellIdentifier : String = "booksCell"
    let myAPIKey : String = "AIzaSyC1aESLz9zSNwFEONEVPcHI15hdDazHFNo"
    let segueIdentefier : String = "booksCell"
    
    //var bookCount : Int = 0
    var booksArray : [[String : AnyObject]] = []
     
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        searchBar.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func downloadBooks(bookTitle : String) {
        let stringURL : String = "https://www.googleapis.com/books/v1/volumes?q=\(bookTitle)+inauthor:keyes&key=\(myAPIKey)"
        
        guard let url = NSURL(string : stringURL) else {
            print("URL problem\n\(stringURL)")
            return
        }
        
        let urlRequest = NSMutableURLRequest(URL : url)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(urlRequest) { (data : NSData?, response : NSURLResponse?, error : NSError?) in
            guard let jsonData = data else {
                print("No data has been downloaded :(")
                return
            }
            guard error == nil else {
                print("Some error happened: \(error)" )
                return
            }
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments)
                
                guard let item = json["items"] as? [[String : AnyObject]] else {
                    guard let errorJSON = json["error"] as? [String : AnyObject],
                        let errorCode = errorJSON["code"] as? String else {
                            print("Error while getting ITEM")
                            return
                    }
                    print("Error while getting ITEM  \nError code \(errorCode)")
                    return
                }
                self.booksArray = item
                
                dispatch_async(dispatch_get_main_queue(), { 
                    self.tableView.reloadData()
                })
                
            } catch {
                print("Error with JSON")
            }
        }
        
        task.resume()
    }
    
}

extension ViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksArray.count
    
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(BooksCellIdentifier, forIndexPath: indexPath)
        
        if let bookInfo   = self.booksArray[indexPath.row]["volumeInfo"] as? [String : AnyObject]{
            cell.textLabel?.text = bookInfo["title"] as? String
            cell.detailTextLabel?.text  = bookInfo["subtitle"] as? String
        }
        
        return cell
    }
    
    /*
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(self.segueIdentefier, sender: indexPath);
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == self.segueIdentefier) {
            let controller = segue.destinationViewController as! bookInfoVC
            let row = tableView.indexPathForSelectedRow!.row;
            controller.book = self.booksArray[row]
        }
    }
}

extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let bookTitle : String = searchBar.text!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        downloadBooks(bookTitle)
        self.view.endEditing(true)
    }
}
