//
//  Objects.swift
//  VH Jobs
//
//  Created by tolu oluwagbemi on 2/17/18.
//  Copyright © 2018 tolu oluwagbemi. All rights reserved.
//

import UIKit

struct Job {
    
    var id: Int?
    var title: String?
    var position: String?
    var location: String?
    var slot: Int?
    var deadline: Date?
    var type: String?
    var salary: String?
    var company: Company?
    
    init(_ data: NSDictionary) {
        if let id = data["id"] as? Int { self.id = id }
        if let title = data["title"] as? String { self.title = title }
        if let position = data["position"] as? String { self.position = position }
        if let location = data["location"] as? String { self.location = location }
        if let slot = data["slot"] as? Int { self.slot = slot }
        if let deadline = data["deadline"] as? String { self.deadline = Util.parseDate(deadline) }
        if let type = data["type"] as? String { self.type = type }
        if let salary = data["salary"] as? String { self.salary = salary }
        if let company = data["company"] as? NSDictionary { self.company = Company(company) }
    }
}


struct Company {
    
    var id: Int?
    var name: String?
    var description: String?
    var location: String?
    var website: String?
    
    init (_ data: NSDictionary) {
        if let id = data["id"] as? Int { self.id = id }
        if let name = data["name"] as? String { self.name = name }
        if let description = data["description"] as? String { self.description = description }
        if let location = data["location"] as? String { self.location = location }
        if let website = data["website"] as? String { self.website = website }
    }
}

struct Response {
    var errors: [NSDictionary]?
    var data: NSDictionary?
    var error: NSDictionary?
    
    init(_ dict: NSDictionary) {
        if let data = dict["data"] as? NSDictionary { self.data = data }
        if let errors = dict["errors"] as? [NSDictionary] { self.errors = errors }
        if let error = dict["error"] as? NSDictionary { self.error = error }
    }
}

protocol  AuthorizationDelegate {
    func Authorization_didAuthorize()
    func Authorization_didFailAuthorization()
}

