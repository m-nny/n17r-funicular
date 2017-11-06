//
//  ChatViewController.swift
//  salem
//
//  Created by Alibek Manabayev on 19.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit
import KFSwiftImageLoader

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextButton: UITextField!
    
    let recieveCell : String = "RecieveCell"
    let sendCell : String = "SendCell"
    
    var friend : Friend!
    var history = [History]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        //tableView.delegate = self
        // Do any additional setup after loading the view.
        
        self.subscribe()
    }

    
    @IBAction func sendButtonPressed(sender: UIButton) {
        publishMessageAsync(messageTextButton.text!)
    }
 
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let index = indexPath.row
        if (self.history.count >= index) {
            print("Out of range")
            let zeroIndex = NSIndexPath(forRow: 0, inSection: 0)
            return tableView.dequeueReusableCellWithIdentifier(sendCell, forIndexPath: zeroIndex)
        }
        if (self.history[index].isMine == true) {
            let cell = tableView.dequeueReusableCellWithIdentifier(sendCell, forIndexPath: indexPath) as! SenderTableViewCell
            
            cell.messageText.text = self.history[index].message
            let profileURL = self.friend.user1!.getProperty("profile") as! String
            cell.profileImageView.loadImageFromURLString(profileURL)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(recieveCell, forIndexPath: indexPath) as! RecieverTableViewCell
            
            cell.messageText.text = self.history[index].message
            let profileURL = self.friend.user2!.getProperty("profile") as! String
            cell.profileImageView.loadImageFromURLString(profileURL)
            
            return cell
        }
        
    }
    
    func publishMessageAsync(message: String) {
        let history = History()
        history.message = message
        history.isMine = true
        
        Backendless.sharedInstance().messaging.publish(self.friend.user2!.objectId, message: message,
            response:{ ( messageStatus : MessageStatus!) -> () in
                print("\(messageStatus)")
                print("MessageStatus = \(messageStatus.status) ['\(messageStatus.messageId)']")
                self.history.append(history)
                self.messageTextButton.text = ""
                self.messageTextButton.resignFirstResponder()
                self.tableView.reloadData()
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
            }
        )
    }
    
    func subscribe() {
        let responder = Responder(responder: self, selResponseHandler: #selector(IResponder.responseHandler(_:)), selErrorHandler: #selector(IResponder.errorHandler(_:)))
        let subscriptionOptions = SubscriptionOptions()
        let subscription = Backendless.sharedInstance().messagingService.subscribe(self.friend.user1!.objectId, subscriptionResponder: responder, subscriptionOptions: subscriptionOptions)
        print(subscription)
    }
    
    func responseHandler(response : AnyObject!) -> AnyObject {
        let messages = response as! [Message]
        for message in messages {
            print("\(message.data)")
            let newHistory = History()
            newHistory.message = "\(message.data)"
            newHistory.isMine = false
            self.history.append(newHistory)
        }
        self.tableView.reloadData()
        
        return response
    }
    
    func errorHandler(fault : Fault!) {
        print("\(fault)")
    }
}
