import XCTest

import OnionStashTests

var tests = [XCTestCaseEntry]()
tests += OnionStashTests.allTests()
tests += OnionBankTests.allTests()
XCTMain(tests)
