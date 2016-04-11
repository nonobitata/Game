//
//  infoWindowSuggestedLocation.swift
//  Gymmate
//
//  Created by Trung Do on 4/11/16.
//  Copyright © 2016 TrungDo. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class infoWindowSuggestedLocation : UIView{
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var placeImage: UIImageView!
    
    @IBOutlet var view: UIView!
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setUp()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
        
    }
    func setUpInformation(name: String, address: String, imageReference: String){
        self.placeNameLabel.text = name
        self.addressLabel.text = address
        if (imageReference != "")
        {
            
            let urlString = String(format: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=230&maxheight=120&photoreference=\(imageReference)&key=AIzaSyAg3I88OaaBJGcZCTApMdYvJfhGLUjmAY8")
            print ("URL: ",urlString)
            let url = NSURL(string: urlString )
            print ("data:", url)
            let data = NSData(contentsOfURL: url!)
            self.placeImage.image = UIImage(data: data!)
            //self.placeImage.contentMode = .ScaleAspectFit

        }

        
    }
    
    func setUp(){
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth,UIViewAutoresizing.FlexibleHeight]
        
        addSubview(view);
        
    }
    func loadViewFromNib()->UIView
    {
        let bundle =  NSBundle(forClass: self.dynamicType)
        //.mainBundle().loadNibNamed("AddEventView", owner: self, options: nil)
        let nib = UINib(nibName: "infoWindowSuggestedLocation", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.layer.cornerRadius = 15.0;
        view.layer.masksToBounds = true
        
        return view
    }
    

}
