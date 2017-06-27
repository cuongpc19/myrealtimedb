//
//  Comment.swift
//  myrealtimedb
//
//  Created by AgribankCard on 6/25/17.
//  Copyright © 2017 cuongpc. All rights reserved.
//

import UIKit
import Firebase

class Comment: NSObject {
    var uid: String
    var author: String
    var text: String
    init(uid: String, author: String, text : String ) {
        self.uid = uid
        self.author = author
        self.text = text
        
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: AnyObject] else { return nil }
        guard let uid  = dict["uid"] as? String  else { return nil }
        guard let author = dict["author"] as? String else { return nil }
        guard let text = dict["text"] as? String else { return nil }
        self.uid = uid
        self.author = author
        self.text = text
    }
    
    convenience override init() {
        self.init(uid: "", author: "", text : "")
    }
}
