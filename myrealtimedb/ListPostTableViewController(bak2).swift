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
class ListPostTableViewControllerbak2: UITableViewController {
    var ref: DatabaseReference!        
    var post: Post = Post()
    var posts : [Post] = []
    
    var dataSource: FUITableViewDataSource?
    var thefirstKey : String = ""
    var thefirstIndex : Int = 0
    private var imageDownloadsInProgress: [IndexPath: IconDownloader] = [:]
    let PlaceHolderCellIdentifier = "postcell"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageDownloadsInProgress = [:]
        ref = Database.database().reference()
        // Get a reference to the storage service using the default Firebase App
        dataSource = FUITableViewDataSource.init(query: queryDatabase(lastkey: self.thefirstKey)) { (tableView, indexPath, snap) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "postcell", for: indexPath) as! PostTableViewCell
            let nodeCount = self.posts.count
            
            if nodeCount == 0 && indexPath.row == 0 {
                // add a placeholder cell while waiting on table data
                
            }
            
            guard let post = Post.init(snapshot: snap) else { return cell }
            self.posts.append(post)
            
            cell.textLabel?.text = post.body
            
            //print("post image = \(post.image)")
            
            if self.posts[indexPath.row].uiimage == nil {
                if !self.tableView.isDragging && !self.tableView.isDecelerating {
                       self.startIconDownload(post, forIndexPath: indexPath)                    
                }
                // if a download is deferred or in progress, return a placeholder image
                cell.imageView?.image = UIImage(named: "test")!
            } else {
               // cell.imageView?.image = self.posts[indexPath.row].uiimage
            }
            return cell
        }
        
        dataSource?.bind(to: tableView)
        tableView.delegate = self
    }
    
    
   
    func queryDatabase(lastkey : String) -> DatabaseQuery {
        //print("lastkey  in query: \(lastkey)")
        return(self.ref.child("posts")).queryOrderedByKey().queryStarting(atValue: lastkey).queryLimited(toFirst: 100)
    }
    

    
    private func startIconDownload(_ post: Post, forIndexPath indexPath: IndexPath) {
        var iconDownloader = self.imageDownloadsInProgress[indexPath]
        if iconDownloader == nil {
            iconDownloader = IconDownloader()
            iconDownloader!.post = post
            iconDownloader!.completionHandler = {
                
                //let cell = self.tableView.cellForRow(at: indexPath) as! PostTableViewCell
                let cell = self.tableView.cellForRow(at: indexPath)
                //cell?.imageView?.image = post.uiimage
                // Display the newly loaded image
                //cell.uiImage.image = post.uiimage
               // self.posts[indexPath.row].uiimage = post.uiimage
                // Remove the IconDownloader from the in progress list.
                // This will result in it being deallocated.
                self.imageDownloadsInProgress.removeValue(forKey: indexPath)
                
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
        self.tableView.reloadData()
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
