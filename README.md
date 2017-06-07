
<p align="center">
    <img src="Assets/Icon.png?raw=false" alt="STWUITestingKit"/>
</p>


# STWUITestingKit


[![Swift Version](https://img.shields.io/badge/Swift-3.0.x-orange.svg)]()

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

```ruby
source 'https://github.com/stanwood/Cocoa_Pods_Specs.git'

pod 'STWUITestingKit'
```

## Usage

### iOS Develop Usage

#### Step One - Set up the testing tool

1. Add a new `XCTestCase` to the UI Test target and import `STWUITestingKit`

	```swift
		import XCTest
		import STWUITestingKit
		
		class STWSchemaTests: XCTestCase {
		    
		    let app = XCUIApplication()
		    
		    override func setUp() {
		        super.setUp()
		        
		    }
		    
		    override func tearDown() {
		        // Put teardown code here. This method is called after the invocation of each test method in the class.
		        super.tearDown()
		    }
		}
	```

2. Let's configure and launch the sdk
	
	Add this to the `setUp()` function
	
	```swift
	
		// Based on JSONSTWSchema draft4 tempalte - Will be removed
		// >Note: For testing only
    	let url = "https://dl.dropboxusercontent.com/s/qbfgngc7bzuq3s5/test_chema.json"
		
		// curent token for monitoring UI interruption alerts
		var currentToken: NSObjectProtocol?
		
		override func setUp() {
	        super.setUp()
	        
	        continueAfterFailure = false
	        
	        
	        guard let url = URL(string: url) else { return } // >Note: Still WIP - Thi will be removed
	        let launchHandlers: [LaunchHandlers] = [.notification, .review, .default]
	        
	        // Launch configurations
	        let tool = STWTestConfigurations(url: url, launchHandlers: launchHandlers, app: app)
	        
	        // Setting up the testing tool
	        UITestingManager.shared.setup(tool: tool)
	        
	        // This will fetch the test cases from the API
	        UITestingManager.shared.launch()
	        
	        // Monitoring
	        monitor()
	    }
	    
	    // Monitoring for system alerts
	    // >Note: Still WIP
	    func monitor(){
	        self.currentToken = addUIInterruptionMonitor(withDescription: "Authorization Prompt") {
	            
	            if $0.buttons["Allow"].exists {
	                $0.buttons["Allow"].tap()
	            }
	            
	            if $0.buttons["OK"].exists {
	                $0.buttons["OK"].tap()
	            }
	            
	            return true
	        }
	    }
	```

3. Now we are ready to set up the test case

	```swift
		func testSTWSchema(){
	        UITestingManager.shared.runTests { [unowned self] in
	            if let token = self.currentToken {
	                self.removeUIInterruptionMonitor(token)
	            }
	            
	            self.monitor()
	        }
    	}
	```
	
	`UITestingManager.shared.runTests` will run the tests and report if there are any failures. The callback is triggered if a test case should be 	monitored for system alerts.
	
	>Note: The Monitor feature is still in RnD 
	

#### Step Two - Configure your project

##### Overview

The test navigation works by quering `XCUIElement` & `XCUIElementQuery` types. Check out the navigation types for a full list [here](). The UI Testing tool identifies each element by either an index, or a key, for example:

```swift
// Index
buttons.element(boundBy: index)

// Key
buttons[key]
```

##### What we need to do?

1. We need to set an `accessibilityIdentifier` for each element. This can be done in Xcode, in the utilities pannel under the identitiy inspector.
2. Or we can set this by code `button.accessibilityIdentifier = key`
3. We need to make it clear to the PM where we used the identifiers, so they can set the test case with the proper keys.

>Note: 3 still in WIP how we track all identifiers

### PM Usage

//TODO

## License

STWUITestingKit is a priavte library. See the LICENSE file for more info.
