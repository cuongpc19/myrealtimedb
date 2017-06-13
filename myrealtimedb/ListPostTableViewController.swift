//
//  ListPostTableViewController.swift
//  myrealtimedb
//
//  Created by AgribankCard on 6/9/17.
//  Copyright © 2017 cuongpc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabaseUI

class ListPostTableViewController: UITableViewController {
    var ref: DatabaseReference!
    //var post: Post = Post()
    var posts : [Post] = []
    var storageRef: StorageReference!
    var dataSource: FUITableViewDataSource?
    var thefirstKey : String = ""
    var thefirstIndex : Int = 0
    private var imageDownloadsInProgress: [IndexPath: IconDownloader] = [:]
    let CellIdentifier = "LazyTableCell"
    let PlaceHolderCellIdentifier = "PlaceholderCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageDownloadsInProgress = [:]
        ref = Database.database().reference()
        let storage = Storage.storage()
        storageRef = storage.reference()
        ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            for item in snapshot.children.allObjects  as! [DataSnapshot]{
                
                
                let onepostdb = item.value  as? NSDictionary
                let post = Post()
                post.body = onepostdb?["body"] as? String ?? ""
                post.image = onepostdb?["image"] as? String ?? ""
                //post.isdownloadImg = 0
                self.posts.append(post)
            }
            self.tableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let count = self.posts.count
        
        // if there's no data yet, return enough rows to fill the screen
        if count == 0 {
            return 1
        }
        return count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        let nodeCount = self.posts.count
        
        if nodeCount == 0 && indexPath.row == 0 {
            // add a placeholder cell while waiting on table data
            cell = tableView.dequeueReusableCell(withIdentifier: PlaceHolderCellIdentifier, for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
            
            // Leave cells empty if there's no data yet
            if nodeCount > 0 {
                // Set up the cell representing the app
                let post = self.posts[indexPath.row]
                cell.textLabel?.text = post.body
                // Only load cached images; defer new downloads until scrolling ends
                if (post.uiimage != nil) {
                    cell.imageView?.image = post.uiimage
                    NSLog("uitable cell (has image data): %d", indexPath.row);
                } else {
                    if (self.tableView.isDragging == false && self.tableView.isDecelerating == false) {
                        NSLog("uitable cell (preparing for download): %d", indexPath.row)
                            self.startIconDownload(post, forIndexPath: indexPath)
                    }
                    NSLog("uitable cell (set default image): %d", indexPath.row);
                    cell.imageView?.image = UIImage(named: "test")
                    
                }
            }
        }
        
        return cell
    }
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
    private func startIconDownload(_ post: Post, forIndexPath indexPath: IndexPath) {
        var iconDownloader = self.imageDownloadsInProgress[indexPath]
        if iconDownloader == nil {
            iconDownloader = IconDownloader()
            iconDownloader!.post = post
            iconDownloader!.completionHandler = {[unowned self] in
                let cell = self.tableView.cellForRow(at: indexPath)
                NSLog("startIconDownload: %d", indexPath.row);
                cell?.imageView?.image = post.uiimage
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }

            self.imageDownloadsInProgress[indexPath] = iconDownloader
            iconDownloader!.startDownload()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    private func loadImagesForOnscreenRows() {
        if !self.posts.isEmpty {
            let visiblePaths = self.tableView.indexPathsForVisibleRows!
            for indexPath in visiblePaths {
                let post = posts[indexPath.row]
                
                // Avoid the app icon download if the app already has an icon
                if post.uiimage == nil {
                    self.startIconDownload(post, forIndexPath: indexPath)
                }
            }
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.loadImagesForOnscreenRows()
        }
    }
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.loadImagesForOnscreenRows()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        //self.tableView.reloadData()
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

