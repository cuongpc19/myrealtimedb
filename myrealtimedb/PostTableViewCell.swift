//
//  PostTableViewCell.swift
//  myrealtimedb
//
//  Created by AgribankCard on 6/9/17.
//  Copyright © 2017 cuongpc. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var bodyPost: UILabel!
    
    @IBOutlet weak var uiImagePost: UIImageView!
    
    @IBOutlet weak var uiCountLikeLabel: UILabel!
    
    @IBOutlet weak var uiCountCommentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
