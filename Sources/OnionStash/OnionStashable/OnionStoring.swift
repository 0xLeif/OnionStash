import Foundation

public protocol OnionStoring {
  func storeOnions() throws
  func deleteOnions() throws
  
  mutating func add<Value>(value: Value) where Value: Codable, Value: Layerable
  mutating func add<Value>(values: [Value]) where Value: Codable, Value: Layerable
  mutating func remove<Value>(value: Value) where Value: Codable, Value: Layerable
  mutating func remove<Value>(values: [Value]) where Value: Codable, Value: Layerable
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
  
  public func deleteOnions() throws {
    try? FileManager.default
      .removeItem(
        at: FileManager.default
          .urls(
            for: .documentDirectory,
               in: .userDomainMask
          )[0]
          .appendingPathComponent("\(OnionStash.self)-\(type(of: Value.self))")
      )
  }
  
  
  public mutating func add<OnionValue>(value: OnionValue) where OnionValue : Layerable, OnionValue : Decodable, OnionValue : Encodable {
    guard let value = value as? Value else {
      chrono.log(level: .error("\(#function): value (of type \(OnionValue.self)) is not of type \(Value.self)", nil))
      return
    }
    
    onionSet.insert(Onion(value))
  }
  
  public mutating func add<OnionValue>(values: [OnionValue]) where OnionValue : Layerable, OnionValue : Decodable, OnionValue : Encodable {
    guard let values = values as? [Value] else {
      chrono.log(level: .error("\(#function): value (of type \(OnionValue.self)) is not of type \(Value.self)", nil))
      return
    }
    
    values
      .map(Onion.init)
      .forEach { onionSet.insert($0) }
  }
  
  public mutating func remove<OnionValue>(value: OnionValue) where OnionValue : Layerable, OnionValue : Decodable, OnionValue : Encodable {
    guard let value = value as? Value else {
      chrono.log(level: .error("\(#function): value (of type \(OnionValue.self)) is not of type \(Value.self)", nil))
      return
    }
    
    onionSet.remove(Onion(value))
  }
  
  public mutating func remove<OnionValue>(values: [OnionValue]) where OnionValue : Layerable, OnionValue : Decodable, OnionValue : Encodable {
    guard let values = values as? [Value] else {
      chrono.log(level: .error("\(#function): value (of type \(OnionValue.self)) is not of type \(Value.self)", nil))
      return
    }
    
    values
      .map(Onion.init)
      .forEach { onionSet.remove($0) }
  }
}
