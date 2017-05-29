//
//  BackgroundCelll.swift
//  STWUITestingKit
//
//  Created by Tal Zion on 29/05/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class BackgroundCelll: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .red
        backgroundView?.backgroundColor = .red
    }

}
