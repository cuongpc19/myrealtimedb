//
//  FbLoginViewController.swift
//  myrealtimedb
//
//  Created by AgribankCard on 6/20/17.
//  Copyright © 2017 cuongpc. All rights reserved.
//

import UIKit
import Firebase
class FbLoginViewController: UIViewController , FBSDKLoginButtonDelegate{
        let loginButton = FBSDKLoginButton()
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            
            loginButton.setTitle("Đăng nhập với Facebook", for: .normal)
            loginButton.delegate = self
            loginButton.center = self.view.center
            
            loginButton.readPermissions = ["public_profile","email","user_friends"]
            self.view.addSubview(loginButton)
            
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
            if (FBSDKAccessToken.current() != nil) {
                //self.loginButton.isHidden = true
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                Auth.auth().signIn(with: credential) { (user, error) in
                    if let error = error {
                        print("error signin: \(error)")
                        return
                    }
                    print("User signin ....")
                    
                    
                   // let nav = self.navigationController
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ListPostTableViewController") as! ListPostTableViewController
                    
                    let navController = UINavigationController(rootViewController: vc)
                    
                    // 2. Present the navigation controller
                    
                    self.present(navController, animated: true, completion: nil)
                }
                
                
            }
        }
        
        
        /**
         Sent to the delegate when the button was used to logout.
         - Parameter loginButton: The button that was clicked.
         */
        func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                print("Sign out firebase")
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }

}
