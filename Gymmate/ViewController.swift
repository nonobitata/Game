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
    
    lazy var mapView = GMSMapView()
    let addAnEventButton   = UIButton(type: UIButtonType.RoundedRect) as UIButton
    let moveToGymVCButton   = UIButton(type: UIButtonType.RoundedRect) as UIButton
    let ref = Firebase(url: "https://gym8.firebaseio.com/listOfEvents/location/run")
    let addMarker = GMSMarker()
    var addAnEventMode = false;
    var tapLocation = CLLocationCoordinate2D()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        mapInitialize()

        addEventButtonInitialize()
        moveToGymVCButtonInitialize()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    func addEventButtonInitialize(){
        self.addAnEventButton.frame = CGRectMake(20 , 70, 50, 50)
        self.addAnEventButton.backgroundColor = UIColor.whiteColor()
        self.addAnEventButton.setTitle("Add", forState: UIControlState.Normal)
        self.addAnEventButton.addTarget(self, action: "tapAddEvent:", forControlEvents: UIControlEvents.TouchUpInside)
        self.mapView.addSubview(addAnEventButton)
        
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
                let tempLongitude = child.value.objectForKey("longitude") as! CLLocationDegrees
                let coordinate = CLLocationCoordinate2D(latitude: tempLatitude, longitude: tempLongitude)
                let  position = coordinate
                let marker = GMSMarker(position: position)
                marker.icon = GMSMarker.markerImageWithColor(UIColor.blackColor())
                let routeDescription = child.value.objectForKey("routeDescription") as! String
                marker.title = routeDescription
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
            let camera = GMSCameraPosition.cameraWithLatitude(coordinate.latitude-0.005, longitude: coordinate.longitude, zoom: 15)
            mapView.camera = camera
            let  position = coordinate
            addMarker.position =  position
            addMarker.map = self.mapView
            
            self.addAnEventMode = false
            self.addAnEventButton.backgroundColor = UIColor.whiteColor()
            createAnAddEventInfoView()
            self.tapLocation = coordinate
        }
    }
 
    func createAnAddEventInfoView(){
        let blurView = UIView(frame:CGRect(x:0, y:0, width:self.view.frame.width,height: self.view.frame.height))
        blurView.backgroundColor = UIColor.whiteColor()
        blurView.alpha = 0.30
        blurView.tag = 1
        self.view.insertSubview(blurView, atIndex: 3)
        
        let addInfo = AddEventView(frame:CGRect(x:0, y:self.view.frame.height/2, width:self.view.frame.width,height: self.view.frame.height/2))
        addInfo.tag = 2
        self.view.insertSubview(addInfo, atIndex:4)
        appearFromBottom(addInfo,animationTime:0.15)
        
        let cancel   = UIButton(type: UIButtonType.RoundedRect) as UIButton
        cancel.frame = CGRect(x:0, y:addInfo.frame.minY-50, width:self.view.frame.width/2,height: 50)
        cancel.tag = 3
        cancel.setTitle("Cancel", forState: UIControlState.Normal)
        cancel.backgroundColor = UIColor.lightGrayColor()
        cancel.addTarget(self, action: "cancelAddEvent:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.insertSubview(cancel, atIndex:5)
        appearFromBottom(cancel,animationTime:0.15)

        let agree   = UIButton(type: UIButtonType.RoundedRect) as UIButton
        agree.frame = CGRect(x:cancel.frame.maxX, y:addInfo.frame.minY-50, width:self.view.frame.width/2,height: 50)
        agree.tag = 4
        agree.setTitle("Agree", forState: UIControlState.Normal)
        agree.backgroundColor = UIColor.blueColor()
        agree.addTarget(self, action: "agreeAddEvent:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.insertSubview(agree, atIndex:6)
        appearFromBottom(agree,animationTime:0.15)

    }
    @IBAction func agreeAddEvent(sender: AnyObject) {
        let viewWithTag = self.view.viewWithTag(2) as! AddEventView
        addDataToFirebase(tapLocation, routeDescription: viewWithTag.routeDescriptionText.text)
        let dateRow = viewWithTag.dateTimePickerView.selectedRowInComponent(0)
        let hourRow =   viewWithTag.dateTimePickerView.selectedRowInComponent(1)
        let minuteRow =  viewWithTag.dateTimePickerView.selectedRowInComponent(2)
        let ampmRow =  viewWithTag.dateTimePickerView.selectedRowInComponent(3)
        print(viewWithTag.dateArray[dateRow],viewWithTag.hourArray[hourRow],
            viewWithTag.minuteArray[minuteRow],viewWithTag.ampmArray[ampmRow])
        
        
        
        dismissAllAddView()
    }
    func dismissAllAddView(){
        addMarker.map = nil

        
        if let viewWithTag = self.view.viewWithTag(1) {
            viewWithTag.removeFromSuperview()
        }else{
            print("No!")
        }
        for index in 2...4{
            if let viewWithTag = self.view.viewWithTag(index) {
                disapprearToBottom(viewWithTag,animationTime: 1)
            }
        }
    }
    @IBAction func cancelAddEvent(sender: AnyObject) {
        dismissAllAddView()

    }
    
    func addDataToFirebase(position: CLLocationCoordinate2D, routeDescription: NSString){
        let info = ["latitude":position.latitude,"longitude":position.longitude,"routeDescription":routeDescription]
        let locationRef = self.ref.childByAutoId()
        locationRef.setValue(info)
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
    func appearFromBottom(view: UIView, animationTime: Float){
        var animation:CATransition = CATransition()
        animation.duration = CFTimeInterval(animationTime)
        animation.type = "moveIn"
        animation.timingFunction = CAMediaTimingFunction(name:"easeInEaseOut")
        animation.subtype = "fromTop"
        animation.fillMode = "forwards"
        view.layer.addAnimation(animation, forKey: nil)
    }
    func disapprearToBottom(view: UIView, animationTime: NSTimeInterval){
        UIView.animateWithDuration(animationTime, animations:  {() in
            view.center.y = +2000
            }, completion:{(Bool)  in
                view.removeFromSuperview()
        })
    }
    
    
    
}

