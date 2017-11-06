//
//  FeedViewController.swift
//  SuretGramm
//
//  Created by Alibek Manabayev on 21.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, segue  {

    let cellIdentifier : String = "PostCell"
    let segueIdentifier : String = "DetailsSegue"
    var user : BackendlessUser?
    var feed = [Post]()
    
    @IBOutlet weak var tableView: PostsTableView!
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self.tableView
        self.tableView.delegate = self.tableView
        self.tableView.delegateVC = self
        
        self.findAllPostsAsync()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(FeedViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
    }

    func refresh(sender:AnyObject) {
        self.findAllPostsAsync()
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == segueIdentifier) {
            let vc = segue.destinationViewController as! ProfileDetailsViewController
            let index = (sender as! NSIndexPath).section
            vc.user = feed[index].user
        }
    }
    
    //MARK: - IBAction
    @IBAction func createPostButtonPressed(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Image Picker Controller Delegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        let fileName = "\(Backendless.sharedInstance().userService.currentUser.objectId)\(NSDate().timeIntervalSince1970).jpeg"
        let data = UIImageJPEGRepresentation(image, 0.8)
        
        Backendless.sharedInstance().file.upload(fileName, content: data, response: { (file : BackendlessFile!) in
            print("file url: \(file.fileURL)")
            //self.saveUserAsync(file.fileURL, nickname: nickname)
            self.savePostAsync(file.fileURL)
            
            picker.dismissViewControllerAnimated(true, completion: nil)
        }) { (fault : Fault!) in
            print("Server error : \(fault)")
            
            picker.dismissViewControllerAnimated(true, completion: nil)
        }

    }
    
    //MARK: - Backendless
    
    
    func savePostAsync(url : String) {
        let newPost = Post()
        newPost.user = Backendless.sharedInstance().userService.currentUser
        newPost.imageURL = url
        
        let dataStore = Backendless.sharedInstance().data.of(Post.ofClass())
        dataStore.save(newPost, response: { (result : AnyObject!) in
            let obj = result as! Post
            print("new post has been saved: \(obj.objectId)")
            
            self.feed.insert(obj, atIndex: 0)
            self.tableView.reloadData()
        }) { (fault : Fault!) in
            print("Server error : \(fault)")
        }
    }
    
    func findAllPostsAsync() {
        
        let dataStore = Backendless.sharedInstance().data.of(Post.ofClass())
        dataStore.find({ (results : BackendlessCollection!) in
            let posts = results.getCurrentPage()
            self.feed = []
            for obj in posts {
                let post = obj as! Post
                //post.likeCount = AccessBackendless.getNumberOfLikes(post)
                self.feed.append(post)
            }
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            print("Feed loaded")
        }) { (fault : Fault!) in
            print("Server error: \(fault)")
            self.refreshControl.endRefreshing()
        }
    }

}

