//
//  LoginIntroVC.swift
//  Gymmate
//
//  Created by Trung Do on 3/4/16.
//  Copyright © 2016 TrungDo. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class LoginIntroVC: UIViewController{
    var ref =  Firebase(url:"https://gym8.firebaseio.com");
    override func viewDidLoad(){
        
    }
    
    @IBAction func tapCloseView(sender: AnyObject) {
     self.navigationController?.popViewControllerAnimated(true)
    }
}