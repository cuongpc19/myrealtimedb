//
//  ListCommentPostTableVC.swift
//  myrealtimedb
//
//  Created by AgribankCard on 6/25/17.
//  Copyright © 2017 cuongpc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabaseUI
class ListCommentPostTableVC: ExTableVC {
    var key : String?
    let CellIdentifier = "commentCell"
    let PlaceHolderCellIdentifier = "PlaceholderCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        dataSource = FUITableViewDataSource.init(query: getQuery()) { (tableView, indexPath, snap) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.CellIdentifier, for: indexPath) as! CommentTableViewCell
            
            guard let commentpost = Comment.init(snapshot: snap) else {
                return cell }
            cell.authorLabel.text = commentpost.author
            cell.commentTextLabel.text = commentpost.text
            return cell
        }
        dataSource?.bind(to: tableView)
        tableView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let countComment = dataSource?.items.count ?? 0
        return countComment
    }

    
   
    
    func getQuery() -> DatabaseQuery {
        let recentPostsQuery = (ref?.child("post-comments").child(self.key!).queryLimited(toFirst: 100))!
        return(recentPostsQuery)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
