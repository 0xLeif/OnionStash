public struct OnionStash<Value: Equatable>: Codable where Value: Codable, Value: Layerable {
  private(set) public var onions: Set<Onion<Value>>
  
  public init() { onions = [] }
  public init(onions: [Onion<Value>]) {
    self.onions = Set(onions)
  }
}

public extension OnionStash {
  func onion(forID id: String) -> Onion<Value>? {
    onions
      .first { onion in
        onion.id == id
      }
  }
  
  func onions(forType type: String) -> [Onion<Value>] {
    onions
      .filter { onion in
        onion.type == type
      }
  }
  
  func onions(
    forMetaKey key: String,
    andValue value: String
  ) -> [Onion<Value>] {
    onions
      .filter { onion in
        onion.meta?[key] == value
      }
  }
}

public extension OnionStash {
  mutating func add(value: Value) {
    onions.insert(Onion(value))
  }
  
  mutating func add(values: [Value]) {
    values.map(Onion.init).forEach { onions.insert($0) }
  }
}
