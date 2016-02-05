//
//  AddEventView.swift
//  Gymmate
//
//  Created by Trung Do on 2/4/16.
//  Copyright © 2016 TrungDo. All rights reserved.
//

import Foundation
import UIKit

class AddEventView: UIView,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var routeDescriptionText: UITextView!
    @IBOutlet weak var pickerActivateButton: UIButton!
    @IBOutlet weak var dateTimePickerView: UIPickerView!
    @IBOutlet weak var addressText: UITextView!
    var dateArray = ["Today","Tomorrow"];
    var hourArray = ["1","2","3","4","5","6","7","8","9","10","11","12"];
    var minuteArray = ["00","15","30","45"];
    var ampmArray = ["AM","PM"];

        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)!
            NSBundle.mainBundle().loadNibNamed("AddEventView", owner: self, options: nil)
            self.addSubview(self.view);
            self.dateTimePickerView.delegate = self
            self.dateTimePickerView.dataSource = self
            self.dateTimePickerView.hidden = true
            
    }
    // for this to work programmatically I had to do the same...
    override init(frame: CGRect) {
        super.init(frame: frame)
        NSBundle.mainBundle().loadNibNamed("AddEventView", owner: self, options: nil)
        self.view.frame = bounds
        self.addSubview(self.view)
        self.dateTimePickerView.delegate = self
        self.dateTimePickerView.dataSource = self
        self.dateTimePickerView.hidden = true
    }
    @IBAction func tapChoosingDateTime(sender: AnyObject) {
        if (self.dateTimePickerView.hidden){
            self.dateTimePickerView.hidden = false
        }
        else{
            self.dateTimePickerView.hidden = true
        }
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch(component){
        case 0:
            return dateArray[row]
        case 1:
            return hourArray[row]
        case 2:
            return minuteArray[row]
        case 3:
            return ampmArray[row]
        default:
            break;
        }
        return "";
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 4;
        
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch(component){
        case 0:
            return dateArray.count;
        case 1:
            return hourArray.count;
        case 2:
            return minuteArray.count;
        case 3:
            return ampmArray.count;
        default:
            break;
        }
        return 0;
    }
}
