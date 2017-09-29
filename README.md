
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

target 'Project_Tests' do
      inherit! :search_paths
      pod 'STWUITestingKit'
end
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
	
		// Based on JSONSTWSchema draft4 template - Will be removed
		// >Note: For testing only
    	let url = "https://dl.dropboxusercontent.com/s/qbfgngc7bzuq3s5/test_chema.json"
		
		// current token for monitoring UI interruption alerts
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

The test navigation works by querying `XCUIElement` & `XCUIElementQuery` types. Check out the navigation types for a full list [here](https://github.com/stanwood/STWUITestingKit/blob/develop/STWUITestingKit/Classes/STWNavigationType.swift). The UI Testing tool identifies each element by either an index, or a key, for example:

```swift
// Index
buttons.element(boundBy: index)

// Key
buttons[key]
```

##### What we need to do?

1. We need to set an `accessibilityIdentifier` for each element. This can be done in Xcode, in the utilities panel  under the identity inspector. Setting the ket to `localisedText`

###### Setting identifiers using `extensions` for `[UIButton, UIAlertAction, UILabel, UIBarButtonItem, UITextField]`

```swift
extension UILabel {
    
    open var localisedText: String? {
        get {
            return text
        }
        set {
            accessibilityIdentifier = newValue
            text = newValue?.localized()
        }
    }
    
    // When working with xib elements, set the localised key in IB
    open override func awakeFromNib() {
        super.awakeFromNib()
        localisedText = text
    }
}
```

>Note: Only set the localised key as the `localisedText` i.e' `MY_KEY_TITLE`, **NOT** the localised text i.e' `My Key`

2. Or we can set this by code `button.accessibilityIdentifier = key`
3. We need to make it clear to the PM where we used the identifiers, so they can set the test case with the proper keys.
4. List all identifiers and indexes in the project documentation

**Example**

##### View One

###### View Overview
| UITabBarIndex| isRootView  |
|---|---|
|  0-3 - nil | YES  |

###### Test Case Information
| Description| Type  | Navigation Type | Navigation Action | Identifier | Index  |
|---|---|---|---|---|---|
|  Histogram View | UIView  | view  | swipeLeft  | `histogramAccesibiltyIdenfier`  |  - |
|  Image Cell | UICollectionViewCell  | collectionView  | tap  | -  | 1-11  |
| Back Button  | UIBarButtonItem  | button  | tap  | `backButtonAccessibilityIdentifer`  | -  |

For the full action list, please check [here](https://github.com/stanwood/STWUITestingKit/blob/develop/STWUITestingKit/Classes/STWNavigationAction.swift)

For the full navigation types, please check [here](https://github.com/stanwood/STWUITestingKit/blob/develop/STWUITestingKit/Classes/STWNavigationType.swift). The UI Testing tool identifies each element by either an index, or a key.

### PM Usage

##### Overview

The UI Testing tool works by querying  element types from the views hierarchy and they can be accessed by calling a custom key or an index. For example, if we look at the image below from develop.apple.com, we can see how the elements are laid out. 

<p align="center">
    <img src="Assets/views hierchy.png?raw=false" alt="STWUITestingKit"/>
</p>

This is a great example where we have a top `UIView`, which can be identified with a key, and a `UICellectionView`, which cells can be identified with an index. 

##### Let's create our first test case

1. First, we want to set the schema JSON format

	```json
	{
		"test_cases" : [
			
		]
	}
	```

2. Creating a test case

	```json
	{
		"test_cases": [
			"id" : "1",
			"title": "Images Test",
			"description": "Testing if the fifth image is tappable"
		]
	}
	```
	
3. Setting `navigation` action to support the test case

	The navigation is a collection of navigation actions. We need to set navigation items to navigation to what we want to test. For example, let's set navigation items according to the example above. 
	
	Let's assume this view is on:
	
	- The second tab can be access with `tabs` as index 1
	- And the images view is accessed by tapping a button in the tab's `rootView` with an identifier of `pierIdentifier`
	- The fifth image can be access with `cells` at index 4
	
		```json
		{
			"test_cases": [
				"id" : "1",
				"title": "Images Test",
				"description": "Testing if the fifth image is tappable",
				"navigation" : [
					"tabs[1].action.tap",
					"buttons['pierIdentifier'].action.tap",
					"cells[4].action.tap"
				]
			]
		}
		```
	
4. Now, let's say we want to test the image at position 11, which cannot be accessed in the view, we can set different actions, like `swipeUp, swipeDown`. For example:


	```json
	{
		"test_cases": [
			"id": "1",
			"title": "Images Test",
			"description": "Testing if the fifth image is tappable",
			"navigation": [
				"tabs[1].action.tap",
				"buttons['pierIdentifier'].action.tap",
				"cells[4].action.swipeUp",
				"cells[10].action.tap"
			]
		]
	}
	```

For the full action list, please check [here](https://github.com/stanwood/STWUITestingKit/blob/develop/STWUITestingKit/Classes/STWNavigationAction.swift)

For the full navigation types, please check [here](https://github.com/stanwood/STWUITestingKit/blob/develop/STWUITestingKit/Classes/STWNavigationType.swift). The UI Testing tool identifies each element by either an index, or a key.

>Note: Element identifiers will be listed in each project documentation  under **UI Testing Identifiers**


## License

STWUITestingKit is a private library. See the LICENSE file for more info.
