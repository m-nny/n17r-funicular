//
//  ProfileDetailsViewController.swift
//  SuretGramm
//
//  Created by Alibek Manabayev on 21.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit

class ProfileDetailsViewController: UIViewController, segue {
    
    let segueIdentifier : String = ""
    var user : BackendlessUser?
    var feed = [Post]()

    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tableView: PostsTableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = tableView
        tableView.delegate = tableView
        tableView.delegateVC = self
        
        loadData()
        // Do any additional setup after loading the view.
    }

    func loadData() {
        guard let nickname = user?.getProperty("name") as? String,
        let url = user?.getProperty("profileURL") as? String else {
            return
        }
        nicknameLabel.text = nickname
        profileImageView.loadImageFromURLString(url, placeholderImage: UIImage(named: "placeholder_person"), completion: nil)
        findAllPostsByAsync(nickname)
    }
    
    //MARK: - Backendless
    func findAllPostsByAsync(nickname : String) {
        let whereClause = "user.name = \'\(nickname)\'"
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = whereClause
        let dataStore = Backendless.sharedInstance().data.of(Post.ofClass())
        dataStore.find(dataQuery, response: { (result : BackendlessCollection!) in
            self.feed = []
            let posts = result.getCurrentPage()
            for obj in posts {
                let post = obj as! Post
                //post.likeCount = AccessBackendless.getNumberOfLikes(post)
                self.feed.append(post)
            }
            self.tableView.reloadData()
            print("All posts downloaded")
            //
        }) { (fault : Fault!) in
            print("Server error: \(fault)")
            //
        }
    }
}
