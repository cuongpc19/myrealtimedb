//
//  CommentTableViewCell.swift
//  myrealtimedb
//
//  Created by AgribankCard on 6/25/17.
//  Copyright © 2017 cuongpc. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var commentTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        //commentTextLabel.numberOfLines = 0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
