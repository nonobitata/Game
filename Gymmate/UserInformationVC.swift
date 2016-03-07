//
//  UserInformationVC.swift
//  Gymmate
//
//  Created by Trung Do on 2/14/16.
//  Copyright © 2016 TrungDo. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class UserInformationVC: UIViewController{
    var ref =  Firebase(url:"https://gym8.firebaseio.com");
//    override func viewDidAppear(animated: Bool) {
//        if ((self.ref.authData) == nil){
//        }
//    }
    override func viewDidLoad() {
       // if ((self.ref.authData) == nil){
        authenticateUser()

        showLoginView()
        showUserInfoView()

    }
    func showLoginView(){
        print("haha")
        print("%d %d",self.view.frame.width, self.view.frame.height)
        let loginView = LoginIntroView(frame:CGRect(x:0, y:0, width:self.view.frame.width,height: self.view.frame.height))
        loginView.tag = 2
        self.view.addSubview(loginView)
    }
    func showUserInfoView(){
        let userInfoView = UserInfoView(frame:CGRect(x:0, y:66, width:self.view.frame.width,height: self.view.frame.height))
        userInfoView.tag = 2
        self.view.addSubview(userInfoView)
        
    }
    func authenticateUser(){
        let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
        self.ref.authWithOAuthProvider("facebook", token: accessToken,
            withCompletionBlock: { error, authData in
                if error != nil {
                    self.showLoginView()
                } else {
                    print("Logged in! \(authData)")
                    let newUser = [
                        "provider": authData.provider,
                        "displayName": authData.providerData["displayName"] as? NSString as? String
                    ]
                    let userRef = self.ref.childByAppendingPath("users")
                    userRef.childByAppendingPath(authData.uid).setValue(newUser)
                }
        })

//        let facebookLogin = FBSDKLoginManager()
//        facebookLogin.logInWithReadPermissions(["email"], fromViewController:self.parentViewController, handler: {
//            (facebookResult, facebookError) -> Void in
//            if facebookError != nil {
//                print("Facebook login failed. Error \(facebookError)")
//            } else if facebookResult.isCancelled {
//                print("Facebook login was cancelled.")
//            } else {
//                            }
//        })
//        let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
//
//        ref.authWithOAuthProvider("facebook", token: accessToken,
//            withCompletionBlock: { error, authData in
//                if error != nil {
//        let loginVC: UIViewController = UIViewController(nibName: "LoginIntroVC", bundle: nil)
//        loginVC.view.backgroundColor = UIColor.whiteColor()
//        self.navigationController?.pushViewController(loginVC, animated: true)
//
//                } else {
//                    print(authData.providerData["displayName"])
//                    print("Logged in! \(authData)")
//                }
//        })
    }
    func findUserInfo(){
        let userRef = ref.childByAppendingPath("userInformation")
        userRef.observeEventType(.Value, withBlock: { snapshot in
            let a  = snapshot.children
            let accessID = self.ref.authData.providerData["id"] as! String
            var found = false
            for (child) in a.allObjects as![FDataSnapshot] {
                print(child)
            }
            if (found){
                print("haha")
            }
            else {
                let k = userRef.childByAppendingPath(accessID)
                k.setValue("10")
            }
            
            }, withCancelBlock: { error in
                print(error.description)
        })

    }
}
    