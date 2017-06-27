//
//  PostTableViewCell.swift
//  myrealtimedb
//
//  Created by AgribankCard on 6/9/17.
//  Copyright © 2017 cuongpc. All rights reserved.
//

import UIKit
import Firebase
class PostTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var bodyPost: UILabel!
    
    @IBOutlet weak var uiImagePost: UIImageView!
    
    @IBOutlet weak var uiCountLikeLabel: UILabel!
    
    @IBOutlet weak var uiCountCommentLabel: UILabel!
    
    
    
    @IBOutlet weak var likeButton: ButtonWithKey!
    
    @IBOutlet weak var commentButton: ButtonWithKey!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func checkIsLogin() -> Bool {
        var islogin = false
        if  Auth.auth().currentUser != nil {
            islogin = true
        } else {
            islogin = false
        }
        return islogin
    }
    
   
    
    @IBAction func commentClickAction(_ sender: Any) {
    }
    
    @IBAction func downloadClickAction(_ sender: Any) {
    }
    
    @IBAction func shareClickAction(_ sender: Any) {
    }
    
    
}
