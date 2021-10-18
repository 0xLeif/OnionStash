import Foundation

public indirect enum Layer: Codable {
  case id(id: String, next: Layer)
  case type(type: String, next: Layer)
  case meta(data: [String: String], next: Layer)
  case value(data: Data)
}

public extension Layer {
  /// Getter for case id(id: String, next: Layer)
  var id: String? {
    guard case let .id(id, _) = self else {
      return nil
    }
    
    return id
  }
  
  /// Getter for case type(type: String, next: Layer)
  var type: String? {
    guard case let .type(type, _) = self else {
      return nil
    }
    
    return type
  }
  
  /// Getter for case meta(data: [String: String], next: Layer)
  var meta: [String: String]? {
    guard case let .meta(meta, _) = self else {
      return nil
    }
    
    return meta
  }
  
  /// Getter for case value(data: Data)
  var value: Data? {
    guard case let .value(value) = self else {
      return nil
    }
    
    return value
  }
  
  var peel: Layer {
    switch self {
    case .id(_, let next), .type(_, let next),
        .meta(_, let next):
      return next
      
    case .value:
      return self
    }
  }
}

public protocol Layerable {
  func idLayer() -> String
  func typeLayer() -> String?
  func metaLayer() -> [String: String]?
  func valueLayer() -> Data
}

public extension Layerable {
  func typeLayer() -> String? { nil }
  func metaLayer() -> [String: String]? { nil }
}
