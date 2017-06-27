//
//  ExTableVC.swift
//  myrealtimedb
//
//  Created by AgribankCard on 6/25/17.
//  Copyright © 2017 cuongpc. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabaseUI
class ExTableVC : UITableViewController {
    var ref: DatabaseReference!
    var postRef: DatabaseReference!
    var dataSource: FUITableViewDataSource?
    
    func checkIsLogin() -> Bool {
        var islogin = false
        if  Auth.auth().currentUser != nil {
            islogin = true
        } else {
            islogin = false
        }
        return islogin
    }
    
    
    func getUid() -> String {
        return (Auth.auth().currentUser?.uid)!
    }
}
