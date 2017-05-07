import UIKit
import XCTest
import STWUITestingKit

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
    
    func testCorrectSchemaFormat() {
        
        guard let schemaJSON = test(schemaFor: "test_schema") else { XCTFail("Failed to load schema rfom file"); return }
        var testCases:[STWSchema] = []
            
            if let schemas = schemaJSON["test_cases"] as? NSArray {
                for schema in schemas {
                    guard let schemaDictionary = schema as? JSONDictionary else { continue }
                    do {
                        let testCase = try STWSchema(schemaDictionary)
                        testCases.append(testCase)
                    } catch SchemaError.error( let m ) {
                        XCTFail(m)
                    } catch {
                        XCTFail(error.localizedDescription)
                    }
                }
            }

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
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
