import XCTest
@testable import OnionStash

final class OnionBankTests: XCTestCase {
  struct A: Layerable, Codable, Equatable {
    var id = UUID().uuidString
    
    var value: String
    
    func idLayer() -> String {
      id
    }
    
    func valueLayer() -> Data {
      value.data(using: .utf8)!
    }
  }
  struct B: Layerable, Codable, Equatable {
    var id = UUID().uuidString
    
    var value: String
    
    func idLayer() -> String {
      id
    }
    
    func valueLayer() -> Data {
      value.data(using: .utf8)!
    }
  }
  
  func testExample() {
    var bank = OnionBank(
      stashableOnionTypes: OnionStash<A>.self, OnionStash<B>.self
    )
    
    XCTAssertEqual(bank.all.count, 2)
    
    bank.add(value: A(value: "First Bank Value"))
    
    try! bank.save()
    
    var loadedBank = OnionBank(
      stashableOnionTypes: OnionStash<A>.self, OnionStash<B>.self
    )
    
    dump(loadedBank)
    
    XCTAssertEqual((loadedBank.all[0] as? OnionStash<A>)?.onionSet.count, 1)
    
    try! bank.deleteAll()
    
    XCTAssertEqual(bank.all.count, 2)
    XCTAssertEqual((bank.all[0] as? OnionStash<A>)?.onionSet.count, 0)
    
    try! loadedBank.load()
    
    XCTAssertEqual(loadedBank.all.count, 2)
    XCTAssertEqual((loadedBank.all[0] as? OnionStash<A>)?.onionSet.count, 0)
  }
  
  static var allTests = [
    ("testExample", testExample)
  ]
}
