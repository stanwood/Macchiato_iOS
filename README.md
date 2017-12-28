
<p align="center">
    <img src="Assets/Icon.png?raw=false" alt="STWUITestingKit"/>
</p>


# STWUITestingKit


[![Swift Version](https://img.shields.io/badge/Swift-3.2.x-orange.svg)]()

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
	
	class StanwoodTests: XCTestCase {
	    
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
	 override func setUp() {
        	super.setUp()
        
        	continueAfterFailure = false
        
        let baseURLString: String = "https://stanwood-ui-testing.firebaseio.com"
        let version: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)?.replacingOccurrences(of: ".", with: "-") ?? "-"
        guard let url = URL(string: "ios/com-uitesting-example/\(version).json", relativeTo: URL(string: baseURLString)) else { return }
        
        let launchHandlers: [LaunchHandlers] = [.notification, .review, .default]
    
        let slack = UITesting.Slack(teamID: "T034UPBQE", channelToken: "B8K8L6S1Y/F6SKtmB1GoAbcDaTl00fuxtx", channelName: "#_ui_testing")
        let tool = UITesting.Configurations(url: url, launchHandlers: launchHandlers, app: app, slack: slack)
        
        testingManager = UITesting.Manager(tool: tool, target: self)
        testingManager.launch()
   	 }
	```

3. Now we are ready to set up the test case

	```swift
     func testStanwood(){
	   testingManager.runTests()
     }
	```
	
	`testingManager.runTests()` will run the tests and report if there are any failures.
	

#### Step Two - Configure your project

##### Overview

The test navigation works by querying `XCUIElement` & `XCUIElementQuery` types. Check out the navigation types for a full list [here](https://github.com/stanwood/STWUITestingKit/blob/develop/STWUITestingKit/Classes/NavigationType.swift). The UI Testing tool identifies each element by either an index, or a key, for example:

```swift
// Index
buttons.element(boundBy: index)

// Key
buttons[key]
```

##### What we need to do?

We need to set an `accessibilityIdentifier` for each element. This can be done in Xcode, in the utilities panel under the identity inspector.

You are starting to feel this may take too long! Say no more... This is handled for you, all you have to do is follow 3 simple steps:

	1) Add `pod 'StanwoodCore` to your podfile
	2) import StanwoodCore in any .swift files that contains UI elements
	3) When setting labels/text, you have two options:
		a) Set the localised KEY in interface builder, i'e "MY_KEY_TITLE"
		b) Set `.localisedText` instead of `.text`.
		Note> It is required that you do not localise the key, rather then pass in the key. This will get handled by StanwoodCore

>Note: Ful StanwoodCore documentations to follow.

### PM Usage

##### Overview

The UI Testing tool works by querying  element types from the views hierarchy and they can be accessed by calling a custom key or an index. For example, if we look at the image below from develop.apple.com, we can see how the elements are laid out. 

<p align="center">
    <img src="Assets/views hierchy.png?raw=false" alt="STWUITestingKit"/>
</p>

This is a great example where we have a top `UIView`, which can be identified with a key, and a `UICellectionView`, which cells can be identified with an index. 

##### Let's create our first test case

1. First, we want to set the schema JSON format

	```javascript
	{
		"test_cases" : [
			
		]
	}
	```

2. Creating a test case

	```javascript
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
	
		```javascript
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


	```javascript
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
