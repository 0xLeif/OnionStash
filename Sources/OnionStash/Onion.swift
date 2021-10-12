import Foundation

public typealias 🧅 = Onion

/**
 Onion 🧅
 
 Layers
  - id
  - Optional: Type
  - Optional: Meta
  - Value
 */
public struct Onion<Value: Equatable>: Identifiable, Hashable, Codable where Value: Codable, Value: Layerable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  public static func == (lhs: Onion<Value>, rhs: Onion<Value>) -> Bool {
    lhs.id == rhs.id
  }
  
  public let id: String
  public let layer: Layer
  
  public init(
    _ value: Value
  ) {
    let valueLayer = Layer.value(data: value.valueLayer())
    var layer = valueLayer
    
    if let meta = value.metaLayer() {
      layer = .meta(data: meta, next: layer)
    }
    
    if let type = value.typeLayer() {
      layer = .type(type: type, next: layer)
    }
    
    self.id = value.idLayer()
    self.layer = .id(id: self.id, next: layer)
  }
}

public extension Onion {
  /// Getter for case type(type: String, next: Layer)
  ///
  ///  Layers
  ///   - id
  ///   - Optional: Type
  ///   - Optional: Meta
  ///   - Value
  var type: String? {
    layer.peel.type
  }
  
  /// Getter for case meta(data: [String: String], next: Layer)
  ///
  ///  Layers
  ///   - id
  ///   - Optional: Type
  ///   - Optional: Meta
  ///   - Value
  var meta: [String: String]? {
    let nextLayer = layer.peel
    
    guard nextLayer.type != nil else {
      return nextLayer.meta
    }
    
    return nextLayer.peel.meta
  }
  
  /// Getter for case value(data: Data)
  ///
  ///  Layers
  ///   - id
  ///   - Optional: Type
  ///   - Optional: Meta
  ///   - Value   
  var value: Data? {
    var nextLayer = layer.peel
    
    guard nextLayer.type != nil else {
      guard nextLayer.meta != nil else {
        return nextLayer.value
      }
      
      return nextLayer.peel.value
    }
    
    nextLayer = nextLayer.peel
    
    guard nextLayer.meta != nil else {
      return nextLayer.value
    }
    
    return nextLayer.peel.value
  }
}
