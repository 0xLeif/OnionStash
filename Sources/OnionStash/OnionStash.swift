public typealias OnionStashable = OnionStoring & OnionLoading

public struct OnionStash<Value: Equatable>: Codable, Equatable where Value: Codable, Value: Layerable {
  public var onionSet: Set<Onion<Value>>
  
  public init() { onionSet = [] }
  public init(onions: [Onion<Value>]) {
    self.onionSet = Set(onions)
  }
}

public extension OnionStash {
  func onion(forID id: String) -> Onion<Value>? {
    onionSet
      .first { onion in
        onion.id == id
      }
  }
  
  func onions(forType type: String) -> [Onion<Value>] {
    onionSet
      .filter { onion in
        onion.type == type
      }
  }
  
  func onions(
    forMetaKey key: String,
    andValue value: String
  ) -> [Onion<Value>] {
    onionSet
      .filter { onion in
        onion.meta?[key] == value
      }
  }
}
