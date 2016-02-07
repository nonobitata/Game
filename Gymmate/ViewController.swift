//
//  ViewController.swift
//  Gym8
//
//  Created by Trung Do on 1/30/16.
//  Copyright © 2016 TrungDo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import Firebase


class ViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var addEventInfo: AddEventView!
    lazy var mapView = GMSMapView()
    let addAnEventButton   = UIButton(type: UIButtonType.RoundedRect) as UIButton
    let moveToGymVCButton   = UIButton(type: UIButtonType.RoundedRect) as UIButton
    var ref = Firebase(url: "https://gym8.firebaseio.com/listOfEvents/location/run")
    
    var addAnEventMode = false;
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        mapInitialize()
       //
        addEventButtonInitialize()
        moveToGymVCButtonInitialize()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        
    }
    func addEventButtonInitialize(){
        self.addAnEventButton.frame = CGRectMake(20 , 70, 50, 50)
        self.addAnEventButton.backgroundColor = UIColor.whiteColor()
        self.addAnEventButton.setTitle("Add", forState: UIControlState.Normal)
        self.addAnEventButton.addTarget(self, action: "tapAddEvent:", forControlEvents: UIControlEvents.TouchUpInside)
        self.mapView.addSubview(addAnEventButton)
        
        
        self.addEventInfo.frame = CGRectMake(0,self.mapView.frame.height/2, self.view.frame.width,(self.view.frame.height/2))
        self.view.insertSubview(addEventInfo, atIndex:2)
        self.addEventInfo.hidden = true

    
    }
    
    func moveToGymVCButtonInitialize(){

        self.moveToGymVCButton.frame = CGRectMake(self.mapView.frame.width/2,self.mapView.frame.height, self.view.frame.width/2,(self.view.frame.height)/4)
        self.moveToGymVCButton.backgroundColor = UIColor.grayColor()

        self.moveToGymVCButton.setTitle("Next", forState: UIControlState.Normal)
        self.moveToGymVCButton.addTarget(self, action: "tapMoveToGymVC:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.insertSubview(moveToGymVCButton, atIndex:1)
    }
    func mapInitialize(){
        
        self.mapView.delegate = self
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.frame = CGRectMake(0,0, self.view.frame.width,(self.view.frame.height*3)/4)
        self.mapView.myLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        self.mapView.settings.compassButton = true
        self.mapView.settings.consumesGesturesInView = false
        self.view.insertSubview(mapView, atIndex: 0)
        

        ref.observeEventType(.Value, withBlock: { snapshot in
            let a  = snapshot.children
            for (child) in a.allObjects as![FDataSnapshot] {
                let tempLatitude = child.value.objectForKey("latitude") as!CLLocationDegrees
                let tempLongitude = child.value.objectForKey("longtitude") as! CLLocationDegrees
                let coordinate = CLLocationCoordinate2D(latitude: tempLatitude, longitude: tempLongitude)
                let  position = coordinate
                let marker = GMSMarker(position: position)
                marker.icon = GMSMarker.markerImageWithColor(UIColor.blackColor())
                marker.title = "Hello World"
                marker.map = self.mapView
                
            }
            

            
        }, withCancelBlock: { error in
                print(error.description)
        })
    }
    @IBAction func tapAddEvent(sender: AnyObject) {
        if (!addAnEventMode){
            addAnEventMode = true;
            addAnEventButton.backgroundColor = UIColor.redColor()
           // addEventInfo.hidden = false

        }
        else{
            addAnEventMode = false;
            addAnEventButton.backgroundColor = UIColor.whiteColor()
            addEventInfo.hidden = true


        }
    }
    @IBAction func tapMoveToGymVC(sender: AnyObject) {
        let gymVC = self.storyboard?.instantiateViewControllerWithIdentifier("GymVC") as? GymMapVC
        print("a")
        self.navigationController?.pushViewController(gymVC!, animated: true)
    }
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        NSLog("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    func mapView(mapView: GMSMapView!, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D) {
        if(addAnEventMode)
        {
            let  position = coordinate
            let marker = GMSMarker(position: position)
            marker.title = "Hello World"
            marker.map = self.mapView
            //addDataToFirebase(position)
            test()
            addAnEventMode = false
            addAnEventButton.backgroundColor = UIColor.whiteColor()
            addEventInfo.hidden = false
         appearFromBottom(self.addEventInfo,animationTime:1.0)
            

        }
    }
    func appearFromBottom(view: UIView, animationTime: Float){
        var animation:CATransition = CATransition()
        animation.duration = CFTimeInterval(animationTime)
        animation.type = "moveIn"
        animation.timingFunction = CAMediaTimingFunction(name:"easeInEaseOut")
        animation.subtype = "fromBottom"
        animation.fillMode = "forwards"
        view.layer.addAnimation(animation, forKey: nil)
    }
    func test(){
        var description = self.addEventInfo.routeDescriptionText.text;
           print(description)
    }
    @IBAction func tapConfirmAddEvent(sender: AnyObject) {
        var description = self.addEventInfo.routeDescriptionText.text;
        var date = self.addEventInfo.dateTimePickerView.description
        print(date)
    }
    
    func addDataToFirebase(position: CLLocationCoordinate2D, routeDescription: NSString, duration: NSInteger){
        let location = ["latitude":position.latitude,"longtitude":position.longitude]
        let locationRef = self.ref.childByAutoId()
        locationRef.setValue(location)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations:[CLLocation]){
        let location = locations.last
        let camera = GMSCameraPosition.cameraWithLatitude(location!.coordinate.latitude, longitude: location!.coordinate.longitude, zoom: 15)
        //        let region = MKCoordinateRegion(center: center , span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        mapView.camera = camera
        
        
        self.locationManager.stopUpdatingLocation()
    }
    
    
}

