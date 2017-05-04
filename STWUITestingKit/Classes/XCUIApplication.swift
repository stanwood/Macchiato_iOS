//
//  XCUIApplication.swift
//  Glamour
//
//  Created by Tal Zion on 21/03/2017.
//  Copyright © 2017 Stanwood GmbH. All rights reserved.
//

import XCTest

extension XCUIApplication {
    func setupAndLaunch() {
        launchEnvironment = ["DISABLE_ANIMATION":"1"]
        launch()
    }
    
    func getVisibleCellsCount()-> Int {
        var visibleCount = 0
        var isInitialCellVisible = true
        
        for i in 0...cells.count {
            let cell = cells.element(boundBy: UInt(i))
            if cell.exists, !cell.isHittable {
                if i == 0 || !isInitialCellVisible {
                    isInitialCellVisible = false
                } else {
                    return visibleCount
                }
            } else {
                isInitialCellVisible = true
                visibleCount += 1
            }
        }
        return visibleCount
    }
}
