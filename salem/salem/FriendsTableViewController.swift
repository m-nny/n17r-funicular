//
//  FriendsTableViewController.swift
//  salem
//
//  Created by Alibek Manabayev on 17.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    
    let cellIdentifier : String = "FriendCell"
    let segueIdentifier : String = "ChatSegue"
    
    var friends = [Friend]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.findUsersAsync(Backendless.sharedInstance().userService.currentUser)
        
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
        return self.friends.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = self.friends[indexPath.row].user2!.email
        return cell
    }
    
    
    @IBAction func addFriendButtonPressed(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Create new chat", message: "Please enter your friend's eminl below:", preferredStyle: UIAlertControllerStyle.Alert)
        
        let findAction = UIAlertAction(title: "Search", style: UIAlertActionStyle.Default) { (action : UIAlertAction) in
            let emailTextField = alertController.textFields![0] as UITextField
            self.findUserAsync(emailTextField.text!)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField) in
            textField.placeholder = "email"
        }
        
        alertController.addAction(findAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(segueIdentifier, sender: indexPath)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == segueIdentifier) {
            let chatVC = segue.destinationViewController as! ChatViewController
            let index = (sender as! NSIndexPath).row
            chatVC.friend = self.friends[index]
        }
    }
    
    //MARK: - Backendless
    
    func findUserAsync(email : String) {
        let whereClause = "email = \'\(email)\'"
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = whereClause
        
        let dataSource = Backendless.sharedInstance().data.of(BackendlessUser.ofClass())
     
        dataSource.find(dataQuery, response: { (result : BackendlessCollection!) in
            let users = result.getCurrentPage()
            for obj in users {
                let user = obj as! BackendlessUser
                let newFriend = Friend()
                newFriend.user1 = Backendless.sharedInstance().userService.currentUser
                newFriend.user2 = user
                
                //append locally
                self.friends.append(newFriend)
                
                //backendless send
                let dataSource = Backendless.sharedInstance().data.of(newFriend.ofClass())
                
                dataSource.save(newFriend, response: { (result : AnyObject!) in
                    //let obj = result as! [Friend]
                    self.tableView.reloadData()
                    
                    }, error: { (fault : Fault!) in
                        print("Error: \(fault)")
                        //code
                })
            }
            //code
        }) { (fault : Fault!) in
            print("Server error: \(fault)")
        }
        
    }
    
    func findUsersAsync(user : BackendlessUser) {
        
        let whereClause = "user1.objectid = \'\(user.objectId)\'"
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = whereClause
        
        let dataSource = Backendless.sharedInstance().data.of(Friend.ofClass())
        dataSource.find(dataQuery, response: { (result : BackendlessCollection!) in
            //code
            let friends = result.getCurrentPage()
            for obj in friends {
                let friend = obj as! Friend
                self.friends.append(friend)
            }
            self.tableView.reloadData()
        }) { (fault :Fault!) in
            print("Server error: \(fault)")
        }
    }

}
