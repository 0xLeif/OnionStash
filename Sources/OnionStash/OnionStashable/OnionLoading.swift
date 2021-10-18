import Foundation

public protocol OnionLoading {
  static func loadOnionStash() throws -> Self
}

extension OnionStash: OnionLoading {
  public static func loadOnionStash() throws -> Self {
    {
      try? Data(
        base64Encoded: try Data(
          contentsOf: FileManager.default
            .urls(
              for: .documentDirectory,
                 in: .userDomainMask
            )[0]
            .appendingPathComponent("\(OnionStash.self)-\(type(of: Value.self))")
        )
      )
        .map { try JSONDecoder().decode(OnionStash<Value>.self, from: $0) }
    }()
    ??
    OnionStash<Value>(onions: [])
  }
}
