import XCTest
import SwiftTreeSitter
import TreeSitterBicep
import TreeSitterBicepParams

final class TreeSitterBicepTests: XCTestCase {
    func testCanLoadBicepGrammar() throws {
        let parser = Parser()
        let language = Language(language: tree_sitter_bicep())
        XCTAssertNoThrow(try parser.setLanguage(language),
                         "Error loading Bicep grammar")
    }

    func testCanLoadBicepParamsGrammar() throws {
        let parser = Parser()
        let language = Language(language: tree_sitter_bicep_params())
        XCTAssertNoThrow(try parser.setLanguage(language),
                         "Error loading Bicep Params grammar")
    }
}
