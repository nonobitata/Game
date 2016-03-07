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


class UserInfoView: UIView{
    
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
    func loadFriendList(){
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"friends"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else if (error == nil)
            {
                print("friends are: \(result)")
            }
        })
    }
    func setUp(){
        view = loadViewFromNib()
        view.frame = bounds
        self.addSubview(self.view);
        let url = NSURL(string: self.ref.authData.providerData["profileImageURL"] as! String)
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        self.userImage.contentMode = .ScaleAspectFit
        self.userImage.image =  UIImage(data: data!)
        self.userName.text = self.ref.authData.providerData["displayName"] as! String
        loadFriendList()
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