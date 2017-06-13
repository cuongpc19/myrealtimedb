//
//  Post.swift
//  myrealtimedb
//
//  Created by AgribankCard on 6/9/17.
//  Copyright © 2017 cuongpc. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Post: NSObject {
    var uid: String
    var author: String
    var title: String
    var body: String
    var starCount: AnyObject?
    var stars: Dictionary<String, Bool>?
    var image : String
    var isdownloadImg : Int
    var uiimage: UIImage?
    init(uid: String, author: String, title: String, body: String,image : String,isdownloadImg : Int ) {
        self.uid = uid
        self.author = author
        self.title = title
        self.body = body
        self.starCount = 0 as AnyObject?
        self.image = image
        self.isdownloadImg = isdownloadImg
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: String] else { return nil }
        guard let uid  = dict["uid"]  else { return nil }
        guard let author = dict["author"] else { return nil }
        guard let title = dict["title"] else { return nil }
        guard let body = dict["body"] else { return nil }        
        guard let image = dict["image"] else { return nil }
        
        self.uid = uid
        self.author = author
        self.title = title
        self.body = body
        self.starCount = 0 as AnyObject?
        self.image = image
        self.isdownloadImg = 0
    }
    
    convenience override init() {
        self.init(uid: "", author: "", title: "", body:  "",image : "",isdownloadImg : 0)
    }
}
