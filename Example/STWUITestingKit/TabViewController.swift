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
    @IBOutlet weak var tapMeImage: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //UserAuthorization.requestContactsAccess()
        
        UserAuthorization.requestLibraryPermission()
        
        // Asking the user for a location request
//        UserAuthorization.requestionLocation(manager: manager)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        tap.numberOfTapsRequired = 1
        tapMeImage?.isUserInteractionEnabled = true
        tapMeImage?.addGestureRecognizer(tap)
    }
    
    @objc func tap(_ tap: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Testing images", message: "Looks like tap gesture works!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        let cancel = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
    
}
