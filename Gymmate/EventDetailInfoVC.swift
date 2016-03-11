//
//  EventDetailInfoVC.swift
//  Gymmate
//
//  Created by Trung Do on 3/10/16.
//  Copyright © 2016 TrungDo. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleMaps

class EventDetailInfoVC: UIViewController, GMSMapViewDelegate{
    
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var eventTypeImage: UIImageView!
    @IBOutlet weak var mapViewWindow: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    var mapView = GMSMapView()

    var ref =  Firebase(url:"https://gym8.firebaseio.com/listOfEvents/location");
    var eventID = String()
    var eventDate = String()

    override func viewDidLoad() {

        initializeText(eventDate, eventIDValue:  eventID)
    }
    
    func initializeText(eventDateValue: String, eventIDValue: String){
        var activityRef = self.ref.childByAppendingPath(eventDateValue)
        activityRef = activityRef.childByAppendingPath(eventIDValue)
        activityRef.observeEventType(.Value, withBlock: { snapshot in
            self.dateLabel.text = snapshot.value.objectForKey("date") as? (String)
            self.timeLabel.text = snapshot.value.objectForKey("time") as? String
            self.titleLabel.text = snapshot.value.objectForKey("routeDescription") as?
            String
            
            //create Sub- map
            let latitude = snapshot.value.objectForKey("latitude") as! CLLocationDegrees
            let longitude = snapshot.value.objectForKey("longitude") as! CLLocationDegrees
            let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.mapView.frame = CGRectMake(0,0, self.view.frame.width,self.mapViewWindow.frame.size.height)
            let camera = GMSCameraPosition.cameraWithLatitude(latitude, longitude:longitude, zoom: 15)
            self.mapView.camera = camera
            self.mapViewWindow.addSubview(self.mapView)
            let marker = GMSMarker(position: position)
            marker.icon = GMSMarker.markerImageWithColor(UIColor.blackColor())
            marker.map = self.mapView
            

            }, withCancelBlock: { error in
                print(error.description)
        })
        
       


//        let sydney = GMSCameraPosition.cameraWithLatitude(position.latitude, longitude: position.longitude, zoom: 6)
//        mapView.camera = sydney

    }
    @IBAction func tapJoinEvent(sender: AnyObject) {
        self.joinButton.animateButton(self.joinButton)
    }
}