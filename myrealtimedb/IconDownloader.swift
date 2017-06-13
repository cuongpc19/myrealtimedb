//
//  IconDownloader.swift
//  myrealtimedb
//
//  Created by AgribankCard on 6/11/17.
//  Copyright © 2017 cuongpc. All rights reserved.
//

import Foundation
import UIKit
import Firebase
public let kAppIconSize  = CGFloat(150)
class IconDownloader : NSObject, NSURLConnectionDataDelegate {
    
    var post: Post?
    var completionHandler: (() -> Void)?
    private var sessionTask: URLSessionDataTask?
    var storageRef: StorageReference!
    func startDownload() {
        let storage = Storage.storage()
        storageRef = storage.reference()
        let starsRef = self.storageRef.child("images").child((post?.image)!)
        starsRef.downloadURL { url, error in
            if let error = error {
                print("Downloadurl error")
            } else {
                //self.post?.image = (url?.absoluteString)!
                let request = URLRequest(url: URL(string: (url?.absoluteString)!)!)
                //print("url String: \(self.post?.image)")
                // create an session data task to obtain and download the app icon
                self.sessionTask = URLSession.shared.dataTask(with: request, completionHandler: {
                    data, response, error in
                    
                    // in case we want to know the response status code
                    //let httpStatusCode = (response as! HTTPURLResponse).statusCode
                    
                    if let actualError = error as NSError? {
                        if #available(iOS 9.0, *) {
                            if actualError.code == NSURLErrorAppTransportSecurityRequiresSecureConnection {
                                abort()
                            }
                        }
                    }
                    OperationQueue.main.addOperation{
                        // Set appIcon and clear temporary data/image
                        NSLog("icon object download complete" )
                        let image = UIImage(data: data!)
                        if (image!.size.width != kAppIconSize || image?.size.height != kAppIconSize)
                        {
                            let itemSize = CGSize(width: kAppIconSize, height: kAppIconSize)
                            UIGraphicsBeginImageContextWithOptions(itemSize, false, 0.0)
                             let imageRect = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
                            //[image drawInRect:imageRect];
                            image?.draw(in: imageRect)
                            self.post?.uiimage = UIGraphicsGetImageFromCurrentImageContext();
                            UIGraphicsEndImageContext();
                        }
                        else
                        {
                            self.post?.uiimage = image;
                        }
                        
                        //self.post?.uiimage = data
                        
                        
                        self.completionHandler?()
                    }
                })
                self.sessionTask?.resume()

            }
        }
    }
    func cancelDownload() {
        self.sessionTask?.cancel()
        sessionTask = nil
    }
    
}
