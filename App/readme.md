### Installation

update code 

```
class Linker {
    
    var params: [String: String]!
    var url: URL = URL(string: "http://192.168.8.101:8000/")!
    var method = "POST"
    var image: UIImage!
    
```

to 

```
class Linker {
    
    var params: [String: String]!
    var url: URL = URL(string: "address or ip of the server")!
    var method = "POST"
    var image: UIImage!
```
