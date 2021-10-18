public typealias 🧅🏦 = OnionBank

public struct OnionBank {
  private var stashableOnionTypes: [OnionStashable.Type]
  public var all: [OnionStashable]
  
  public init(
    stashableOnionTypes: OnionStashable.Type...
  ) {
    self.stashableOnionTypes = stashableOnionTypes
    self.all = []
    
    try! load()
  }
}

public extension OnionBank {
  func save() throws {
    try all.forEach { try $0.storeOnions() }
  }
  
  mutating func load() throws {
    all = []
    
    try stashableOnionTypes
      .forEach { onionType in
        all.append(try onionType.loadOnionStash())
      }
  }
  
  mutating func deleteAll() throws {
    try all.forEach {
      try $0.deleteOnions()
    }
    try load()
  }
  
  mutating func add<Value: Equatable>(value: Value) where Value: Codable, Value: Layerable {
    guard let index = all.firstIndex(where: { $0 is OnionStash<Value> }) else {
      chrono.log(level: .error("\(#function): Could not find OnionStash of type \(Value.self)", nil))
      return
    }
    
    all[index].add(value: value)
  }
}
