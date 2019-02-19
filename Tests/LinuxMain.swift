import XCTest

import AtomicTests

var tests = [XCTestCaseEntry]()
tests += AtomicTests.__allTests()

XCTMain(tests)
