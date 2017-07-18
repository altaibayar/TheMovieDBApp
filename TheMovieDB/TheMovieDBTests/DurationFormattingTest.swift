//
//  DurationFormattingTest.swift
//  TheMovieDBTests
//
//  Created by altaibayar tseveenbayar on 18/07/2017.
//  Copyright © 2017 tsevealt. All rights reserved.
//


import XCTest
@testable import TheMovieDB

class DurationFormattingTest: XCTestCase {

    func testFormatting() {

        XCTAssert(TimeFormatUtil.formatDuration(minutes: 1) == "01min");
        XCTAssert(TimeFormatUtil.formatDuration(minutes: 59) == "59min");
        XCTAssert(TimeFormatUtil.formatDuration(minutes: 60) == "01h 00min");
        XCTAssert(TimeFormatUtil.formatDuration(minutes: 61) == "01h 01min");
        XCTAssert(TimeFormatUtil.formatDuration(minutes: 121) == "02h 01min");
    }
}

