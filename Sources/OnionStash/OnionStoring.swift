import Foundation

public protocol OnionStoring {
  func storeOnions() throws
}

extension OnionStash: OnionStoring {
  public func storeOnions() throws {
    try JSONEncoder()
      .encode(self)
      .base64EncodedData()
      .write(
        to: FileManager.default
          .urls(
            for: .documentDirectory,
               in: .userDomainMask
          )[0]
          .appendingPathComponent("\(OnionStash.self)-\(type(of: Value.self))"),
        options: .atomic
      )
  }
}
