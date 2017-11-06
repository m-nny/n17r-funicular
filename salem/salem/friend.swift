//
//  friend.swift
//  salem
//
//  Created by Alibek Manabayev on 17.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import Foundation


class Friend : NSObject {
    var objectId : String?
    var user1 : BackendlessUser?
    var user2 : BackendlessUser?
}

class History : NSObject {
    var message : String?
    var isMine : Bool!
}