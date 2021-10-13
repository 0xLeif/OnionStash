struct OnionBank {
  var all: [OnionStashable]
  
  func load() {
    
  }
  
  func save() throws {
    try all.forEach { try $0.storeOnions() }
  }
}
