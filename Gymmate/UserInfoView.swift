//
//  UserInfoView.swift
//  Gymmate
//
//  Created by Trung Do on 3/6/16.
//  Copyright © 2016 TrungDo. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FBSDKShareKit
import FBSDKLoginKit


class UserInfoView: UIView{
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet var view: UIView!
    
    var ref =  Firebase(url:"https://gym8.firebaseio.com");
    
    func loadViewFromNib()->UIView
    {
        let bundle =  NSBundle(forClass: self.dynamicType)
        //.mainBundle().loadNibNamed("AddEventView", owner: self, options: nil)
        let nib = UINib(nibName: "UserInfoView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
//    func loadFriendList(){
//        let params = ["fields": "id, first_name, last_name, middle_name, name, email, picture"]
//        let request = FBSDKGraphRequest(graphPath: "me/taggable_friends?limit=1000", parameters: params)
//        request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
//            
//            if error != nil {
//                /* Handle error */
//            }
//            else if result.isKindOfClass(NSDictionary){
//                /*  handle response */
//                //print(result)
//                let friends = NSMutableArray()
//                let array = result.objectForKey("data")
//                friends.addObject((array?.objectAtIndex(0))!)
//                if (array!.count > 0) {
//                    for index in 1...array!.count-1 {
//                        friends.addObject((array?.objectAtIndex(index))!)
//                        print((friends.objectAtIndex(index)).objectForKey("first_name"))
//                    }
//                }
//                print(friends.count)
//            }
//        }
//       // print(self.ref.authData.providerData["id"])
//    }
    func setUp(){
        view = loadViewFromNib()
        view.frame = bounds
        self.addSubview(self.view);
        self.loginView.hidden = true

        if (self.ref.authData != nil){
            loadInfo()
        }
        else{
            self.loginView.hidden = false;
        }
       // loadFriendList()
    }
    
    @IBAction func tapLogOut(sender: AnyObject) {
        self.ref.unauth()
        self.loginView.hidden = false
        
    }
    func authenticateUser(){
        let facebookLogin = FBSDKLoginManager()
        if (FBSDKAccessToken.currentAccessToken() == nil){
        facebookLogin.logInWithReadPermissions(["email","user_friends","public_profile"], handler: {
                    (facebookResult, facebookError) -> Void in
                    if facebookError != nil {
                        print("Facebook login failed. Error \(facebookError)")
                    } else if facebookResult.isCancelled {
                        print("Facebook login was cancelled.")
                    } else {
                                    }
        })
        }
        else{
            facebookLogin.logInWithReadPermissions(["email","user_friends","public_profile"], handler: {
                (facebookResult, facebookError) -> Void in
                if facebookError != nil {
                    print("Facebook login failed. Error \(facebookError)")
                } else if facebookResult.isCancelled {
                    print("Facebook login was cancelled.")
                } else {
                }
            })

        let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
        self.ref.authWithOAuthProvider("facebook", token: accessToken,
            withCompletionBlock: { error, authData in
                if error != nil {
                } else {
                    print("Logged in! \(authData)")
                    let newUser = [
                        "provider": authData.provider,
                        "displayName": authData.providerData["displayName"] as? NSString as? String,
                    ]
                    let userRef = self.ref.childByAppendingPath("users")
                    userRef.childByAppendingPath(authData.uid).setValue(newUser)
                    self.loadInfo()

                }
        })
        }
    }
    @IBAction func tapLogIn(sender: AnyObject) {
        authenticateUser()
        self.loginView.hidden = true;
    }
    func loadInfo(){
        let url = NSURL(string: self.ref.authData.providerData["profileImageURL"] as! String)
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        self.userImage.contentMode = .ScaleAspectFit
        self.userImage.image =  UIImage(data: data!)
        self.userName.text = self.ref.authData.providerData["displayName"] as? String

    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setUp()
    }

}