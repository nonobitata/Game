//
//  NavigationVC.swift
//  Gymmate
//
//  Created by Trung Do on 2/14/16.
//  Copyright © 2016 TrungDo. All rights reserved.
//

import Foundation
import UIKit
class NavigationVC: UINavigationController, UIViewControllerTransitioningDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Status bar white font
        self.navigationBar.tintColor = UIColor(red: (255/255.0), green: (102/255.0), blue: (102/255.0), alpha: 1.0)


    }
}