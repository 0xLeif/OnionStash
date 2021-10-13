import Foundation

public protocol OnionLoading {
  mutating func loadOnions() throws
}

extension OnionStash: OnionLoading {
  public mutating func loadOnions() throws {
    if let onions = try Data(
      base64Encoded: try Data(
        contentsOf: FileManager.default
          .urls(
            for: .documentDirectory,
               in: .userDomainMask
          )[0]
          .appendingPathComponent("\(OnionStash.self)-\(type(of: Value.self))")
      )
    )
        .map({  try JSONDecoder().decode(OnionStash<Value>.self, from: $0) }) {
      onionSet = onions.onionSet
    }
  }
}
