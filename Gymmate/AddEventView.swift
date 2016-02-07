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
   
    @IBOutlet weak var dateTimeText: UITextField!
    @IBOutlet weak var dateTimePickerView: UIPickerView!
    @IBOutlet weak var routeDescriptionText: UITextView!
    var dateArray = ["Today","Tomorrow"];
    var hourArray = ["1","2","3","4","5","6","7","8","9","10","11","12"];
    var minuteArray = ["00","15","30","45"];
    var ampmArray = ["AM","PM"];

        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)!
            NSBundle.mainBundle().loadNibNamed("AddEventView", owner: self, options: nil)
            self.addSubview(self.view);
            self.routeDescriptionText.delegate = self
            self.dateTimePickerView.delegate = self
            self.dateTimePickerView.dataSource = self
            
            //setUpPickerView()
    }
    func setUpPickerView(){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicker")
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        dateTimeText.inputView = self.dateTimePickerView
        dateTimeText.inputAccessoryView = toolBar
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
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
