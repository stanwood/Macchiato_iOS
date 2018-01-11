import UIKit
import XCTest
import StanwoodUITesting

public typealias JSONDictionary = [AnyHashable:Any]

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /// Testing overall schema item foramt is correct
    ///     - file: test_schema.json
    
    func testCorrectSchemaFormat() {
        
        guard let schemaJSON = test(schemaFor: "test_schema") else { XCTFail("Failed to load schema ffom file"); return }
        var testCases:[UITesting.TestCase] = []
            
            if let schemas = schemaJSON["test_cases"] as? NSArray {
                for schema in schemas {
                    guard let schemaDictionary = schema as? JSONDictionary else { continue }
                    do {
                        let testCase = try UITesting.TestCase(testCase: schemaDictionary)
                        testCases.append(testCase)
                    } catch UITesting.TestError.error( let m ) {
                        XCTFail(m.message)
                    } catch {
                        XCTFail(error.localizedDescription)
                    }
                }
            }

    }
    
    /// Testing schema has as least one test case
    ///     - file: test_schema_empty.json
    
    func testSchemaHasUITests(){
        guard let schemaJSON = test(schemaFor: "test_schema_empty") else { XCTFail("Failed to load schema from file"); return }
        var testCases:[UITesting.TestCase] = []
        
        if let schemas = schemaJSON["test_cases"] as? NSArray {
            for schema in schemas {
                guard let schemaDictionary = schema as? JSONDictionary else { continue }
                do {
                    let testCase = try UITesting.TestCase(testCase: schemaDictionary)
                    testCases.append(testCase)
                } catch UITesting.TestError.error( let m ) {
                    XCTFail(m.message)
                } catch {
                    XCTFail(error.localizedDescription)
                }
            }
            
            if testCases.count == 0 {
                XCTFail("No test cases")
            }
        }
    }
    
    /// Testing schema throws an error if no navigation items have been set up
    ///     - file: navigation_items.json
    
    func testSchemaNoNafigationItemsError(){
        guard let schemaJSON = test(schemaFor: "navigation_items") else { XCTFail("Failed to load schema from file"); return }
    
        if let schemas = schemaJSON["test_cases"] as? NSArray {
            for schema in schemas {
                guard let schemaDictionary = schema as? JSONDictionary else { continue }
                do {
                    let _ = try UITesting.TestCase(testCase: schemaDictionary)
                    XCTFail("Failed to initate Schema with no items")
                } catch UITesting.TestError.error( let m ) {
                    print("Test passed: \(m.message)")
                } catch {
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }
    
    /// Testing navigation throws an error with type is incorrect
    ///     - file: navigation_format_wrong_type.json
    
    func testWrongTypeNavigationITem(){
        guard let schemaJSON = test(schemaFor: "navigation_format_wrong_type") else { XCTFail("Failed to load schema from file"); return }
        
        if let schemas = schemaJSON["test_cases"] as? NSArray {
            for schema in schemas {
                guard let schemaDictionary = schema as? JSONDictionary else { continue }
                do {
                    let _ = try UITesting.TestCase(testCase: schemaDictionary)
                    XCTFail("Did not fail when navigation foramt is missing a type")
                } catch UITesting.TestError.error( let m ) {
                    print("Test passed: \(m.message)")
                } catch {
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }
    
    /// Testing navigation throwing an error is index is missing from an item
    ///     - file: navigation_format_missing_index.json
    
    func testWrongIndexNavigationITem(){
        guard let schemaJSON = test(schemaFor: "navigation_format_missing_index") else { XCTFail("Failed to load schema from file"); return }
        
        if let schemas = schemaJSON["test_cases"] as? NSArray {
            for schema in schemas {
                guard let schemaDictionary = schema as? JSONDictionary else { continue }
                do {
                    let _ = try UITesting.TestCase(testCase: schemaDictionary)
                    XCTFail("Did not fail when navigation foramt is missing a type")
                } catch UITesting.TestError.error( let m ) {
                    print("Test passed: \(m)")
                } catch {
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }
    
    /// Testing navigation throwing an error is missing an action
    ///     - file: navigation_format_no_actions_error.json
    
    func testNoActionsInNavigationITem(){
        guard let schemaJSON = test(schemaFor: "navigation_format_no_actions_error") else { XCTFail("Failed to load schema from file"); return }
        
        if let schemas = schemaJSON["test_cases"] as? NSArray {
            for schema in schemas {
                guard let schemaDictionary = schema as? JSONDictionary else { continue }
                do {
                    let _ = try UITesting.TestCase(testCase: schemaDictionary)
                    XCTFail("Did not fail when navigation foramt is missing a type")
                } catch UITesting.TestError.error( let m ) {
                    print("Test passed: \(m)")
                } catch {
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }
    
    /// Testing navigation throwing an error is missing a type key
    ///     - file: navigation_format_missing_key.json
    
    func testMissingKeyInNavigationITem(){
        guard let schemaJSON = test(schemaFor: "navigation_format_missing_key") else { XCTFail("Failed to load schema from file"); return }
        
        if let schemas = schemaJSON["test_cases"] as? NSArray {
            for schema in schemas {
                guard let schemaDictionary = schema as? JSONDictionary else { continue }
                do {
                    let _ = try UITesting.TestCase(testCase: schemaDictionary)
                    XCTFail("Did not fail when navigation foramt is missing a type")
                } catch UITesting.TestError.error( let m ) {
                    print("Test passed: \(m)")
                } catch {
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }
    
    /// Testing navigation thwoing an error is format is incorrect
    ///     - file: navigation_format_incorrect_format.json
    
    func testIncorrectNavigationItemForamt(){
        guard let schemaJSON = test(schemaFor: "navigation_format_incorrect_format") else { XCTFail("Failed to load schema from file"); return }
        
        if let schemas = schemaJSON["test_cases"] as? NSArray {
            for schema in schemas {
                guard let schemaDictionary = schema as? JSONDictionary else { continue }
                do {
                    let _ = try UITesting.TestCase(testCase: schemaDictionary)
                    XCTFail("Did not fail when navigation foramt is missing a type")
                } catch UITesting.TestError.error( let m ) {
                    print("Test passed: \(m)")
                } catch {
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }
    
    private func test(schemaFor file: String) -> JSONDictionary? {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: file, withExtension: "json") else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
            return json
        } catch {
            return nil
        }
    }
}
