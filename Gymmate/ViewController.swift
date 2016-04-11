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
import GeoFire

class ViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {
    
    lazy var mapView = GMSMapView()
    let addAnEventButton   = UIButton(type: UIButtonType.RoundedRect) as UIButton
    let myLocButton   = UIButton(type: UIButtonType.RoundedRect) as UIButton

    let ref = Firebase(url: "https://gym8.firebaseio.com/listOfEvents/location")
    let addMarker = GMSMarker()
    var addAnEventMode = false;
    var tapLocation = CLLocationCoordinate2D()
    let locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient?
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    

    
    func tryToPrintAllCoffeePlaces(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let southWest = CLLocationCoordinate2D(latitude: 40.712216, longitude: -74.22655)
        let northEast = CLLocationCoordinate2D(latitude: 40.773941, longitude: -74.12544)
        let overlayBounds = GMSCoordinateBounds(coordinate: southWest, coordinate: northEast)
        
        // Image from http://www.lib.utexas.edu/maps/historical/newark_nj_1922.jpg
        let icon = UIImage(named: "markerInfoWindow.png")
        
        let overlay = GMSGroundOverlay(bounds: overlayBounds, icon: icon)
        overlay.bearing = 0
        overlay.map = mapView
        
        let urlString = String(format: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=8000&type=gym&key=AIzaSyAg3I88OaaBJGcZCTApMdYvJfhGLUjmAY8",latitude,longitude)
        print (urlString)
        let requestURL: NSURL = NSURL(string: urlString)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                    do{
                        
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    
                        if let stations = json["results"] as? [[String: AnyObject]] {
                            
                            for station in stations {
                                let dictionary = station as NSDictionary
                                let lat = dictionary.valueForKeyPath("geometry.location.lat") as! NSNumber
                                let long = dictionary.valueForKeyPath("geometry.location.lng") as! NSNumber
                                
                                let circleCenter = CLLocationCoordinate2D(latitude: Double(lat), longitude: Double(long))
//                                let circ = GMSCircle(position: circleCenter, radius: 20)
//                                circ.fillColor = UIColor.redColor()
//                                circ.map = self.mapView;
                                var myData = Dictionary<String, String>()
                                myData["placeName"] = (dictionary.valueForKeyPath("name") as! String)
                                myData["placeAddress"] = (dictionary.valueForKeyPath("vicinity") as! String)
                                myData["placeImageReference"]  = ""

                                if dictionary["photos"] != nil {
                                    if  let k = dictionary["photos"]![0]["photo_reference"] {
                                        myData["placeImageReference"] = k as? String
                                    }
                                    else{
                                     print("KAKAKA")
                                    }
                                }
                                
                                

                                let marker = GMSMarker(position: circleCenter)
                                //xmarker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
                                marker.appearAnimation = kGMSMarkerAnimationPop
                                marker.userData = myData
                                marker.title = "suggestedLocation"
                                marker.icon = UIImage(named: "suggestedLocationMarker1")
                                marker.map = self.mapView
                                if let name = station["id"] as? String {
                                    
                                    print (name)
                                    
                                }
                            }
                            
                        }
                        
                    }catch {
                        print("Error with Json: \(error)")
                    }
                
            }
        }
        task.resume()
        
    }
    @IBAction func myLocation(sender: AnyObject) {
        placesClient?.currentPlaceWithCallback({
        (placeLikelihoodList: GMSPlaceLikelihoodList?, error: NSError?) -> Void in
        if let error = error {
            print("Pick Place error: \(error.localizedDescription)")
            return
        }
        
        
        
        if let placeLikelihoodList = placeLikelihoodList {
            let place = placeLikelihoodList.likelihoods.first?.place
            if let place = place {
                print(place.name)
               print(place.formattedAddress!.componentsSeparatedByString(", ").joinWithSeparator("\n"))
            }
        }
    })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        placesClient = GMSPlacesClient()
        addEventButtonInitialize()
        addMyLocInitialize()
       // self.navigationController?.setNavigationBarHidden(true, animated: true)
       // self.tabBarController?.title = "Maps"

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        mapInitialize()

    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {

        if (marker.title == "eventPoint"){
            let markerInfoWindow = infoWindowMapView(frame:CGRect(x: 0, y: 0, width: 230, height: 120))
            markerInfoWindow.setUpInformation( marker.userData["routeDescription"] as! String , eventID:marker.userData["eventID"] as! String, date: marker.userData["date"] as! String, time:marker.userData["time"] as! String, creator:  marker.userData["creatorID"] as! String)
            return markerInfoWindow

        }
        else
            if (marker.title == "suggestedLocation"){
                let markerInfoWindow = infoWindowSuggestedLocation(frame:CGRect(x: 0, y: 0, width: 230, height: 120))
                markerInfoWindow.setUpInformation(marker.userData["placeName"] as! String, address: marker.userData["placeAddress"] as! String, imageReference: marker.userData["placeImageReference"]! as! String)
                return markerInfoWindow
            }
        return nil
        }

    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        print("haha")
        moveToEventDescriptionVC(marker.userData["date"] as! String
            , eventID: marker.userData["eventID"] as! String)
        
    }
    func addEventButtonInitialize(){
        self.addAnEventButton.frame = CGRectMake(20 , 20+66, 50, 50)
        self.addAnEventButton.backgroundColor = UIColor.whiteColor()
        self.addAnEventButton.setTitle("Add", forState: UIControlState.Normal)
        self.addAnEventButton.addTarget(self, action: #selector(ViewController.tapAddEvent(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.mapView.addSubview(addAnEventButton)
        
    }
    func addMyLocInitialize(){
        self.myLocButton.frame = CGRectMake(100 , 20+66, 50, 50)
        self.myLocButton.backgroundColor = UIColor.whiteColor()
        self.myLocButton.setTitle("Loc", forState: UIControlState.Normal)
    //    self.myLocButton.addTarget(self, action: #selector(ViewController.pickPlace(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.mapView.addSubview(myLocButton)
        
    }
    
    

    func mapInitialize(){
        
        self.mapView.delegate = self
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.frame = CGRectMake(0,0, self.view.frame.width,(self.view.frame.height-(self.tabBarController?.tabBar.frame.size.height)!))
        self.mapView.myLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        self.mapView.settings.compassButton = true
        self.mapView.settings.consumesGesturesInView = false
        self.view.insertSubview(mapView, atIndex: 0)
        
        let current = NSDate()
        let today = current.toDate() 
        var nextDate = NSDate()
        nextDate = current.dateByAddingTimeInterval(60*60*24*1)
        let nextDateText = nextDate.toDate()
        initializeLocations(today)
        initializeLocations(nextDateText)
        

    
    }
    func initializeLocations(date:String!){
        let tempRef = ref.childByAppendingPath(date)
        tempRef.observeEventType(.Value, withBlock: { snapshot in
            let a  = snapshot.children
            for (child) in a.allObjects as![FDataSnapshot] {
                var myData = Dictionary<String, String>()
                myData["eventID"] = child.key
                myData["date"] = child.value.objectForKey("date") as? String
                myData["time"] = child.value.objectForKey("time") as? String
                myData["creatorID"] = child.value.objectForKey("creatorID") as? String
                let tempLatitude = child.value.objectForKey("latitude") as!CLLocationDegrees
                let tempLongitude = child.value.objectForKey("longitude") as! CLLocationDegrees
                let coordinate = CLLocationCoordinate2D(latitude: tempLatitude, longitude: tempLongitude)
                let  position = coordinate
                let marker = GMSMarker(position: position)
                marker.icon = GMSMarker.markerImageWithColor(UIColor.blackColor())
                myData["routeDescription"] = child.value.objectForKey("routeDescription") as? String
                marker.appearAnimation = kGMSMarkerAnimationPop
                marker.userData = myData
                marker.title = "eventPoint"
                marker.map = self.mapView
            }
            
            }, withCancelBlock: { error in
                print(error.description)
        })

    }
    func moveToEventDescriptionVC(date: String, eventID: String){
        let viewController = EventDetailInfoVC(nibName: "EventDetailInfoVC", bundle: nil)
        viewController.eventDate = date
        viewController.eventID = eventID
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func tapAddEvent(sender: AnyObject) {
        self.addAnEventButton.animateButton(self.addAnEventButton)
        if (self.ref.authData != nil){
            if (!addAnEventMode){
                addAnEventMode = true;
                addAnEventButton.backgroundColor = UIColor.redColor()

            }
            else{
                addAnEventMode = false;
                addAnEventButton.backgroundColor = UIColor.whiteColor()
            
            }
        }
        else{
            let alert = UIAlertController(title: "Login", message: "Login to create an event", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
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
        
        let addInfo = AddEventView(frame:CGRect(x:0, y:self.view.frame.height/2-(self.tabBarController?.tabBar.frame.size.height)!, width:self.view.frame.width,height: self.view.frame.height/2+(self.tabBarController?.tabBar.frame.size.height)!))
        addInfo.tag = 2
        addInfo.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
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
        let addView = self.view.viewWithTag(2) as! AddEventView
        let info = ["latitude":tapLocation.latitude,"longitude":tapLocation.longitude,"routeDescription":addView.routeDescriptionText.text,"type":addView.currentActivity,"date":addView.currentDate, "time":addView.currentTime,"creatorID":ref.authData.uid]
        addDataToFirebase(info)
    
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
    
    func addDataToFirebase(setOfData:NSDictionary){
        let activityType = setOfData.objectForKey("date") as! String
        let activityRef = self.ref.childByAppendingPath(activityType)
        let locationRef = activityRef.childByAutoId()
        locationRef.setValue(setOfData)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations:[CLLocation]){
        let location = locations.last
        let camera = GMSCameraPosition.cameraWithLatitude(location!.coordinate.latitude, longitude: location!.coordinate.longitude, zoom: 12)
        //        let region = MKCoordinateRegion(center: center , span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        mapView.camera = camera
        

        self.locationManager.stopUpdatingLocation()
        self.tryToPrintAllCoffeePlaces(location!.coordinate.latitude, longitude: location!.coordinate.longitude)

    }
    func appearFromBottom(view: UIView, animationTime: Float){
        let animation:CATransition = CATransition()
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