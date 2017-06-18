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
    var post: Post = Post()
    var posts : [Post] = []
    
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
        // Get a reference to the storage service using the default Firebase App
        dataSource = FUITableViewDataSource.init(query: queryDatabase(lastkey: self.thefirstKey)) { (tableView, indexPath, snap) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.CellIdentifier, for: indexPath) as! PostTableViewCell
            
            guard let post = Post.init(snapshot: snap) else { return cell }
            self.posts.append(post)
            print("body post \(post.body)")
            print("index Path: \(indexPath.row)")
            cell.bodyPost?.text = "Loading ..."
            cell.uiImagePost.image = UIImage(named: "test")
            if let starCount = post.starCount {
                cell.uiCountLikeLabel.text = "\(starCount) like"
            }
            
            if (self.posts[indexPath.row].uiimage == nil) {
                
                self.performUIUpdatesOnMain {
                    self.startIconDownload(post, forIndexPath: indexPath)
                }
            } else {
                cell.bodyPost?.text = post.body
                cell.uiImagePost?.image = self.posts[indexPath.row].uiimage
            }
            
            
            return cell
        }
        dataSource?.bind(to: tableView)
        tableView.delegate = self
    }
    
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
   
    func queryDatabase(lastkey : String) -> DatabaseQuery {
        //print("lastkey  in query: \(lastkey)")
        //return(self.ref.child("posts")).queryOrderedByKey().queryStarting(atValue: lastkey).queryLimited(toLast: 100)
        return(self.ref.child("posts")).queryOrderedByKey()
    }
    

    
    private func startIconDownload(_ post: Post, forIndexPath indexPath: IndexPath) {
        var iconDownloader = self.imageDownloadsInProgress[indexPath]
        if iconDownloader == nil {
            iconDownloader = IconDownloader()
            iconDownloader!.post = post
            iconDownloader!.completionHandler = {[unowned self] in
                
                guard let cell = self.tableView.cellForRow(at: indexPath) as? PostTableViewCell
                    else {
                    // Value requirements not met, do something
                    return
                }
                //guard let cell = self.tableView.cellForRow(at: indexPath) as! PostTableViewCell
                //NSLog("startIconDownload: %d", indexPath.row);
                cell.uiImagePost?.image = post.uiimage
                cell.bodyPost?.text = post.body
                self.posts[indexPath.row].uiimage = post.uiimage
                self.posts[indexPath.row].body = post.body
                //self.tableView.reloadRows(at: [indexPath], with: .fade)
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
                    self.performUIUpdatesOnMain {
                        self.startIconDownload(post, forIndexPath: indexPath)
                        //self.tableView.reloadRows(at: [indexPath], with: .fade)
                    }
                    
                    
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
