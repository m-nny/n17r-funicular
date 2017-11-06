//
//  AccessBackendless.swift
//  SuretGramm
//
//  Created by Alibek Manabayev on 28.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import Foundation

class AccessBackendless {
    
    static func updatePost(newPost : Post) {
        let dataStore = Backendless.sharedInstance().data.of(Post)
        dataStore.save(newPost, response: { (result : AnyObject!) in
            let obj = result as! Post
            print("post has been update: \(obj.objectId)")
            
        }) { (fault : Fault!) in
            print("Server error : \(fault)")
        }
    }

    static func AddLikeToPost(post : Post, nickname : String) {
        let like = PostLike()
        like.post = post
        like.userNickname = nickname
        let dataStore = Backendless.sharedInstance().data.of(PostLike)
        dataStore.save(like, response: { (result : AnyObject!) in
            print("Liked")
        }) { (fault : Fault!) in
            print("Server error")
        }
    }
    
    static func RemoveLikeFromPost(like : PostLike) {
        let dataStore = Backendless.sharedInstance().data.of(PostLike)
        dataStore.remove(like, response: { (_ : NSNumber!) in
            print("Unliked")
        }) { (fault : Fault!) in
            print("Server error")
        }
    }
    
    static func HasUserLikedPost(post : Post, nickname : String) -> PostLike? {
        let whereClause = "post.objectId = '\(post.objectId!)' AND userNickname = '\(nickname)'"
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = whereClause
        var ans = [PostLike]()
        var error : Fault?
        let dataStore = Backendless.sharedInstance().data.of(PostLike)
        let bc = dataStore.find(dataQuery, fault: &error)
        if error == nil {
            for obj in bc.data {
                ans.append(obj as! PostLike)
            }
            print("Post's likes downloaded: \(ans)")
        }
        else {
            print("Server reported an error: \(error)")
        }
        if (ans.isEmpty) {
            print("User hasn't liked")
            return nil
        }
        print("User has liked")
        return ans[0]
    }
    
    static func getLikesOfPost(post : Post) -> [PostLike]{
        let whereClause = "post.objectId = '\(post.objectId!)'"
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = whereClause
        var ans = [PostLike]()
        var error : Fault?
        let dataStore = Backendless.sharedInstance().data.of(PostLike)
        let bc = dataStore.find(dataQuery, fault: &error)
        if error == nil {
            for obj in bc.data {
                ans.append(obj as! PostLike)
            }
            print("Post's likes downloaded")
        }
        else {
            print("Server reported an error: \(error)")
        }
        return ans
    }
    
    static func getNumberOfLikes(post : Post) -> Int {
        let whereClause = "post.objectId = '\(post.objectId!)'"
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = whereClause
        dataQuery.queryOptions.pageSize = 1
        let dataStore = Backendless.sharedInstance().data.of(PostLike)
        
        let result = dataStore.find(dataQuery)
        let ans = result.totalObjects as Int
        print("\(ans) people liked \(post.objectId!)")
        return ans
    }
    
    static func getPostByID(objectId : String) -> Post? {
        let dataStore = Backendless.sharedInstance().data.of(Post)
        let post = dataStore.findID(objectId) as? Post
        
        return post
    }

}
