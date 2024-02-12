//
//  SkhdCheatSheetTests.swift
//  SkhdCheatSheetTests
//
//  Created by Thomas Dion-Grondin on 2024-02-11.
//

import XCTest
@testable import SkhdCheatSheet

final class SkhdCheatSheetTests: XCTestCase {


    func testParseGroupDefinition() {
        
    }
    
    func testGetGroupSubstrs() {
        
        let configPath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".skhdrc")

        let rawContent = getCheatSheetSubstr(configPath: configPath)
        let rawGroups = getGroupSubstrs(content: rawContent)
        
        XCTAssertNotNil(rawGroups)
        XCTAssertEqual(rawGroups.count, 2)

    }
    
    func testParseConfig() {
        
        let result = parseConfig()
        
        XCTAssertNotNil(result)
    }

}
