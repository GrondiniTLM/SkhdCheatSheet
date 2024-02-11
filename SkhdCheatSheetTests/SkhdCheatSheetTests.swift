//
//  SkhdCheatSheetTests.swift
//  SkhdCheatSheetTests
//
//  Created by Thomas Dion-Grondin on 2024-02-11.
//

import XCTest
@testable import SkhdCheatSheet

final class SkhdCheatSheetTests: XCTestCase {

    func testParseHotKeys() {
        let viewModel = CheatsheetViewModel()
        let result = viewModel.parseHotKeys()
        
        XCTAssertNotNil(result)

        
        for hotkey in result {
            XCTAssertNotNil(hotkey.binding)
            XCTAssertNotNil(hotkey.command)
        }
        
    }

}
