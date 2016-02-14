//
//  GymMapVC.swift
//  Gymmate
//
//  Created by Trung Do on 2/4/16.
//  Copyright © 2016 TrungDo. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import Firebase

class GymMapVC: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapMoveToRunVC(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)

        
    }
    
}