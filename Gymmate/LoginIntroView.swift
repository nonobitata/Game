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

class LoginIntroView: UIView{
    var ref =  Firebase(url:"https://gym8.firebaseio.com");
    @IBOutlet var view: UIView!
    
    func loadViewFromNib()->UIView
    {
        let bundle =  NSBundle(forClass: self.dynamicType)
        //.mainBundle().loadNibNamed("AddEventView", owner: self, options: nil)
        let nib = UINib(nibName: "LoginIntroView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    func setUp(){
        view = loadViewFromNib()
        view.frame = bounds
        self.addSubview(self.view);

        
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