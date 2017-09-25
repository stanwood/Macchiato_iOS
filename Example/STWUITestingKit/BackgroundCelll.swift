//
//  BackgroundCelll.swift
//  STWUITestingKit
//
//  Created by Tal Zion on 29/05/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class BackgroundCelll: UICollectionViewCell {
    
    @IBOutlet var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(indexPath: IndexPath){
        backgroundColor = .red
        backgroundView?.backgroundColor = .red
        //cellLabel.text = "Cell at row: \(indexPath.row), section: \(indexPath.section)"
    }
}
