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
    override func viewDidLoad() {
        if ((self.ref.authData) != nil){
            authenticateUser()
        }
    }
    func authenticateUser(){
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logInWithReadPermissions(["email"], fromViewController:self.parentViewController, handler: {
            (facebookResult, facebookError) -> Void in
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled {
                print("Facebook login was cancelled.")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                self.ref.authWithOAuthProvider("facebook", token: accessToken,
                    withCompletionBlock: { error, authData in
                        if error != nil {
                            print("Login failed. \(error)")
                        } else {
                            print("Logged in! \(authData)")
                        }
                })
            }
        })
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
}
    