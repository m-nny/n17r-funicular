//
//  PostsTableView.swift
//  SuretGramm
//
//  Created by Alibek Manabayev on 22.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit

protocol segue {
    var segueIdentifier : String {get}
    var user : BackendlessUser? {get}
    var feed : [Post] {get set}
    func performSegueWithIdentifier(identifier: String, sender: AnyObject?)
}

class PostsTableView: UITableView, UITableViewDataSource, UITableViewDelegate {

    let cellIdentifier : String = "PostCell"
    var delegateVC : segue!
    var islIked : [Post]!
    
    //MARK: - Table View Data Source (Cells)
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.delegateVC.feed.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PostTableViewCell

        let index = indexPath.section
        guard let url = self.delegateVC.feed[index].imageURL else {
            return cell
        }
        cell.postImageView.loadImageFromURLString(url, placeholderImage: UIImage(named: "placeholder_image"), completion: nil)
        
        //Double tap
        let gesture = MyTapGestureRecognizer(target: self, action: #selector(self.doubleTapped(_:)))
        gesture.numberOfTapsRequired = 2
        gesture.section = indexPath.section
        cell.addGestureRecognizer(gesture)
        
        return cell
    }
    
    //MARK: - Table View Delegate (Header)
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: 44.0))
        header.backgroundColor = UIColor.whiteColor()
        
        let imageView = UIImageView(frame: CGRect(x: 8.0, y: 8.0, width: 30.0, height: 21.0))
        imageView.contentMode = .ScaleAspectFill
        
        if let profileURL = self.delegateVC.feed[section].user!.getProperty("profileURL") as? String {
            imageView.loadImageFromURLString(profileURL, placeholderImage: UIImage(named: "placeholder_person"), completion: nil)
            
        }
        header.addSubview(imageView)
        
        let likesLabel = UILabel(frame: CGRect(x : (header.frame.width - 48.0), y : (header.frame.height - 15.0) / 2.0, width: 40, height: 15))
        let likeCount = AccessBackendless.getNumberOfLikes(self.delegateVC.feed[section])
        likesLabel.text = "\(likeCount) like"
        likesLabel.textAlignment = .Right
        likesLabel.font = UIFont(name: "Bodoni 72 Oldstyle", size: likesLabel.font!.pointSize)
        header.addSubview(likesLabel)
        
        let author = UILabel(frame: CGRect(x: 46.0, y: 12.5, width: header.frame.width - (46.0 - 8.0), height: 15.0))
        author.text = self.delegateVC.feed[section].user!.getProperty("name") as? String
        
        header.addSubview(author)
        
        
        //tap
        let gesture = MyTapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        gesture.numberOfTapsRequired = 1
        gesture.section = section
        header.addGestureRecognizer(gesture)
        
        return header
    }
}


extension PostsTableView {
    
    //MARK: - Double tab
    class MyTapGestureRecognizer: UITapGestureRecognizer {
        var section : Int!
    }
    
    func tapped(gestureRecognizer: MyTapGestureRecognizer) {
        let section = gestureRecognizer.section
        
        print("\(section) was tapped")
        
        self.delegateVC.performSegueWithIdentifier(self.delegateVC.segueIdentifier, sender: NSIndexPath(forRow: 0, inSection: section))
    }
    
    func doubleTapped(gestureRecognizer: MyTapGestureRecognizer) {
        let section = gestureRecognizer.section
        
        print("\(section) was double tapped")
        
        let user = Backendless.sharedInstance().userService.currentUser!
        if let like = AccessBackendless.HasUserLikedPost(self.delegateVC.feed[section], nickname: user.name) {
            AccessBackendless.RemoveLikeFromPost(like)
        } else {
            AccessBackendless.AddLikeToPost(self.delegateVC.feed[section], nickname: user.name)
        }
        
        self.reloadSections(NSIndexSet(index: section), withRowAnimation: .None)
        
    }
    
}
