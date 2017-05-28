//
//  UserAuthorization.swift
//  STWUITestingKit
//
//  Created by Tal Zion on 28/05/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import UserNotifications

class UserAuthorization {
    
    static func requestionLocation(from manager: CLLocationManager){
        manager.requestAlwaysAuthorization()
    }
    
    static func requestRemoteNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
}
