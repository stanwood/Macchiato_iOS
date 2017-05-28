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
import Contacts

class UserAuthorization {
    
    static func requestionLocation(){
        let manager: CLLocationManager = CLLocationManager()
        manager.requestAlwaysAuthorization()
    }
    
    static func requestRemoteNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    static func requestContactsAccess(){
        let addressBook = CNContactStore()
        addressBook.requestAccess(for: .contacts) { (granted, error) in
            
        }
    }
}
