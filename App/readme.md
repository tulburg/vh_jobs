### Installation

update code 

```swift
class Linker {
    
    var params: [String: String]!
    var url: URL = URL(string: "http://192.168.8.101:8000/")!
    var method = "POST"
    var image: UIImage!
    
```

to 

```swift
class Linker {
    
    var params: [String: String]!
    var url: URL = URL(string: "address or ip of the server & port")!
    var method = "POST"
    var image: UIImage!
```
