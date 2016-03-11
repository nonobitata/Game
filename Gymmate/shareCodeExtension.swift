//
//  shareCodeExtension.swift
//  Gymmate
//
//  Created by Trung Do on 2/14/16.
//  Copyright © 2016 TrungDo. All rights reserved.
//

import Foundation
import UIKit

extension NSDate{
    func toShortTimeString() -> String
    {
        //Get Short Time String
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        let timeString = formatter.stringFromDate(self)
        
        //Return Short Time String
        return timeString
    }
    func toDate() -> String
    {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        let timeString = formatter.stringFromDate(self)
        
        //Return Short Time String
        return timeString
    }
   
}
extension UIButton{
    func animateButton(button: UIButton){
        button.transform = CGAffineTransformMakeScale(0.7, 0.7)
        UIView.animateWithDuration(0.5,
            delay: 0,
            usingSpringWithDamping: 0.20,
            initialSpringVelocity: 20.00,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: {
                button.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
}
