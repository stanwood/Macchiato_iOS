//
//  TabOneViewController.swift
//  STWUITestingKit
//
//  Created by Tal Zion on 03/05/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
typealias JSONDictionary = [AnyHashable:Any]


class TabViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let dic = test(schemaFor: "test_schema")
        print(dic ?? [:])
    }
    
    
    private func test(schemaFor file: String) -> JSONDictionary? {
        let path = Bundle.main.url(forResource: file, withExtension: "json") //else { return nil }
        let dictionary = NSDictionary(contentsOf: path!)
        //let dictionaryy = NSDictionary(contentsOfFile: path)
        return dictionary as? JSONDictionary
    }
}
