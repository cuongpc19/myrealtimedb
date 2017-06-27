//
//  Post.swift
//  myrealtimedb
//
//  Created by AgribankCard on 6/9/17.
//  Copyright © 2017 cuongpc. All rights reserved.
//

import UIKit
import Firebase

class Post: NSObject {
    var uid: String
    var author: String
    var title: String
    var body: String
    var image: String?
    var starCount: AnyObject?
    var stars: Dictionary<String, Bool>?
    var uiimage: UIImage?
    var commentCount: AnyObject?
    init(uid: String, author: String, title: String, body: String, image : String ) {
        self.uid = uid
        self.author = author
        self.title = title
        self.body = body
        self.image = image
        self.starCount = 0 as AnyObject?
        
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: AnyObject] else { return nil }
        guard let uid  = dict["uid"] as? String  else { return nil }
        guard let author = dict["author"] as? String else { return nil }
        guard let title = dict["title"] as? String else { return nil }
        guard let body = dict["body"] as? String else { return nil }
        guard let image = dict["image"] as? String else { return nil }
        if let starCount = dict["starCount"] {
            self.starCount = starCount as AnyObject?
        }
        if let commentCount = dict["commentCount"] {
            self.commentCount = commentCount
        }
        
        
        self.uid = uid
        self.author = author
        self.title = title
        self.body = body
        self.image = image
        
        
    }
    
    convenience override init() {
        self.init(uid: "", author: "", title: "", body:  "",image : "")
    }
}

