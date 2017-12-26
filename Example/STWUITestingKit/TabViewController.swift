//
//  TabOneViewController.swift
//  STWUITestingKit
//
//  Created by Tal Zion on 03/05/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import CoreLocation

typealias JSONDictionary = [AnyHashable:Any]


class TabViewController: UIViewController {
    
    lazy var manager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //UserAuthorization.requestContactsAccess()
        
        // Asking the user for a location request
        //UserAuthorization.requestionLocation(manager: manager)
    }
}
