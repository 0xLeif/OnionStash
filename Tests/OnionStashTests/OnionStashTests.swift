import XCTest
@testable import OnionStash

final class OnionStashTests: XCTestCase {
  func testExample() {
    struct SomeData: Layerable, Codable, Equatable {
      let id: String
      let type: String
      var createdAt = Date()
      
      let someValueToFilterOn: String
      
      var innerMostValue = "🍯"
      
      // Layerable
      func idLayer() -> String {
        id
      }
      
      func typeLayer() -> String? {
        type
      }
      
      func metaLayer() -> [String : String]? {
        ["createdAt": createdAt.timeIntervalSince1970.description, "filterValue": someValueToFilterOn]
      }
      
      func valueLayer() -> Data {
        try! JSONEncoder().encode(self)
      }
    }
    
    var onion: Onion<SomeData>?
    let someData = SomeData(
      id: "SOME-ID",
      type: "SomeData",
      createdAt: Date(),
      someValueToFilterOn: "!!!",
      innerMostValue: "🍷"
    )
    
    measure {
      onion = Onion(someData)
    }
    
    guard let onion = onion else {
      XCTFail()
      return
    }
    
    let idLayer = onion.layer
    let typeLayer = idLayer.peel
    let metaLayer = typeLayer.peel
    let valueLayer = metaLayer.peel
    
    XCTAssertEqual(idLayer.id, someData.id)
    XCTAssertEqual(typeLayer.type, someData.type)
    XCTAssertEqual(metaLayer.meta?["filterValue"], someData.someValueToFilterOn)
    XCTAssertNotNil(valueLayer.value)
  }
  
  func testStash() {
    struct User: Layerable, Codable, Equatable {
      var id = UUID().uuidString
      
      var name: String
      var isRegistered: Bool
      
      func idLayer() -> String {
        id
      }
      
      func typeLayer() -> String? {
        "\(User.self).\(isRegistered ? "Registered" : "Anon")"
      }
      
      func metaLayer() -> [String : String]? {
        ["tag": (name == "Anon") ? "0" : "1"]
      }
      
      func valueLayer() -> Data {
        name.data(using: .utf8)!
      }
    }
    
    var stash = OnionStash<User>()
    
    let someUser = User(name: "Leif", isRegistered: true)
    
    stash.add(value: someUser)
    stash.add(value: someUser)
    stash.add(value: someUser)
    
    XCTAssertEqual(stash.onionSet.count, 1)
    
    XCTAssertNotNil(stash.onion(forID: someUser.id))
    
    stash.add(
      values: (0 ..< 99999)
        .map { i in User(name: "Anon", isRegistered: i.isMultiple(of: 2)) }
    )
    
    XCTAssertEqual(stash.onionSet.count, 100000)
    
    //    measure {
    XCTAssertEqual(stash.onions(forType: "User.Registered").count, 50001)
    //    }
    
    measure {
      XCTAssertEqual(stash.onions(forMetaKey: "tag", andValue: "1").count, 1)
    }
  }
  
  func testOnionStashCollection() {
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
    
    let store: [OnionStoring] = [
      OnionStash<A>(
        onions: [
          Onion(A(value: "First")),
          Onion(A(value: "Second")),
          Onion(A(value: "Third"))
        ]
      ),
      OnionStash<B>()
    ]
    
    try! store.first?.storeOnions()
    
    var loadedStash = OnionStash<A>()
    
    try! loadedStash.loadOnions()
    
    XCTAssertEqual(loadedStash, (store.first as? OnionStash<A>))
  }
  
  static var allTests = [
    ("testExample", testExample),
    ("testStash", testStash),
    ("testOnionStashCollection", testOnionStashCollection)
  ]
}
