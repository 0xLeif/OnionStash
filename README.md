# OnionStash

*Layered Data*


## Onion Layers
- ID
- Optional: Type
- Optional: Meta
- Value

### Layerable
```swift
public protocol Layerable {
  func idLayer() -> String
  func typeLayer() -> String?
  func metaLayer() -> [String: String]?
  func valueLayer() -> Data
}
```
