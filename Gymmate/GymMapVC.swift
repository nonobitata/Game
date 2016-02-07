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

    @IBOutlet weak var mapView: GMSMapView!
    
    let addAnEventButton   = UIButton(type: UIButtonType.RoundedRect) as UIButton
    var ref = Firebase(url: "https://gym8.firebaseio.com/listOfEvents/location/gym")
    
    var addAnEventMode = false;
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
        self.mapView.delegate = self
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.myLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        self.mapView.settings.compassButton = true
        
        mapInitialize()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        //swipe right to open menu
        
    }
    func mapInitialize(){
        addAnEventButton.frame = CGRectMake(20 , 70, 50, 50)
        addAnEventButton.backgroundColor = UIColor.whiteColor()
        addAnEventButton.setTitle("Add", forState: UIControlState.Normal)
        addAnEventButton.addTarget(self, action: "tapAddEvent:", forControlEvents: UIControlEvents.TouchUpInside)
        self.mapView.addSubview(addAnEventButton)
        // Attach a closure to read the data at our posts reference
        ref.observeEventType(.Value, withBlock: { snapshot in
            let a  = snapshot.children
            for (child) in a.allObjects as![FDataSnapshot] {
                let tempLatitude = child.value.objectForKey("latitude") as!CLLocationDegrees
                let tempLongitude = child.value.objectForKey("longtitude") as! CLLocationDegrees
                let coordinate = CLLocationCoordinate2D(latitude: tempLatitude, longitude: tempLongitude)
                let  position = coordinate
                let marker = GMSMarker(position: position)
                marker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
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
            
        }
        else{
            addAnEventMode = false;
            addAnEventButton.backgroundColor = UIColor.whiteColor()
            
            
        }
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
            addDataToFirebase(position)
        }
    }
    func addDataToFirebase(position: CLLocationCoordinate2D){
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
    

    
    @IBAction func tapMoveToRunVC(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)

        
    }
    
}