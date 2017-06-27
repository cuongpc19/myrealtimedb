//
//  ListPostTableViewController.swift
//  
//
//  Created by AgribankCard on 6/18/17.
//
//

import UIKit
import Firebase
import FirebaseDatabaseUI
class ListPostTableViewController: ExTableVC {
    
    var post: Post = Post()
    var posts : [Post] = []
    
    
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
        dataSource = FUITableViewDataSource.init(query: getQuery()) { (tableView, indexPath, snap) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.CellIdentifier, for: indexPath) as! PostTableViewCell
            cell.likeButton.key = snap.key
            cell.commentButton.key = snap.key
            guard let post = Post.init(snapshot: snap) else {
                return cell }
            
            self.posts.append(post)
            //print("snap key \(snap.key)")
            cell.likeButton.setImage(UIImage(named: "like"), for: .normal)
            self.postRef = Database.database().reference().child("posts").child(snap.key).child("stars").child(self.getUid())
            self.postRef.observe(DataEventType.value, with: { (snapshot) in
                guard let postDict = snapshot.value as? Bool else {
                    cell.likeButton.setImage(UIImage(named: "like"), for: .normal)
                    return}
                    cell.likeButton.setImage(UIImage(named: "liked"), for: .normal)
                
            })
            
            //cell.likeButton.setImage(UIImage.init(named: imageName), for: .normal)
            cell.bodyPost?.text = "Loading ..."
            cell.uiImagePost.image = UIImage(named: "test")
            if let starCount = post.starCount {
                cell.uiCountLikeLabel.text = "\(starCount) like"
            }
            cell.uiCountCommentLabel.text = "0 comment"
            if let commentCount = post.commentCount {
                cell.uiCountCommentLabel.text = "\(commentCount) comments"
            }
            if (self.posts[indexPath.row].uiimage == nil) {
                
                self.performUIUpdatesOnMain {
                    self.startIconDownload(post, forIndexPath: indexPath)
                }
            } else {
                cell.bodyPost?.text = post.body
                cell.uiImagePost?.image =  self.posts[indexPath.row].uiimage
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
    
    
    
    
    @IBAction func likeClickAction(_ sender: Any) {
        if (self.checkIsLogin() == true) {
            guard let likeButton = sender as? ButtonWithKey else {
               fatalError("Chung toi rat tiec vi xay ra loi.")
            }
            let postKey = likeButton.key
            //print("current Key uid: \(postKey)")
            postRef = Database.database().reference().child("posts").child(postKey!)
            incrementStars(forRef: postRef)
            
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FbLoginViewController") as! FbLoginViewController
            self.present(vc, animated: true, completion: nil)

        }
        
    }
    
    func incrementStars(forRef ref: DatabaseReference) {
        // [START post_stars_transaction]
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
                var stars: Dictionary<String, Bool>
                stars = post["stars"] as? [String : Bool] ?? [:]
                var starCount = post["starCount"] as? Int ?? 0
                
                if let _ = stars[uid] {
                    // Unstar the post and remove self from stars
                    starCount -= 1
                    stars.removeValue(forKey: uid)
                } else {
                    // Star the post and add self to stars
                    starCount += 1
                    stars[uid] = true
                }
                post["starCount"] = starCount as AnyObject?
                post["stars"] = stars as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        // [END post_stars_transaction]
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
                let post = Post.init(snapshot: (dataSource?.snapshot(at: indexPath.row))!)
                
                // Avoid the app icon download if the app already has an icon
                if post?.uiimage == nil {
                    self.performUIUpdatesOnMain {
                        self.startIconDownload(post!, forIndexPath: indexPath)
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
    
    
    func getQuery() -> DatabaseQuery {
        let recentPostsQuery = (ref?.child("posts").queryLimited(toFirst: 100))!
        return(recentPostsQuery)
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
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "showComment":
            guard let postdetailVC = segue.destination as? ListCommentPostTableVC else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let commentButton = sender as? ButtonWithKey else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            let keyPost = commentButton.key
                        
            postdetailVC.key = keyPost
            
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    
     }
    
    
}
