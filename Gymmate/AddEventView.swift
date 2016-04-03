//
//  AddEventView.swift
//  Gymmate
//
//  Created by Trung Do on 2/4/16.
//  Copyright © 2016 TrungDo. All rights reserved.
//

import Foundation
import UIKit

class AddEventView: UIView,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate {
    
    @IBOutlet var view: UIView!
   
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var activityTypeLabel: UILabel!
    @IBOutlet weak var dateTimePickerView: UIPickerView!
    @IBOutlet weak var routeDescriptionText: UITextView!
    
    var dateArray = [String]()
    var timeFullArray = [String] ()
    var timeTodayArray = [String] ()
    
    
    var selectedDate: String = "Today"
    var currentActivity: String = "Run/Jog"
    var currentDate: String = ""
    var currentTime: String = ""
        required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
           setUp()
            
            //setUpPickerView()
        }
    
    @IBAction func activitySegmentChange(sender: AnyObject) {
        let activitySegment: UISegmentedControl = sender as! UISegmentedControl
        
        switch (activitySegment.selectedSegmentIndex){
        case 0:
            currentActivity = "Run/Jog"
            break
        case 1:
            currentActivity = "Gym/Weight"
            break
        case 2:
            currentActivity = "Soccer"
            break
        case 3:
            currentActivity = "Football"
            break;
        case 4:
            currentActivity = "Basketball"
            break;
        case 5:
            currentActivity = "Tenis"
            break;
        case 6:
            currentActivity = "Badminton"
            break;
        case 7:
            currentActivity = "Ping pong"
            break;
        default:
            break;
            
        }
        self.activityTypeLabel.text =  self.currentActivity;
    }
    func setUpDateTimeArray(){
        let current = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: current)
        self.currentDate = current.toDate()
        self.currentTime = "HH:MM"
        
        let hour = components.hour
        print(hour)
        
        if (hour >= 23){
            dateArray.append("Tomorrow")
        }
        else
        {
            dateArray.append("Today")
            dateArray.append("Tomorrow")
        }
        
        for i in 0...23{
            var k: Int = 0;
            let tempHour: String = String(i)
            while(k < 60){
                var tempMinute: String = ""
                if (k == 0){ tempMinute = "0" + String(k)}
                else { tempMinute = String(k) }

                let tempString = tempHour + ":" + tempMinute
                timeFullArray.append(tempString)
                k += 15
            }
        }
        selectedDate = "Tomorrow"
        if (dateArray.count == 2){
            for i in hour+1...23{
                var k: Int = 0;
                let tempHour: String = String(i)
                while(k < 60){
                    var tempMinute: String = ""
                    
                    if (k == 0){ tempMinute = "0" + String(k)}
                    else {tempMinute = String(k)}
                    
                    let tempString = tempHour + ":" + tempMinute
                    timeTodayArray.append(tempString)
                    k += 15
                }
            }
            selectedDate = "Today"
            
        }
        
        
    }
    // for this to work programmatically I had to do the same...
    override init(frame: CGRect) {
        super.init(frame: frame)
       // NSBundle.mainBundle().loadNibNamed("AddEventView", owner: self, options: nil)
        setUp()

    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (component == 0){
            selectedDate = dateArray[row];
            let current = NSDate()
            if (selectedDate == "Today"){
                self.currentDate = current.toDate()
            }
            else{
                var nextDate = NSDate()
                nextDate = current.dateByAddingTimeInterval(60*60*24*1)
                self.currentDate = nextDate.toDate()
            }
            pickerView.reloadComponent(1)
        }
        
        if (selectedDate == "Today"){
            self.currentTime = timeTodayArray[self.dateTimePickerView.selectedRowInComponent(1)]
        }
        else{
            self.currentTime = timeFullArray[self.dateTimePickerView.selectedRowInComponent(1)]

        }
        let timeToBeShow: String = self.selectedDate + "(" +  self.currentDate + ")"
        self.dateTimeLabel.text = timeToBeShow + " at " + self.currentTime



    }
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        switch(component){
//        case 0:
//            return dateArray[row]
//        case 1:
//            if (selectedDate == "Today"){
//                return timeTodayArray[row]
//            }
//            else{
//                return timeFullArray[row]
//            }
//        default:
//            break;
//        }
//        return "";
//    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2;
        
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch(component){
        case 0:
            return dateArray.count;
        case 1:
            if (selectedDate == "Tomorrow"){
                return timeFullArray.count
            }
            else{
                return timeTodayArray.count

            }
        default:
            break;
        }
        return 0;
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var tempString: String = ""
        switch(component){
        case 0:
            tempString =  dateArray[row]
        case 1:
            if (selectedDate == "Today"){
                tempString = timeTodayArray[row]
            }
            else{
                tempString =  timeFullArray[row]
            }
        default:
            break;
        }
        return NSAttributedString(string: tempString, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
    func setUp(){
        view = loadViewFromNib()
        view.frame = bounds

        self.addSubview(self.view);
        setUpDateTimeArray()
        
        //show default activity label
        self.activityTypeLabel.text = self.currentActivity
        
        //Show default Time label
        let timeToBeShow: String = self.selectedDate + "(" +  self.currentDate + ")"
        self.dateTimeLabel.text = timeToBeShow + " at " + self.currentTime
        
        
        self.routeDescriptionText.delegate = self
        self.dateTimePickerView.delegate = self
        self.dateTimePickerView.dataSource = self
    }
    func loadViewFromNib()->UIView
    {
        let bundle =  NSBundle(forClass: self.dynamicType)
            //.mainBundle().loadNibNamed("AddEventView", owner: self, options: nil)
        let nib = UINib(nibName: "AddEventView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
}
