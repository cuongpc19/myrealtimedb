//
//  ViewController.swift
//  myrealtimedb
//
//  Created by AgribankCard on 6/9/17.
//  Copyright © 2017 cuongpc. All rights reserved.
//

import UIKit
import Firebase
class ViewController: UIViewController {
    var ref: DatabaseReference!
    
    @IBOutlet weak var titleBox: UITextField!
    
    @IBOutlet weak var desBox: UITextField!
    
    @IBOutlet weak var imagenameBox: UITextField!
    var post: Post = Post()
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendAction(_ sender: Any) {
        let key = ref.child("posts").childByAutoId().key
        let imagename = imagenameBox.text! + ".jpg"
        let post = ["uid": "cuongpc",
                    "author": "cuongpc",
                    "title": titleBox.text,
                    "body": desBox.text,
                    "image" : imagename] as [String : Any]
        let childUpdates = ["/posts/\(key)": post]
        ref.updateChildValues(childUpdates)
    }

}

