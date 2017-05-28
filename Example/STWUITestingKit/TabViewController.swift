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

    lazy var locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Asking the user for a location request
        UserAuthorization.requestionLocation(from: locationManager)
    }
}
