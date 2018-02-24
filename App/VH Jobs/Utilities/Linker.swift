//
//  Linker.swift
//  WooCast
//
//  Created by Tolu Oluwagbemi on 15/02/2017.
//  Copyright © 2017 WooCast Hub. All rights reserved.
//

import UIKit

class Linker {
    
    var params: [String: String]!
    var url: URL = URL(string: "http://192.168.8.101:8000/")!
    var method = "POST"
    var image: UIImage!
    var completion: (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void!
    
    init (parameters: [String: String], completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        
        params = parameters
        self.completion = completion
    }
    
    init (parameters: [String: String], method: String, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        self.method = method
        params = parameters
        self.completion = completion
    }
    
    init (parameters: [String: String], image: UIImage, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        params = parameters
        self.image = image
        self.completion = completion
    }
    
    init (url: URL, parameters: [String: String], completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        self.url = url
        params = parameters
        self.completion = completion
    }
    
    init (url: URL, parameters: [String: String], method: String, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        self.url = url
        params = parameters
        self.method = method
        self.completion = completion
    }
    
    init (url: URL, parameters: [String: String], image: UIImage, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        self.url = url
        params = parameters
        self.image = image
        
        self.completion = completion
    }
    
    public func setMethod(_ method: String) -> Linker {
        self.method = method
        return self
    }
    
    public func execute() {
        var request: URLRequest = URLRequest(url: url as URL)
        request.httpMethod = method
        _execute(request, endPoint: "")
    }
    
    public func execute(endPoint: String) {
        var request: URLRequest = URLRequest(url: URL(string: endPoint, relativeTo: url)!)
        request.httpMethod = method
        _execute(request, endPoint: endPoint)
    }
    
    public func executeAuth(token: String) {
        var request: URLRequest = URLRequest(url: url as URL)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        _execute(request, endPoint: "")
    }
    
    public func executeBasicAuth(username: String, password: String) {
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        // create the request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        simple_execute(req: request)
    }
    
    public func executeJsonRequest(token: String) {
        var data = ""
        for (key, value) in params {
            data += "\(key)=\(value)&"
        }
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data.data(using: .utf8, allowLossyConversion: true) // "query={name}".data(using: .utf8, allowLossyConversion: true)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        simple_execute(req: request)
    }
    
    private func simple_execute(req: URLRequest) {
        let task = URLSession.shared.dataTask(with: req) { data, response, error in
            
            if (error != nil) {
                print(error!)
                self.completion(data, response, error)
            }
            if data != nil {
//                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//                print(responseString!)
                self.completion(data!, response!, error)
            }
        }
        task.resume()
    }
    
    private func _execute(_ req: URLRequest, endPoint: String) {
        if self.method == "GET" {
            var rUrl = "?"
            for (key, value) in params {
                rUrl += "\(key)=\(value)&"
            }
            if let furl = URL(string: "\(endPoint)\(rUrl)", relativeTo: url) {
                var request = req;
                request.url = furl
                simple_execute(req: request)
            }else {
                NSLog("Error encoding the url")
            }
        }else {
            let boundary = requestBoundary()
            var request = req
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
            if image != nil {
                let photoData = UIImageJPEGRepresentation(image, 1)
                if photoData == nil { return }
                
                request.httpBody = requestBody(parameters: params, filePathKey: "file", imageDataKey: photoData! as NSData, boundary: boundary) as Data
            }else{
                request.httpBody = requestBody(parameters: params, filePathKey: nil, imageDataKey: nil, boundary: boundary) as Data
            }
        
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                if data != nil  {
//                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//                    print(responseString!)
                    self.completion(data!, response!, error)
                }
                if error != nil {
                    NSLog((error?.localizedDescription)!)
                }
                
            }
            task.resume()
        }
    }
    
    private func requestBody(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData?, boundary: String) -> NSData {
        
        let body = NSMutableData()
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        if imageDataKey != nil {
            let filename = "user-profile.jpg"
            let mimetype = "image/jpg"
            
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
            body.appendString("Content-Type: \(mimetype)\r\n\r\n")
            body.append(imageDataKey! as Data)
            body.appendString("\r\n")
        }
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    private func requestBoundary() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    
}

extension NSMutableData {
    
    
    func appendString(_ value : String) {
        let data = value.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

