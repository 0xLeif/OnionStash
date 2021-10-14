import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(OnionStashTests.allTests),
        testCase(OnionBankTests.allTests)
    ]
}
#endif
